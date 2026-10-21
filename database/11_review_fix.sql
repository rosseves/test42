-- =====================================================================
-- Close Nutrition — 11. Making "mark as checked" stick
--
-- The review list mixed a flag with a live calculation. Clearing the flag
-- did nothing to the calculation, so a recipe came straight back the next
-- time the list was opened. This records WHEN a recipe was checked, and
-- stops asking until something about it changes.
--
-- Run once in Supabase. Only adds a column and redefines a view.
-- =====================================================================
begin;

alter table recipes add column if not exists reviewed_at timestamptz;
alter table recipes add column if not exists reviewed_by text;
alter table foods   add column if not exists reviewed_at timestamptz;

create or replace view needs_review as
  select 'food' as kind, id, name, review_note as note,
         null::numeric as published_kcal, null::numeric as calculated_kcal, updated_at
  from foods
  where needs_review
    and not archived
    and (reviewed_at is null or updated_at > reviewed_at)
  union all
  select 'recipe', r.id, r.name,
         coalesce(r.review_note,
           case when r.published_kcal is not null
                     and abs(m.kcal - r.published_kcal) > 0.15 * r.published_kcal
                then format('book says %s kcal, the ingredients come to %s',
                            round(r.published_kcal), round(m.kcal))
           end),
         r.published_kcal, m.kcal, r.updated_at
  from recipes r, lateral recipe_macros(r.id) m
  where not r.archived                       -- archived ones are not anybody's problem
    and (r.reviewed_at is null or r.updated_at > r.reviewed_at)
    and ( r.needs_review
          or (r.published_kcal is not null
              and abs(m.kcal - r.published_kcal) > 0.15 * r.published_kcal) );

comment on view needs_review is
  'Anything wanting a human decision. A recipe drops off once it has been '
  'marked as checked, and only comes back if it is edited afterwards.';

-- what has already been looked at, for the record
create or replace view reviewed_recipes as
  select id, name, reviewed_at, reviewed_by, published_kcal
  from recipes
  where reviewed_at is not null
  order by reviewed_at desc;

grant all on all tables in schema public to anon, authenticated;

commit;

-- how many are actually left
select count(*) filter (where kind='recipe') as recipes_to_check,
       count(*) filter (where kind='food')   as foods_to_check
from needs_review;
