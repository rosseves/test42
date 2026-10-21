-- =====================================================================
-- Close Nutrition — after the stalled import
--
-- Read-only. Run each query on its own and read the result.
-- =====================================================================

-- 1. How much is actually in there?
select count(*) filter (where source = 'master')                      as from_the_book,
       count(*) filter (where source <> 'master' and not archived)     as added,
       count(*) filter (where archived)                               as archived
from recipes;

-- 2. What arrived in the last few hours, newest first. The import stopped
--    wherever this list stops.
select name, created_at, import_batch
from recipes
where created_at > now() - interval '12 hours'
  and source <> 'master'
order by created_at desc
limit 60;

-- 3. Anything that got in without its ingredients — a recipe that was half
--    written when it failed. These are worth archiving and re-importing.
select r.name, r.created_at
from recipes r
left join recipe_ingredients ri on ri.recipe_id = r.id
where ri.id is null
  and r.source <> 'master'
group by r.id, r.name, r.created_at
order by r.created_at desc;

-- 4. Foods added in the same window, so you can see what the import created.
select name, kcal_100g, created_at
from foods
where created_at > now() - interval '12 hours'
order by created_at desc;

-- ---------------------------------------------------------------------
-- 5. If the partial batch needs to go, archive it by its tag. Take the tag
--    from query 2. Nothing is deleted.
-- ---------------------------------------------------------------------
-- select * from cn_archive_batch('paste the import_batch here');

-- Or by time, if the rows have no tag:
-- select * from cn_archive_added_between(
--   '2026-09-27 09:00:00+01', now());
