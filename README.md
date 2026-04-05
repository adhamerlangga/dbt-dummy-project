# dbt Learning Journey

A structured, hands-on dbt learning project built around progressively complex real-world pipelines. Rather than following a single tutorial, this repo is organized as a series of self-contained projects — each one introducing new dbt concepts on top of the last.

All projects use **dbt-duckdb** as the local analytical engine. No cloud warehouse required.

---

## Projects

| # | Project | Dataset | Status | Key Concepts |
|---|---------|---------|--------|--------------|
| 1 | [E-Commerce Analytics Pipeline](#1-e-commerce-analytics-pipeline) | Olist (Kaggle) | ✅ 89% complete | Staging/marts/analytics layers, sources, tests, macros, dbt_utils |
| 2 | [Personal Finance Tracker](#2-personal-finance-tracker) | Personal CSV exports | 🔜 Planned | Incremental models, custom macros, budget vs actual |
| 3 | [Public Data Analysis](#3-public-data-analysis) | TBD (GitHub Archive / COVID / Weather) | 🔜 Planned | dbt variables, custom tests, incremental models |

---

## Stack

| Tool | Version | Role |
|------|---------|------|
| [dbt-duckdb](https://github.com/duckdb/dbt-duckdb) | 1.10.0 | Transformation layer |
| [DuckDB](https://duckdb.org/) | 1.4.4 | Local analytical database |
| [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) | 1.3.0 | Utility macros (date spine, etc.) |
| Python | 3.x | Runtime environment |

---

## Project 1: E-Commerce Analytics Pipeline

**Dataset:** [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 100k orders from 2016–2018 across Brazilian marketplaces.

**Status:** ✅ Models complete | ⏳ Documentation in progress

The first and most complete project. Builds a full analytics pipeline from raw CSV seeds to business-ready aggregation models, following a three-layer architecture.

### Architecture

```
Raw (DuckDB seeds)
       │
       ▼
  [ Staging ]  ── views ──  Cleaned, typed, renamed source data
       │
       ▼
  [  Marts  ]  ── tables ── Dimensional & fact models (star schema)
       │
       ▼
 [ Analytics ] ── tables ── Business aggregations & metrics
```

### Models

**Staging** (`dev.staging.*`)

| Model | Description |
|-------|-------------|
| `stg_customers` | Customer identifiers and location. Preserves both `customer_id` (per-order) and `customer_unique_id` (true customer). |
| `stg_orders` | Order headers with all timestamps from purchase through delivery. |
| `stg_order_items` | Line-item grain. One row per `order_id` + `order_item_id`. |
| `stg_products` | Product catalog with dimensions and categories. Fixes source typos (`lenght` → `length`). |

**Marts** (`dev.marts.*`)

| Model | Description |
|-------|-------------|
| `dim_customers` | Customer dimension with unique customer identifier. |
| `dim_products` | Product dimension with category and physical attributes. |
| `fact_orders` | Central fact table. Grain: one row per order line item. Includes `total_item_revenue` (price + freight). |

**Analytics** (`dev.marts.*` via `analytics/` subfolder)

| Model | Description |
|-------|-------------|
| `monthly_revenue` | Monthly revenue trend using delivery date as the time anchor (accrual basis). |
| `product_performance` | Category-level metrics: revenue, orders, sellers, and orders-per-product ratio. |
| `customer_lifetime_value` | Per-customer aggregation using `customer_unique_id` to handle Olist's order-scoped `customer_id` correctly. |
| `cohort_analysis` | Monthly acquisition cohorts with retention rates. Uses `dbt_utils.date_spine` to fill period gaps. |

### Key Design Decisions

**Schema separation via custom macro** — dbt's default behavior concatenates the target schema and custom schema (e.g., `main_staging`). The `generate_schema_name` macro is overridden to produce clean schema names (`staging`, `marts`) regardless of target environment.

**`customer_unique_id` for customer-level analysis** — Olist uses `customer_id` as a per-order identifier. A real customer can have many `customer_id` values across orders. All customer-level aggregations join through `customer_unique_id` to avoid inflating customer counts.

**Delivery date as revenue anchor** — `monthly_revenue` uses `order_delivered_customer_at` rather than `order_purchase_timestamp`, reflecting accrual-basis recognition: revenue is counted when delivery is complete.

**Float rounding on financial columns** — Aggregated revenue columns use `round(..., 2)` to prevent floating-point precision artifacts in financial reporting.

### Tests

**Schema tests** (defined in `schema.yaml`):
- `unique` and `not_null` on all primary keys
- `relationships` to validate FK integrity across staging and mart layers
- `accepted_values` on `order_status`

**Singular test** (`tests/assert_monthly_revenue_positive.sql`):
- Asserts no month has zero or negative total revenue

---

## Project 2: Personal Finance Tracker

> 🔜 **Status: Planned**

A dbt pipeline built on top of personal financial transaction exports (bank statements, credit cards). The focus shifts from analytical breadth to analytical *depth on a known domain* — and introduces concepts not covered in the e-commerce project.

**Planned concepts:**
- **Incremental materialization** — process only new transactions rather than full table rebuilds
- **Custom categorization macro** — Jinja-based logic to map raw merchant names to spending categories
- **Budget vs actual** — mart-level model comparing planned budgets against real spending
- **Custom singular tests** — assert that no category exceeds a defined monthly threshold
- **YoY comparisons** — analytics model using window functions for year-over-year trend analysis

---

## Project 3: Public Data Analysis

> 🔜 **Status: Planned**

An open-ended analytical project on a large public dataset (candidates: GitHub Archive, Stack Overflow, COVID, or weather data). The goal is to practice identifying interesting questions and building models to answer them — closer to real analytics engineering work than following a predefined schema.

**Planned concepts:**
- **dbt variables** — parameterize models via `dbt_project.yml` and `--vars` at runtime
- **Advanced incremental models** — handle late-arriving data and partition strategies
- **dbt packages** — deeper use of `dbt_utils` and community macros beyond `date_spine`
- **Reusable macros** — extract repeated logic into project-wide macros
- **Custom generic tests** — write reusable tests applicable across multiple models

---

## Setup

### Prerequisites
- Python 3.x
- DuckDB CLI (optional — for browsing `target/dev.duckdb` directly)

### Install
```bash
pip install dbt-duckdb==1.10.0
dbt deps  # install dbt_utils
```

### Configure
Create `profiles.yml` (gitignored — never committed):
```yaml
my_first_project:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: target/dev.duckdb
      schema: main
```

### Load source data (Project 1)
Download the [Olist dataset from Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), place CSVs in `seeds/`, then:
```bash
dbt seed
```

### Run
```bash
dbt run          # full pipeline
dbt test         # all tests
dbt docs generate && dbt docs serve  # lineage + docs UI

# Selective runs
dbt run --select staging.*
dbt run --select marts.*
dbt run --select monthly_revenue
```

---

## Overall Progress

```
Setup & Foundation          ██████████  100%  (14/14)
E-Commerce Pipeline         █████████░   89%  (24/27)
Personal Finance Tracker    ░░░░░░░░░░    0%  ( 0/12)
Public Data Analysis        ░░░░░░░░░░    0%  ( 0/11)
Leveling Up                 ░░░░░░░░░░    0%  ( 0/13)
Bonus Challenges            ░░░░░░░░░░    0%  ( 0/5 )
─────────────────────────────────────────────────────
Overall                                  46%  (38/82)
```

---

## Dataset Credits

- **Project 1:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — CC BY-NC-SA 4.0