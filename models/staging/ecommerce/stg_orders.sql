with source as (
    select 
        order_id, 
        customer_id, 
        order_status, 
        order_purchase_timestamp, 
        order_approved_at, 
        order_delivered_carrier_date, 
        order_delivered_customer_date, 
        order_estimated_delivery_date
    from 
        -- {{ ref('olist_orders_dataset') }}
        {{ source('ecommerce_raw', 'olist_orders_dataset') }}
)

select
    nullif(trim(order_id), '') as order_id,
    nullif(trim(customer_id), '') as customer_id,
    nullif(trim(order_status), '') as order_status,

    try_cast(order_purchase_timestamp as timestamp) as order_purchased_at,
    try_cast(order_approved_at as timestamp) as order_approved_at,
    try_cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_at,
    try_cast(order_delivered_customer_date as timestamp) as order_delivered_customer_at,
    try_cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_at
from 
    source