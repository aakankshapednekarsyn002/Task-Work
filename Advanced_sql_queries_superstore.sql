CREATE DATABASE superstore;
USE superstore;

SELECT COUNT(*) FROM superstore_data;
SELECT COUNT(*) FROM superstore_customer;


ALTER TABLE superstore_data RENAME COLUMN `Order ID` TO order_id ;
ALTER TABLE superstore_data RENAME COLUMN `Row ID` TO row_id ;
ALTER TABLE superstore_data RENAME COLUMN `Order Date` TO order_date ;
ALTER TABLE superstore_data RENAME COLUMN `Ship Date` TO ship_date ;
ALTER TABLE superstore_data RENAME COLUMN `Ship Mode` TO ship_mode ;
ALTER TABLE superstore_data RENAME COLUMN `Customer ID` TO customer_id ;
ALTER TABLE superstore_data RENAME COLUMN `Customer Name` TO customer_name ;
ALTER TABLE superstore_data RENAME COLUMN `Product ID` TO product_id ;
ALTER TABLE superstore_data RENAME COLUMN `Sub-Category` TO sub_category ;

-- Total number of transactions and total sales amount Country.
SELECT country , 
	   COUNT('Order ID') AS TotalOrders ,
       SUM(Sales) AS TotalSales
FROM superstore_data
GROUP BY Country ;

-- Top 3 product categories based on total sales.
SELECT category,
       SUM(sales) AS total_sales
FROM superstore_data
GROUP BY category
ORDER BY total_sales DESC
LIMIT 3;

-- Average quantity purchased per Market by descending order.
SELECT market,
       AVG(Quantity) AS avg_quantity
FROM superstore_data
GROUP BY market
ORDER BY avg_quantity DESC;

-- Shipping mode has the highest total sales amount.
SELECT ship_mode,
       SUM(sales) AS total_sales
FROM superstore_data
GROUP BY ship_mode
ORDER BY total_sales DESC
LIMIT 1;

-- Product categories whose total sales are greater than 50,000.
SELECT Category,
       SUM(sales) AS total_sales
FROM superstore_data
GROUP BY Category
HAVING SUM(sales) > 50000;

-- Market with more than 50 total transactions.
SELECT Market,
       COUNT(order_id) AS total_transactions
FROM superstore_data
GROUP BY Market
HAVING COUNT(order_id) > 50;

-- Identify payment methods used in more than 1,000 transactions.
SELECT ship_mode,
       COUNT(order_id) AS total_transactions
FROM superstore_data
GROUP BY ship_mode
HAVING COUNT(order_id) > 1000;

-- Rank of Market by total revenue.
SELECT market,
       SUM(sales) AS total_revenue,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS market_rank
FROM superstore_data
GROUP BY market;

-- Top 5 customers based on total spending.
SELECT customer_id,
       SUM(sales) AS total_spending
FROM superstore_data
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 5;

-- Categorize purchases into: Small (≤ 200) , Medium (201–500) ,Large (> 500), Also how many purchases fall into each category.
SELECT
CASE
    WHEN sales <= 200 THEN 'Small'
    WHEN sales BETWEEN 201 AND 500 THEN 'Medium'
    ELSE 'Large'
END AS purchase_category,
COUNT(*) AS total_purchases
FROM superstore_data
GROUP BY purchase_category;

-- Purchases as Bulk Purchase if quantity > 5, else Regular Purchase.
SELECT *,
CASE
    WHEN quantity > 5 THEN 'Bulk Purchase'
    ELSE 'Regular Purchase'
END AS purchase_type
FROM superstore_data;

-- each purchase with customer’s average customer_id,
 SELECT      sales,
       AVG(sales) OVER (PARTITION BY customer_id) AS avg_customer_sales
FROM superstore_data;

-- Product categories starting with the letter ‘F’.
SELECT DISTINCT category
FROM superstore_data
WHERE category LIKE 'F%';


-- Display product categories containing the word ‘Electronics’.
SELECT DISTINCT category
FROM superstore_data
WHERE category LIKE '%Electronics%';


-- Compare each purchase amount with the average purchase amount of that customer.
SELECT 
    customer_id,
    order_id,
    sales,
    AVG(sales) OVER (PARTITION BY customer_id) AS avg_customer_sales,
    sales - AVG(sales) OVER (PARTITION BY customer_id) AS difference_from_avg
FROM superstore_data;

-- Create a view showing customer_id, total transactions, total quantity, and total spending.
CREATE VIEW customer_summary AS
SELECT 
    customer_id,
    COUNT(order_id) AS total_transactions,
    SUM(quantity) AS total_quantity,
    SUM(sales) AS total_spending
FROM superstore_data
GROUP BY customer_id ;

-- Create a view that displays total sales per Market.
CREATE VIEW Market_summary AS
SELECT 
    Market ,
    SUM(sales) AS total_sales
FROM superstore_data
GROUP BY Market;

-- From a view, retrieve top 5 customers by total spending.
SELECT 
    customer_id,
    total_spending
FROM customer_summary
ORDER BY total_spending DESC
LIMIT 5;