with repo_events as (
    select
        e.repo_id,
        r.repo_name,
        e.event_type,
        e.payload.action as payload_action
    from {{ ref('stg_github_events') }} e
    inner join {{ ref('dim_repos') }} r
        on e.repo_id = r.repo_id
),

repo_metrics as (
    select
        repo_id,
        repo_name,
        sum(case when event_type = 'PushEvent' then 1 else 0 end) as push_event_count,
        sum(
            case
                when event_type = 'PullRequestEvent' and payload_action = 'opened' then 1
                else 0
            end
        ) as pr_opened_event_count
    from repo_events
    group by
        repo_id,
        repo_name
)

select
    repo_id,
    repo_name,
    push_event_count,
    pr_opened_event_count,
    round(cast(push_event_count as double) / nullif(pr_opened_event_count, 0), 2) as push_pr_ratio,
    case
        when pr_opened_event_count = 0 then 'no_pr_activity'
        when cast(push_event_count as double) / pr_opened_event_count <= {{var('github_pr_heavy_ratio_threshold')}} then 'pr_heavy'
        when cast(push_event_count as double) / pr_opened_event_count <= {{var('github_balanced_ratio_threshold')}} then 'balanced'
        else 'push_heavy'
    end as workflow_discipline_band
from repo_metrics
