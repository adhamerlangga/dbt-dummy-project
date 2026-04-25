with source_reviews as (
    select
        count(*) as source_review_events
    from {{ ref('stg_github_events') }}
    where event_type = 'PullRequestReviewEvent'
),

model_reviews as (
    select
        coalesce(sum(review_event_count), 0) as model_review_events
    from {{ ref('pr_review_patterns') }}
)

select
    s.source_review_events,
    m.model_review_events
from source_reviews s
cross join model_reviews m
where s.source_review_events <> m.model_review_events
