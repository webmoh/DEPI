-- 1) Which sales agents have the lowest performance in terms of sales volume and won opportunities?
-- Check if there are any sales agents without assigned deals:
SELECT st.sales_agent, st.manager, st.regional_office
FROM [dbo].[sales_teams] st 
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[sales] AS s WHERE s.agent_id = st.agent_id);

-- Sales agents performance ranking:
SELECT st.sales_agent,
		SUM(s.close_value) AS sales_revenue,
        RANK () OVER (ORDER BY SUM(s.close_value) DESC) AS revenue_rank,
        COUNT(*) AS won_opportunities,
        RANK () OVER (ORDER BY COUNT(*) DESC) AS won_opportunities_rank
FROM [dbo].[sales] AS s
JOIN [dbo].[sales_teams] AS st 
	ON s.agent_id = st.agent_id
WHERE s.deal_stage = 'Won'
GROUP BY st.sales_agent
ORDER BY sales_revenue ASC, won_opportunities ASC;

-- Lowest performing sales agent of each team:
WITH ranked_sales_agents AS (
    SELECT st.regional_office AS teams_regional_office, st.manager AS teams_manager, st.sales_agent,
        SUM(s.close_value) AS sales_revenue,
        DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY SUM(s.close_value) ASC) AS sales_rank_asc,
        COUNT(*) AS won_opportunities,
        DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY COUNT(*) ASC) AS opp_rank_asc
    FROM [dbo].[sales] AS s
    JOIN [dbo].[sales_teams] AS st 
        ON s.agent_id = st.agent_id
    WHERE s.deal_stage = 'Won'
    GROUP BY st.regional_office, st.manager, st.sales_agent
)
SELECT teams_regional_office, teams_manager, sales_agent, sales_revenue,
    CASE WHEN sales_rank_asc <= 2 THEN 'Yes' ELSE 'No' END AS 'lowest sales performance?',
    won_opportunities,
    CASE WHEN opp_rank_asc <= 2 THEN 'Yes' ELSE 'No' END AS 'lowest opportunities performance?'
FROM ranked_sales_agents
ORDER BY teams_regional_office, teams_manager, sales_revenue;

-- 2) What is the individual success rate of each sales agent, and how does it compare to the team success rate?
WITH sales_deals AS (
    SELECT st.regional_office AS teams_regional_office, 
		st.manager AS teams_manager, 
		st.sales_agent,
        SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        SUM(CASE WHEN s.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS won_lost_deals        
	FROM [dbo].[sales] AS s
	JOIN [dbo].[sales_teams] AS st ON s.agent_id = st.agent_id
	GROUP BY st.regional_office, st.manager, st.sales_agent
),
success_rates AS (
	SELECT teams_regional_office, 
		teams_manager, sales_agent,
		CAST(won_deals AS float)/ CAST(won_lost_deals AS float) AS agents_success_rate,
		SUM(CAST(won_deals AS float)) OVER (PARTITION BY teams_regional_office, teams_manager) /
			SUM(CAST(won_lost_deals AS float)) OVER (PARTITION BY teams_regional_office, teams_manager)AS teams_success_rate
	FROM sales_deals
)
SELECT teams_regional_office,teams_manager,sales_agent,
    ROUND(agents_success_rate * 100, 2) AS agents_success_rate_pct,
    ROUND(teams_success_rate * 100, 2) AS team_success_rate_pct,
    CASE WHEN agents_success_rate > teams_success_rate THEN 'Above Team Average' ELSE 'Below Team Average' END AS success_rate_description
FROM success_rates
ORDER BY teams_regional_office, teams_manager, sales_agent;