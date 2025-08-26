-- Advanced Analysis questions and answers, and Insights

-- 1) SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

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
    year,
    month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM Retail_Sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

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
    COUNT(DISTINCT Customer_ID) as cnt_unique_cs
FROM Retail_Sales
GROUP BY category



-- 5) SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM Retail_Sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- 6) Query to show Year-over-Year (YoY) growth in total sales per category.
WITH yearly AS (
  SELECT
    category,
    YEAR(sale_date) AS yr,
    ROUND(SUM(COALESCE(total_sale,0)), 2) AS total_sales
  FROM Retail_Sales
  GROUP BY category, YEAR(sale_date)
),
yearly_with_prev AS (
  SELECT
    category,
    yr,
    total_sales,
    LAG(total_sales) OVER (PARTITION BY category ORDER BY yr) AS prev_year_sales
  FROM yearly
)
SELECT
  category,
  yr,
  total_sales,
  prev_year_sales,
  CASE
    WHEN prev_year_sales IS NULL OR prev_year_sales = 0 THEN NULL
    ELSE ROUND((total_sales - prev_year_sales) / prev_year_sales * 100, 2)
  END AS pct_yoy_growth
FROM yearly_with_prev
ORDER BY category, yr;

-- 7)Average basket size by category:
--     a) avg_basket_per_txn = average of (total_sale / quantity) across transactions,
--     b) revenue_per_unit   = overall sum(total_sale)/sum(quantity) (weighted).
SELECT
  category,
  ROUND(AVG(CASE WHEN quantity > 0 THEN total_sale / quantity ELSE NULL END), 2) AS avg_basket_per_txn,
  ROUND(
    CASE WHEN SUM(quantity) = 0 THEN NULL ELSE SUM(total_sale) / SUM(quantity) END
  , 2) AS revenue_per_unit,
  COUNT(*) AS transactions,
  SUM(quantity) AS total_items,
  ROUND(SUM(total_sale),2) AS total_revenue
FROM Retail_Sales
GROUP BY category
ORDER BY total_revenue DESC;
