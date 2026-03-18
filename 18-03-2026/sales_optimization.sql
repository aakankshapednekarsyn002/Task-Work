CREATE DATABASE SALES;
USE SALES;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE sales_data;

SELECT * FROM customers LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM sales_data LIMIT 10;

--  1. Total sales per customer
SELECT customer_key, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY customer_key ;

-- Before creating Index
EXPLAIN
SELECT customer_key, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY customer_key;
 
-- create index
CREATE INDEX idx_customer_key ON sales_data(customer_key);

-- After Creating Index
EXPLAIN
SELECT customer_key, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY customer_key;

-- 2. Total Sales per product
SELECT p.product_name, SUM(s.sales) AS total_sales 
FROM sales_data s 
JOIN products p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name; 
 
-- create index
CREATE INDEX idx_product_key ON sales_data(product_key);

-- Explain after indexing 
EXPLAIN
SELECT p.product_name, SUM(s.sales) AS total_sales 
FROM sales_data s 
JOIN products p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name; 
 
-- 3 . Top selling Product
SELECT p.product_name, SUM(s.sales) AS total_sales 
FROM sales_data s 
JOIN products p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name   
ORDER BY total_sales DESC
LIMIT 1;

CREATE INDEX idx_product_sales ON sales_data(product_key, sales);

-- Explain after indexing
EXPLAIN
SELECT p.product_name, SUM(s.sales) AS total_sales 
FROM sales_data s 
JOIN products p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name   
ORDER BY total_sales DESC
LIMIT 1;
 
-- 4. Top 10 customers by sales 
SELECT c.first_name, SUM(s.sales) AS total_sales
FROM sales_data s
JOIN customers c 
ON s.customer_key = c.customer_key
GROUP BY s.customer_key, c.first_name  
ORDER BY total_sales DESC
LIMIT 10;

-- create index
CREATE INDEX idx_customer_sales ON sales_data(customer_key, sales);

-- Explain after Indexing
EXPLAIN
SELECT c.first_name, SUM(s.sales) AS total_sales
FROM sales_data s
JOIN customers c 
ON s.customer_key = c.customer_key
GROUP BY s.customer_key, c.first_name   
ORDER BY total_sales DESC
LIMIT 10;


-- 5. total quantity sales per product
SELECT p.product_name, SUM(s.quantity) AS total_quantity 
FROM sales_data s 
JOIN products p
ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name;  

-- Explain
EXPLAIN
SELECT p.product_name, SUM(s.quantity) AS total_quantity 
FROM sales_data s 
JOIN products p
ON s.product_key =  p.product_key
GROUP BY s.product_key, p.product_name; 



