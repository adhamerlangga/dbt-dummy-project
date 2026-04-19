select 
    *
from 
    {{ ref('stg_expenses') }}
where 
    transaction_date > current_date