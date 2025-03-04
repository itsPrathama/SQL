create database Pizzas;
use Pizzas;
-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_order_placed
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price)) AS Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.
SELECT 
    pizzas.size, COUNT(order_details.order_details_id)
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY COUNT(order_details.order_details_id) DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS order_count
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity) DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS order_category
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

-- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(orders.time) AS Total_Hour,
    COUNT(order_details.order_details_id) AS Total_count
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY HOUR(orders.time)
ORDER BY HOUR(orders.time);

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name) AS pizza_count
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day. 
SELECT 
    FORMAT(AVG(sum_quantity), 2) AS average_orders_per_day
FROM
    (SELECT 
        DAY(orders.date),
            SUM(order_details.quantity) AS sum_quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS sum_order_perday;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name, SUM(order_details.quantity * pizzas.price)
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity * pizzas.price) DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.name,
    CONCAT(ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                            SUM(order_details.quantity * pizzas.price)
                        FROM
                            order_details
                                JOIN
                            pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100,
                    2),
            '%') AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_revenue DESC;
