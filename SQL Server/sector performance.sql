-- Unassigned deals:
SELECT SUM(CASE WHEN deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS unassigned_engaging_deals,
	SUM(CASE WHEN deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS unassigned_prospecting_deals
FROM [dbo].[sales]
WHERE account_id IS NULL;

-- 1) Which sectors generate the most revenue and have the highest success rates?
SELECT a.sector,
		SUM(CASE WHEN s.deal_stage = 'Won' THEN s.close_value ELSE 0 END) AS sales_revenue,
		ROUND((CAST(SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS float) /
				CAST(SUM(CASE WHEN s.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END) AS float))*100, 2) AS success_rate_pct
FROM [dbo].[sales] AS s
JOIN [dbo].[accounts] AS a 
	ON s.account_id = a.account_id
GROUP BY a.sector
ORDER BY sales_revenue DESC, success_rate_pct DESC;

-- 2) What is the distribution of opportunities by sector?
with deal_stage_sector as(
	SELECT a.sector, s.deal_stage, COUNT(s.deal_stage) as total
	FROM [dbo].[sales] AS s
	JOIN [dbo].[accounts] AS a 
		ON s.account_id = a.account_id
	GROUP BY a.sector, s.deal_stage
),
pivoted_data AS (
	SELECT sector,
		ISNULL([Prospecting], 0) AS prospecting, ISNULL([Engaging], 0) AS engaging, ISNULL([Won], 0) AS won, ISNULL([Lost], 0) AS lost,
		ISNULL([Prospecting], 0) + ISNULL([Engaging], 0) + ISNULL([Won], 0) + ISNULL([Lost], 0) AS total
	FROM deal_stage_sector
	PIVOT(SUM(total)
		FOR deal_stage IN ([Prospecting], [Engaging], [Won], [Lost])
	) AS pivot_table
)
SELECT *, 
	ROUND((CAST(won AS float) / CAST(total AS float))*100, 2) AS win_rate_pct,
	ROUND((CAST(won AS float) / CAST(lost AS float)), 2) AS win_loss_ratio
FROM pivoted_data AS pd
ORDER BY won DESC;