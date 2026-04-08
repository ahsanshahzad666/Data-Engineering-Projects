-- ============================================================
-- Project: Sales Data Analysis (SQL)
-- Description: Business insights using SQL (Revenue, Growth, Trends)
-- ============================================================


-- ==================== DATABASE SETUP ====================

CREATE DATABASE IF NOT EXISTS de_projects;
USE de_projects;

-- ==================== TABLE CREATION ====================

DROP TABLE IF EXISTS orders;

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

-- ==================== DATA PREVIEW ====================

SELECT * FROM orders;
DESC orders;


-- ============================================================
-- ==================== BUSINESS SQL ANALYSIS ==================
-- ============================================================




-- ==================== SALES PERFORMANCE ====================


-- ---- Q1. Find Top 10 highest revenue generating products 


SELECT 
    product_id, 
    SUM(sale_price * quantit) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;





-- ---- Q2 Find Top 5 highest products in each region


WITH ranked_products AS (
    SELECT 
        region, 
        product_id,
        SUM(sale_price * quantity) AS total_revenue,
        RANK() OVER (
            PARTITION BY region 
            ORDER BY SUM(sale_price * quantity) DESC
        ) AS rank_in_region
    FROM orders
    GROUP BY region, product_id
)
SELECT *
FROM ranked_products
WHERE rank_in_region <= 5;





-- ==================== YEAR-OVER-YEAR ANALYSIS ====================

-- ---- Q3. revenue Comparison between 2023 jan and 2022 jan 

 
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





-- ==================== TIME-BASED ANALYSIS ====================

-- ---- Q4. for each category which month had highest sales


with cte as (
SELECT category,DATE_FORMAT(order_date, '%Y-%m') AS year_month_no,
	SUM(sale_price * quantity) as sales
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





-- ==================== PROFIT & GROWTH ANALYSIS ====================

-- ---- Q5. which sub_category have highest gowth by profit in 2023 Comparison to 2022


WITH revenue_2022 AS (
    SELECT sub_category,
          SUM(sale_price * quantity) AS revenue_2022
    FROM orders
    WHERE YEAR(order_date) = 2022
    GROUP BY sub_category
),
revenue_2023 AS (
    SELECT sub_category,
           SUM(sale_price * quantity) AS revenue_2023
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
growth_per as growth_percentage
from final_data
order by growth_percentage desc
limit 1;


