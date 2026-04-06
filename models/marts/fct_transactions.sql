with transactions as (
    select * from {{ ref('stg_transactions') }}
),

accm as (
    select * from {{ ref('stg_accm_completion_update') }}
),

final as (
    select
        -- primary key
        t.transaction_id,
        t.transaction_ref,

        -- foreign keys
        t.property_id,
        t.client_id,
        t.agent_id,
        t.payment_id,

        -- transaction details
        t.transaction_type,
        t.transaction_date,
        t.status,
        t.contract_start,
        t.contract_end,
        t.notes,
        t.created_at,
        a.accm_txn_complete_time,

        -- date dimensions
        date_part('year', t.transaction_date)                   as transaction_year,
        date_part('quarter', t.transaction_date)                as transaction_quarter,
        date_part('month', t.transaction_date)                  as transaction_month,

        -- measures
        {{ format_currency('t.listing_price') }}                as listing_price,
        {{ format_currency('t.agreed_price') }}                 as agreed_price,
        {{ format_currency('t.discount_amount') }}              as discount_amount,
        {{ calculate_discount_pct('t.discount_amount', 't.listing_price') }}
                                                                as discount_pct,
        t.commission_rate,
        {{ format_currency('t.commission_amount') }}            as commission_amount,

        -- calculated measures
        round(t.agreed_price / nullif(t.listing_price, 0) * 100, 2)
                                                                as price_achieved_pct,
        datediff('day', t.contract_start, t.contract_end)      as contract_duration_days,
        datediff('day', t.transaction_date, a.accm_txn_complete_time::date)
                                                                as days_to_completion

    from transactions t
    left join accm a on t.transaction_ref = a.txn_id
)

select * from final
