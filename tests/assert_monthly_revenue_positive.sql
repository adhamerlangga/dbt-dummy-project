select *
from {{ ref('monthly_revenue') }}
where total_revenue <= 0