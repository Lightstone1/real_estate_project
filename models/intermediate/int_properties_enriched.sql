with properties as (
    select * from {{ ref('int_properties_with_type') }}
),

location as (
    select * from {{ ref('int_location_enriched') }}
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
        p.build_year,
        p.energy_class,
        p.listing_price,
        p.is_available,
        p.listed_at,
        p.latitude,
        p.longitude,
        p.agent_id,

        -- property type
        p.type_code,
        p.type_name,
        p.base_price_sqm,
        p.typical_size_min,
        p.typical_size_max,
        p.is_residential,

        -- location
        l.city_id,
        l.city_name,
        l.city_population,
        l.is_major_city,
        l.region_id,
        l.region_code,
        l.region_name,
        l.price_multiplier,
        l.capital_city,

        -- calculations
        round(p.listing_price / nullif(p.size_sqm, 0), 2)      as price_per_sqm,
        datediff('year', to_date(p.build_year::varchar, 'YYYY'), current_date())
                                                                as property_age,
        (case when p.has_parking = 1 then 1 else 0 end
         + case when p.has_garden = 1 then 1 else 0 end
         + case when p.has_balcony = 1 then 1 else 0 end)      as amenity_count,
        case
            when p.size_sqm < 50  then 'Small'
            when p.size_sqm < 100 then 'Medium'
            when p.size_sqm < 200 then 'Large'
            else 'Extra Large'
        end                                                     as size_category,
        round(
            p.listing_price - (p.base_price_sqm * p.size_sqm * l.price_multiplier), 2
        )                                                       as price_vs_market

    from properties p
    left join location l on p.city_id = l.city_id
)

select * from final
