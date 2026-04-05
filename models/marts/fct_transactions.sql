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

        -- measures
        t.listing_price,
        t.agreed_price,
        t.discount_amount,
        round(
            case
                when t.listing_price > 0
                then (t.discount_amount / t.listing_price) * 100
                else 0
            end, 2
        )                   as discount_pct,
        t.commission_rate,
        t.commission_amount

    from transactions t
    left join accm a on t.transaction_ref = a.txn_id
)

select * from final
