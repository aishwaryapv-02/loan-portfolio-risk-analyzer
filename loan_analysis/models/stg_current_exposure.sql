with latest_loan as (  
select loan_id, month, balance, new_status 
from {{ ref('stg_status_monthly')}}   
where month = '2025-06-01'
), 
grade_state as ( 
select l.loan_id, l.grade, c.state 
from {{ref('loans')}} l inner join {{ref('customers')}} c 
on l.customer_id = c.customer_id 
) select l.loan_id, l.month, l.balance, gs.grade,gs.state 
from latest_loan l inner join grade_state gs 
on l.loan_id = gs.loan_id 
where l.new_status not in ('charged off','paid off')
