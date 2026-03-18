with source as (
    select 
        product_id, 
        product_category_name, 
        product_name_lenght, 
        product_description_lenght, 
        product_photos_qty, 
        product_weight_g, 
        product_length_cm, 
        product_height_cm, 
        product_width_cm
    from 
        -- {{ ref('olist_products_dataset') }}
        {{ source('ecommerce_raw', 'olist_products_dataset') }}
)

select
    nullif(trim(product_id), '') as product_id,
    nullif(trim(product_category_name), '') as product_category_name,
    try_cast(product_name_lenght as integer) as product_name_length,
    try_cast(product_description_lenght as integer) as product_description_length,
    try_cast(product_photos_qty as integer) as product_photos_qty,
    try_cast(product_weight_g as integer) as product_weight_g,
    try_cast(product_length_cm as integer) as product_length_cm,
    try_cast(product_height_cm as integer) as product_height_cm,
    try_cast(product_width_cm as integer) as product_width_cm
from 
    source