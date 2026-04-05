with transactions as (
    select * from {{ ref('stg_transactions') }}
),

properties as (
    select * from {{ ref('int_properties_enriched') }}
),

agents as (
    select * from {{ ref('int_agents_enriched') }}
),

clients as (
    select * from {{ ref('int_clients_enriched') }}
),

payment_details as (
    select * from {{ ref('stg_payment_details') }}
),

accm as (
    select * from {{ ref('stg_accm_completion_update') }}
),

final as (
    select
        -- transaction
        t.transaction_id,
        t.transaction_ref,
        t.transaction_type,
        t.transaction_date,
        t.agreed_price,
        t.listing_price,
        t.discount_amount,
        t.commission_rate,
        t.commission_amount,
        t.status,
        t.contract_start,
        t.contract_end,
        t.notes,
        t.created_at,

        -- completion timestamp
        a.accm_txn_complete_time,

        -- property
        p.property_id,
        p.address                                               as property_address,
        p.size_sqm,
        p.num_bedrooms,
        p.num_bathrooms,
        p.type_name                                             as property_type,
        p.is_residential,
        p.condition_status,
        p.energy_class,
        p.listing_price                                         as original_listing_price,
        p.city_name                                             as property_city,
        p.region_name                                           as property_region,
        p.price_multiplier                                      as region_price_multiplier,
        p.price_per_sqm                                         as property_price_per_sqm,
        p.size_category,

        -- agent
        ag.agent_id,
        ag.agent_full_name,
        ag.specialization                                       as agent_specialization,
        ag.seniority_band                                       as agent_seniority_band,
        ag.agency_name,
        ag.agency_region,

        -- client
        cl.client_id,
        cl.client_full_name,
        cl.client_type,
        cl.nationality                                          as client_nationality,
        cl.city_name                                            as client_city,
        cl.region_name                                          as client_region,
        cl.is_verified                                          as client_is_verified,
        cl.age_band                                             as client_age_band,

        -- payment
        pd.payment_method,
        pd.bank_name,
        pd.mortgage_rate,
        pd.mortgage_term_years,
        pd.down_payment_pct,

        -- calculations
        round(t.agreed_price / nullif(t.listing_price, 0) * 100, 2)
                                                                as price_achieved_pct,
        datediff('day', t.contract_start, t.contract_end)      as contract_duration_days,
        datediff('day', t.transaction_date, a.accm_txn_complete_time::date)
                                                                as days_to_completion

    from transactions t
    left join properties p      on t.property_id = p.property_id
    left join agents ag         on t.agent_id    = ag.agent_id
    left join clients cl        on t.client_id   = cl.client_id
    left join payment_details pd on t.payment_id = pd.payment_id
    left join accm a            on t.transaction_ref = a.txn_id
)

select * from final
