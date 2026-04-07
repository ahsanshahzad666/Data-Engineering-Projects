show databases;
create database de_projects;
use de_projects;
show tables;

select * from orders
order by profit desc;

DESC orders;

-- ----------------------------------------------------------------

select * from orders;
drop table orders;



CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity INT,
	discount_amount DECIMAL(7,2),
    sale_price DECIMAL(7,2),
    profit DECIMAL(7,2)
);

select * from orders;



-- ==================== All Data Analysis Queries with Sql =========================



-- ---- Q1. Find Top 10 highest revenue generating products 
 
 
select * from orders ;
select * from orders where product_id = 'TEC-CO-10004722';


-- ----- Version 1 

select product_id, sum(sale_price) as total_revenue
from orders group by product_id
order by total_revenue desc
limit 10;

-- ----- Version 2

select product_id, sum(sale_price) as total_revenue, count(*) as total_orders
from orders group by product_id
order by total_revenue desc
limit 10;


-- ----- Version 3

SELECT 
    product_id, 
    SUM(sale_price * quantity) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;



-- ---- Q2 Find Top 5 highest products in each region


select * from orders ;
select distinct region from orders ;

-- ----- Version 1 

SELECT 
    product_id, region,
    SUM(sale_price * quantity) AS total_revenue
FROM orders
GROUP BY product_id, region
ORDER BY total_revenue
LIMIT 5;


-- ----- Version 2 

SELECT 
    region, product_id,
    SUM(sale_price * quantity) AS total_revenue
FROM orders
GROUP BY region, product_id
ORDER BY region, product_id desc;


-- ----- Version 3 ( Wrong Code )

SELECT 
    region, product_id,
    SUM(sale_price * quantity) AS total_revenue
FROM orders
GROUP BY region, product_id
ORDER BY region, product_id desc limit 5;

 
-- ----- Version 4 

SELECT * 
   from (
    select region, 
    product_id,
    SUM(sale_price * quantity) AS total_revenue,
    RANK() over (partition by region order by SUM(sale_price * quantity) desc ) as Top_5_products
FROM orders
GROUP BY region, product_id
)t
 where Top_5_products <= 5; 
 
 
 
 
-- ---- Q3. revenue Comparison between 2023 jan and 2022 jan 
 
-- -------------------- Version 1


SELECT
  t1.product_id, 
  t1.revenue_2022, 
  t2.revenue_2023,
  (t2.revenue_2023 - t1.revenue_2022) AS revenue_diff,
  (t2.revenue_2023 - t1.revenue_2022) / t1.revenue_2022 * 100 AS growth_percentage
FROM (
    SELECT 
        product_id,
        SUM(sale_price * quantity) AS revenue_2022
    FROM orders 
    WHERE YEAR(order_date) = 2022
    GROUP BY product_id
) t1
LEFT JOIN (
    SELECT 
        product_id,
        SUM(sale_price * quantity) AS revenue_2023
    FROM orders 
    WHERE YEAR(order_date) = 2023
    GROUP BY product_id
) t2
ON t1.product_id = t2.product_id;




-- -------------------- Version 2
 
WITH revenue_2022 AS (
    SELECT product_id,
           SUM(sale_price * quantity) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY product_id
),
revenue_2023 AS (
    SELECT product_id,
           SUM(sale_price * quantity) AS revenue_2023
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY product_id
)

SELECT 
    r22.product_id,
    r22.revenue_2022,
    r23.revenue_2023,
	(r23.revenue_2023 - r22.revenue_2022) AS revenue_diff,
    concat(round((r23.revenue_2023 - r22.revenue_2022) / r22.revenue_2022 * 100, 2), '%') AS growth_percentage
FROM revenue_2022 r22
left JOIN revenue_2023 r23
ON r22.product_id = r23.product_id;



-- -------------------- Version 3
 
WITH revenue_2022 AS (
    SELECT product_id,
           SUM(sale_price * quantity) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY product_id
),
revenue_2023 AS (
    SELECT product_id,
           SUM(sale_price * quantity) AS revenue_2023
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY product_id
)

