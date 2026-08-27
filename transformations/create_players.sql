-- Creates the final players table
CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.players`

CLUSTER BY hero_id, match_id
AS
SELECT
  SAFE_CAST(match_id AS INT64) AS match_id,
  SAFE_CAST(player_slot AS INT64) AS player_slot,
  SAFE_CAST(SAFE_CAST(firstblood_claimed AS FLOAT64) AS INT64) AS firstblood_claimed,
  SAFE_CAST(SAFE_CAST(account_id AS FLOAT64) AS INT64) AS account_id,
  SAFE_CAST(SAFE_CAST(hero_id AS FLOAT64) AS INT64) AS hero_id,
  SAFE_CAST(SAFE_CAST(deaths AS FLOAT64) AS INT64) AS deaths,
  SAFE_CAST(SAFE_CAST(assists AS FLOAT64) AS INT64) AS assists,
  SAFE_CAST(SAFE_CAST(level AS FLOAT64) AS INT64) AS level,
  personaname,
  SAFE_CAST(radiant_win AS BOOL) AS radiant_win,
  SAFE_CAST(isRadiant AS BOOL) AS is_radiant,
  SAFE_CAST(win AS INT64) AS win,
  SAFE_CAST(lose AS INT64) AS lose,
  SAFE_CAST(kills_per_min AS FLOAT64) AS kills_per_min,
  SAFE_CAST(kda AS FLOAT64) AS kda,
  SAFE_CAST(SAFE_CAST(lane AS FLOAT64) AS INT64) AS lane,
  SAFE_CAST(SAFE_CAST(lane_role AS FLOAT64) AS INT64) AS lane_role,
  SAFE_CAST(leagueid AS INT64) AS league_id

FROM `dota-2-analysis.dota2_staging.stage_players_raw_2016_2023`
UNION ALL 

SELECT 
  SAFE_CAST(match_id AS INT64) AS match_id,
  SAFE_CAST(player_slot AS INT64) AS player_slot,
  SAFE_CAST(SAFE_CAST(firstblood_claimed AS FLOAT64) AS INT64) AS firstblood_claimed,
  SAFE_CAST(SAFE_CAST(account_id AS FLOAT64) AS INT64) AS account_id,
  SAFE_CAST(SAFE_CAST(hero_id AS FLOAT64) AS INT64) AS hero_id,
  SAFE_CAST(SAFE_CAST(deaths AS FLOAT64) AS INT64) AS deaths,
  SAFE_CAST(SAFE_CAST(assists AS FLOAT64) AS INT64) AS assists,
  SAFE_CAST(SAFE_CAST(level AS FLOAT64) AS INT64) AS level,
  personaname,
  SAFE_CAST(radiant_win AS BOOL) AS radiant_win,
  SAFE_CAST(isRadiant AS BOOL) AS is_radiant,
  SAFE_CAST(win AS INT64) AS win,
  SAFE_CAST(lose AS INT64) AS lose,
  SAFE_CAST(kills_per_min AS FLOAT64) AS kills_per_min,
  SAFE_CAST(kda AS FLOAT64) AS kda,
  SAFE_CAST(SAFE_CAST(lane AS FLOAT64) AS INT64) AS lane,
  SAFE_CAST(SAFE_CAST(lane_role AS FLOAT64) AS INT64) AS lane_role,
  SAFE_CAST(leagueid AS INT64) AS league_id
FROM `dota-2-analysis.dota2_staging.stage_players_raw_current_era`