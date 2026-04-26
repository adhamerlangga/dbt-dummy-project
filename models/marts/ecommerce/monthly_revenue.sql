with base as (
    select
        order_id,
        customer_id,
        order_delivered_customer_at,
        total_item_revenue
    from 
        {{ ref('fact_orders') }}
    where
        order_status = 'delivered'
        and order_delivered_customer_at is not null
)

select 
    date_trunc('month', order_delivered_customer_at) as revenue_month,
    round(sum(total_item_revenue), 2) as total_revenue,
    count(distinct order_id) as total_orders,
    count(distinct customer_id) as total_customers,
    round(avg(total_item_revenue), 2) as avg_order_value
from
    base
group by
    revenue_month
order by
    revenue_month