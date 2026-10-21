-- =====================================================================
-- Close Nutrition — Performance Plan Builder
-- 02. The import API
--
-- Run AFTER 01_schema.sql. Safe to re-run at any time: it only
-- replaces the functions, it never touches data.
--
-- These are the four things the app calls:
--   cn_preview_import   what would happen if I uploaded this? (writes nothing)
--   cn_upsert_food      add or update one food
--   cn_upsert_recipe    add or update one recipe, keeping the old version
--   cn_restore_version  put a replaced recipe back
-- =====================================================================

-- ---------------------------------------------------------------------
-- Work out the fingerprint of a recipe we have been HANDED, so it can be
-- compared with one already stored without writing anything first.
-- ---------------------------------------------------------------------
create or replace function cn_payload_fingerprint(p jsonb)
returns text language sql immutable as $$
  select md5(
    coalesce(p->>'slot','') || '|' ||
    coalesce(p->>'servings','1') || '|' ||
    coalesce((
      select string_agg(norm_name(coalesce(i->>'brand','') || (i->>'name')) || ':' ||
                        (i->>'qty') || (i->>'unit'), ','
                        order by norm_name(coalesce(i->>'brand','') || (i->>'name')), (i->>'qty'))
      from jsonb_array_elements(coalesce(p->'items','[]'::jsonb)) i
    ), '')
  )
$$;

-- =====================================================================
-- PREVIEW — the heart of the "ask once" flow.
--
-- Hand it the whole uploaded file. It writes NOTHING and tells you, for
-- every row, whether it is new, already there and identical, or already
-- there and different — and for the different ones, what changed.
--
-- Rows that are already there and identical are reported as 'unchanged'
-- so the app can stay quiet about them. That is what stops a re-uploaded
-- spreadsheet asking to replace 100 recipes when only 5 have moved.
-- =====================================================================
create or replace function cn_preview_import(p_payload jsonb)
returns table (
  row_index    integer,
  kind         text,
  name         text,
  status       text,     -- new | unchanged | changed | blocked
  existing_id  uuid,
  detail       text
)
language plpgsql stable as $$
declare
  item     jsonb;
  idx      integer := 0;
  ex       record;
  fp_new   text;
  changes  text[];
  atwater  numeric;
