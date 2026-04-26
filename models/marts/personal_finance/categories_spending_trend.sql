with monthly_spending as (
    select 
        spending_month,
        spending_classification,
        total_spending,
        total_transactions
    from 
        {{ ref('fact_monthly_spending') }}
),

spending_with_lag as (
    select 
        spending_month,
        spending_classification,
        total_spending,
        total_transactions,
        lag(total_spending) over (partition by spending_classification order by spending_month) as prev_month_spending
    from 
        monthly_spending
)

select 
    spending_month,
    spending_classification,
    total_spending,
    total_transactions,
    prev_month_spending,
    total_spending - prev_month_spending as mom_change_amount,
    round(
        case 
            when prev_month_spending = 0 or prev_month_spending is null then null
            else (total_spending - prev_month_spending) / prev_month_spending * 100
        end
        , 2
    ) as mom_change_pct
from 
    spending_with_lag
order by 
    spending_classification, spending_month
