-- =====================================================================
-- Close Nutrition — 12. Adding "Off" as a day type
--
-- A rest day with its own g/kg targets, alongside Normal, Game Day,
-- Game Day -1 and Game Day +1. Run once in Supabase.
-- Only widens a rule — changes no data.
-- =====================================================================
begin;

alter table player_day_targets drop constraint if exists day_type_valid;
alter table player_day_targets add constraint day_type_valid check
  (day_type in ('Normal','Game Day','Game Day -1','Game Day +1','Off'));

commit;
select 'Off is now an allowed day type' as status;
