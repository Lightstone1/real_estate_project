with properties as (
    select * from {{ ref('stg_properties') }}
),

property_types as (
    select * from {{ ref('stg_property_types') }}
),

cities as (
    select * from {{ ref('stg_cities') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
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
        pt.type_code,
        pt.type_name,
        pt.base_price_sqm,
        pt.typical_size_min,
        pt.typical_size_max,
        pt.is_residential,

        -- city
        c.city_id,
        c.city_name,
        c.postal_code                                           as city_postal_code,
        c.population                                            as city_population,
        c.is_major_city,

        -- region
        r.region_id,
        r.region_code,
        r.region_name,
        r.price_multiplier,
        r.capital_city,

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
            p.listing_price - (pt.base_price_sqm * p.size_sqm * r.price_multiplier), 2
        )                                                       as price_vs_market

    from properties p
    left join property_types pt on p.type_id = pt.type_id
    left join cities c on p.city_id = c.city_id
    left join regions r on c.region_id = r.region_id
)

select * from final
