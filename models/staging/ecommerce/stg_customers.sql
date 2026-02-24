with source as (
    select 
        *
    from 
        {{ ref('olist_customers_dataset') }}
)

select 
    *
from source
limit 5