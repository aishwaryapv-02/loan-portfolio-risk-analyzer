with prob_default as (
select l.grade,
count(c.loan_id) as charged_off_loans,
count(l.loan_id) as total_loans,
count(c.loan_id) * 1.0 / count(l.loan_id) as pd 
from {{ ref('loans') }} l   left join {{ ref('charge_offs') }} c  
on l.loan_id = c.loan_id    
group by l.grade  
), 
exposure_default as (  
select grade,  
avg(charge_off_balance) as ead  
from {{ref('charge_offs')}} 
group by grade  
)  
select p.grade, 
p.pd,  
e.ead, 
0.85 as lgd, 
(p.pd*e.ead*0.85) as expected_loss  
from prob_default p inner join exposure_default e 
on p.grade = e.grade
