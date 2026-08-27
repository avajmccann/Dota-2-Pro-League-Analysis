#CREATE OR REPLACE TABLE `dota-2-analysis.dota2_analysis.hero_diversity` AS

WITH hero_counts AS (
  SELECT
    h.name as hero_name,
    h.hero_id as hero_id,
    # Group by month
    DATE_TRUNC(m.start_date_time, MONTH) AS month,
    # Get count of all hero picks each month
    COUNT(p.hero_id) AS hero_count
  FROM `dota-2-analysis.dota2_analysis.players` p
    JOIN `dota2_analysis.constants_heroes` h ON h.hero_id = p.hero_id
    JOIN `dota2_analysis.main_metadata` m on m.match_id = p.match_id
    GROUP BY hero_name, hero_id, month
),

# Get pick rates of each hero each month
hero_pick_rates AS (
  SELECT  
    *,
    # All hero picks for the month
    SUM(hero_count) OVER (PARTITION BY month) AS total_hero_picks,
    # Avg pick rate for specific heroes
    hero_count / SUM(hero_count) OVER (PARTITION BY month) AS average_pick_rate,
  FROM hero_counts
)

SELECT
  month,
  SUM(average_pick_rate * LN(average_pick_rate)) * -1 AS hero_diversity,
  (SUM(average_pick_rate * LN(average_pick_rate)) * -1) / LN(COUNT(DISTINCT hero_name)) AS hero_equitability,
FROM hero_pick_rates
GROUP BY month