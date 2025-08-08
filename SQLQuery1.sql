CREATE DATABASE amazon;

--Total sales by city
SELECT c.city, SUM(o.quantity * p.unit_price) AS total_sales
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id
GROUP BY c.city;

--Find top-selling product
SELECT TOP 1 
p.product_name, SUM(o.quantity) AS total_sold
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;


--orders that have a matching customer in the customers table.
SELECT 
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.quantity
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- order details along with product names and prices.
SELECT 
    o.order_id,
    o.order_date,
    p.product_name,
    p.unit_price,
    o.quantity
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id;

	--Merges customers, orders, and products so you can see full order history with sales amounts.

	SELECT 
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    p.product_name,
    p.category,
    o.quantity,
    (o.quantity * p.unit_price) AS total_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON o.product_id = p.product_id
ORDER BY o.order_date;

-- customers from both cities, including duplicates if the same person appears in both queries

SELECT customer_id, customer_name, city
FROM customers
WHERE city = 'New York'

UNION ALL

SELECT customer_id, customer_name, city
FROM customers
WHERE city = 'Los Angeles';


-- Combine Orders from Two Time Periods

SELECT order_id, customer_id, product_id, order_date, quantity
FROM orders
WHERE order_date < '2023-07-15'

UNION ALL

SELECT order_id, customer_id, product_id, order_date, quantity
FROM orders
WHERE order_date >= '2023-07-15';

-- customers who have placed at least one order for a product in the "Electronics" category.

SELECT customer_name, city
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE product_id IN (
        SELECT product_id
        FROM products
        WHERE category = 'Electronics'
    )
);

--order with the total spent by that customer

SELECT 
    o.order_id,
    o.customer_id,
    (SELECT SUM(o2.quantity * p.unit_price)
     FROM orders o2
     JOIN products p ON o2.product_id = p.product_id
     WHERE o2.customer_id = o.customer_id) AS total_spent_by_customer
FROM orders o;

--top 5 customers by total amount spent.

SELECT top 5 customer_name, total_spent
FROM (
    SELECT c.customer_name, 
           SUM(o.quantity * p.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN products p ON o.product_id = p.product_id
    GROUP BY c.customer_name
) AS customer_totals
ORDER BY total_spent DESC
;

--Average Sales Per Order
SELECT 
    AVG(o.quantity * p.unit_price) AS avg_sales_per_order
FROM orders o
JOIN products p 
    ON o.product_id = p.product_id;

	--Average Sales Per Customer

	SELECT 
    c.customer_name,
    AVG(o.quantity * p.unit_price) AS avg_sales_per_customer
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY avg_sales_per_customer DESC;

 --Average Sales Per Product
 SELECT 
    p.product_name,
    AVG(o.quantity * p.unit_price) AS avg_sales_per_product
FROM products p
JOIN orders o 
    ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY avg_sales_per_product DESC;

