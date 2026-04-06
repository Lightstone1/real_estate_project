with properties_enriched as (
    select * from {{ ref('int_properties_enriched') }}
),

condition_labels as (
    select * from {{ ref('property_condition_labels') }}
),

energy_ratings as (
    select * from {{ ref('energy_class_ratings') }}
),

final as (
    select
        -- property
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
        cl.condition_label,
        cl.condition_rank,
        p.build_year,
        p.energy_class,
        er.energy_label,
        er.efficiency_rank,
        er.description                                          as energy_description,
        {{ format_currency('p.listing_price') }}                as listing_price,
        p.is_available,
        p.listed_at,
        p.latitude,
        p.longitude,

        -- foreign key
        p.agent_id,

        -- property type
        p.type_code,
        p.type_name,
        {{ format_currency('p.base_price_sqm') }}              as base_price_sqm,
        p.typical_size_min,
        p.typical_size_max,
        p.is_residential,

        -- location
        p.city_name,
        p.is_major_city,
        p.region_name,
        p.region_code,
        p.price_multiplier,

        -- calculations
        {{ price_per_sqm('p.listing_price', 'p.size_sqm') }}   as price_per_sqm,
        p.property_age,
        p.amenity_count,
        p.size_category,
        {{ format_currency('p.price_vs_market') }}              as price_vs_market

    from properties_enriched p
    left join condition_labels cl on p.condition_status = cl.condition_status
    left join energy_ratings er on p.energy_class = er.energy_class
)

select * from final
