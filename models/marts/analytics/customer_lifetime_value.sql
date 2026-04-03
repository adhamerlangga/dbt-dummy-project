with orders as(
    select
        order_id,
        customer_id,
        order_purchased_at,
        total_item_revenue
    from 
        {{ ref('fact_orders') }}
    where
        order_status = 'delivered'
)

, customers as (
    select
        customer_id,
        customer_unique_id
    from
        {{ ref('dim_customers') }}
)

select
    c.customer_unique_id,
    count(distinct order_id) as total_orders,
    round(sum(total_item_revenue), 2) as total_revenue,
    round(sum(total_item_revenue) / count(distinct order_id), 2) as avg_order_value,
    min(order_purchased_at) as first_order_date,
    max(order_purchased_at) as last_order_date,
    datediff('day', min(order_purchased_at), max(order_purchased_at)) as customer_lifetime_days
from
    orders o
join
    customers c
on
    o.customer_id = c.customer_id
group by
    c.customer_unique_id