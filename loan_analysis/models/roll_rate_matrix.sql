with prev as (
  select loan_id, month, new_status,
    lag(new_status) over (partition by loan_id order by month) as previous_status
  from {{ ref('stg_status_monthly') }}
),
counts as (
  select previous_status, new_status, count(*) as loan_count
  from prev
  where previous_status is not null
  group by previous_status, new_status
)
select *, loan_count * 1.0 / sum(loan_count) over (partition by previous_status) as roll_pct
from counts
