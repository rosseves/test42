-- =====================================================================
-- Close Nutrition — Performance Plan Builder
-- 05. Supplements, player detail, and the swapping rules
--
-- Run AFTER 01-03. This one only ADDS. It never deletes anything and
-- never changes a recipe, so it is safe to run on a live database and
-- safe to run twice.
-- =====================================================================

begin;

-- ---------------------------------------------------------------------
-- 1. WHEN IN THE DAY — meals and supplements share one timeline, so a
--    pre-training shake sits in the right place rather than being
--    filed under "snack".
-- ---------------------------------------------------------------------
create table if not exists day_slots (
  slot        text primary key,
  label       text not null,
  sort_order  integer not null,
  is_meal     boolean not null default false
);

insert into day_slots (slot, label, sort_order, is_meal) values
  ('waking',        'On waking',      10, false),
  ('breakfast',     'Breakfast',      20, true),
  ('pre_training',  'Pre-training',   30, false),
  ('post_training', 'Post-training',  40, false),
  ('snack',         'Snack',          50, true),
  ('lunchdinner',   'Lunch / dinner', 60, true),
  ('smoothie',      'Smoothie',       70, true),
  ('bed',           'Before bed',     80, false)
on conflict (slot) do nothing;

-- ---------------------------------------------------------------------
-- 2. SUPPLEMENTS — things that are not food. Anything with meaningful
--    nutrition (whey, carb powder) belongs in foods, not here.
-- ---------------------------------------------------------------------
create table if not exists supplements (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  brand        text,
  name_key     text generated always as (norm_name(coalesce(brand,'') || name)) stored,
  dose_amount  numeric(8,2),
  dose_unit    text,
  default_slot text references day_slots(slot),
  notes        text,
  source       text not null default 'app',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  constraint supplement_name_unique unique (name_key),
  constraint supplement_dose_ok     check (dose_amount is null or dose_amount > 0),
  constraint supplement_unit_ok     check (dose_unit is null or dose_unit in
                 ('g','mg','ug','ml','capsule','tablet','scoop','sachet','gel','IU'))
);

-- a player's standing protocol: set once, applies every day
create table if not exists player_supplements (
  id            uuid primary key default gen_random_uuid(),
  player_id     uuid not null references players(id) on delete cascade,
  supplement_id uuid not null references supplements(id) on delete cascade,
  dose_amount   numeric(8,2),
  dose_unit     text,
  slot          text references day_slots(slot),
  notes         text,
  created_at    timestamptz not null default now(),
  unique (player_id, supplement_id, slot)
);

-- ---------------------------------------------------------------------
-- 3. PLAYER DETAIL
-- ---------------------------------------------------------------------
alter table players add column if not exists height_cm      numeric(5,1);
alter table players add column if not exists notes          text;
alter table players add column if not exists bodyweight_at  date;
alter table players add column if not exists archived       boolean not null default false;

-- targets per day type, matching the four already in the app.
-- Entered in grams per kilo, so they follow the player's bodyweight.
create table if not exists player_day_targets (
  id         uuid primary key default gen_random_uuid(),
  player_id  uuid not null references players(id) on delete cascade,
  day_type   text not null,
  pro_g_kg   numeric(5,2),
  cho_g_kg   numeric(5,2),
  fat_g_kg   numeric(5,2),
  unique (player_id, day_type),
  constraint day_type_valid check
    (day_type in ('Normal','Game Day','Game Day -1','Game Day +1'))
);

-- what a player cannot or will not eat
create table if not exists player_avoids (
  id         uuid primary key default gen_random_uuid(),
  player_id  uuid not null references players(id) on delete cascade,
  food_id    uuid references foods(id) on delete cascade,
  swap_group text,          -- avoid a whole category, e.g. all pork
  allergen   text,
  severity   text not null default 'dislike',
  notes      text,
  created_at timestamptz not null default now(),
  constraint severity_valid check (severity in ('allergy','intolerance','dislike')),
  constraint avoids_something check
    (food_id is not null or allergen is not null or swap_group is not null)
);
alter table player_avoids add column if not exists swap_group text;
-- if this table already existed from an earlier run, widen the rule so a
-- whole category can be ruled out, not just a single food or an allergen
alter table player_avoids drop constraint if exists avoids_something;
alter table player_avoids add constraint avoids_something check
  (food_id is not null or allergen is not null or swap_group is not null);

