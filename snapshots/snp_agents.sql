{% snapshot snp_agents %}

{{
    config(
        target_schema='analytics',
        unique_key='agent_id',
        strategy='check',
        check_cols=[
            'is_active',
            'specialization',
            'years_experience',
            'agency_id'
        ]
    )
}}

select * from {{ source('real_estate', 'AGENTS') }}

{% endsnapshot %}
