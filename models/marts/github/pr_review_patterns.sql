with review_events as (
    select
        e.repo_id,
        r.repo_name,
        e.actor_id,
        cast(e.created_timestamp as date) as review_date,
        extract('hour' from e.created_timestamp) as review_hour_utc,
        date_trunc('hour', e.created_timestamp) as review_hour_timestamp_utc,
        coalesce(e.payload.review.state, 'unknown') as review_state
    from {{ ref('stg_github_events') }} e
    inner join {{ ref('dim_repos') }} r
        on e.repo_id = r.repo_id
    inner join {{ ref('dim_actors') }} a
        on e.actor_id = a.actor_id
    where e.event_type = 'PullRequestReviewEvent'
)

select
    repo_id,
    repo_name,
    review_date,
    review_hour_utc,
    review_hour_timestamp_utc,
    review_state,
    count(*) as review_event_count,
    count(distinct actor_id) as unique_reviewers
from review_events
group by
    repo_id,
    repo_name,
    review_date,
    review_hour_utc,
    review_hour_timestamp_utc,
    review_state
