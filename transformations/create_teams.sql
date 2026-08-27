-- Creates the final teams table
CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.teams`

CLUSTER BY match_id
AS
SELECT
  CAST(match_id AS INT64) AS match_id,
  CAST(leagueid AS INT64) AS league_id,
  SAFE_CAST( NULLIF(radiant_team_id, -1) AS INT64) AS radiant_team_id,
  SAFE_CAST( NULLIF(radiant_name, '<UNKNOWN>') AS STRING) AS radiant_name,
  SAFE_CAST( NULLIF(radiant_tag, '<UNKNOWN>') AS STRING) AS radiant_tag,
  SAFE_CAST( NULLIF(dire_team_id, -1) AS INT64) AS dire_team_id,
  SAFE_CAST( NULLIF(dire_name, '<UNKNOWN>') AS STRING) AS dire_name,
  SAFE_CAST( NULLIF(dire_tag, '<UNKNOWN>') AS STRING) AS dire_tag

FROM `dota-2-analysis.dota2_staging.stage_teams_raw_2016_2023`
UNION ALL 

SELECT 
  CAST(match_id AS INT64) AS match_id,
  CAST(leagueid AS INT64) AS league_id,
  SAFE_CAST( NULLIF(radiant_team_id, -1) AS INT64) AS radiant_team_id,
  SAFE_CAST( NULLIF(radiant_name, '<UNKNOWN>') AS STRING) AS radiant_name,
  SAFE_CAST( NULLIF(radiant_tag, '<UNKNOWN>') AS STRING) AS radiant_tag,
  SAFE_CAST( NULLIF(dire_team_id, -1) AS INT64) AS dire_team_id,
  SAFE_CAST( NULLIF(dire_name, '<UNKNOWN>') AS STRING) AS dire_name,
  SAFE_CAST( NULLIF(dire_tag, '<UNKNOWN>') AS STRING) AS dire_tag
FROM `dota-2-analysis.dota2_staging.stage_teams_raw_current_era`