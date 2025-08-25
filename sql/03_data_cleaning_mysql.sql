-- In order to clean the data, we should remove the data where all important data is missing like:
-- Transaction_ID, sale_date,vsale_time, gender, age, categor, quantity, cogs, or total_sale.
--First, execute SELECT COUNT(*) in order to find how many rows are going to be removed in process
--of cleaning.

SELECT COUNT(*) AS rows_removed
FROM Retail_Sales
WHERE Transaction_ID IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
  
-- Further, on checking we delete these rows in order to clean the data.
-- Also, safe update mode is ON by default in MySQL to prevent from running a DELETE or UPDATE
-- without using a key column in the WHERE clause (to avoid wiping big chunks of data by mistake).

SET SQL_SAFE_UPDATES = 0;
DELETE FROM Retail_Sales
WHERE Transaction_ID IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
SET SQL_SAFE_UPDATES = 1;  -- re-enabled for safety
