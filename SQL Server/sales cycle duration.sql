-- 1) What is the average sales cycle duration for won and lost opportunities?
SELECT deal_stage,
		ROUND(AVG(DATEDIFF(DAY, engage_date, close_date)), 2) AS avg_sales_cycle_days,
        MAX(DATEDIFF(DAY, engage_date, close_date)) AS max_sales_cycle_days,
        MIN(DATEDIFF(DAY, engage_date, close_date)) AS min_sales_cycle_days
FROM [dbo].[sales]
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY deal_stage;

-- 2) How does the sales cycle duration vary by product or sector?
-- Sales cycle duration by product
SELECT p.product_name,
		ROUND(AVG(CASE WHEN s.deal_stage = 'Won' THEN DATEDIFF(DAY, s.engage_date, s.close_date) END), 2) AS avg_won_sales_cycle_days,
		ROUND(AVG(CASE WHEN s.deal_stage = 'Lost' THEN DATEDIFF(DAY, s.engage_date, s.close_date) END), 2) AS avg_lost_sales_cycle_days
FROM [dbo].[sales] AS s
JOIN [dbo].[products] AS p 
	ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_won_sales_cycle_days ASC, avg_lost_sales_cycle_days ASC;

-- Sales cycle duration by sector
SELECT a.sector,
		ROUND(AVG(CASE WHEN s.deal_stage = 'Won' THEN DATEDIFF(DAY, s.engage_date, s.close_date) END), 2) AS avg_won_sales_cycle_days,
		ROUND(AVG(CASE WHEN s.deal_stage = 'Lost' THEN DATEDIFF(DAY, s.engage_date, s.close_date) END), 2) AS avg_lost_sales_cycle_days
FROM [dbo].[sales] AS s
JOIN [dbo].[accounts] AS a 
	ON s.account_id = a.account_id
GROUP BY a.sector
ORDER BY avg_won_sales_cycle_days ASC, avg_lost_sales_cycle_days ASC;