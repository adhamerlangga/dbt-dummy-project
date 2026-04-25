select
    repo_id,
    pr_opened_event_count,
    push_pr_ratio
from {{ ref('repo_workflow_discipline') }}
where pr_opened_event_count = 0
  and push_pr_ratio is not null
