-- Create database and main table (MySQL 8)
DROP DATABASE IF EXISTS retail_sql_ksankalp;
CREATE DATABASE retail_sql_ksankalp;
USE retail_sql_ksankalp;


-- Core sales table
CREATE TABLE Retail_Sales (
Transaction_ID INT PRIMARY KEY,
sale_date DATE NOT NULL,
sale_time TIME NULL,
Customer_ID INT NOT NULL,
gender ENUM('Male','Female','Other') NOT NULL,
age INT CHECK (age BETWEEN 10 AND 100),
category VARCHAR(50) NOT NULL,
quantity INT NOT NULL CHECK (quantity >= 0),
price_per_unit DECIMAL(10,2),
cogs DECIMAL(10,2),
total_sale DECIMAL(10,2),


-- Derived fields
sale_timestamp DATETIME GENERATED ALWAYS AS (
TIMESTAMP(sale_date, COALESCE(sale_time, '00:00:00'))
) VIRTUAL,
margin DECIMAL(10,2) GENERATED ALWAYS AS (total_sale - cogs) VIRTUAL
) ENGINE=InnoDB;


-- Optional reference tables for future normalization
-- CREATE TABLE customers (...);
-- CREATE TABLE products (...);
