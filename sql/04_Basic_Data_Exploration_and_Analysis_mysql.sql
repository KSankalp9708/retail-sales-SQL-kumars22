-- Basic Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM Retail_Sales
  
-- How many uniuque customers thus total sales we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales

-- How many categories of items that were sold?
SELECT DISTINCT category FROM Retail_Sales

-----------------------------------------------------------------------------------

--Basic Data Analysis Questions & Answers
  
-- 1) SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM Retail_Sales
WHERE sale_date = '2022-11-05';

-- 2)SQL query to retrieve all transactions where the category is 'Electronics' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM Retail_Sales
WHERE 
    category = 'Electronics'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
  
-- 3) SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as Net_sale,
    COUNT(*) as Total_orders
FROM Retail_Sales
GROUP BY 1

-- 4) SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_beauty_age
FROM Retail_Sales
WHERE category = 'Beauty'


-- 5) SQL query to find the number of transactions where the total_sale is greater than 1000.

SELECT COUNT(*) as total_high_sales
FROM Retail_Sales
WHERE total_sale > 1000
