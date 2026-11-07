create database superstore;
DROP TABLE IF EXISTS superstore;

USE superstore;

SELECT COUNT(*) FROM superstore;

ALTER TABLE superstore
    RENAME COLUMN `Row ID`        TO row_id,
    RENAME COLUMN `Order ID`      TO order_id,
    RENAME COLUMN `Order Date`    TO order_date,
    RENAME COLUMN `Ship Date`     TO ship_date,
    RENAME COLUMN `Ship Mode`     TO ship_mode,
    RENAME COLUMN `Customer ID`   TO customer_id,
    RENAME COLUMN `Customer Name` TO customer_name,
    RENAME COLUMN `Segment`       TO segment,
    RENAME COLUMN `Country`       TO country,
    RENAME COLUMN `City`          TO city,
    RENAME COLUMN `State`         TO state,
    RENAME COLUMN `Postal Code`   TO postal_code,
    RENAME COLUMN `Region`        TO region,
    RENAME COLUMN `Product ID`    TO product_id,
    RENAME COLUMN `Category`      TO category,
    RENAME COLUMN `Sub-Category`  TO sub_category,
    RENAME COLUMN `Product Name`  TO product_name,
    RENAME COLUMN `Sales`         TO sales,
    RENAME COLUMN `Quantity`      TO quantity,
    RENAME COLUMN `Discount`      TO discount,
    RENAME COLUMN `Profit`        TO profit;

ALTER TABLE superstore
    ADD COLUMN order_dt DATE,
    ADD COLUMN ship_dt  DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE superstore
SET order_dt = STR_TO_DATE(TRIM(REPLACE(order_date, '\r', '')), '%m/%d/%Y'),
    ship_dt  = STR_TO_DATE(TRIM(REPLACE(ship_date,  '\r', '')), '%m/%d/%Y');

SELECT COUNT(*) AS null_dates
FROM superstore
WHERE order_dt IS NULL OR ship_dt IS NULL;

SELECT * FROM superstore;

SELECT SUM(profit) from superstore;

-- 1. Monthly Sales and Profit Trend
SELECT DATE_FORMAT(order_dt, '%Y-%m') AS month,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM superstore
GROUP BY month
ORDER BY month;


-- 2A. Top 10 Products by Profit
SELECT product_name,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- 2B. Bottom 10 Products by Profit (Big Losses)
SELECT product_name,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;

SELECT YEAR(order_dt) AS yr,
       product_name,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore
WHERE MONTH(order_dt) = 11
GROUP BY yr, product_name
ORDER BY total_profit ASC
LIMIT 10;

-- 3. Region and Category wise Profit
SELECT region,
       category,
       ROUND(SUM(sales), 2)  AS total_sales,
       ROUND(SUM(profit), 2) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM superstore
GROUP BY region, category
ORDER BY category, total_profit ASC;


-- 4. Discount Bands vs Profit
SELECT CASE
           WHEN discount = 0     THEN '0%'
           WHEN discount <= 0.20 THEN '1-20%'
           ELSE '20%+'
       END AS discount_band,
       COUNT(*) AS order_lines,
       ROUND(AVG(profit), 2) AS avg_profit,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY discount_band
ORDER BY MIN(discount);


-- 5. Customer Revenue Concentration (Pareto: Top 20% Customers)
WITH cust AS (
    SELECT customer_id,
           SUM(sales) AS revenue
    FROM superstore
    GROUP BY customer_id
),
ranked AS (
    SELECT revenue,
           NTILE(5) OVER (ORDER BY revenue DESC) AS bucket
    FROM cust
)
SELECT ROUND(SUM(CASE WHEN bucket = 1 THEN revenue END) / SUM(revenue) * 100, 2) AS top_20pct_share
FROM ranked;


-- 5B. Revenue Share by Customer Quintile
WITH cust AS (
    SELECT customer_id,
           SUM(sales) AS revenue
    FROM superstore
    GROUP BY customer_id
),
ranked AS (
    SELECT revenue,
           NTILE(5) OVER (ORDER BY revenue DESC) AS bucket
    FROM cust
)
SELECT bucket,
       ROUND(SUM(revenue), 2) AS bucket_revenue,
       ROUND(SUM(revenue) / (SELECT SUM(revenue) FROM cust) * 100, 2) AS share_pct
FROM ranked
GROUP BY bucket
ORDER BY bucket;


-- 6. Shipping Mode vs Delivery Days
SELECT ship_mode,
       COUNT(*) AS order_lines,
       ROUND(AVG(DATEDIFF(ship_dt, order_dt)), 2) AS avg_days
FROM superstore
GROUP BY ship_mode
ORDER BY avg_days;