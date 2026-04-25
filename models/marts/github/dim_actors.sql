with actor_events as (
    select
        actor_id,
        actor_login,
        repo_id,
        event_type,
        created_timestamp
    from {{ ref('stg_github_events') }}
    where actor_id is not null
),

actor_agg as (
    select
        actor_id,
        arg_max(actor_login, created_timestamp) as actor_login,
        min(created_timestamp) as first_event_timestamp_utc,
        max(created_timestamp) as last_event_timestamp_utc,
        count(*) as total_event_count,
        count(distinct repo_id) as distinct_repos_touched,
        sum(case when event_type = 'PushEvent' then 1 else 0 end) as push_event_count,
        sum(case when event_type = 'PullRequestEvent' then 1 else 0 end) as pull_request_event_count,
        sum(case when event_type = 'PullRequestReviewEvent' then 1 else 0 end) as pull_request_review_event_count
    from actor_events
    group by actor_id
)

select
    actor_id,
    actor_login,
    first_event_timestamp_utc,
    last_event_timestamp_utc,
    total_event_count,
    distinct_repos_touched,
    push_event_count,
    pull_request_event_count,
    pull_request_review_event_count
from actor_agg
