with agents as (
    select * from {{ ref('stg_agents') }}
),

agencies as (
    select * from {{ ref('stg_agencies') }}
),

cities as (
    select * from {{ ref('stg_cities') }}
),

regions as (
    select * from {{ ref('stg_regions') }}
),

final as (
    select
        -- agent
        a.agent_id,
        a.first_name,
        a.last_name,
        a.first_name || ' ' || a.last_name                     as agent_full_name,
        a.license_number                                        as agent_license_number,
        a.email                                                 as agent_email,
        a.phone                                                 as agent_phone,
        a.hire_date,
        a.specialization,
        a.years_experience,
        a.is_active                                             as agent_is_active,

        -- agency
        ag.agency_id,
        ag.agency_name,
        ag.license_number                                       as agency_license_number,
        ag.address                                              as agency_address,
        ag.phone                                                as agency_phone,
        ag.email                                                as agency_email,
        ag.website                                              as agency_website,
        ag.established_year,
        ag.is_active                                            as agency_is_active,

        -- location
        c.city_name                                             as agency_city,
        c.is_major_city,
        r.region_name                                           as agency_region,

        -- calculations
        case
            when a.years_experience < 2  then 'Junior'
            when a.years_experience < 5  then 'Mid-Level'
            when a.years_experience < 10 then 'Senior'
            else 'Expert'
        end                                                     as seniority_band,
        datediff('year', a.hire_date, current_date())           as years_since_hired

    from agents a
    left join agencies ag on a.agency_id = ag.agency_id
    left join cities c on ag.city_id = c.city_id
    left join regions r on c.region_id = r.region_id
)

select * from final
