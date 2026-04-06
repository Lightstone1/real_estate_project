-- Agreed price should never exceed the listing price
select
    transaction_id,
    agreed_price,
    listing_price
from {{ ref('fct_transactions') }}
where agreed_price > listing_price
