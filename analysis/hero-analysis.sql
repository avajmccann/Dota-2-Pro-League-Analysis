# Analyze all heroes

SELECT
  REPLACE(h.name, 'npc_dota_hero_', '') AS hero_name,
  COUNT(*) AS total_plays,
  ROUND(AVG(kda), 2) AS avg_kda,
  ROUND(AVG(win), 2) AS avg_win,
  ROUND(AVG(deaths), 2) AS avg_deaths,
  ROUND(AVG(kills_per_min), 2) AS avg_kills_per_min,
  ROUND(AVG(level), 2) AS avg_player_level
FROM `dota-2-analysis.dota2_analysis.players` p
JOIN `dota-2-analysis.dota2_analysis.constants_heroes` h ON p.hero_id = h.id
WHERE level >= 20
GROUP BY p.hero_id, h.name
ORDER BY avg_win DESC
