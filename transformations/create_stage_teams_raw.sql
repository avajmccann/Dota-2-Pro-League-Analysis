-- Creates the raw teams table for data after 2024
CREATE OR REPLACE EXTERNAL TABLE dota2_staging.stage_teams_raw_current_era (
  match_id FLOAT64,
  leagueid FLOAT64,
  radiant_team_id FLOAT64,
  radiant_name STRING,
  radiant_tag STRING,
  radiant_logo_url STRING,
  dire_team_id FLOAT64,
  dire_name STRING,
  dire_tag STRING,
  dire_logo_url STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://dota2-analysis/matches/2024/teams.csv',
  'gs://dota2-analysis/matches/2025/teams.csv',
  'gs://dota2-analysis/matches/2026/*/teams.csv'],
  skip_leading_rows = 1,
  allow_jagged_rows = true, 
  ignore_unknown_values = true 
);