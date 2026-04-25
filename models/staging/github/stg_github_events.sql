with github_events as (
    select
        id as event_id,
        type as event_type,
        actor.id as actor_id,
        actor.login as actor_login,
        repo.id as repo_id,
        repo.name as repo_name,
        repo.url as repo_url,
        payload,
        public as is_public,
        created_at,
        org.id as org_id,
        org.login as org_login,
        org.url as org_url
    from {{ source('github_archive_raw', 'github_events') }}
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
from github_events