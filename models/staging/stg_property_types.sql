with source as (
    select * from {{ source('real_estate', 'PROPERTY_TYPES') }}
),

renamed as (
    select
        TYPE_ID          as type_id,
        TYPE_CODE        as type_code,
        TYPE_NAME        as type_name,
        BASE_PRICE_SQM   as base_price_sqm,
        TYPICAL_SIZE_MIN as typical_size_min,
        TYPICAL_SIZE_MAX as typical_size_max,
        IS_RESIDENTIAL   as is_residential
    from source
)

select * from renamed
