--1. How many pizzas were ordered?
SELECT count(*) AS pizzas_ordered
  FROM customer_orders
  --14

  --2. How many unique customer orders were made?
  SELECT  Count(DISTINCT order_id) as unique_orders
  FROM customer_orders

  --10

--3. How many successful orders were delivered by each runner?
SELECT  runner_id,
count(DISTINCT CO.order_id) as deliveries
FROM runner_orders as RO
JOIN customer_orders as CO
ON RO.order_id = CO.order_id
WHERE pickup_time <> 'NULL'
GROUP BY runner_id

/*
1	4
2	3
3	1
*/


--4. How many of each type of pizza was delivered?
SELECT  CAST(PN.pizza_name as varchar) pizza_name, /* pizza_name data type is text*/
count(CO.pizza_id) as deliveries
FROM runner_orders as RO
Inner JOIN customer_orders as CO ON RO.order_id = CO.order_id
Inner JOIN pizza_names as PN  ON CO.pizza_id = PN.pizza_id
WHERE pickup_time <> 'NULL'
GROUP BY CAST(PN.pizza_name as varchar)

/*
Meatlovers	9
Vegetarian	3
*/


--5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT customer_id, CAST(PN.pizza_name as varchar) as pizza_type, COUNT(CO.pizza_id) as pizzas_ordered
FROM customer_orders as CO
Inner Join pizza_names as PN on CO.pizza_id = PN.pizza_id
group BY CAST(PN.pizza_name as varchar), customer_id

/*
101	Meatlovers	2
101	Vegetarian	1
102	Meatlovers	2
102	Vegetarian	1
103	Meatlovers	3
103	Vegetarian	1
104	Meatlovers	3
105	Vegetarian	1
*/

--6. What was the maximum number of pizzas delivered in a single order?
