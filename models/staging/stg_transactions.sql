with source as (
    select * from {{ source('real_estate', 'TRANSACTIONS') }}
),

renamed as (
    select
        TRANSACTION_ID   as transaction_id,
        TRANSACTION_REF  as transaction_ref,
        PROPERTY_ID      as property_id,
        CLIENT_ID        as client_id,
        AGENT_ID         as agent_id,
        PAYMENT_ID       as payment_id,
        TRANSACTION_TYPE as transaction_type,
        TRANSACTION_DATE as transaction_date,
        AGREED_PRICE     as agreed_price,
        LISTING_PRICE    as listing_price,
        DISCOUNT_AMOUNT  as discount_amount,
        COMMISSION_RATE  as commission_rate,
        COMMISSION_AMOUNT as commission_amount,
        STATUS           as status,
        CONTRACT_START   as contract_start,
        CONTRACT_END     as contract_end,
        NOTES            as notes,
        CREATED_AT       as created_at
    from source
)

select * from renamed
