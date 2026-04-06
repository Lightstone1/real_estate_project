-- Contract end date should always be after contract start date
select
    transaction_id,
    contract_start,
    contract_end
from {{ ref('fct_transactions') }}
where contract_end < contract_start
