with source_push as (
    select
        count(*) as source_push_events
    from {{ ref('stg_github_events') }}
    where event_type = 'PushEvent'
),

model_push as (
    select
        coalesce(sum(push_event_count), 0) as model_push_events
    from {{ ref('hourly_push_activity') }}
)

select
    s.source_push_events,
    m.model_push_events
from source_push s
cross join model_push m
where s.source_push_events <> m.model_push_events
