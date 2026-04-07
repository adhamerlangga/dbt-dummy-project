# dbt Learning Roadmap — Progress Snapshot
> Last updated: April 8, 2026 at 3:19 AM

## Overall: 44/82 tasks (54%)

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

### Personal Finance Tracker — 3/12 (25%)
`███░░░░░░░`

**Setup**
- [x] Create new dbt project or add folder
- [x] Find/create personal finance CSV dataset
- [x] Load transaction data as seeds

**Build Pipeline**
- [ ] Staging: clean transaction data (dates, categories, amounts)
- [ ] Marts: monthly spending summaries
- [ ] Marts: budget tracking (planned vs actual)
- [ ] Analytics: YoY spending comparisons
- [ ] Analytics: category trends over time

**Advanced Features**
- [ ] Custom macro for categorization logic
- [ ] Data quality tests (no future dates, amount ranges)
- [ ] Try incremental materialization
- [ ] Custom singular tests (budget thresholds)

### Public Data Analysis — 0/11 (0%)
`░░░░░░░░░░`

**Setup & Build**
- [ ] Pick dataset: GitHub Archive / Stack Overflow / COVID / weather
- [ ] Download and load into DuckDB
- [ ] Staging layer for data cleanup
- [ ] Identify 3–5 interesting questions
- [ ] Build models to answer each question
- [ ] Create final "dashboard" model

**Advanced Concepts**
- [ ] Use dbt packages (dbt_utils)
- [ ] Implement incremental models
- [ ] Create custom tests
- [ ] Build reusable macros
- [ ] Use variables in dbt_project.yml

### Leveling Up — 0/13 (0%)
`░░░░░░░░░░`

**Deep Dives**
- [ ] Snapshots (slowly changing dimensions)
- [ ] Hooks (pre-hook, post-hook)
- [ ] Exposures (dbt → BI tools)
- [ ] Packages & community macros
- [ ] Orchestration concepts (dbt Cloud / Airflow)

**Best Practices**
- [ ] Set up version control (git)
- [ ] Naming convention for models
- [ ] Folder structure (staging/intermediate/marts/analytics)
- [ ] Tests for all critical models
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

