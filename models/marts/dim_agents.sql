with agents_enriched as (
    select * from {{ ref('int_agents_enriched') }}
),

final as (
    select
        -- agent
        agent_id,
        first_name,
        last_name,
        agent_full_name,
        agent_license_number,
        agent_email,
        agent_phone,
        hire_date,
        specialization,
        years_experience,
        agent_is_active,

        -- agency
        agency_id,
        agency_name,
        agency_license_number,
        agency_address,
        agency_phone,
        agency_email,
        agency_website,
        established_year,
        agency_is_active,

        -- location
        agency_city,
        agency_region,

        -- calculations
        seniority_band,
        years_since_hired

    from agents_enriched
)

select * from final
