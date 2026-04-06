{% macro active_flag_label(column_name) %}
    case when {{ column_name }} = 1 then 'Active' else 'Inactive' end
{% endmacro %}