begin
  ---------------------------------------------------------------- foods
  for item in select * from jsonb_array_elements(coalesce(p_payload->'foods','[]'::jsonb))
  loop
    idx := idx + 1;
    changes := '{}';
    row_index := idx; kind := 'food'; name := item->>'name';
    existing_id := null; detail := null;

    -- refusals first: these can never be right, so they are never offered
    if (item->>'protein_100g')::numeric + (item->>'carbs_100g')::numeric
       + (item->>'fat_100g')::numeric > 100.5 then
      status := 'blocked';
      detail := 'protein, carbs and fat add up to more than 100g per 100g';
      return next; continue;
    end if;
    if (item->>'kcal_100g')::numeric > 905 then
      status := 'blocked';
      detail := 'more than 9 kcal per gram, which is more than pure fat';
      return next; continue;
    end if;
    if least((item->>'protein_100g')::numeric, (item->>'carbs_100g')::numeric,
             (item->>'fat_100g')::numeric, (item->>'kcal_100g')::numeric) < 0 then
      status := 'blocked'; detail := 'negative value'; return next; continue;
    end if;

    select * into ex from foods
     where name_key = norm_name(coalesce(item->>'brand','') || (item->>'name'));

    if not found then
      status := 'new';
      atwater := 4*(item->>'protein_100g')::numeric + 4*(item->>'carbs_100g')::numeric
               + 9*(item->>'fat_100g')::numeric;
      if abs(atwater - (item->>'kcal_100g')::numeric)
         > greatest(30, 0.15*(item->>'kcal_100g')::numeric) then
        detail := format('calories and macros disagree (%s vs %s) — will be flagged for review',
                         round((item->>'kcal_100g')::numeric), round(atwater));
      end if;
    else
      existing_id := ex.id;
      if round(ex.protein_100g,2) is distinct from round((item->>'protein_100g')::numeric,2)
        then changes := changes || format('protein %s → %s', ex.protein_100g, item->>'protein_100g'); end if;
      if round(ex.carbs_100g,2) is distinct from round((item->>'carbs_100g')::numeric,2)
        then changes := changes || format('carbs %s → %s', ex.carbs_100g, item->>'carbs_100g'); end if;
      if round(ex.fat_100g,2) is distinct from round((item->>'fat_100g')::numeric,2)
        then changes := changes || format('fat %s → %s', ex.fat_100g, item->>'fat_100g'); end if;
      if round(ex.kcal_100g,1) is distinct from round((item->>'kcal_100g')::numeric,1)
        then changes := changes || format('%s → %s kcal', ex.kcal_100g, item->>'kcal_100g'); end if;
      if array_length(changes,1) > 0 then
        status := 'changed'; detail := array_to_string(changes, ', ');
      else
        status := 'unchanged';
      end if;
    end if;
    return next;
  end loop;

  -------------------------------------------------------------- recipes
  for item in select * from jsonb_array_elements(coalesce(p_payload->'recipes','[]'::jsonb))
  loop
    idx := idx + 1;
    changes := '{}';
    row_index := idx; kind := 'recipe'; name := item->>'name';
    existing_id := null; detail := null;

    if coalesce(jsonb_array_length(item->'items'),0) = 0 then
      status := 'blocked'; detail := 'no ingredients'; return next; continue;
    end if;
    if (item->>'slot') not in ('breakfast','smoothie','snack','lunchdinner') then
      status := 'blocked';
      detail := format('meal type "%s" is not one of the four allowed', item->>'slot');
      return next; continue;
    end if;

    select * into ex from recipes where name_key = norm_name(item->>'name');

    if not found then
      status := 'new';
    else
      existing_id := ex.id;
      fp_new := cn_payload_fingerprint(item);
      if fp_new = recipe_fingerprint(ex.id) then
        status := 'unchanged';
      else
        status := 'changed';
        if ex.servings is distinct from coalesce((item->>'servings')::int,1)
          then changes := changes || format('servings %s → %s', ex.servings, item->>'servings'); end if;
        if ex.slot is distinct from (item->>'slot')
          then changes := changes || format('%s → %s', ex.slot, item->>'slot'); end if;
        declare old_n integer; new_n integer;
        begin
          select count(*) into old_n from recipe_ingredients where recipe_id = ex.id;
          new_n := jsonb_array_length(item->'items');
          if old_n is distinct from new_n then
            changes := changes || format('%s ingredients → %s', old_n, new_n);
          elsif array_length(changes,1) is null then
            changes := changes || 'ingredient amounts changed';
          end if;
        end;
        detail := array_to_string(changes, ', ');
      end if;
    end if;
    return next;
  end loop;
end $$;

