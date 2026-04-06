with agents as (
    select * from {{ ref('int_agents_with_agency') }}
),

location as (
    select * from {{ ref('int_location_enriched') }}
),

final as (
    select
        -- agent
        a.agent_id,
        a.first_name,
        a.last_name,
        a.agent_full_name,
        a.agent_license_number,
        a.agent_email,
        a.agent_phone,
        a.hire_date,
        a.specialization,
        a.years_experience,
        a.agent_is_active,

        -- agency
        a.agency_id,
        a.agency_name,
        a.agency_license_number,
        a.agency_address,
        a.agency_phone,
        a.agency_email,
        a.agency_website,
        a.established_year,
        a.agency_is_active,

        -- location
        l.city_name                                             as agency_city,
        l.is_major_city,
        l.region_name                                           as agency_region,

        -- calculations
        case
            when a.years_experience < 2  then 'Junior'
            when a.years_experience < 5  then 'Mid-Level'
            when a.years_experience < 10 then 'Senior'
            else 'Expert'
        end                                                     as seniority_band,
        datediff('year', a.hire_date, current_date())           as years_since_hired

    from agents a
    left join location l on a.agency_city_id = l.city_id
)

select * from final
