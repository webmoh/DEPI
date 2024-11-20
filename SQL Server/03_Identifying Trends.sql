SELECT 
    CASE 
        WHEN MONTH(close_date) IN (1, 2, 3) THEN 1
        WHEN MONTH(close_date) IN (4, 5, 6) THEN 2
        WHEN MONTH(close_date) IN (7, 8, 9) THEN 3
        WHEN MONTH(close_date) IN (10, 11, 12) THEN 4
    END AS quarter,
    YEAR(close_date) AS year,
    SUM(close_value) AS total_revenue, 
    COUNT(opportunity_id) AS total_deals, 
    FORMAT(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(opportunity_id), 0), 'N2') + '%' AS win_rate
FROM 
    sales
WHERE 
    YEAR(close_date) = 2017  -- Filter for the year 2017
GROUP BY 
    YEAR(close_date),
    CASE 
        WHEN MONTH(close_date) IN (1, 2, 3) THEN 1
        WHEN MONTH(close_date) IN (4, 5, 6) THEN 2
        WHEN MONTH(close_date) IN (7, 8, 9) THEN 3
        WHEN MONTH(close_date) IN (10, 11, 12) THEN 4
    END
ORDER BY 
    YEAR(close_date), 
    quarter;
