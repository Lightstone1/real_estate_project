with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2015-01-01' as date)",
        end_date="cast('2030-12-31' as date)"
    ) }}
),

final as (
    select
        cast(date_day as date)                                  as date_id,
        date_day                                                as full_date,

        -- year
        date_part('year', date_day)::int                        as year,

        -- quarter
        date_part('quarter', date_day)::int                     as quarter_number,
        'Q' || date_part('quarter', date_day)::int              as quarter_name,
        date_part('year', date_day)::varchar
            || '-Q' || date_part('quarter', date_day)::int      as year_quarter,

        -- month
        date_part('month', date_day)::int                       as month_number,
        to_varchar(date_day, 'MMMM')                            as month_name,
        to_varchar(date_day, 'MON')                             as month_short_name,
        date_part('year', date_day)::varchar
            || '-' || lpad(date_part('month', date_day)::varchar, 2, '0')
                                                                as year_month,

        -- week
        date_part('week', date_day)::int                        as week_number,
        date_part('year', date_day)::varchar
            || '-W' || lpad(date_part('week', date_day)::varchar, 2, '0')
                                                                as year_week,

        -- day
        date_part('day', date_day)::int                         as day_of_month,
        date_part('dayofyear', date_day)::int                   as day_of_year,
        date_part('dayofweek', date_day)::int                   as day_of_week_number,
        to_varchar(date_day, 'DDDD')                            as day_name,
        to_varchar(date_day, 'DY')                              as day_short_name,

        -- flags
        case
            when date_part('dayofweek', date_day) in (0, 6) then true
            else false
        end                                                     as is_weekend,
        case
            when date_part('dayofweek', date_day) in (0, 6) then false
            else true
        end                                                     as is_weekday,
        case
            when date_part('month', date_day) in (12, 1, 2) then 'Winter'
            when date_part('month', date_day) in (3, 4, 5)  then 'Spring'
            when date_part('month', date_day) in (6, 7, 8)  then 'Summer'
            else 'Autumn'
        end                                                     as season

    from date_spine
)

select * from final
