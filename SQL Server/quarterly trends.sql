-- Closing Dates information: 
SELECT MIN(close_date) AS first_close_date, 
		MAX(close_date) AS last_close_date
FROM [dbo].[sales];

-- 1) What are the quarter-over-quarter sales trends in terms of won opportunities and sales volume?
WITH quarter_sales_opportunities AS (
    SELECT DATEPART(QUARTER, close_date) AS quarter, 
        COUNT(*) AS won_opportunities, 
        SUM(close_value) AS sales_revenue
    FROM [dbo].[sales]
    WHERE deal_stage = 'Won'
    GROUP BY DATEPART(QUARTER, close_date)
),
qoq_trends AS (
    SELECT quarter,
        won_opportunities,
        sales_revenue,
        LAG(won_opportunities) OVER (ORDER BY quarter ASC) AS prev_won_opportunities,
        LAG(sales_revenue) OVER (ORDER BY quarter ASC) AS prev_sales_revenue
    FROM quarter_sales_opportunities
)
SELECT 
    quarter,
    won_opportunities,
    ROUND((CAST((won_opportunities - prev_won_opportunities) AS float) / 
		CAST((NULLIF(prev_won_opportunities, 0)) AS float)) * 100, 2) AS QoQ_won_opportunities_growth_pct,
    sales_revenue,
    ROUND(((sales_revenue - prev_sales_revenue) / NULLIF(prev_sales_revenue, 0)) * 100, 2) AS QoQ_sales_revenue_growth_pct
FROM qoq_trends;

-- 2) How do success rates for sales opportunities vary by quarter?
WITH quarter_sales_deals AS (
    SELECT DATEPART(QUARTER, close_date) AS quarter,
        SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS won_lost_deals
    FROM [dbo].[sales]
    WHERE close_date IS NOT NULL
    GROUP BY DATEPART(QUARTER, close_date)
),
qoq_success_rate AS (
	SELECT quarter,
		won_deals, won_lost_deals,
		CASE WHEN won_lost_deals = 0 THEN 0 ELSE CAST(won_deals AS float) / CAST(won_lost_deals AS float) END AS success_rate,
		LAG(CASE WHEN won_lost_deals = 0 THEN 0 ELSE CAST(won_deals AS float) / CAST(won_lost_deals AS float) END) OVER (ORDER BY quarter ASC) AS prev_success_rate
	FROM quarter_sales_deals
)
SELECT quarter,
		ROUND(success_rate * 100, 2) AS success_rate_pct,
		ROUND(((success_rate - prev_success_rate)/prev_success_rate) * 100, 2) AS QoQ_success_rate_growth_pct
FROM qoq_success_rate;