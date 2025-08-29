-- Advanced Analysis questions-answers, and Insights

-- 1) SQL query to find the total number of transactions (Transaction_ID) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM Retail_Sales
GROUP BY 
    category,
    gender
ORDER BY 1

-- 2) SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
    m.year,
    m.month,
    m.avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM Retail_Sales
    GROUP BY 1, 2
) m
JOIN (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        MAX(AVG(total_sale)) AS max_avg_sale
    FROM Retail_Sales
    GROUP BY EXTRACT(YEAR FROM sale_date)
) n
ON m.year = n.year AND m.avg_sale = n.max_avg_sale
    
-- 3) SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    Customer_ID,
    SUM(total_sale) as total_sales
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 4) SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT Customer_ID) as no_unique_customerss
FROM Retail_Sales
GROUP BY category

-- 5) SQL query to create each shift, count number of orders and total sale in each shift
-- (Example Morning < 1200 hrs, Afternoon Between 1200 hrs and 1800 hrs, Evening > 1800 hrs)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 18 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM Retail_Sales
)
SELECT 
    shift,
    COUNT(*) as total_orders  
    SUM(total_sale) AS total_revenue
FROM hourly_sale
GROUP BY shift

-- 6) Query to show Year-over-Year (YoY) growth in total sales per category.

SELECT 
    cur.category,
    cur.yr,
    cur.total_sales,
    prev.total_sales AS prev_year_sales,
    ROUND(
        (cur.total_sales - prev.total_sales) / prev.total_sales * 100, 2)
        AS pct_yoy_growth
FROM (
    SELECT category, YEAR(sale_date) AS yr, SUM(total_sale) AS total_sales
    FROM Retail_Sales
    GROUP BY category, YEAR(sale_date)
) cur
LEFT JOIN (
    SELECT category, YEAR(sale_date) AS yr, SUM(total_sale) AS total_sales
    FROM Retail_Sales
    GROUP BY category, YEAR(sale_date)
) prev
ON cur.category = prev.category
AND cur.yr = prev.yr + 1
ORDER BY cur.category, cur.yr

-- 7)Average basket size by category:
--     a) avg_basket_per_trnscn = average of (total_sale / quantity) across transactions,
--     b) revenue_per_unit   = overall sum(total_sale)/sum(quantity) (weighted).
SELECT
  category,
  ROUND(
    AVG(CASE WHEN quantity > 0 THEN total_sale / quantity 
    ELSE NULL END), 2) 
    AS avg_basket_per_trnscn,
  ROUND(
    CASE WHEN SUM(quantity) = 0 THEN NULL 
    ELSE SUM(total_sale) / SUM(quantity) END, 2)
    AS revenue_per_unit,
  COUNT(*) AS transactions,
  SUM(quantity) AS total_items,
  ROUND
    (SUM(total_sale), 2)
    AS total_revenue
FROM Retail_Sales
GROUP BY category
ORDER BY total_revenue DESC
