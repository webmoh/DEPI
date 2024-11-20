SELECT 
    s.product_id,    
	p.product_name AS product_name,  -- Select product name from the products table
    FORMAT(SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(s.opportunity_id), 0), 'N2') + '%' AS win_rate,
    SUM(s.close_value) AS total_revenue
FROM 
    sales s
JOIN 
    products p ON s.product_id = p.product_id  -- Join with the products table
GROUP BY 
    p.product_name, s.product_id  -- Group by product name and product_id
ORDER BY 
    total_revenue DESC;  -- Order by total revenue in descending order

