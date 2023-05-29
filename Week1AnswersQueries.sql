--1.	What is the total amount each customer spent at the restaurant?
SELECT customer_id, Sum(price) as price
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;


--2.	How many days has each customer visited the restaurant?
SELECT  customer_id,  COUNT(DISTINCT order_date) as days_visited 
FROM sales
GROUP BY customer_id;


--3.	What was the first item from the menu purchased by each customer?
WITH CTE as (

	select customer_id, product_name,
	row_number() OVER (PARTITION BY customer_id ORDER BY order_date) as row_num
	from sales as S
	inner join menu as M
	on S.product_id = M.product_id
)
SELECT *
FROM CTE
WHERE row_num = 1


--4.	What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT top 1 M.product_name, count(order_date) as num_of_orders
FROM sales as S
INNER JOIN menu as M
ON s.product_id = m.product_id
GROUP BY M.product_name
ORDER BY num_of_orders desc;


--5.	Which item was the most popular for each customer?
WITH  CTE as (
	SELECT product_name,
	customer_id,
	Count (S.product_id) as items,
	Row_Number() OVER (PARTITION BY customer_id ORDER BY Count (S.product_id) desc) as favourite
	FROM sales as S
	INNER JOIN menu as M
	on S.product_id = M.product_id
	GROUP BY M.product_name, customer_id
	)

SELECT
customer_id, 
product_name 
FROM CTE 
WHERE favourite = 1;

--6.Which item was purchased first by the customer after they became a member?

WITH CTE as (
	SELECT
	S.customer_id, 
	order_date, 
	join_date, 
	product_name,
	ROW_NUMBER() OVER (PARTITION BY S.customer_id order by order_date) as RN
	from Sales as S
	INNER JOIN members as Mem 	on Mem.customer_id = S.customer_id
	INNER JOIN Menu as M on S.product_id = M.product_id
	WHERE order_date >= join_date
)
select 
customer_id,
product_name
from CTE
WHERE RN = 1

--7.Which item was purchased just before the customer became a member?

WITH CTE as (
	SELECT
	S.customer_id, 
	order_date, 
	join_date, 
	product_name,
	ROW_NUMBER() OVER (PARTITION BY S.customer_id order by order_date Desc) as RN
	from Sales as S
	INNER JOIN members as Mem 	on Mem.customer_id = S.customer_id
	INNER JOIN Menu as M on S.product_id = M.product_id
	WHERE order_date < join_date
)
SELECT 
customer_id,
product_name
FROM CTE
WHERE RN = 1


--8. What is the total items and amount spent for each member before they became a member?
SELECT  
S.customer_id,
COUNT(M.product_name) as Total_Items,
SUM(price) as spent
FROM sales as S
INNER JOIN Menu as M on S.product_id = M.product_id
INNER JOIN members as Mem on S.customer_id = Mem.customer_id
WHERE order_date < join_date
GROUP BY S.customer_id

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
customer_id,
SUM (CASE 
	WHEN M.product_name = 'sushi' THEN price * 10 * 2 
	ELSE price * 10
END) AS points
FROM sales as S
INNER JOIN Menu as M on S.product_id = M.product_id
Group BY S.customer_id;

--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT 
  S.customer_id, 
  SUM(
    CASE 
      WHEN S.order_date BETWEEN MEM.join_date AND DATEADD(day,6,Mem.join_date) THEN price * 10 * 2 
      WHEN product_name = 'sushi' THEN price * 10 * 2 
      ELSE price * 10 
    END
  ) as points 
FROM 
  MENU as M 
  INNER JOIN SALES as S ON S.product_id = M.product_id
  INNER JOIN MEMBERS AS MEM ON MEM.customer_id = S.customer_id 
WHERE 
  DATETRUNC(month, S.order_date) = '2021-01-01' 
GROUP BY 
  S.customer_id;

