{% snapshot snp_properties %}

{{
    config(
        target_schema='analytics',
        unique_key='property_id',
        strategy='check',
        check_cols=[
            'listing_price',
            'is_available',
            'condition_status',
            'energy_class'
        ]
    )
}}

select * from {{ source('real_estate', 'PROPERTIES') }}

{% endsnapshot %}
