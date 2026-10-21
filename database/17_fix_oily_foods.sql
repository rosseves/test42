-- =====================================================================
-- Close Nutrition — 17. Foods carrying implausible fat
--
-- "Tuna, canned in sunflower oil" reading 900 kcal per 100g is the
-- calorie value of pure oil — the food has been given the oil's figures
-- rather than the drained fish's.
--
-- Read-only until the last two sections.
-- =====================================================================

-- 1. The one reported, and anything like it.
select name, protein_100g, carbs_100g, fat_100g, kcal_100g,
       (select count(*) from recipe_ingredients ri where ri.food_id = f.id) as used_in
from foods f
where name ilike '%tuna%'
   or name ilike '%sunflower%'
order by kcal_100g desc;

-- 2. Anything at or near the calorie value of pure fat. Only oils, butter
--    and lard belong here; a tinned fish does not.
select name, protein_100g, carbs_100g, fat_100g, kcal_100g,
       (select count(*) from recipe_ingredients ri where ri.food_id = f.id) as used_in
from foods f
where kcal_100g >= 700
  and name !~* '(oil|lard|ghee|butter|dripping|tallow)'
order by kcal_100g desc;

-- 3. Foods whose fat alone is above 60g per 100g — again, only fats and
--    oily nuts should appear here.
select name, fat_100g, kcal_100g
from foods
where fat_100g > 60
  and name !~* '(oil|lard|ghee|butter|dripping|tallow|nut|seed|tahini|coconut)'
order by fat_100g desc;

-- ---------------------------------------------------------------------
-- 4. CORRECTING THE TUNA. Drained tuna in sunflower oil is roughly
--    24g protein, 0g carbs, 9g fat, 186 kcal per 100g. Check the name
--    against what query 1 returned before running this.
-- ---------------------------------------------------------------------
-- update foods
--    set protein_100g = 24, carbs_100g = 0, fat_100g = 9, kcal_100g = 186,
--        needs_review = false, review_note = null
--  where name ilike '%tuna%sunflower%'
-- returning name, protein_100g, carbs_100g, fat_100g, kcal_100g;

-- ---------------------------------------------------------------------
-- 5. FLAG THE REST for checking in the app rather than guessing here.
--    They then appear under "Check the numbers".
-- ---------------------------------------------------------------------
-- update foods
--    set needs_review = true,
--        review_note = 'Calories are at or near pure fat — check this is right',
--        reviewed_at = null
--  where kcal_100g >= 700
--    and name !~* '(oil|lard|ghee|butter|dripping|tallow)'
-- returning name, kcal_100g;
