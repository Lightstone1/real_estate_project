with cities as (
    select * from {{ ref('stg_cities') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
),

final as (
    select
        c.city_id,
        c.city_name,
        c.postal_code,
        c.latitude,
        c.longitude,
        c.population       as city_population,
        c.is_major_city,
        r.region_id,
        r.region_code,
        r.region_name,
        r.capital_city,
        r.population       as region_population,
        r.area_sqkm,
        r.price_multiplier
    from cities c
    left join regions r on c.region_id = r.region_id
)

select * from final
