{% materialization analyzed_table, default %}
    {%- set target_relation = this.incorporate(type='table') -%}
    {%- set existing_relation = adapter.get_relation(
        database=target_relation.database,
        schema=target_relation.schema,
        identifier=target_relation.identifier
    ) -%}

    {{ run_hooks(pre_hooks) }}

    {% do adapter.create_schema(target_relation) %}

    {% if existing_relation is not none %}
        {% do adapter.drop_relation(existing_relation) %}
    {% endif %}

    {% call statement('main') -%}
        {{ get_create_table_as_sql(False, target_relation, sql) }}
    {%- endcall %}

    {% call statement('analyze') -%}
        analyze {{ target_relation }}
    {%- endcall %}

    {% do persist_docs(target_relation, model) %}

    {{ run_hooks(post_hooks) }}

    {% do adapter.commit() %}

    {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
