-- Creates the raw main_metadata table for data after 2024
CREATE OR REPLACE EXTERNAL TABLE dota2_staging.stage_main_metadata_raw_current_era (
  version STRING,
  match_id STRING,
  leagueid STRING,
  start_date_time STRING,
  duration STRING,
  radiant_win STRING,
  match_seq_num STRING,
  first_blood_time STRING,
  radiant_score STRING,
  dire_score STRING,
  dire_team_id FLOAT64,
  radiant_team_id FLOAT64,
  region FLOAT64,
  throw FLOAT64,
  loss FLOAT64,
  comeback FLOAT64,
  stomp FLOAT64,
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://dota2-analysis/matches/2024/main_metadata.csv',
  'gs://dota2-analysis/matches/2025/main_metadata.csv',
  'gs://dota2-analysis/matches/2026/*/main_metadata.csv'],
  skip_leading_rows = 1,
  ignore_unknown_values = true 
);