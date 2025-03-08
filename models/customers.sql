{{ 
    config(materialized='table')
    
}}


WITH customer as (
    select 
        id as customer_id,
        first_name,
        last_name 
    FROM `dbt-tutorial`.jaffle_shop.customers
),

orders as (
    select 
        id as order_id,
        user_id as customer_id,
        order_date,
        status
    FROM `dbt-tutorial`.jaffle_shop.orders
),

customer_order as (
    select 
        customer_id,
        Min(order_date) as first_order_date,
        Max(order_date) as most_recent_order_date,
        Count(order_id) as number_of_orders
    From orders 
    group by customer_id
)

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    co.number_of_orders
FROM customer c
LEFT JOIN customer_order co
ON c.customer_id = co.customer_id
ORDER BY co.number_of_orders DESC