SELECT 
    r22.product_id,
    r22.revenue_2022,
	COALESCE(r23.revenue_2023, 0) AS revenue_2023,
    (COALESCE(r23.revenue_2023, 0) - r22.revenue_2022) AS revenue_diff,
    concat(round((r23.revenue_2023 - r22.revenue_2022) / ifnull(r22.revenue_2022,0) * 100, 2), '%') AS growth_percentage
FROM revenue_2022 r22
left join revenue_2023 r23
ON r22.product_id = r23.product_id;


-- ---- Q4. for each category which month had highest sales
 
 
select * from orders;
select category from orders;
select distinct category from orders;


-- -------------------- Version 1
 
WITH highest_category_sales AS (
    SELECT category,
           SUM(sale_price * quantity) AS revenue 
    FROM orders
    GROUP BY category
    order by revenue desc limit 1
)
SELECT * from highest_category_sales; 



-- -------------------- Version 2
 
select 
     DATE_FORMAT(order_date, '%Y-%m') as Year_month_no, 
     category,
     SUM(sale_price * quantity) AS revenue,
     row_number() over (partition by category) as highest_sales_category
from orders
where year(order_date) = '2022'
group by DATE_FORMAT(order_date, '%Y-%m'), category
order by DATE_FORMAT(order_date, '%Y-%m'), category;


-- -------------------- Version 3

select * from orders;
SELECT * from cte;


with cte as (
SELECT category,DATE_FORMAT(order_date, '%Y-%m') AS year_month_no,
	sum(sale_price) as sales,
    row_number() over(partition by category order by SUM(sale_price) desc) as highest_revenue
    FROM orders
    GROUP BY category,DATE_FORMAT(order_date, '%Y-%m')
)
SELECT * from cte;




-- -------------------- Version 4

with cte as (
SELECT category,DATE_FORMAT(order_date, '%Y-%m') AS year_month_no,
	sum(sale_price) as sales
    FROM orders
    GROUP BY category,DATE_FORMAT(order_date, '%Y-%m')
),
ranked_data as (
select * ,
    row_number() over(partition by category order by sales desc ) as highest_revenue
    from cte
)
SELECT * from 
ranked_data 
where highest_revenue = 1;





-- ---- Q5. which sub_category have highest gowth by profit in 2023 Comparison to 2022

select * from orders;


-- -------------------- Version 1
 
WITH revenue_2022 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY sub_category
),
revenue_2023 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2023
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY sub_category
)
SELECT 
    r22.sub_category,
    r22.revenue_2022,
	COALESCE(r23.revenue_2023, 0) AS revenue_2023,
    concat(round((r23.revenue_2023 - r22.revenue_2022) / ifnull(r22.revenue_2022,0) * 100, 2), '%') AS growth_percentage
FROM revenue_2022 r22
left join revenue_2023 r23
ON r22.sub_category= r23.sub_category
order by growth_percentage desc;


-- -------------------- Version 2
 
WITH revenue_2022 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY sub_category
),
revenue_2023 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2023
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY sub_category
)
SELECT 
    r22.sub_category,
    r22.revenue_2022,
	COALESCE(r23.revenue_2023, 0) AS revenue_2023,
    round((r23.revenue_2023 - r22.revenue_2022) / ifnull(r22.revenue_2022,0) * 100, 2) AS growth_percentage
FROM revenue_2022 r22
left join revenue_2023 r23
ON r22.sub_category= r23.sub_category
order by growth_percentage desc;


-- -------------------- Version 3
 
WITH revenue_2022 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY sub_category
),
revenue_2023 AS (
    SELECT sub_category,
           SUM(sale_price) AS revenue_2023
    FROM orders
    WHERE YEAR(order_date) = 2023
    GROUP BY sub_category
),
final_data as ( 
   select 
    r22.sub_category,
    r22.revenue_2022 as revenue_2022,
	COALESCE(r23.revenue_2023, 0) AS revenue_2023,
    round((r23.revenue_2023 - r22.revenue_2022) / ifnull(r22.revenue_2022,0) * 100, 2) AS growth_per
FROM revenue_2022 r22
left join revenue_2023 r23
ON r22.sub_category= r23.sub_category
)

select 
sub_category,
revenue_2022,
revenue_2023,
-- CONCAT(growth_per, '%') AS growth_percentage 
growth_per as growth_percentage
from final_data
order by growth_percentage desc
limit 1;


