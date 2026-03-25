CREATE DATABASE Sales_2022_24;
USE Sales_2022_24;

SELECT count(*) from fmcg_2022_2024;

-- Total sales by Category
SELECT category, ROUND(SUM(units_sold * price_unit), 2) AS total_sales
FROM fmcg_2022_2024
GROUP BY category
ORDER BY total_sales DESC;

-- Top 10 Products (SKU) by Sales
SELECT sku as Products, ROUND(SUM(units_sold * price_unit), 2) AS total_sales
FROM fmcg_2022_2024
GROUP BY sku
ORDER BY total_sales DESC LIMIT 10;

-- Sales by Region
SELECT region, ROUND(SUM(units_sold * price_unit), 2) AS total_sales
FROM fmcg_2022_2024
GROUP BY region
ORDER BY total_sales DESC;

-- Understanding trend across Months
SELECT DATE_FORMAT(date, '%Y-%m') AS month,ROUND(SUM(units_sold * price_unit), 2) AS total_sales
FROM fmcg_2022_2024
GROUP BY month
ORDER BY month;

-- Average delivery days by region
SELECT region, ROUND(AVG(delivery_days), 2) AS avg_delivery_time
FROM fmcg_2022_2024
GROUP BY region;

--  Distribution by Promotion flag
SELECT promotion_flag,ROUND(AVG(units_sold * price_unit), 2) AS avg_sales
FROM fmcg_2022_2024
GROUP BY promotion_flag;



