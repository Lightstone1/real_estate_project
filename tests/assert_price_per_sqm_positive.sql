-- Price per sqm should always be positive for available properties
select
    property_id,
    listing_price,
    size_sqm,
    price_per_sqm
from {{ ref('dim_properties') }}
where price_per_sqm <= 0
  and listing_price > 0
