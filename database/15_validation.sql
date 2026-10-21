-- =====================================================================
-- Close Nutrition — 15. Recipe validation
--
-- The ingredients are now the truth: a recipe's macros are what its
-- ingredients add up to, with no adjustment applied to make them agree
-- with the figure printed in the book.
--
-- That exposes every recipe where the two disagree. This gives Graeme
-- somewhere to record a decision on each one, so a checked recipe stays
-- checked and an unchecked one keeps asking.
--
-- Run once in Supabase.
-- =====================================================================
begin;

-- the full set of book figures, not just calories, so every macro can be
-- compared rather than just the total
alter table recipes add column if not exists published_pro numeric(7,1);
alter table recipes add column if not exists published_cho numeric(7,1);
alter table recipes add column if not exists published_fat numeric(7,1);

-- what was decided, and by whom
alter table recipes add column if not exists macro_source text
  default 'unchecked'
  check (macro_source in ('unchecked','ingredients','book','corrected'));
alter table recipes add column if not exists validated_at timestamptz;
alter table recipes add column if not exists validated_by text;

comment on column recipes.macro_source is
  'unchecked = nobody has looked. ingredients = the ingredient list is right '
  'and the book figure was wrong. book = the book is right and the ingredients '
  'need work. corrected = the ingredients have been edited to agree.';

-- every recipe, its book figure, what its ingredients come to, and the gap
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
         round(m.pro) as ing_pro, round(m.cho) as ing_cho, round(m.fat) as ing_fat,
         r.published_pro, r.published_cho, r.published_fat,
         (select count(*) from recipe_ingredients ri where ri.recipe_id = r.id)
                                                 as ingredient_lines,
         (select count(*) from recipe_ingredients ri
            join foods f on f.id = ri.food_id
           where ri.recipe_id = r.id
             and coalesce(f.protein_100g,0)+coalesce(f.carbs_100g,0)
                +coalesce(f.fat_100g,0) = 0)     as lines_counting_as_zero
  from recipes r, lateral recipe_macros(r.id) m
  where not r.archived;

comment on view recipe_validation is
  'Every recipe with the book figure beside what its ingredients come to. '
  'Sort by pct_out to work through the worst first.';

-- record a decision
create or replace function cn_validate_recipe(
  p_id uuid, p_decision text, p_who text default null)
returns void language plpgsql as $$
declare mk numeric; mp numeric; mc numeric; mf numeric;
begin
  select kcal, pro, cho, fat into mk, mp, mc, mf from recipe_macros(p_id);

  if p_decision = 'ingredients' then
    -- the ingredient list is right; bring the book figures into line with it
    update recipes
       set published_kcal = round(mk), published_pro = round(mp),
           published_cho  = round(mc), published_fat = round(mf),
           macro_source = 'ingredients',
           validated_at = now(), validated_by = p_who,
           needs_review = false, review_note = null, reviewed_at = now()
     where id = p_id;
  else
    update recipes
       set macro_source = p_decision,
           validated_at = now(), validated_by = p_who,
           needs_review = (p_decision = 'book'),
           review_note = case when p_decision = 'book'
             then 'Book figure accepted — the ingredient list still needs work' end,
           reviewed_at = case when p_decision = 'book' then null else now() end
     where id = p_id;
  end if;
end $$;

grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

commit;

-- ---------------------------------------------------------------------
-- Where the library stands. Work down from the worst.
-- ---------------------------------------------------------------------
select count(*)                                               as recipes,
       count(*) filter (where abs(pct_out) <= 5)              as within_5_pct,
       count(*) filter (where abs(pct_out) between 6 and 15)  as out_by_6_to_15,
       count(*) filter (where abs(pct_out) > 15)              as out_by_more,
       count(*) filter (where lines_counting_as_zero > 0)     as have_a_zero_ingredient,
       count(*) filter (where macro_source <> 'unchecked')    as already_decided
from recipe_validation;
