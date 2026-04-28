with repo_activity_state as (
    select *
    from {{ ref('int_github_repo_activity_state') }}
)

select
    repo_id,
    repo_name,
    split_part(repo_name, '/', 1) as repo_owner,
    split_part(repo_name, '/', 2) as repo_slug,
    repo_url,
    first_event_timestamp_utc,
    last_event_timestamp_utc,
    total_event_count,
    push_event_count,
    pull_request_event_count,
    pull_request_review_event_count,
    watch_event_count,
    fork_event_count
from repo_activity_state
