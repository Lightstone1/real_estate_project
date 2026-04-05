with source as (
    select * from {{ source('real_estate', 'REGIONS') }}
),

renamed as (
    select
        REGION_ID        as region_id,
        REGION_CODE      as region_code,
        REGION_NAME      as region_name,
        PRICE_MULTIPLIER as price_multiplier,
        CAPITAL_CITY     as capital_city,
        POPULATION       as population,
        AREA_SQKM        as area_sqkm
    from source
)

select * from renamed
