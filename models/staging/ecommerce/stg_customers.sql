with source as (
    select 
        *
    from 
        {{ ref('olist_customers_dataset') }}
)

select 
     nullif(trim(customer_id), '') as customer_id,
     nullif(trim(customer_unique_id), '') as customer_unique_id,
     lpad(cast(customer_zip_code_prefix as varchar), 5, '0') as customer_zip_code_prefix,
     upper(left(customer_city, 1)) || lower(substring(customer_city, 2)) as customer_city,
     nullif(trim(customer_state), '') 
from source