with source as (
    select * from {{ source('real_estate', 'AGENTS') }}
),

renamed as (
    select
        AGENT_ID         as agent_id,
        AGENCY_ID        as agency_id,
        FIRST_NAME       as first_name,
        LAST_NAME        as last_name,
        LICENSE_NUMBER   as license_number,
        EMAIL            as email,
        PHONE            as phone,
        HIRE_DATE        as hire_date,
        SPECIALIZATION   as specialization,
        YEARS_EXPERIENCE as years_experience,
        IS_ACTIVE        as is_active
    from source
)

select * from renamed
