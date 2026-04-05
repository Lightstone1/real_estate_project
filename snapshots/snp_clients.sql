{% snapshot snp_clients %}

{{
    config(
        target_schema='analytics',
        unique_key='client_id',
        strategy='check',
        check_cols=[
            'is_verified',
            'address',
            'city_id',
            'phone',
            'email'
        ]
    )
}}

select * from {{ source('real_estate', 'CLIENTS') }}

{% endsnapshot %}
