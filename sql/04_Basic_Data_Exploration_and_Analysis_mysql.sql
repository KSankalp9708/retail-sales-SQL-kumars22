-- Basic Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM Retail_Sales
  
-- How many uniuque customers thus total sales we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales

-- How many categories of items that were sold?
SELECT DISTINCT category FROM retail_sales

-----------------------------------------------------------------------------------

--Basic Data Analysis Questions & Answers
-- 1) SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2)SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
  
-- 3) SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- 4) SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- 5) SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000
