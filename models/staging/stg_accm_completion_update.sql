with source as (
    select * from {{ source('real_estate', 'ACCM_COMPLETION_UPDATE') }}
),

renamed as (
    select
        TXN_ID              as txn_id,
        ACCM_TXN_COMPLETE_TIME as accm_txn_complete_time
    from source
)

select * from renamed
