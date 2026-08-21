select *,
pd*2*lgd*ead as stressed_expected_loss,
(pd*2*lgd*ead) - expected_loss as loss_increase
from {{ref('expected_loss')}}
