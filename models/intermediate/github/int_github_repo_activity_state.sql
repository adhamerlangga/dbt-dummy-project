with repo_events as (
    select
        repo_id,
        repo_name,
        repo_url,
        event_type,
        created_timestamp
    from {{ ref('stg_github_events') }}
    where repo_id is not null
)

, repo_agg as (
    select
        repo_id,
        /* duckdb's equivalnent to array_agg(repo_name order by created_timestamp desc limit 1)[offset(0)] */
        arg_max(repo_name, created_timestamp) as repo_name,
        arg_max(repo_url, created_timestamp) as repo_url,
        min(created_timestamp) as first_event_timestamp_utc,
        max(created_timestamp) as last_event_timestamp_utc,
        count(*) as total_event_count,
        sum(case when event_type = 'PushEvent' then 1 else 0 end) as push_event_count,
        sum(case when event_type = 'PullRequestEvent' then 1 else 0 end) as pull_request_event_count,
        sum(case when event_type = 'PullRequestReviewEvent' then 1 else 0 end) as pull_request_review_event_count,
        sum(case when event_type = 'WatchEvent' then 1 else 0 end) as watch_event_count,
        sum(case when event_type = 'ForkEvent' then 1 else 0 end) as fork_event_count
    from repo_events
    group by repo_id
)

select *
from repo_agg