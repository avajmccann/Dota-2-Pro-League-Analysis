-- Creates the raw players table for data after 2024
CREATE OR REPLACE EXTERNAL TABLE `dota-2-analysis.dota2_staging.stage_players_raw_current_era`(
  player_slot STRING,
  firstblood_claimed STRING,
  account_id STRING,
  hero_id STRING,
  kills STRING,
  deaths STRING,
  assists STRING,
  level STRING,
  personaname STRING,
  radiant_win STRING,
  isRadiant STRING,
  win STRING,
  lose STRING,
  kills_per_min STRING,
  kda STRING,
  lane STRING,
  lane_role STRING,
  match_id STRING,
  leagueid STRING
)
OPTIONS (
  format = 'CSV',
    uris = ['gs://dota2-analysis/matches/2024/players.csv',
  'gs://dota2-analysis/matches/2025/players.csv',
  'gs://dota2-analysis/matches/2026/*/players.csv'],
  skip_leading_rows = 1,
  allow_jagged_rows = true, 
  ignore_unknown_values = true 
);