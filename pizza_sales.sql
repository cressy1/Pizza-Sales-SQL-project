CREATE TABLE pizza_sales (
    pizza_id INT,
    order_id INT,
    pizza_name_id TEXT,
    quantity INT,
    order_date DATE, 
    order_time TIME,
    unit_price NUMERIC(8,2),
    total_price NUMERIC(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name TEXT
);

CREATE TABLE pizza_sales_staging (
    pizza_id TEXT,
    order_id TEXT,
    pizza_name_id TEXT,
    quantity TEXT,
    order_date TEXT,
    order_time TEXT,
    unit_price TEXT,
    total_price TEXT,
    pizza_size TEXT,
    pizza_category TEXT,
    pizza_ingredients TEXT,
    pizza_name TEXT
);

INSERT INTO pizza_sales (
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    order_date,
    order_time,
    unit_price,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
)
SELECT
    pizza_id::INT,
    order_id::INT,
    pizza_name_id,
    quantity::INT,
    TO_DATE(order_date, 'DD-MM-YYYY'),
    order_time::TIME,
    unit_price::NUMERIC,
    total_price::NUMERIC,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
FROM pizza_sales_staging;

SELECT * FROM pizza_sales;

SELECT SUM(total_price) || ' Dollars' AS Total_revenue
FROM pizza_sales;

SELECT 
	ROUND(SUM(total_price)::NUMERIC/COUNT(DISTINCT order_id)::NUMERIC, 2)  AS Average_order_value
FROM pizza_sales;

SELECT SUM(quantity) AS Total_pizza_sold
FROM pizza_sales;

SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales;

SELECT 
	ROUND(SUM(quantity)::NUMERIC/COUNT(DISTINCT order_id)::NUMERIC, 2)  AS Average_order_value
FROM pizza_sales;

SELECT 
    EXTRACT(HOUR FROM order_time) AS order_hours,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY 1
ORDER BY 1;

SELECT 
    EXTRACT(WEEK FROM order_date) AS weeknumber,
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY 
    1,
    2
ORDER BY 
    2, 1;


WITH total AS (
    SELECT SUM(total_price) AS total_revenue FROM pizza_sales
)
SELECT 
    p.pizza_category,
    ROUND(SUM(p.total_price), 2) AS total_revenue,
    ROUND(SUM(p.total_price) * 100.0 / t.total_revenue, 2) AS percentage_total
FROM pizza_sales p
CROSS JOIN total t
GROUP BY p.pizza_category, t.total_revenue
ORDER BY total_revenue DESC;

WITH total AS (
    SELECT SUM(total_price) AS total_revenue FROM pizza_sales
)
SELECT 
    p.pizza_size,
    ROUND(SUM(p.total_price), 2) AS total_revenue,
    ROUND(SUM(p.total_price) * 100.0 / t.total_revenue, 2) AS percentage_total
FROM pizza_sales p
CROSS JOIN total t
GROUP BY p.pizza_size, t.total_revenue
ORDER BY total_revenue DESC;

SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1 
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC


SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;

SELECT pizza_name, SUM(quantity) AS Total_pizza_sold
FROM pizza_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT pizza_name, SUM(quantity) AS Total_pizza_sold
FROM pizza_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_oders
FROM pizza_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_oders
FROM pizza_sales
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;

