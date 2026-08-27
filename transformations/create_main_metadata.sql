-- Creates the final main_metadata table
CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.main_metadata`

PARTITION BY start_date_time
CLUSTER BY match_id
AS
SELECT
  SAFE_CAST(match_id AS INT64) AS match_id,
  SAFE_CAST(dire_score AS INT64) AS dire_score,
  SAFE_CAST(duration AS INT64) AS duration,
  SAFE_CAST(first_blood_time AS INT64) AS first_blood_time,
  SAFE_CAST(leagueid AS INT64) AS league_id,
  SAFE_CAST(match_seq_num AS INT64) AS match_seq_num,
  SAFE_CAST(radiant_score AS INT64) AS radiant_score,
  SAFE_CAST(radiant_win AS BOOL) AS radiant_win,
  DATE(SAFE.TIMESTAMP(start_date_time)) AS start_date_time,
  SAFE_CAST(version AS FLOAT64) AS version,
  SAFE_CAST(region AS INT64) AS region,
  SAFE_CAST(throw AS INT64) AS throw,
  SAFE_CAST(loss AS INT64) AS loss,
  SAFE_CAST(comeback AS INT64) AS comeback,
  SAFE_CAST(stomp AS INT64) AS stomp,
  SAFE_CAST(dire_team_id AS INT64) AS dire_team_id,
  SAFE_CAST(radiant_team_id AS INT64) AS radiant_team_id

FROM `dota-2-analysis.dota2_staging.stage_main_metadata_raw_2016_2023`
UNION ALL 

SELECT 
  SAFE_CAST(match_id AS INT64) AS match_id,
  SAFE_CAST(dire_score AS INT64) AS dire_score,
  SAFE_CAST(duration AS INT64) AS duration,
  SAFE_CAST(first_blood_time AS INT64) AS first_blood_time,
  SAFE_CAST(leagueid AS INT64) AS league_id,
  SAFE_CAST(match_seq_num AS INT64) AS match_seq_num,
  SAFE_CAST(radiant_score AS INT64) AS radiant_score,
  SAFE_CAST(radiant_win AS BOOL) AS radiant_win,
  DATE(SAFE.TIMESTAMP(start_date_time)) AS start_date_time,
  SAFE_CAST(version AS FLOAT64) AS version,
  SAFE_CAST(region AS INT64) AS region,
  SAFE_CAST(throw AS INT64) AS throw,
  SAFE_CAST(loss AS INT64) AS loss,
  SAFE_CAST(comeback AS INT64) AS comeback,
  SAFE_CAST(stomp AS INT64) AS stomp,
  SAFE_CAST(dire_team_id AS INT64) AS dire_team_id,
  SAFE_CAST(radiant_team_id AS INT64) AS radiant_team_id
FROM `dota-2-analysis.dota2_staging.stage_main_metadata_raw_current_era`