with source_counts as (
    select
        repo_id,
        sum(case when event_type = 'WatchEvent' then 1 else 0 end) as source_watch_event_count,
        sum(case when event_type = 'ForkEvent' then 1 else 0 end) as source_fork_event_count
    from {{ ref('stg_github_events') }}
    group by repo_id
),

model_counts as (
    select
        repo_id,
        watch_event_count,
        fork_event_count
    from {{ ref('repo_growth_signals') }}
)

select
    m.repo_id,
    m.watch_event_count,
    s.source_watch_event_count,
    m.fork_event_count,
    s.source_fork_event_count
from model_counts m
left join source_counts s
    on m.repo_id = s.repo_id
where coalesce(m.watch_event_count, 0) <> coalesce(s.source_watch_event_count, 0)
   or coalesce(m.fork_event_count, 0) <> coalesce(s.source_fork_event_count, 0)
