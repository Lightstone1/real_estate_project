with source as (
    select * from {{ source('real_estate', 'PAYMENT_DETAILS') }}
),

renamed as (
    select
        PAYMENT_ID          as payment_id,
        PAYMENT_METHOD      as payment_method,
        BANK_NAME           as bank_name,
        IBAN                as iban,
        MORTGAGE_RATE       as mortgage_rate,
        MORTGAGE_TERM_YEARS as mortgage_term_years,
        DOWN_PAYMENT_PCT    as down_payment_pct
    from source
)

select * from renamed
