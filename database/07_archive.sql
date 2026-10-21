-- =====================================================================
-- Close Nutrition — 07. Archiving instead of deleting
--
-- Run after the others. Only adds columns, changes no data.
-- Safe to run twice.
--
-- Deleting a recipe took its ingredients with it and kept no copy, so one
-- mis-click removed it for everyone, permanently. Now nothing is destroyed:
-- it is put away, and can be brought back.
-- =====================================================================
begin;

alter table recipes add column if not exists archived     boolean not null default false;
alter table recipes add column if not exists archived_at  timestamptz;
alter table recipes add column if not exists archived_by  text;
alter table foods   add column if not exists archived     boolean not null default false;
alter table foods   add column if not exists archived_at  timestamptz;
alter table supplements add column if not exists archived    boolean not null default false;
alter table supplements add column if not exists archived_at timestamptz;

create index if not exists recipes_archived_idx on recipes (archived) where archived;
create index if not exists foods_archived_idx   on foods   (archived) where archived;
create index if not exists supps_archived_idx   on supplements (archived) where archived;

-- Recipes added in the app are cleared 30 days after archiving.
-- Anything from the master book is kept indefinitely: if one is archived by
-- mistake and nobody notices for a month, the only way back is a re-import.
create or replace function cn_purge_archived()
returns table (removed_name text) language sql as $$
  delete from recipes
   where archived
     and source <> 'master'
     and archived_at < now() - interval '30 days'
  returning name;
$$;

comment on function cn_purge_archived is
  'Nothing runs this on its own. Either call it by hand, or set up a scheduled '
  'job in Supabase if you want the clear-out to be automatic.';

-- how long an archived recipe has left
create or replace view archived_recipes as
  select r.id, r.name, r.slot, r.source, r.archived_at, r.archived_by,
         case when r.source = 'master' then null
              else greatest(0, 30 - extract(day from now() - r.archived_at)::int)
         end as days_left,
         (select count(*) from recipe_ingredients ri where ri.recipe_id = r.id) as ingredients
  from recipes r
  where r.archived
  order by r.archived_at desc;

grant all on all tables in schema public to anon, authenticated;
grant execute on all functions in schema public to anon, authenticated;

commit;
select 'archiving added — deletes are now recoverable' as status;
