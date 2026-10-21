-- =====================================================================
-- Close Nutrition — Performance Plan Builder
-- 01. Database structure
--
-- Run this ONCE in Supabase → SQL Editor → Run.
-- It builds everything from scratch. Then run 02_seed.sql to load the
-- master recipe book.
--
-- Running this a second time WIPES everything and starts again, so
-- don't, once there is real work in here.
-- =====================================================================

drop table if exists recipe_versions   cascade;
drop table if exists recipe_ingredients cascade;
drop table if exists recipes           cascade;
drop table if exists foods             cascade;
drop table if exists plans             cascade;
drop table if exists players           cascade;
drop view  if exists needs_review      cascade;

-- ---------------------------------------------------------------------
-- Tidied-up name used for spotting duplicates.
-- "Olive Oil", "olive oil" and "Olive-Oil" all reduce to "oliveoil",
-- so they can never end up in here three times with three different
-- calorie figures. The name people see is never changed.
-- ---------------------------------------------------------------------
create or replace function norm_name(txt text)
returns text language sql immutable as $$
  select lower(regexp_replace(coalesce(txt,''), '[^a-zA-Z0-9]', '', 'g'))
$$;

-- =====================================================================
-- FOODS — every ingredient, per 100g or per 100ml
-- =====================================================================
create table foods (
  id            uuid primary key default gen_random_uuid(),
  ext_id        text unique,                    -- ING001 etc, master book only
  name          text not null,
  brand         text,
  name_key      text generated always as
                  (norm_name(coalesce(brand,'') || name)) stored,

  protein_100g  numeric(6,2) not null,
  carbs_100g    numeric(6,2) not null,
  fat_100g      numeric(6,2) not null,
  kcal_100g     numeric(7,1) not null,

  default_unit  text not null default 'g',
  density       numeric(5,3),                   -- g per ml, liquids only
  piece_grams   numeric(7,2),                   -- what one egg / bar / scoop weighs
  piece_name    text,
  portioning    text not null default 'free',
  scaling_increment numeric(6,2),

  allergens     text,
  dislike_tags  text,
  source_note   text,

  source        text not null default 'app',    -- master | app | import
  is_custom     boolean not null default true,
  needs_review  boolean not null default false,
  review_note   text,

  created_at    timestamptz not null default now(),
  created_by    text,
  updated_at    timestamptz not null default now(),

  -- ---- rules that cannot be broken, whatever route the data came in by ----
  constraint food_name_unique      unique (name_key),
  constraint food_macros_positive  check (protein_100g >= 0 and carbs_100g >= 0
                                          and fat_100g >= 0 and kcal_100g >= 0),
  constraint food_mass_balance     check (protein_100g + carbs_100g + fat_100g <= 100.5),
  constraint food_energy_density   check (kcal_100g <= 905),
  constraint food_unit_valid       check (default_unit in ('g','ml')),
  constraint food_portioning_valid check (portioning in ('free','half','whole')),
  constraint food_source_valid     check (source in ('master','app','import'))
);
comment on constraint food_mass_balance on foods is
  'Protein, carbs and fat cannot add up to more than 100g per 100g. This is the Digestive Biscuit check.';
comment on constraint food_energy_density on foods is
  'Nothing has more energy than pure fat, which is about 9 kcal per gram.';

create index foods_name_idx on foods using gin (to_tsvector('simple', name));
create index foods_review_idx on foods (needs_review) where needs_review;

-- =====================================================================
-- RECIPES — macros are never stored. They are added up from the
-- ingredients every time, so the two can never drift apart.
-- =====================================================================
create table recipes (
  id             uuid primary key default gen_random_uuid(),
  ext_id         text unique,                   -- R001 etc, master book only
  name           text not null,
  name_key       text generated always as (norm_name(name)) stored,
  slot           text not null default 'lunchdinner',
  servings       integer not null default 1,
  method         text,
  notes          text,

  published_kcal numeric(7,1),                  -- the book figure, kept as a cross-check only
  source         text not null default 'app',
  needs_review   boolean not null default false,
  review_note    text,

  created_at     timestamptz not null default now(),
  created_by     text,
  updated_at     timestamptz not null default now(),

  constraint recipe_name_unique  unique (name_key),
  constraint recipe_slot_valid   check (slot in ('breakfast','smoothie','snack','lunchdinner')),
  constraint recipe_servings_ok  check (servings >= 1),
  constraint recipe_source_valid check (source in ('master','app','import'))
);
create index recipes_review_idx on recipes (needs_review) where needs_review;

