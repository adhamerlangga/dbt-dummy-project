with source as (
    select 
        order_id, 
        order_item_id, 
        product_id, 
        seller_id, 
        shipping_limit_date, 
        price, 
        freight_value
    from 
        {{ ref('olist_order_items_dataset') }}
)

select
    nullif(trim(order_id), '') as order_id,
    try_cast(order_item_id as string) as order_item_id,
    nullif(trim(product_id), '') as product_id,
    nullif(trim(seller_id), '') as seller_id,
    try_cast(shipping_limit_date as timestamp) as shipping_limit_date,
    try_cast(price as float) as price,
    try_cast(freight_value as float) as freight_value
    
from 
    source