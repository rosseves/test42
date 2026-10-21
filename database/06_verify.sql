-- =====================================================================
-- Close Nutrition — 04. Did it all land?
--
-- Read-only. Changes nothing. Safe to run any time.
-- Paste into Supabase → SQL Editor → Run.
--
-- Everything comes back as ONE table. Read it top to bottom.
-- =====================================================================

with counts as (
  select 1 as ord, 'COUNT' as section, 'foods' as item,
         count(*)::text as value,
         case when count(*) = 258 then 'correct' else 'expected 258' end as verdict
  from foods
  union all
  select 1, 'COUNT', 'recipes', count(*)::text,
         case when count(*) = 292 then 'correct' else 'expected 292' end
  from recipes
  union all
  select 1, 'COUNT', 'ingredients', count(*)::text,
         case when count(*) = 2856 then 'correct' else 'expected 2856' end
  from recipe_ingredients
),
slots as (
  select 2, 'RECIPES BY MEAL TYPE', slot, count(*)::text, ''
  from recipes group by slot
),
problems as (
  select 3, 'PROBLEM', 'recipe with no ingredients', r.name, 'needs fixing'
  from recipes r
  left join recipe_ingredients ri on ri.recipe_id = r.id
  where ri.id is null
  union all
  select 3, 'PROBLEM', 'macros over 100g per 100g', name, 'needs fixing'
  from foods where protein_100g + carbs_100g + fat_100g > 100.5
  union all
  select 3, 'PROBLEM', 'over 9 kcal per gram', name, 'needs fixing'
  from foods where kcal_100g > 905
  union all
  select 3, 'PROBLEM', 'duplicate recipe name', name, 'needs fixing'
  from recipes
  where name_key in (select name_key from recipes group by name_key having count(*) > 1)
),
problem_check as (
  select 4 as ord, 'RESULT' as section, 'anything broken?' as item,
         case when (select count(*) from problems) = 0
              then 'no - all clear'
              else (select count(*)::text from problems) || ' found, listed above'
         end as value,
         '' as verdict
),
review as (
  select 5, 'FOR GRAEME', kind || 's flagged for review', count(*)::text, ''
  from needs_review group by kind
),
worst as (
  select 6, 'WORST CALORIE MISMATCHES', left(r.name, 46),
         'book ' || round(r.published_kcal) || ' vs ingredients ' || round(m.kcal),
         round((m.kcal - r.published_kcal) / r.published_kcal * 100)::text || '% out'
  from recipes r, lateral recipe_macros(r.id) m
  where r.published_kcal is not null
  order by abs(m.kcal - r.published_kcal) / r.published_kcal desc
  limit 15
)
select section, item, value, verdict from (
  select * from counts
  union all select * from slots
  union all select * from problems
  union all select * from problem_check
  union all select * from review
  union all select * from worst
) all_checks
order by ord, item;