-- =====================================================================
-- RECIPE INGREDIENTS
-- =====================================================================
create table recipe_ingredients (
  id           uuid primary key default gen_random_uuid(),
  recipe_id    uuid not null references recipes(id) on delete cascade,
  food_id      uuid not null references foods(id)   on delete restrict,
  qty          numeric(9,3) not null,
  unit         text not null,
  display_text text,
  min_qty      numeric(9,3),
  max_qty      numeric(9,3),
  macro_role   text,
  sort_order   integer not null default 0,

  constraint ri_unit_valid check (unit in ('g','ml','each','tbsp','tsp','handful','slice')),
  constraint ri_qty_positive check (qty > 0)
);
create index ri_recipe_idx on recipe_ingredients (recipe_id);
create index ri_food_idx   on recipe_ingredients (food_id);
comment on constraint ri_unit_valid on recipe_ingredients is
  'Seven units only. "piece" is not one of them — use "each".';

-- =====================================================================
-- RECIPE VERSIONS — the undo. Every time a recipe is replaced, the
-- version that was there is kept, so a wrong "yes, replace" is a
-- thirty second fix rather than a lost afternoon.
-- =====================================================================
create table recipe_versions (
  id          uuid primary key default gen_random_uuid(),
  recipe_id   uuid not null references recipes(id) on delete cascade,
  name        text not null,
  snapshot    jsonb not null,        -- the whole recipe as it was
  replaced_at timestamptz not null default now(),
  replaced_by text,
  reason      text
);
create index rv_recipe_idx on recipe_versions (recipe_id, replaced_at desc);

-- =====================================================================
-- PLAYERS and saved WEEKS
-- =====================================================================
create table players (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  name_key   text generated always as (norm_name(name)) stored,
  position   text,
  bodyweight numeric(6,2),
  pro_g      numeric(6,2),
  cho_g      numeric(6,2),
  fat_g      numeric(6,2),
  notes      text,
  created_at timestamptz not null default now(),
  constraint player_name_unique unique (name_key)
);

create table plans (
  id         uuid primary key default gen_random_uuid(),
  player_id  uuid references players(id) on delete cascade,
  week_start date not null,
  title      text,
  bodyweight numeric(6,2),
  data       jsonb not null,
  avg_kcal   numeric(8,1),
  avg_pro    numeric(7,1),
  avg_cho    numeric(7,1),
  avg_fat    numeric(7,1),
  created_at timestamptz not null default now(),
  created_by text
);
create index plans_player_idx on plans (player_id, week_start desc);

-- =====================================================================
-- keep updated_at honest
-- =====================================================================
create or replace function touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

create trigger foods_touch   before update on foods   for each row execute function touch_updated_at();
create trigger recipes_touch before update on recipes for each row execute function touch_updated_at();

-- =====================================================================
-- FLAGGING — things that are possible but unlikely, so they are saved
-- and marked rather than refused. Graeme clears them in one screen.
-- =====================================================================
create or replace function flag_food()
returns trigger language plpgsql as $$
declare atwater numeric; notes text[] := '{}';
begin
  atwater := 4*new.protein_100g + 4*new.carbs_100g + 9*new.fat_100g;
  -- fibre and alcohol both legitimately break this, so it is a flag, never a block
  if new.kcal_100g > 0 and abs(atwater - new.kcal_100g) > greatest(30, 0.15*new.kcal_100g) then
    notes := notes || format('calories (%s) do not match protein/carbs/fat (%s) — fine for high-fibre or alcoholic items, worth a look otherwise',
                             round(new.kcal_100g), round(atwater));
  end if;
  if new.kcal_100g > 800 and new.fat_100g < 80 then
    notes := notes || 'very high calories for the fat content';
  end if;
  if array_length(notes,1) > 0 then
    new.needs_review := true;
    new.review_note  := array_to_string(notes, ' | ');
  elsif tg_op = 'UPDATE' and old.needs_review then
    -- somebody has been in and the numbers now look fine, so drop the flag
    new.needs_review := false;
    new.review_note  := null;
  end if;
  return new;
