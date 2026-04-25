{{ config(
    materialized = 'incremental',
    unique_key = 'event_id',
    on_schema_change = 'fail'
) }}

with source_events as (
    select
        raw_events.id as event_id,
        raw_events.type as event_type,
        {{ dbt_utils.star(
            from=source('github_archive_raw', 'github_events'),
            except=['id', 'type', 'actor', 'repo', 'public', 'created_at', 'org'],
            relation_alias='raw_events'
        ) }},
        raw_events.actor.id as actor_id,
        raw_events.actor.login as actor_login,
        raw_events.repo.id as repo_id,
        raw_events.repo.name as repo_name,
        raw_events.repo.url as repo_url,
        raw_events.public as is_public,
        raw_events.created_at,
        raw_events.org.id as org_id,
        raw_events.org.login as org_login,
        raw_events.org.url as org_url
    from {{ source('github_archive_raw', 'github_events') }} as raw_events

    {{ incremental_timestamp_filter(
        'raw_events.created_at',
        'created_timestamp'
    ) }}
)

select
    event_id,
    event_type,
    actor_id,
    actor_login,
    repo_id,
    repo_name,
    repo_url,
    payload,
    is_public,
    cast(created_at as timestamp) as created_timestamp,
    org_id,
    org_login,
    org_url
from source_events
