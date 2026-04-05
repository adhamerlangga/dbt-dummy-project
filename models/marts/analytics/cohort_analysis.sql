with orders as (
    select
        order_id,
        customer_id,
        order_purchased_at
    from 
        {{ ref('fact_orders') }}
    where
        order_status = 'delivered'
)

, customers as (
    select
        customer_id,
        customer_unique_id
    from
        {{ ref('dim_customers') }}
)

, customer_cohorts as (
    select
        c.customer_unique_id,
        date_trunc('month', min(order_purchased_at)) as cohort_month
    from
        orders o
    join
        customers c
    on
        o.customer_id = c.customer_id
    group by
        c.customer_unique_id
)

, customer_orders as (
    select
        c.customer_unique_id,
        o.order_purchased_at,
        datediff('month', cc.cohort_month, date_trunc('month', o.order_purchased_at)) as months_since_first_order
    from
        orders o
    join
        customers c
    on
        o.customer_id = c.customer_id
    join
        customer_cohorts cc
    on
        c.customer_unique_id = cc.customer_unique_id
)

, date_spine as (
    {{ dbt_utils.date_spine(
        datepart='month',
        start_date="cast('2016-01-01' as date)",
        end_date="cast('2019-01-01' as date)"
    ) }}
)

select
    cc.cohort_month,
    datediff('month', cc.cohort_month, ds.date_month) as months_since_first_order,
    count(distinct cc.customer_unique_id) as total_customers,
    count(distinct co.customer_unique_id) as retained_customers,
    round(count(distinct co.customer_unique_id)::decimal / count(distinct cc.customer_unique_id), 4) as retention_rate
from
    customer_cohorts cc
join
    date_spine ds
on
    ds.date_month >= cc.cohort_month
left join
    customer_orders co
on
    cc.customer_unique_id = co.customer_unique_id
    and datediff('month', cc.cohort_month, ds.date_month) = co.months_since_first_order
group by
    cohort_month, 
    ds.date_month