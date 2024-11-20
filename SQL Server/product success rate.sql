-- 1) Which products have the highest success rates in closing deals?
SELECT p.product_name,
		ROUND((CAST(SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS float) /
				CAST(SUM(CASE WHEN s.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END) AS float))*100, 2) AS success_rate_pct
FROM [dbo].[sales] AS s
JOIN [dbo].[products] p 
	ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY success_rate_pct DESC;

-- 2) Which products generate the most revenue, and how do they compare to other products?
WITH products_revenue AS (
	SELECT p.product_name,
			SUM(s.close_value) AS sales_revenue
	FROM [dbo].[sales] AS s
	JOIN [dbo].[products] p 
		ON s.product_id = p.product_id
	WHERE s.deal_stage = 'Won'
	GROUP BY p.product_name
)
SELECT product_name,
		sales_revenue,
        ROUND((sales_revenue/SUM(sales_revenue) OVER ())*100, 2) AS revenue_pct
FROM products_revenue
ORDER BY sales_revenue DESC;