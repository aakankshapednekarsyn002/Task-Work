USE superstore;
SELECT COUNT(*) FROM superstore_customer;
SELECT COUNT(*) FROM superstore_orders;
SELECT COUNT(*) FROM superstore_products;

ALTER TABLE superstore_orders RENAME COLUMN `Order ID` TO order_id ;
ALTER TABLE superstore_orders RENAME COLUMN `Row ID` TO row_id ;
ALTER TABLE superstore_orders RENAME COLUMN `Order Date` TO order_date ;
ALTER TABLE superstore_orders RENAME COLUMN `Ship Date` TO ship_date ;
ALTER TABLE superstore_orders RENAME COLUMN `Ship Mode` TO ship_mode ;
ALTER TABLE superstore_customer RENAME COLUMN `Customer ID` TO customer_id ;
ALTER TABLE superstore_orders RENAME COLUMN `Customer ID` TO customer_id ;
ALTER TABLE superstore_orders RENAME COLUMN `Product ID` TO product_id ;
ALTER TABLE superstore_customer RENAME COLUMN `Customer Name` TO customer_name ;
ALTER TABLE superstore_products RENAME COLUMN `Product ID` TO product_id ;
ALTER TABLE superstore_products RENAME COLUMN `Product Name` TO product_name;
ALTER TABLE superstore_products RENAME COLUMN `Sub-Category` TO sub_category ;


-- customer name, order ID, and sales for all valid orders
SELECT 
    o.order_id,
    c.customer_name ,
    o.sales
FROM superstore_orders o
INNER JOIN superstore_customer c
    ON o.customer_id = c.customer_id ;
    
    
-- Customers and their total sales, including customers with no orders
SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(o.sales), 0) AS total_sales
FROM superstore_customer c
LEFT JOIN superstore_orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Products and total quantity sold, including products never ordered
SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(o.quantity), 0) AS total_quantity_sold
FROM superstore_orders o
RIGHT JOIN superstore_products p
    ON o.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- customer name, product name, category, order date, sales, and profit for each order
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name,
    p.category,
    o.order_date,
    o.sales,
    o.profit
FROM superstore_orders o
INNER JOIN superstore_customer c
    ON o.customer_id = c.customer_id
INNER JOIN superstore_products p
    ON o.product_id = p.product_id;