-- =====================================================================
-- ADD OR UPDATE ONE FOOD
-- =====================================================================
create or replace function cn_upsert_food(p jsonb, p_replace boolean default false)
returns jsonb language plpgsql as $$
declare ex record; new_id uuid;
begin
  select * into ex from foods
   where name_key = norm_name(coalesce(p->>'brand','') || (p->>'name'));

  if found then
    if not p_replace then
      return jsonb_build_object('action','kept','id',ex.id);
    end if;
    update foods set
      name         = coalesce(p->>'name', name),
      brand        = p->>'brand',
      protein_100g = (p->>'protein_100g')::numeric,
      carbs_100g   = (p->>'carbs_100g')::numeric,
      fat_100g     = (p->>'fat_100g')::numeric,
      kcal_100g    = (p->>'kcal_100g')::numeric,
      default_unit = coalesce(p->>'default_unit', default_unit),
      density      = nullif(p->>'density','')::numeric,
      piece_grams  = nullif(p->>'piece_grams','')::numeric,
      piece_name   = p->>'piece_name',
      portioning   = coalesce(p->>'portioning', portioning),
      allergens    = p->>'allergens',
      source       = coalesce(p->>'source', source)
    where id = ex.id;
    return jsonb_build_object('action','updated','id',ex.id);
  end if;

  insert into foods (name, brand, protein_100g, carbs_100g, fat_100g, kcal_100g,
                     default_unit, density, piece_grams, piece_name, portioning,
                     allergens, source, created_by, is_custom)
  values (p->>'name', p->>'brand',
          (p->>'protein_100g')::numeric, (p->>'carbs_100g')::numeric,
          (p->>'fat_100g')::numeric, (p->>'kcal_100g')::numeric,
          coalesce(p->>'default_unit','g'), nullif(p->>'density','')::numeric,
          nullif(p->>'piece_grams','')::numeric, p->>'piece_name',
          coalesce(p->>'portioning','free'), p->>'allergens',
          coalesce(p->>'source','app'), p->>'created_by',
          coalesce((p->>'source') <> 'master', true))
  returning id into new_id;
  return jsonb_build_object('action','inserted','id',new_id);
end $$;

-- =====================================================================
-- ADD OR UPDATE ONE RECIPE
--
-- Every food named must already exist, or be described well enough to be
-- created. Replacing keeps the old version first, so it can be put back.
-- =====================================================================
create or replace function cn_upsert_recipe(p jsonb,
                                            p_replace boolean default false,
                                            p_reason  text default null)
returns jsonb language plpgsql as $$
declare
  ex        record;
  rid       uuid;
  item      jsonb;
  fid       uuid;
  i         integer := 0;
  snap      jsonb;
  was       text;
begin
  select * into ex from recipes where name_key = norm_name(p->>'name');

  if found then
    if not p_replace then
      return jsonb_build_object('action','kept','id',ex.id);
    end if;
    -- keep what is about to be lost
    select jsonb_build_object(
             'recipe', to_jsonb(ex),
             'items', coalesce(jsonb_agg(jsonb_build_object(
                        'food_id', ri.food_id, 'qty', ri.qty, 'unit', ri.unit,
                        'display_text', ri.display_text, 'sort_order', ri.sort_order)
                        order by ri.sort_order), '[]'::jsonb))
      into snap
      from recipe_ingredients ri where ri.recipe_id = ex.id;

    insert into recipe_versions (recipe_id, name, snapshot, replaced_by, reason)
    values (ex.id, ex.name, snap, p->>'created_by',
            coalesce(p_reason, 'replaced by import'));

    rid := ex.id;
    update recipes set
      name = p->>'name',
      slot = coalesce(p->>'slot', slot),
      servings = coalesce((p->>'servings')::int, servings),
      method = p->>'method',
      notes = p->>'notes',
      published_kcal = nullif(p->>'published_kcal','')::numeric,
      source = coalesce(p->>'source', source)
    where id = rid;
    delete from recipe_ingredients where recipe_id = rid;
    was := 'updated';
  else
    insert into recipes (name, slot, servings, method, notes, published_kcal,
                         source, created_by)
    values (p->>'name', coalesce(p->>'slot','lunchdinner'),
            coalesce((p->>'servings')::int,1), p->>'method', p->>'notes',
            nullif(p->>'published_kcal','')::numeric,
            coalesce(p->>'source','app'), p->>'created_by')
    returning id into rid;
    was := 'inserted';
  end if;

  for item in select * from jsonb_array_elements(coalesce(p->'items','[]'::jsonb))
  loop
    i := i + 1;
    if item ? 'food_id' and (item->>'food_id') <> '' then
      fid := (item->>'food_id')::uuid;
    else
      select id into fid from foods
       where name_key = norm_name(coalesce(item->>'brand','') || (item->>'name'));
      if fid is null then
        if not (item ? 'protein_100g') then
          raise exception 'Ingredient "%" is not in the food list and has no nutrition given',
                          item->>'name';
        end if;
        fid := (cn_upsert_food(item - 'qty' - 'unit', false)->>'id')::uuid;
      end if;
    end if;

    insert into recipe_ingredients
      (recipe_id, food_id, qty, unit, display_text, min_qty, max_qty, macro_role, sort_order)
    values (rid, fid, (item->>'qty')::numeric, coalesce(item->>'unit','g'),
            item->>'display_text', nullif(item->>'min_qty','')::numeric,
            nullif(item->>'max_qty','')::numeric, item->>'macro_role', i);
  end loop;

  return jsonb_build_object('action', was, 'id', rid, 'ingredients', i);
