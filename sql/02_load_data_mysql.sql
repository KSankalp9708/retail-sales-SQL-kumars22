USE retail_sql_ksankalp;


-- Adjust the path below to your machine. Keep the column order to match the CSV header.
LOAD DATA LOCAL INFILE 'C:\Users\Kumar Sanklap\Downloads\retail_sales_datewise_data.csv'
INTO TABLE Retail_Sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transaction_id, sale_date, sale_time, customer_id, gender, age, category,
quantity, price_per_unit, cogs, total_sale);
