select 
    *
from 
    {{ ref('stg_expenses') }}
where 
    amount <= 0