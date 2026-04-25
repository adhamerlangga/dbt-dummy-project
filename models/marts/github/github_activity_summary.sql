with push_summary as (
    select
        repo_id,
        sum(push_event_count) as total_push_events,
        sum(pushed_commit_count) as total_pushed_commits,
        count(distinct push_date) as push_active_days,
        count(*) as push_active_hours,
        round(cast(sum(push_event_count) as double) / nullif(count(*), 0), 2) as avg_push_events_per_active_hour
    from {{ ref('hourly_push_activity') }}
    group by repo_id
),

review_summary as (
    select
        repo_id,
        sum(review_event_count) as total_pr_review_events,
        sum(case when review_state = 'approved' then review_event_count else 0 end) as approved_review_events,
        sum(case when review_state = 'commented' then review_event_count else 0 end) as commented_review_events,
        sum(case when review_state = 'changes_requested' then review_event_count else 0 end) as changes_requested_review_events,
        sum(case when review_state = 'dismissed' then review_event_count else 0 end) as dismissed_review_events,
        count(distinct review_date) as review_active_days
    from {{ ref('pr_review_patterns') }}
    group by repo_id
)

select
    r.repo_id,
    r.repo_name,
    r.repo_owner,
    r.repo_slug,
    r.total_event_count,
    r.first_event_timestamp_utc,
    r.last_event_timestamp_utc,

    coalesce(d.push_event_count, 0) as push_event_count,
    coalesce(d.pr_opened_event_count, 0) as pr_opened_event_count,
    d.push_pr_ratio,
    d.workflow_discipline_band,

    coalesce(g.watch_event_count, 0) as watch_event_count,
    coalesce(g.fork_event_count, 0) as fork_event_count,
    coalesce(g.total_growth_signal_count, 0) as total_growth_signal_count,
    g.watch_rank,
    g.fork_rank,
    g.growth_signal_rank,

    coalesce(p.total_push_events, 0) as total_push_events,
    coalesce(p.total_pushed_commits, 0) as total_pushed_commits,
    coalesce(p.push_active_days, 0) as push_active_days,
    coalesce(p.push_active_hours, 0) as push_active_hours,
    p.avg_push_events_per_active_hour,

    coalesce(rv.total_pr_review_events, 0) as total_pr_review_events,
    coalesce(rv.approved_review_events, 0) as approved_review_events,
    coalesce(rv.commented_review_events, 0) as commented_review_events,
    coalesce(rv.changes_requested_review_events, 0) as changes_requested_review_events,
    coalesce(rv.dismissed_review_events, 0) as dismissed_review_events,
    coalesce(rv.review_active_days, 0) as review_active_days
from {{ ref('dim_repos') }} r
left join {{ ref('repo_workflow_discipline') }} d
    on r.repo_id = d.repo_id
left join {{ ref('repo_growth_signals') }} g
    on r.repo_id = g.repo_id
left join push_summary p
    on r.repo_id = p.repo_id
left join review_summary rv
    on r.repo_id = rv.repo_id
