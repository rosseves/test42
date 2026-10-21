-- =====================================================================
-- Close Nutrition — cleaning up after the stalled import
--
-- The import created around 71 foods of its own, guessing the nutrition
-- from reference tables. Some of those guesses are badly wrong, so they
-- need to come out before anything is built on them.
--
-- Read the first two queries before running anything else.
-- =====================================================================

-- 1. The foods the import created. These are the 15:22–15:24 cluster —
--    everything added after your 21, all lowercase.
select name, protein_100g, carbs_100g, fat_100g, kcal_100g, created_at,
       (select count(*) from recipe_ingredients ri where ri.food_id = f.id) as used_by
from foods f
where created_at > '2026-09-27 15:20:00+00'
order by created_at;

-- 2. Which of them look wrong on their own numbers — the calories do not
--    match the protein, carbs and fat they were given.
select name, kcal_100g as says,
       round((4*protein_100g + 4*carbs_100g + 9*fat_100g)::numeric) as from_its_macros
from foods
where created_at > '2026-09-27 15:20:00+00'
  and abs(kcal_100g - (4*protein_100g + 4*carbs_100g + 9*fat_100g))
      > greatest(30, 0.15 * kcal_100g)
order by abs(kcal_100g - (4*protein_100g + 4*carbs_100g + 9*fat_100g)) desc;

-- ---------------------------------------------------------------------
-- 3. ARCHIVE THE RECIPES FIRST. They reference these foods, so they have
--    to go before the foods can. Uncomment and run.
-- ---------------------------------------------------------------------
-- select * from cn_archive_added_between('2026-09-27 15:20:00+00', now());

-- ---------------------------------------------------------------------
-- 4. THEN REMOVE THE FOODS. Deleted rather than archived, because these
--    were never meant to exist and nothing should reference them once
--    step 3 has run. The "not exists" check means anything still in use
--    is left alone — if rows come back from query 5, stop and tell me.
-- ---------------------------------------------------------------------
-- delete from foods f
--  where f.created_at > '2026-09-27 15:20:00+00'
--    and not exists (select 1 from recipe_ingredients ri where ri.food_id = f.id)
-- returning f.name;

-- ---------------------------------------------------------------------
-- 5. Anything left over that is still in use somewhere.
-- ---------------------------------------------------------------------
-- select f.name, count(ri.id) as used_by
--   from foods f join recipe_ingredients ri on ri.food_id = f.id
--  where f.created_at > '2026-09-27 15:20:00+00'
--  group by f.name order by 2 desc;

-- 6. Where you should end up: your 292 book recipes, your 21 foods, and
--    the 258 that were already there.
select 'recipes in use'  as item, count(*) from recipes where not archived
union all select 'foods', count(*) from foods
union all select 'foods added today', count(*) from foods
  where created_at > '2026-09-27 00:00:00+00';
