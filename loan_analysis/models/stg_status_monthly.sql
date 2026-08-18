select s.loan_id, s.month, s.rung, s.balance, s.status, 
case  
when c.loan_id is not null then 'charged off' 
when s.status = 'current' and s.balance <= 0 then 'paid off' 
else s.status 
end as new_status 
from {{ ref('status_monthly')}} s left join {{ ref('charge_offs')}} c 
on s.loan_id = c.loan_id and s.month = c.charge_off_month
