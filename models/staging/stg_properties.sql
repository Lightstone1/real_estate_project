with source as (
    select * from {{ source('real_estate', 'PROPERTIES') }}
),

renamed as (
    select
        PROPERTY_ID      as property_id,
        TYPE_ID          as type_id,
        CITY_ID          as city_id,
        AGENT_ID         as agent_id,
        ADDRESS          as address,
        POSTAL_CODE      as postal_code,
        FLOOR_NUMBER     as floor_number,
        TOTAL_FLOORS     as total_floors,
        SIZE_SQM         as size_sqm,
        NUM_ROOMS        as num_rooms,
        NUM_BEDROOMS     as num_bedrooms,
        NUM_BATHROOMS    as num_bathrooms,
        HAS_PARKING      as has_parking,
        HAS_GARDEN       as has_garden,
        HAS_BALCONY      as has_balcony,
        AMENITIES        as amenities,
        CONDITION_STATUS as condition_status,
        BUILD_YEAR       as build_year,
        ENERGY_CLASS     as energy_class,
        LISTING_PRICE    as listing_price,
        IS_AVAILABLE     as is_available,
        LISTED_AT        as listed_at,
        LATITUDE         as latitude,
        LONGITUDE        as longitude
    from source
)

select * from renamed
