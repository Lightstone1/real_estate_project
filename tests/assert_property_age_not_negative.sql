-- Property age should never be negative (build year cannot be in the future)
select
    property_id,
    build_year,
    property_age
from {{ ref('dim_properties') }}
where property_age < 0
