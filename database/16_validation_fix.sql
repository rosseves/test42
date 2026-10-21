-- =====================================================================
-- Close Nutrition — 16. Correcting the validation view
--
-- The "ingredients counting as zero" count was flagging salt, pepper,
-- water, ice, whole spices and vanilla — all of which genuinely have no
-- calories. That made 183 recipes look broken when nothing was wrong.
--
-- A food is now only counted as a problem if it carries no nutrition AND
-- is not marked negligible. Seasonings get marked so, once, here.
--
-- Run once in Supabase.
-- =====================================================================
begin;

alter table foods add column if not exists negligible boolean not null default false;

comment on column foods.negligible is
  'No meaningful calories by nature — salt, water, whole spices. Excluded '
  'from the "counting as zero" check, which is for foods that should have '
  'nutrition and do not.';

-- anything with no macros that reads like a seasoning is negligible by nature
update foods
   set negligible = true
 where coalesce(protein_100g,0) + coalesce(carbs_100g,0) + coalesce(fat_100g,0) = 0
   and name ~* ('(salt|pepper|season|herb|spice|stock cube|bouillon|water|ice|tea|'
             || 'coffee|vinegar|sweetener|stevia|vanilla|extract|baking powder|'
             || 'bicarbonate|saffron|bay leaf|curry leaf|lime leaf|star anise|'
             || 'cinnamon stick|cardamom|cloves|garnish|to taste|food colouring|'
             || 'gelatine|zest)');

create or replace view recipe_validation as
  select r.id,
         r.name,
         r.source,
         r.macro_source,
         r.validated_at,
         r.published_kcal                        as book_kcal,
         round(m.kcal)                           as ingredient_kcal,
         case when r.published_kcal > 0
              then round(((m.kcal - r.published_kcal) / r.published_kcal * 100)::numeric)
         end                                     as pct_out,
         round(m.protein) as ing_pro, round(m.carbs) as ing_cho, round(m.fat) as ing_fat,
         r.published_pro, r.published_cho, r.published_fat,
         (select count(*) from recipe_ingredients ri where ri.recipe_id = r.id)
                                                 as ingredient_lines,
         -- only foods that OUGHT to have nutrition and do not
         (select count(*) from recipe_ingredients ri
            join foods f on f.id = ri.food_id
           where ri.recipe_id = r.id
             and not f.negligible
             and coalesce(f.protein_100g,0)+coalesce(f.carbs_100g,0)
                +coalesce(f.fat_100g,0) = 0)     as lines_counting_as_zero
  from recipes r, lateral recipe_macros(r.id) m
  where not r.archived;

-- accept every recipe whose ingredients already agree with the book
create or replace function cn_accept_close_recipes(p_within numeric default 5,
                                                   p_who text default null)
returns table (accepted_name text) language plpgsql as $$
begin
  return query
  with close as (
    select id from recipe_validation
     where macro_source = 'unchecked'
       and pct_out is not null
       and abs(pct_out) <= p_within
  )
  update recipes r
     set macro_source = 'ingredients',
         validated_at = now(), validated_by = coalesce(p_who,'bulk — already agreed'),
         needs_review = false, review_note = null, reviewed_at = now()
    from close c
   where r.id = c.id
  returning r.name;
end $$;

grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

commit;

-- the honest picture now
select count(*)                                              as recipes,
       count(*) filter (where abs(pct_out) <= 5)             as within_5_pct,
       count(*) filter (where abs(pct_out) between 6 and 15) as out_by_6_to_15,
       count(*) filter (where abs(pct_out) > 15)             as out_by_more,
       count(*) filter (where lines_counting_as_zero > 0)    as genuinely_missing_nutrition,
       count(*) filter (where macro_source <> 'unchecked')   as already_decided
from recipe_validation;
