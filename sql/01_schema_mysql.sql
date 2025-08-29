-- Creating database
CREATE DATABASE retail_sql_ksankalp;
USE retail_sql_ksankalp;


-- Core sales table
CREATE TABLE Retail_Sales (
Transaction_ID INT PRIMARY KEY,
sale_date DATE,
sale_time TIME ,
Customer_ID INT,
gender ENUM('Male','Female','Other'),
age INT,
category VARCHAR(50),
quantity INT,
price_per_unit DECIMAL(10,2),
cogs DECIMAL(10,2),
total_sale DECIMAL(10,2),

-- Derived fields
sale_timestamp DATETIME GENERATED ALWAYS AS (
TIMESTAMP(sale_date, COALESCE(sale_time, '00:00:00'))
) VIRTUAL,
margin DECIMAL(10,2) GENERATED ALWAYS AS (total_sale - cogs) VIRTUAL
) ENGINE=InnoDB;