end $$;

-- =====================================================================
-- UNDO — put a replaced recipe back the way it was
-- =====================================================================
create or replace function cn_restore_version(p_version uuid)
returns jsonb language plpgsql as $$
declare v record; snap jsonb; item jsonb; i integer := 0; cur jsonb;
begin
  select * into v from recipe_versions where id = p_version;
  if not found then raise exception 'That version no longer exists'; end if;
  snap := v.snapshot;

  -- keep the current state too, so undo can itself be undone
  select jsonb_build_object('recipe', to_jsonb(r),
           'items', coalesce(jsonb_agg(jsonb_build_object(
             'food_id', ri.food_id, 'qty', ri.qty, 'unit', ri.unit,
             'display_text', ri.display_text, 'sort_order', ri.sort_order)
             order by ri.sort_order), '[]'::jsonb))
    into cur
    from recipes r left join recipe_ingredients ri on ri.recipe_id = r.id
   where r.id = v.recipe_id group by r.id;
  insert into recipe_versions (recipe_id, name, snapshot, reason)
  values (v.recipe_id, v.name, cur, 'replaced by an undo');

  update recipes set
    name           = snap->'recipe'->>'name',
    slot           = snap->'recipe'->>'slot',
    servings       = (snap->'recipe'->>'servings')::int,
    method         = snap->'recipe'->>'method',
    notes          = snap->'recipe'->>'notes',
    published_kcal = nullif(snap->'recipe'->>'published_kcal','')::numeric
  where id = v.recipe_id;

  delete from recipe_ingredients where recipe_id = v.recipe_id;
  for item in select * from jsonb_array_elements(snap->'items') loop
    i := i + 1;
    insert into recipe_ingredients
      (recipe_id, food_id, qty, unit, display_text, sort_order)
    values (v.recipe_id, (item->>'food_id')::uuid, (item->>'qty')::numeric,
            item->>'unit', item->>'display_text', i);
  end loop;

  return jsonb_build_object('action','restored','id',v.recipe_id,'ingredients',i);
end $$;

-- =====================================================================
-- EXPORT — the whole live library, in the shape the master workbook uses.
-- This is how a fresh master file gets made as things grow. The original
-- file is never touched; a new one is written alongside it.
-- =====================================================================
create or replace function cn_export_library()
returns jsonb language sql stable as $$
  select jsonb_build_object(
    'exported_at', now(),
    'foods', (select coalesce(jsonb_agg(to_jsonb(f) order by f.name), '[]'::jsonb) from foods f),
    'recipes', (select coalesce(jsonb_agg(
        to_jsonb(r) || jsonb_build_object(
          'macros', (select to_jsonb(m) from recipe_macros(r.id) m),
          'items', (select coalesce(jsonb_agg(jsonb_build_object(
                      'food', f.name, 'ext_id', f.ext_id, 'qty', ri.qty,
                      'unit', ri.unit, 'display_text', ri.display_text,
                      'sort_order', ri.sort_order) order by ri.sort_order), '[]'::jsonb)
                    from recipe_ingredients ri join foods f on f.id = ri.food_id
                    where ri.recipe_id = r.id))
        order by r.name), '[]'::jsonb) from recipes r)
  )
$$;

grant execute on all functions in schema public to anon, authenticated;

select 'import API built' as status;
