{% macro calculate_discount_pct(discount_col, listing_price_col) %}
    round(
        case
            when {{ listing_price_col }} > 0
            then ({{ discount_col }} / {{ listing_price_col }}) * 100
            else 0
        end, 2
    )
{% endmacro %}
