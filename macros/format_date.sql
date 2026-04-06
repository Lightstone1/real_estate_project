{% macro format_date(column_name, format='YYYY-MM-DD') %}
    to_varchar({{ column_name }}, '{{ format }}')
{% endmacro %}
