select month, status, count(*) as loan_count, sum(balance) as total_balance
from {{ ref('status_monthly') }}
group by 1,2
