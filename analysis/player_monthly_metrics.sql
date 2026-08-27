CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.player_monthly_metrics` AS

WITH player_months AS (
  -- One row per player per month
  SELECT DISTINCT
    account_id,
    DATE_TRUNC(start_date_time, MONTH) AS month
  FROM `dota-2-analysis.dota2_analysis.players` p
  JOIN `dota-2-analysis.dota2_analysis.main_metadata` m
    ON m.match_id = p.match_id
  WHERE account_id IS NOT NULL
),

new_players AS (
  -- Find the first month each player appeared
  SELECT
    account_id,
    MIN(month) AS first_month
  FROM player_months
  GROUP BY account_id
),

monthly_new_players AS (
  -- Count new players by month
  SELECT
    first_month AS month,
    COUNT(*) AS new_players
  FROM new_players
  GROUP BY first_month
),

monthly_players AS (
  -- Count total active players by month
  SELECT
    month,
    COUNT(*) AS total_players
  FROM player_months
  GROUP BY month
),

returning_players AS (
  -- Find players who appeared in consecutive months
  SELECT
    m_cur.account_id,
    m_cur.month
  FROM player_months m_cur
  JOIN player_months m_prev
    ON m_cur.account_id = m_prev.account_id
    AND m_cur.month = DATE_ADD(m_prev.month, INTERVAL 1 MONTH)
),

monthly_returning_players AS (
  -- Count returning players by month
  SELECT
    month,
    COUNT(DISTINCT account_id) AS returning_players
  FROM returning_players
  GROUP BY month
),

monthly_metrics AS (
  SELECT
    mp.month,
    mp.total_players,
    COALESCE(mnp.new_players, 0) AS new_players,
    COALESCE(mrp.returning_players, 0) AS returning_players,

    LAG(mp.total_players) OVER (
      ORDER BY mp.month
    ) AS previous_month_players

  FROM monthly_players mp
  LEFT JOIN monthly_new_players mnp
    ON mp.month = mnp.month
  LEFT JOIN monthly_returning_players mrp
    ON mp.month = mrp.month
)

SELECT
  month,
  total_players,
  new_players,
  returning_players,
  previous_month_players,

  SAFE_DIVIDE(
    new_players,
    total_players
  ) AS new_player_rate,

  SAFE_DIVIDE(
    returning_players,
    previous_month_players
  ) AS retention_rate,

  SAFE_DIVIDE(
    previous_month_players - returning_players,
    previous_month_players
  ) AS churn_rate

FROM monthly_metrics
ORDER BY month;