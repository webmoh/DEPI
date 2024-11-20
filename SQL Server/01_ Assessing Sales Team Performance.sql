--Number of deals won, total revenue generated, average deal size, and win rate (deals won vs. total deals)
SELECT 
    manager, 
    SUM(close_value) AS total_revenue, 
    COUNT(opportunity_id) AS total_deals,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS deals_won,
    CASE 
        WHEN COUNT(opportunity_id) = 0 THEN '0.00%'  -- Handle division by zero
        ELSE FORMAT(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / COUNT(opportunity_id), 'N2') + '%' 
    END AS win_rate
FROM 
    sales
JOIN 
    sales_teams ON sales.agent_id = sales_teams.agent_id
WHERE 
    close_date IS NOT NULL
GROUP BY 
    manager
ORDER BY 
    total_revenue DESC;
