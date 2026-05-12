# dbt DuckDB Learning Project

A hands-on dbt learning repo built around progressively larger analytics engineering projects. The goal is not just to write SQL models, but to practice dbt project structure, source definitions, tests, documentation, macros, incremental models, snapshots, exposures, and CI/CD-ready conventions.

This project uses **dbt-duckdb** so the full warehouse workflow can run locally without a cloud data warehouse.

## Current Status

Progress source: `progress_snapshot.md` and `dbt_roadmap.html`.

Overall progress is **73 of 77 tasks complete, or 95%**.

| Phase | Status | Progress |
| --- | --- | --- |
| Setup & Foundation | Complete | 14/14 |
| E-commerce Analytics Pipeline | Complete | 27/27 |
| Personal Finance Tracker | Complete | 10/10 |
| Public Data Analysis | Complete | 11/11 |
| Leveling Up | Complete | 10/10 |
| Bonus Challenges | In progress | 1/5 |

Remaining bonus work:

- Create a custom materialization
- Finish CI/CD with GitHub Actions
- Connect dbt to a BI tool such as Metabase or Superset
- Write a blog post about learnings

Note: `progress_snapshot.md` marks "Rebuild project using Jinja" complete. `dbt_roadmap.html` still lists that bonus item as incomplete, so the snapshot is treated as the current source of truth.

## Stack

| Tool | Purpose |
| --- | --- |
| dbt Core + dbt-duckdb | Transformation framework and DuckDB adapter |
| DuckDB | Local analytical database |
| dbt_utils | Community macro package |
| Python | Runtime environment |
| GitHub Actions | Planned/active CI workflow area |

## Project Layout

```text
models/
  staging/
    ecommerce/
    personal_finance/
    github/
  intermediate/
    github/
  marts/
    ecommerce/
    personal_finance/
    github/
macros/
snapshots/
seeds/
tests/
```

The repo follows a common analytics engineering pattern:

- **Staging** models are close to source tables. They clean names, cast types, and apply light standardization.
- **Intermediate** models hold reusable business logic that should not be exposed as final reporting tables.
- **Marts** models are business-facing facts, dimensions, summaries, and dashboard-ready outputs.
- **Tests** cover primary keys, relationships, accepted values, and custom business assertions.
- **Macros** hold reusable SQL/Jinja logic.

## Projects

### 1. E-commerce Analytics Pipeline

Dataset: Olist Brazilian E-Commerce public dataset.

This is the core star-schema style project. Raw CSV data is loaded through seeds, staged into cleaned source-aligned models, and transformed into marts and analytics models.

Key models:

| Layer | Models |
| --- | --- |
| Staging | `stg_customers`, `stg_orders`, `stg_order_items`, `stg_products` |
| Marts | `dim_customers`, `dim_products`, `fact_orders` |
| Analytics | `monthly_revenue`, `product_performance`, `customer_lifetime_value`, `cohort_analysis` |

Key dbt concepts practiced:

- `source()` for raw data references
- `ref()` for DAG-aware model dependencies
- Schema tests for primary keys and relationships
- Singular test for positive monthly revenue
- Custom schema naming via `generate_schema_name`
- `dbt_utils.date_spine` for cohort period scaffolding

Important modeling decision: customer-level analysis uses `customer_unique_id`, not only `customer_id`, because Olist's `customer_id` is order-scoped while `customer_unique_id` is the stable customer identity.

### 2. Personal Finance Tracker

Dataset: sample personal finance CSV seed.

This project models transaction-level expense data into monthly spending summaries and trend analysis.

Key models:

| Layer | Models |
| --- | --- |
| Staging | `stg_expenses` |
| Marts | `fact_monthly_spending`, `categories_spending_trend` |

Key dbt concepts practiced:

- Custom categorization macro: `classify_spending`
- Incremental filtering macro: `incremental_timestamp_filter`
- Custom singular tests for expense quality
- Month-over-month trend logic using SQL window functions
- Exposures for BI-facing assets

### 3. Public Data Analysis: GitHub Archive

Dataset: GitHub Archive event data loaded into DuckDB.

This project is closer to open-ended analytics work: define questions, model useful entities, and produce dashboard-ready outputs.

Key models:

| Layer | Models |
| --- | --- |
| Staging | `stg_github_events` |
| Intermediate | `int_github_repo_activity_state` |
| Marts | `dim_repos`, `dim_actors`, `hourly_push_activity`, `repo_workflow_discipline`, `repo_growth_signals`, `pr_review_patterns`, `github_activity_summary` |
| Snapshots | `github_repo_activity_state_snapshot` |

Key dbt concepts practiced:

- Semi-structured event modeling
- Variables in `dbt_project.yml`
- Reusable macros
- Incremental-style thinking for event data
- Snapshotting slowly changing repository activity state
- Custom tests that compare derived metrics back to source event patterns

### 4. Leveling Up

This phase rounds out core dbt project skills:

- Snapshots for slowly changing dimensions
- Hooks
- Exposures
- Packages and community macros
- Version control conventions
- Critical model tests
- Business logic documentation
- Orchestration concepts across dbt Cloud and Airflow

## Useful Commands

Install dependencies:

```bash
pip install dbt-duckdb
dbt deps
```

Check the dbt connection:

```bash
dbt debug
```

Load seed data:

```bash
dbt seed
```

Run the full project:

```bash
dbt run
dbt test
```

Run selected areas:

```bash
dbt run --select staging.*
dbt run --select marts.*
dbt run --select +fact_orders
dbt test --select stg_expenses
```

Generate and serve documentation:

```bash
dbt docs generate
dbt docs serve
```

Compile without executing:

```bash
dbt compile --select <model_name>
```

## Configuration Notes

`dbt_project.yml` configures:

- Staging models as views in the `staging` schema
- Intermediate models as tables in the `intermediate` schema
- Mart models as tables in the `marts` schema
- E-commerce seeds in `raw_ecommerce`
- Personal finance seeds in `raw_personal_finance`
- GitHub analysis thresholds and event type variables

The project also overrides dbt's default schema naming behavior through `macros/generate_schema_name.sql`, keeping schema names clean and predictable.

## Learning Notes

For someone coming from SQL and ETL tools, the biggest dbt shift in this repo is that model dependencies are declared in SQL through `ref()` and `source()`, then dbt builds the DAG from those references. In raw SQL or traditional ETL, execution order is often controlled outside the query. In dbt, the dependency graph is inferred from the model code itself.

The other major shift is testing and documentation living beside the models. Schema YAML files are not just metadata; they are part of the project's quality contract.

## References

- dbt documentation: https://docs.getdbt.com/
- dbt DuckDB adapter: https://github.com/duckdb/dbt-duckdb
- DuckDB: https://duckdb.org/
- dbt-utils package: https://hub.getdbt.com/dbt-labs/dbt_utils/latest/
- Olist Brazilian E-Commerce dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
- GitHub Archive: https://www.gharchive.org/