end $$;
create trigger foods_flag before insert or update on foods
  for each row execute function flag_food();

-- =====================================================================
-- WORKING OUT A RECIPE'S MACROS — one definition, used by the app,
-- the import and the review screen, so they can never disagree.
-- =====================================================================
create or replace function recipe_macros(p_recipe uuid)
returns table (protein numeric, carbs numeric, fat numeric, kcal numeric)
language sql stable as $$
  with g as (
    select case ri.unit
             when 'g'       then ri.qty
             when 'ml'      then ri.qty * coalesce(f.density, 1)
             when 'each'    then ri.qty * coalesce(f.piece_grams, 100)
             when 'slice'   then ri.qty * coalesce(f.piece_grams, 100)
             when 'tbsp'    then ri.qty * 15 * case when f.default_unit='ml' then coalesce(f.density,1) else 1 end
             when 'tsp'     then ri.qty *  5 * case when f.default_unit='ml' then coalesce(f.density,1) else 1 end
             when 'handful' then ri.qty * 30
             else ri.qty
           end as grams,
           f.protein_100g, f.carbs_100g, f.fat_100g
    from recipe_ingredients ri
    join foods f on f.id = ri.food_id
    where ri.recipe_id = p_recipe
  ), t as (
    select coalesce(sum(grams*protein_100g)/100,0) p,
           coalesce(sum(grams*carbs_100g)/100,0)   c,
           coalesce(sum(grams*fat_100g)/100,0)     f
    from g
  )
  select round(p/s.servings,1), round(c/s.servings,1), round(f/s.servings,1),
         round((4*p + 4*c + 9*f)/s.servings,1)
  from t, (select greatest(servings,1) servings from recipes where id = p_recipe) s;
$$;

-- fingerprint of a recipe's contents, so we can tell "already there and
-- identical" from "already there and different". This is what stops a
-- re-uploaded spreadsheet asking to replace 100 unchanged recipes.
create or replace function recipe_fingerprint(p_recipe uuid)
returns text language sql stable as $$
  select md5(
    coalesce(r.slot,'') || '|' || r.servings || '|' ||
    coalesce(string_agg(f.name_key || ':' || ri.qty || ri.unit, ',' order by f.name_key, ri.qty), '')
  )
  from recipes r
  left join recipe_ingredients ri on ri.recipe_id = r.id
  left join foods f on f.id = ri.food_id
  where r.id = p_recipe
  group by r.id, r.slot, r.servings;
$$;

-- =====================================================================
-- THE REVIEW SCREEN — one list of everything wanting a human decision
-- =====================================================================
create or replace view needs_review as
  select 'food' as kind, id, name, review_note as note, null::numeric as published_kcal,
         null::numeric as calculated_kcal, updated_at
  from foods where needs_review
  union all
  select 'recipe', r.id, r.name,
         coalesce(r.review_note,
           case when r.published_kcal is not null
                     and abs(m.kcal - r.published_kcal) > 0.15*r.published_kcal
                then format('book says %s kcal, the ingredients come to %s',
                            round(r.published_kcal), round(m.kcal))
           end),
         r.published_kcal, m.kcal, r.updated_at
  from recipes r, lateral recipe_macros(r.id) m
  where r.needs_review
     or (r.published_kcal is not null and abs(m.kcal - r.published_kcal) > 0.15*r.published_kcal);

-- =====================================================================
-- SECURITY — on, but open, until sign-in is switched on in the app.
-- When it is, change 'anon, authenticated' to 'authenticated'.
-- =====================================================================
alter table foods              enable row level security;
alter table recipes            enable row level security;
alter table recipe_ingredients enable row level security;
alter table recipe_versions    enable row level security;
alter table players            enable row level security;
alter table plans              enable row level security;

do $$
declare t text;
begin
  foreach t in array array['foods','recipes','recipe_ingredients',
                           'recipe_versions','players','plans'] loop
    execute format('create policy %I_all on %I for all to anon, authenticated using (true) with check (true)', t, t);
  end loop;
end $$;

grant usage on schema public to anon, authenticated;
grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

select 'structure built' as status;
