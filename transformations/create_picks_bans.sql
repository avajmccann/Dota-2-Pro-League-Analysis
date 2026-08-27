-- Creates the final picks_bans table
CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.picks_bans`

CLUSTER BY match_id, hero_id
AS
SELECT
  CAST(is_pick AS BOOL) AS is_pick,
  CAST(hero_id AS INT64) AS hero_id,
  CAST(ord AS INT64) AS ord,
  CAST(team AS INT64) AS team,
  CAST(match_id AS INT64) AS match_id,
  CAST(leagueid AS INT64) AS league_id,

FROM `dota-2-analysis.dota2_staging.stage_picks_bans_raw_2016_2023`
UNION ALL 

SELECT 
  CAST(is_pick AS BOOL) AS is_pick,
  CAST(hero_id AS INT64) AS hero_id,
  CAST(ord AS INT64) AS ord,
  CAST(team AS INT64) AS team,
  CAST(match_id AS INT64) AS match_id,
  CAST(leagueid AS INT64) AS league_id,
FROM `dota-2-analysis.dota2_staging.stage_picks_bans_raw_current_era`