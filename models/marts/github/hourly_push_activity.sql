with push_events as (
    select
        e.repo_id,
        r.repo_name,
        e.actor_id,
        cast(e.created_timestamp as date) as push_date,
        extract('hour' from e.created_timestamp) as push_hour_utc,
        date_trunc('hour', e.created_timestamp) as push_hour_timestamp_utc,
        cast(coalesce(e.payload.size, 0) as bigint) as pushed_commit_count
    from {{ ref('stg_github_events') }} e
    inner join {{ ref('dim_repos') }} r
        on e.repo_id = r.repo_id
    where e.event_type = 'PushEvent'
)

select
    {{ dbt_utils.generate_surrogate_key(['repo_id', 'push_date', 'push_hour_utc']) }} as hourly_push_activity_id,
    repo_id,
    repo_name,
    push_date,
    push_hour_utc,
    push_hour_timestamp_utc,
    count(*) as push_event_count,
    count(distinct actor_id) as unique_push_actors,
    sum(pushed_commit_count) as pushed_commit_count
from push_events
group by
    repo_id,
    repo_name,
    push_date,
    push_hour_utc,
    push_hour_timestamp_utc
