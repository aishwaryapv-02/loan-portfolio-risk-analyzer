select grade,
  sum(balance) as grade_balance,
  sum(balance) * 1.0 / sum(sum(balance)) over () as exposure_share
from {{ ref('stg_current_exposure') }}
group by grade
