# dbt Learning Roadmap — Progress Snapshot
> Last updated: May 4, 2026 at 8:28 AM

## Overall: 71/80 tasks (89%)

### Setup & Foundation — 14/14 (100%)
`██████████`

**Environment Setup**
- [x] Install Python
- [x] Install dbt-duckdb: `pip install dbt-duckdb`
- [x] Initialize project: `dbt init my_first_project`
- [x] Understand project folder structure
- [x] Run `dbt debug` to verify

**Quick Theory Skim**
- [x] Read "What is dbt?" on dbt docs
- [x] Understand: models, sources, tests, materializations
- [x] Learn what `ref()` and `source()` do
- [x] Understand DAG (Directed Acyclic Graph)

**First Working Model**
- [x] Create a simple seed file (CSV)
- [x] Run `dbt seed`
- [x] Write your first model (simple SELECT)
- [x] Run `dbt run` and see table created
- [x] Check compiled SQL in target folder

### E-commerce Analytics Pipeline — 27/27 (100%)
`██████████`

**Data Acquisition**
- [x] Download sample e-commerce dataset (Kaggle)
- [x] Place CSV files in `seeds/` folder
- [x] Run `dbt seed`

**Staging Layer**
- [x] Create `models/staging/` folder
- [x] Build stg_customers.sql
- [x] Build stg_orders.sql
- [x] Build stg_products.sql
- [x] Build stg_order_items.sql
- [x] Run `dbt run --select staging.*`
- [x] Check generated tables in DuckDB

**Sources & Tests**
- [x] Create `models/staging/sources.yml`
- [x] Define raw data sources
- [x] Replace with `source()` function
- [x] Add schema tests (unique, not_null, relationships)
- [x] Run `dbt test` and fix failures

**Mart Layer**
- [x] Create `models/marts/` folder
- [x] Build fct_orders.sql
- [x] Build dim_customers.sql
- [x] Build dim_products.sql
- [x] Run `dbt run --select marts.*`

**Analytics Layer**
- [x] Build customer_lifetime_value.sql
- [x] Build monthly_revenue.sql
- [x] Build product_performance.sql
- [x] Build cohort_analysis.sql (optional)

**Documentation**
- [x] Add descriptions to models in schema.yml
- [x] Run `dbt docs generate` + `dbt docs serve`
- [x] Document at least 3 key models

### Personal Finance Tracker — 10/10 (100%)
`██████████`

**Setup**
- [x] Create new dbt project or add folder
- [x] Find/create personal finance CSV dataset
- [x] Load transaction data as seeds

**Build Pipeline**
- [x] Staging: clean transaction data (dates, categories, amounts)
- [x] Marts: monthly spending summaries
- [x] Analytics: category trends over time

**Advanced Features**
- [x] Custom macro for categorization logic
- [x] Data quality tests (no future dates, amount ranges)
- [x] Try incremental materialization
- [x] Custom singular tests (transaction no more than future dates) 

### Public Data Analysis — 11/11 (100%)
`██████████`

**Setup & Build**
- [x] Pick dataset: GitHub Archive / Stack Overflow / COVID / weather
- [x] Download and load into DuckDB
- [x] Staging layer for data cleanup
- [x] Identify 3–5 interesting questions
- [x] Build models to answer each question
- [x] Create final "dashboard" model

**Advanced Concepts**
- [x] Use dbt packages (dbt_utils)
- [x] Implement incremental models
- [x] Create custom tests
- [x] Build reusable macros
- [x] Use variables in dbt_project.yml

### Leveling Up — 9/13 (69%)
`███████░░░`

**Deep Dives**
- [x] Snapshots (slowly changing dimensions)
- [x] Hooks (pre-hook, post-hook)
- [x] Exposures (dbt → BI tools)
- [x] Packages & community macros
- [x] Orchestration concepts (dbt Cloud / Airflow)

**Best Practices**
- [x] Set up version control (git)
- [x] Naming convention for models
- [x] Folder structure (staging/intermediate/marts/analytics)
- [x] Tests for all critical models
- [ ] Document business logic

**TIL Doc**
- [ ] Start markdown TIL file
- [ ] Add working code snippets
- [ ] Note "gotchas" and solutions

### Bonus Challenges — 0/5 (0%)
`░░░░░░░░░░`

**Challenges**
- [ ] Rebuild project using Jinja
- [ ] Create custom materialization
- [ ] CI/CD with GitHub Actions
- [ ] Connect dbt to BI tool (Metabase/Superset)
- [ ] Write a blog post about learnings

