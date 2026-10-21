-- =====================================================================
-- Close Nutrition — 08. Finding and undoing a bad import
--
-- Run in Supabase → SQL Editor. Adds one column, then gives you two
-- things: a way to SEE what was added recently, and a way to put a
-- whole batch away in one go.
--
-- Nothing is deleted. Archiving takes recipes out of the plan builder
-- but keeps them, so a mistake here is recoverable too.
-- =====================================================================
begin;

-- tags every recipe with the import it arrived in, so a batch can be
-- undone as a batch rather than hunted for one at a time
alter table recipes add column if not exists import_batch text;
create index if not exists recipes_batch_idx on recipes (import_batch)
  where import_batch is not null;

-- what has been added lately, grouped into clusters a few minutes apart
create or replace view recent_additions as
  select date_trunc('minute', created_at) as added_at,
         count(*) as recipes,
         string_agg(name, ' · ' order by name) as names,
         coalesce(import_batch, '(added one at a time)') as batch
  from recipes
  where source <> 'master'
    and not archived
  group by 1, 4
  order by 1 desc;

-- put away everything added between two times
create or replace function cn_archive_added_between(p_from timestamptz, p_to timestamptz)
returns table (archived_name text) language sql as $$
  update recipes
     set archived = true, archived_at = now(), archived_by = 'bulk undo'
   where source <> 'master'
     and not archived
     and created_at >= p_from
     and created_at <= p_to
  returning name;
$$;

-- or put away one whole import by its tag
create or replace function cn_archive_batch(p_batch text)
returns table (archived_name text) language sql as $$
  update recipes
     set archived = true, archived_at = now(), archived_by = 'bulk undo'
   where import_batch = p_batch and not archived
  returning name;
$$;

-- and the way back, if you archive the wrong thing
create or replace function cn_restore_batch(p_batch text)
returns table (restored_name text) language sql as $$
  update recipes
     set archived = false, archived_at = null, archived_by = null
   where import_batch = p_batch and archived
  returning name;
$$;

grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

commit;

-- ---------------------------------------------------------------------
-- STEP 1 — look at what has been added recently.
-- A bad import shows up as one cluster with a lot of recipes in it.
-- ---------------------------------------------------------------------
select * from recent_additions limit 20;

-- ---------------------------------------------------------------------
-- STEP 2 — when you have found it, archive that cluster. Put the times
-- from step 1 in here, widening them by a minute at each end.
-- Nothing happens until you uncomment and run it.
-- ---------------------------------------------------------------------
-- select * from cn_archive_added_between(
--   '2026-09-25 14:20:00+00',
--   '2026-09-25 14:35:00+00');

-- ---------------------------------------------------------------------
-- If you archive too much, this puts a batch back:
--   select * from cn_restore_batch('the batch tag');
-- Or restore individually from the Archived list in the app.
-- ---------------------------------------------------------------------
