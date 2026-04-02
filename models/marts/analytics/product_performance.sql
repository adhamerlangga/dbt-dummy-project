with product_orders as (
    SELECT
        order_id,
        product_id,
        seller_id,
        coalesce(product_category_name, 'Uncategorized') as product_category_name,
        total_item_revenue
    FROM 
        {{ ref('fact_orders') }}
    where
        order_status = 'delivered'
)

select 
    product_category_name,
    count(distinct order_id) as total_orders,
    round(sum(total_item_revenue), 2) as total_revenue,
    round(sum(total_item_revenue)  /  count(distinct order_id), 2) as average_order_value,
    count(distinct product_id) as total_products_sold,
    count(distinct seller_id) as total_sellers,
    round(count(distinct order_id)::decimal / count(distinct product_id), 2) as orders_per_product
from
    product_orders
group by
    product_category_name