with source as (
    select 
        transaction_date,
	    spending_type,
	    category,
	    subcategory,
	    merchant_name,
	    amount
    from 
        {{ source('personal_finance_raw', 'personal_finance_sample') }}
)

select
    try_cast(transaction_date as date) as transaction_date,
    spending_type,
    category,
    subcategory,
    merchant_name,
    try_cast(amount as decimal(15,2)) as amount
from 
    source