{% macro price_per_sqm(price_col, size_col) %}
    round({{ price_col }} / nullif({{ size_col }}, 0), 2)
{% endmacro %}