comment on table player_avoids is
  'severity decides the behaviour. allergy: never include, always substitute, '
  'always say so on the PDF. intolerance: substitute and flag on screen. '
  'dislike: substitute or drop quietly.';

-- favourites. player_id null means a team-wide favourite.
create table if not exists favourites (
  id         uuid primary key default gen_random_uuid(),
  player_id  uuid references players(id) on delete cascade,
  recipe_id  uuid not null references recipes(id) on delete cascade,
  created_at timestamptz not null default now()
);
create unique index if not exists fav_unique
  on favourites (coalesce(player_id, '00000000-0000-0000-0000-000000000000'::uuid), recipe_id);

-- ---------------------------------------------------------------------
-- 4. SWAPPING RULES
-- ---------------------------------------------------------------------
alter table foods add column if not exists swap_group text;
alter table recipe_ingredients add column if not exists role text;
alter table recipes add column if not exists prep_mins integer;
alter table recipes add column if not exists cook_mins integer;

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'ri_role_valid') then
    alter table recipe_ingredients add constraint ri_role_valid
      check (role is null or role in ('anchor','base','supporting','flavouring'));
  end if;
end $$;

comment on column recipe_ingredients.role is
  'anchor: the dish is this, swap it but never drop it. base: the carbohydrate, '
  'same rule. supporting: drop or swap, either is fine. flavouring: just remove it.';

-- which groups to try when nothing in a food''s own group will do
create table if not exists swap_families (
  swap_group text not null,
  fallback   text not null,
  priority   integer not null,
  primary key (swap_group, fallback)
);

-- ---------------------------------------------------------------------
-- 5. FINDING A REPLACEMENT
--    Own group first, then the family, closest in character first.
--    It does not need matching macros - the app rescales every
--    ingredient to the player's targets anyway - so this only has to
--    make sense in the kitchen.
-- ---------------------------------------------------------------------
create or replace function cn_find_substitute(p_food uuid, p_player uuid)
returns table (food_id uuid, name text, swap_group text, closeness numeric)
language sql stable as $$
  with me as (select * from foods where id = p_food),
  banned as (
    -- a named food they will not eat
    select pa.food_id from player_avoids pa
     where pa.player_id = p_player and pa.food_id is not null
    union
    -- everything in that food's category, so "no pork" also rules out ham
    select f.id from foods f
     join player_avoids pa on pa.player_id = p_player
     join foods src on src.id = pa.food_id
    where pa.severity in ('allergy','intolerance')
      and f.swap_group = src.swap_group
    union
    -- a whole category ruled out directly
    select f.id from foods f, player_avoids pa
     where pa.player_id = p_player and pa.swap_group is not null
       and f.swap_group = pa.swap_group
    union
    -- an allergen. A food with nothing recorded counts as unsafe, because
    -- blank means nobody checked, not that there is nothing in it.
    select f.id from foods f, player_avoids pa
     where pa.player_id = p_player and pa.allergen is not null
       and (f.allergens ilike '%' || pa.allergen || '%' or f.allergens is null)
  ),
  pool as (
    select f.*, 0 as tier from foods f, me
     where f.swap_group = me.swap_group and f.id <> me.id
    union all
    select f.*, sf.priority from foods f, me
     join swap_families sf on sf.swap_group = me.swap_group
     where f.swap_group = sf.fallback
  )
  select p.id, p.name, p.swap_group,
         round((abs(p.protein_100g - m.protein_100g)
              + abs(p.carbs_100g   - m.carbs_100g)
              + abs(p.fat_100g     - m.fat_100g))::numeric, 1)
  from pool p, me m
  where p.id not in (select food_id from banned)
  order by p.tier,
           abs(p.protein_100g - m.protein_100g)
         + abs(p.carbs_100g - m.carbs_100g)
         + abs(p.fat_100g - m.fat_100g)
  limit 5;
$$;

-- ---------------------------------------------------------------------
-- 6. Security, same as the rest
-- ---------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array['supplements','player_supplements','player_day_targets',
                           'player_avoids','favourites','day_slots','swap_families'] loop
    execute format('alter table %I enable row level security', t);
    if not exists (select 1 from pg_policies where tablename = t) then
      execute format('create policy %I_all on %I for all to anon, authenticated '
                     'using (true) with check (true)', t, t);
    end if;
  end loop;
end $$;

grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

commit;

select 'supplements, player detail and swap rules added' as status;
