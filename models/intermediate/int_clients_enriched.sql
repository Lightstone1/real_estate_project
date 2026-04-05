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
        coalesce(
            nullif(trim(coalesce(c.first_name, '') || ' ' || coalesce(c.last_name, '')), ''),
            c.company_name
        )                                                       as client_full_name,
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
        r.region_code,

        -- calculations
        datediff('year', c.date_of_birth, current_date())      as client_age,
        case
            when datediff('year', c.date_of_birth, current_date()) < 30 then '18-29'
            when datediff('year', c.date_of_birth, current_date()) < 40 then '30-39'
            when datediff('year', c.date_of_birth, current_date()) < 50 then '40-49'
            when datediff('year', c.date_of_birth, current_date()) < 60 then '50-59'
            else '60+'
        end                                                     as age_band,
        datediff('day', c.registered_at, current_date())       as days_since_registered

    from clients c
    left join cities ci on c.city_id = ci.city_id
    left join regions r on ci.region_id = r.region_id
)

select * from final
