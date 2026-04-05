with source as (
    select * from {{ source('real_estate', 'AGENCIES') }}
),

renamed as (
    select
        AGENCY_ID        as agency_id,
        AGENCY_NAME      as agency_name,
        LICENSE_NUMBER   as license_number,
        CITY_ID          as city_id,
        ADDRESS          as address,
        PHONE            as phone,
        EMAIL            as email,
        WEBSITE          as website,
        ESTABLISHED_YEAR as established_year,
        IS_ACTIVE        as is_active
    from source
)

select * from renamed
