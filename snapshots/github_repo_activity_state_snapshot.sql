{% snapshot github_repo_activity_state_snapshot %}

{{
    config(
        target_schema = 'snapshots',
        unique_key = 'repo_id',
        strategy = 'check',
        check_cols = [
            'repo_name',
            'repo_url',
            'last_event_timestamp_utc',
            'total_event_count',
            'push_event_count',
            'pull_request_event_count',
            'pull_request_review_event_count',
            'watch_event_count',
            'fork_event_count'
        ]
    )
}}

select
    repo_id,
    repo_name,
    repo_url,
    first_event_timestamp_utc,
    last_event_timestamp_utc,
    total_event_count,
    push_event_count,
    pull_request_event_count,
    pull_request_review_event_count,
    watch_event_count,
    fork_event_count
from {{ ref('int_github_repo_activity_state') }}

{% endsnapshot %}
