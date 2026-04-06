-- Commission amount should always be zero or positive
select
    transaction_id,
    commission_amount
from {{ ref('fct_transactions') }}
where commission_amount < 0
