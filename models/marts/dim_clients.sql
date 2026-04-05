with clients_enriched as (
    select * from {{ ref('int_clients_enriched') }}
),

final as (
    select
        -- client
        client_id,
        client_type,
        first_name,
        last_name,
        client_full_name,
        company_name,
        date_of_birth,
        nationality,
        email,
        phone,
        address,
        iban,
        tax_id,
        is_verified,
        registered_at,

        -- location
        city_name,
        region_name,
        region_code

    from clients_enriched
)

select * from final
