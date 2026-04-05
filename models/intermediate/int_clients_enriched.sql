with clients as (
    select * from {{ ref('stg_clients') }}
),

cities as (
    select * from {{ ref('stg_cities') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
),

final as (
    select
        -- client
        c.client_id,
        c.client_type,
        c.first_name,
        c.last_name,
        c.first_name || ' ' || c.last_name as client_full_name,
        c.company_name,
        c.date_of_birth,
        c.nationality,
        c.email,
        c.phone,
        c.address,
        c.iban,
        c.tax_id,
        c.is_verified,
        c.registered_at,

        -- city
        ci.city_name,
        ci.is_major_city,

        -- region
        r.region_name,
        r.region_code

    from clients c
    left join cities ci on c.city_id = ci.city_id
    left join regions r on ci.region_id = r.region_id
)

select * from final
