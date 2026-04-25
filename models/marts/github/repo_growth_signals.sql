with growth_events as (
    select
        repo_id,
        event_type,
        created_timestamp
    from {{ ref('stg_github_events') }}
    where event_type in ('WatchEvent', 'ForkEvent')
),

repo_growth as (
    select
        r.repo_id,
        r.repo_name,
        sum(case when g.event_type = 'WatchEvent' then 1 else 0 end) as watch_event_count,
        sum(case when g.event_type = 'ForkEvent' then 1 else 0 end) as fork_event_count,
        min(case when g.event_type = 'WatchEvent' then g.created_timestamp end) as first_watch_timestamp_utc,
        max(case when g.event_type = 'WatchEvent' then g.created_timestamp end) as last_watch_timestamp_utc,
        min(case when g.event_type = 'ForkEvent' then g.created_timestamp end) as first_fork_timestamp_utc,
        max(case when g.event_type = 'ForkEvent' then g.created_timestamp end) as last_fork_timestamp_utc
    from {{ ref('dim_repos') }} r
    left join growth_events g
        on r.repo_id = g.repo_id
    group by
        r.repo_id,
        r.repo_name
),

ranked as (
    select
        repo_id,
        repo_name,
        watch_event_count,
        fork_event_count,
        watch_event_count + fork_event_count as total_growth_signal_count,
        first_watch_timestamp_utc,
        last_watch_timestamp_utc,
        first_fork_timestamp_utc,
        last_fork_timestamp_utc,
        dense_rank() over (
            order by watch_event_count desc, fork_event_count desc, repo_id
        ) as watch_rank,
        dense_rank() over (
            order by fork_event_count desc, watch_event_count desc, repo_id
        ) as fork_rank,
        dense_rank() over (
            order by (watch_event_count + fork_event_count) desc, repo_id
        ) as growth_signal_rank
    from repo_growth
)

select
    repo_id,
    repo_name,
    watch_event_count,
    fork_event_count,
    total_growth_signal_count,
    first_watch_timestamp_utc,
    last_watch_timestamp_utc,
    first_fork_timestamp_utc,
    last_fork_timestamp_utc,
    watch_rank,
    fork_rank,
    growth_signal_rank
from ranked
