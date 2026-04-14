with source as (
    select 
        transaction_date,
        spending_classification,
        amount
    from 
        {{ ref('stg_expenses') }}
)

select 
    date_trunc('month', transaction_date) as spending_month,
    spending_classification,
    round(sum(amount), 2) as total_spending,
    count(*) as total_transactions,
    round(avg(amount), 2) as avg_transaction_amount
from 
    source
group by 
    spending_month,
    spending_classification
order by
    spending_month