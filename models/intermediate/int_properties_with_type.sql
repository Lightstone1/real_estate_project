with properties as (
    select * from {{ ref('stg_properties') }}
),

property_types as (
    select * from {{ ref('stg_property_types') }}
),

final as (
    select
        p.property_id,
        p.address,
        p.postal_code,
        p.floor_number,
        p.total_floors,
        p.size_sqm,
        p.num_rooms,
        p.num_bedrooms,
        p.num_bathrooms,
        p.has_parking,
        p.has_garden,
        p.has_balcony,
        p.amenities,
        p.condition_status,
        p.build_year,
        p.energy_class,
        p.listing_price,
        p.is_available,
        p.listed_at,
        p.latitude,
        p.longitude,
        p.city_id,
        p.agent_id,

        -- property type
        pt.type_code,
        pt.type_name,
        pt.base_price_sqm,
        pt.typical_size_min,
        pt.typical_size_max,
        pt.is_residential

    from properties p
    left join property_types pt on p.type_id = pt.type_id
)

select * from final
