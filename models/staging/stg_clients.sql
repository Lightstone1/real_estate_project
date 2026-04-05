with source as (
    select * from {{ source('real_estate', 'CLIENTS') }}
),

renamed as (
    select
        CLIENT_ID     as client_id,
        CLIENT_TYPE   as client_type,
        FIRST_NAME    as first_name,
        LAST_NAME     as last_name,
        COMPANY_NAME  as company_name,
        DATE_OF_BIRTH as date_of_birth,
        NATIONALITY   as nationality,
        EMAIL         as email,
        PHONE         as phone,
        ADDRESS       as address,
        CITY_ID       as city_id,
        IBAN          as iban,
        TAX_ID        as tax_id,
        IS_VERIFIED   as is_verified,
        REGISTERED_AT as registered_at
    from source
)

select * from renamed
