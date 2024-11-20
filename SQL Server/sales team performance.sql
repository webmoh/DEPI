-- 1) total_sales_volume for each agent.
SELECT st.sales_agent AS agent,
	SUM(s.close_value) AS sales_revunue
FROM [dbo].[sales] AS s
JOIN [dbo].[sales_teams] AS st
	ON s.agent_id = st.agent_id
GROUP BY st.sales_agent
ORDER BY sales_revunue DESC;

-- 2) deals stages made by sales teams
WITH sales_teams_deals AS ( 
	SELECT st.sales_agent AS agent, 
		s.deal_stage, 
		COUNT(s.opportunity_id) AS total_sales 
	FROM [dbo].[sales] AS s
	JOIN [dbo].[sales_teams] AS st
	ON s.agent_id = st.agent_id
	GROUP BY st.sales_agent, st.manager, st.regional_office, s.deal_stage
)
SELECT 
    agent,
    ISNULL([Prospecting], 0) AS prospecting, ISNULL([Engaging], 0) AS engaging, ISNULL([Won], 0) AS won, ISNULL([Lost], 0) AS lost,
    ISNULL([Prospecting], 0) + ISNULL([Engaging], 0) + ISNULL([Won], 0) + ISNULL([Lost], 0) AS Total
FROM sales_teams_deals
PIVOT (
    SUM(total_sales)
    FOR deal_stage IN (
        [Prospecting], [Engaging], [Won], [Lost]
    )
) AS pivot_table
ORDER BY Total desc;

-- 3) What is the sales volume and the number of won opportunities for each sales team?
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        COUNT(*) AS won_opportunities,
		SUM(s.close_value) AS sales_revenue     
FROM [dbo].[sales] AS s
JOIN [dbo].[sales_teams] AS st
	ON s.agent_id = st.agent_id
WHERE s.deal_stage = 'Won'
GROUP BY st.regional_office, st.manager
ORDER BY sales_revenue DESC;

-- 4) Which sales teams have the highest success rate in closing deals? 
-- NOTE: The "Prospecting" and "Engaging" statuses represent intermediate phases in the sales process, so they are not included in the success rate calculation.
with sales_teams_sucsess as (
	SELECT st.regional_office AS teams_regional_office,
			st.manager AS teams_manager,
			SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won, 
			(SUM(CASE WHEN s.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) *100) AS deal_count
	FROM [dbo].[sales] AS s
	JOIN [dbo].[sales_teams] AS st 
		ON s.agent_id = st.agent_id
	GROUP BY st.regional_office, st.manager
)
SELECT teams_regional_office, teams_manager, (cast(won as float) * 100.0 / cast(deal_count as float)) AS conversion_rate
FROM sales_teams_sucsess
ORDER BY conversion_rate DESC;