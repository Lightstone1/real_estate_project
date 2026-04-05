with properties_enriched as (
    select * from {{ ref('int_properties_enriched') }}
),

final as (
    select
        -- property
        property_id,
        address,
        postal_code,
        floor_number,
        total_floors,
        size_sqm,
        num_rooms,
        num_bedrooms,
        num_bathrooms,
        has_parking,
        has_garden,
        has_balcony,
        amenities,
        condition_status,
        build_year,
        energy_class,
        listing_price,
        is_available,
        listed_at,
        latitude,
        longitude,

        -- foreign key
        agent_id,

        -- property type
        type_code,
        type_name,
        base_price_sqm,
        typical_size_min,
        typical_size_max,
        is_residential,

        -- location
        city_name,
        is_major_city,
        region_name,
        region_code,
        price_multiplier,

        -- calculations
        price_per_sqm,
        property_age,
        amenity_count,
        size_category,
        price_vs_market

    from properties_enriched
)

select * from final
