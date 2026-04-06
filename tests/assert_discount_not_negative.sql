-- Discount amount should never be negative
select
    transaction_id,
    discount_amount
from {{ ref('fct_transactions') }}
where discount_amount < 0
