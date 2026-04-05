with location_enriched as (
    select * from {{ ref('int_location_enriched') }}
),

final as (
    select
        city_id,
        city_name,
        postal_code,
        latitude,
        longitude,
        city_population,
        is_major_city,
        region_id,
        region_code,
        region_name,
        capital_city,
        region_population,
        area_sqkm,
        price_multiplier
    from location_enriched
)

select * from final
