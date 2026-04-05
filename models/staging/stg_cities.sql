with source as (
    select * from {{ source('real_estate', 'CITIES') }}
),

renamed as (
    select
        CITY_ID       as city_id,
        REGION_ID     as region_id,
        CITY_NAME     as city_name,
        POSTAL_CODE   as postal_code,
        LATITUDE      as latitude,
        LONGITUDE     as longitude,
        POPULATION    as population,
        IS_MAJOR_CITY as is_major_city
    from source
)

select * from renamed
