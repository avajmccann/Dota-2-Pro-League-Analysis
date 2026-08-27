-- Creates the raw picks_bans table for data after 2024
CREATE OR REPLACE EXTERNAL TABLE dota2_staging.stage_picks_bans_raw_current_era (
  is_pick STRING,
  hero_id FLOAT64,
  team FLOAT64,
  ord FLOAT64,
  match_id FLOAT64,
  leagueid FLOAT64
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://dota2-analysis/matches/2024/picks_bans.csv',
  'gs://dota2-analysis/matches/2025/picks_bans.csv',
  'gs://dota2-analysis/matches/2026/*/picks_bans.csv'],
  skip_leading_rows = 1,
  allow_jagged_rows = true, 
  ignore_unknown_values = true 
);