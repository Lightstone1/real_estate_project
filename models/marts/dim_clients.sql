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
        {{ active_flag_label('is_verified') }}                  as verification_status,
        registered_at,

        -- location
        city_name,
        region_name,
        region_code,

        -- calculations
        client_age,
        age_band,
        days_since_registered

    from clients_enriched
)

select * from final
