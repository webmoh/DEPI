
SELECT
	s.agent_id,
    st.sales_agent,  -- Select the sales agent name 
    COUNT(s.opportunity_id) AS total_deals, 
    SUM(s.close_value) AS total_revenue,
    CASE 
        WHEN COUNT(s.opportunity_id) = 0 THEN '0.00%'  -- Handle division by zero
        ELSE FORMAT(SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(s.opportunity_id), 'N2') + '%' 
    END AS win_rate
FROM 
    sales s
JOIN 
    sales_teams st ON st.agent_id = s.agent_id  -- Join with sales_teams
GROUP BY 
    st.sales_agent, s.agent_id  -- Group by sales agent and agent_id
ORDER BY 
    total_revenue DESC;
