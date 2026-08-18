with charge_off_ages as (
  select c.loan_id,
    cast(l.origination_date as date) as origination_date,
    date_diff('month', cast(l.origination_date as date), cast(c.charge_off_month as date)) as month_on_book,
    date_trunc('quarter', cast(l.origination_date as date)) as vintage_quarter
  from {{ ref('charge_offs') }} c
  inner join {{ ref('loans') }} l
    on c.loan_id = l.loan_id
),
vintage_sizes as (
  select date_trunc('quarter', cast(origination_date as date)) as vintage_quarter,
    count(loan_id) as total_loans
  from {{ ref('loans') }}
  group by 1
),
co_per_month as (
  select vintage_quarter, month_on_book, count(loan_id) as charge_off_count
  from charge_off_ages
  group by vintage_quarter, month_on_book
)
select
  co.vintage_quarter,
  co.month_on_book,
  co.charge_off_count,
  sum(co.charge_off_count) over (partition by co.vintage_quarter order by co.month_on_book) as cumulative_charge_offs,
  sum(co.charge_off_count) over (partition by co.vintage_quarter order by co.month_on_book) * 1.0 / vs.total_loans as cumulative_charge_off_rate
from co_per_month co
inner join vintage_sizes vs
  on co.vintage_quarter = vs.vintage_quarter
order by co.vintage_quarter, co.month_on_book
