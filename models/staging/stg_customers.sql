with source as (
    select 
        *
    from 
        {{ ref('raw_customer') }}
)

, renamed as (
    select 
        customer_id,
        first_name || ' ' || last_name as customer_full_name,
        email as customer_email,
        signup_date as customer_signup_date
    from source
)
select 
    *
from 
    renamed