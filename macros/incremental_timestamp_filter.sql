{% macro incremental_timestamp_filter(source_timestamp_expr, target_timestamp_column) %}
    {% if is_incremental() %}
        where cast({{ source_timestamp_expr }} as timestamp) >=  (
            select coalesce(max({{ target_timestamp_column }}), timestamp '1900-01-01')
            from {{ this }}
        )
    {% endif %}
{% endmacro %}