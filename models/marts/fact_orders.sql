with base as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    from
        {{ ref('stg_order_items') }}
),

orders as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchased_at,
        order_approved_at,
        order_delivered_carrier_at,
        order_delivered_customer_at,
        order_estimated_delivery_at
    from
        {{ ref('stg_orders') }}
),

products as (
    select
        product_id,
        product_category_name
    from
        {{ ref('stg_products') }}
)

select 
    b.order_id,
    b.order_item_id,
    b.product_id,
    b.seller_id,
    o.customer_id,
    
    o.order_status,
    b.shipping_limit_date,
    p.product_category_name,
    
    o.order_purchased_at,
    o.order_approved_at,
    o.order_delivered_carrier_at,
    o.order_delivered_customer_at,
    o.order_estimated_delivery_at,
    
    b.price,
    b.freight_value,
    b.price + b.freight_value as total_item_revenue
from 
    base b
inner join 
    orders o 
on 
    b.order_id = o.order_id
left join 
    products p 
on 
    b.product_id = p.product_id