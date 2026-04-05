{% snapshot snp_agencies %}

{{
    config(
        target_schema='analytics',
        unique_key='agency_id',
        strategy='check',
        check_cols=[
            'is_active',
            'city_id',
            'phone',
            'email',
            'website'
        ]
    )
}}

select * from {{ source('real_estate', 'AGENCIES') }}

{% endsnapshot %}
