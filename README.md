# Real Estate dbt Project

A dbt project transforming raw real estate data from Snowflake into a clean star schema ready for analytics and BI reporting.

---

## Architecture

```
real_estate_raw_db.real_estate (source)
        │
        ▼
   [Staging Layer]          -- Clean, renamed columns. 1:1 with source tables. (10 models)
        │
        ▼
 [Intermediate Layer]       -- Enriched models with joins and business logic. (8 models)
        │
        ▼
   [Marts Layer]            -- Star schema: 1 fact table + 7 dimension tables. (8 models)
```

---

## Project Structure

```
real_estate_project/
├── models/
│   ├── staging/            # stg_*.sql + src_*.yml (source definitions + tests)
│   ├── intermediate/       # int_*.sql + int_*.yml (enriched joins + calculations)
│   └── marts/              # fct_*.sql + dim_*.sql + *.yml (star schema + docs)
├── snapshots/              # SCD Type 2 snapshots for slowly changing dimensions
├── seeds/                  # Reference/lookup CSV data
├── macros/                 # Reusable SQL macros
├── tests/                  # Custom singular business logic tests
├── analyses/               # Ad-hoc SQL queries
├── packages.yml            # dbt package dependencies (dbt_utils, dbt_expectations)
└── .github/workflows/      # CI/CD GitHub Actions pipeline
```

---

## Data Sources

All raw data lives in `real_estate_raw_db.real_estate`:

| Table | Description |
|---|---|
| `TRANSACTIONS` | All property sales and rental transactions |
| `PROPERTIES` | Property listings |
| `AGENTS` | Real estate agents |
| `AGENCIES` | Real estate agencies |
| `CLIENTS` | Individual and corporate clients |
| `CITIES` | City reference data |
| `REGIONS` | Region reference data |
| `PROPERTY_TYPES` | Property type lookup |
| `PAYMENT_DETAILS` | Payment method and financing details |
| `ACCM_COMPLETION_UPDATE` | Transaction completion timestamps |

---

## Intermediate Layer (8 models)

| Model | Joins |
|---|---|
| `int_properties_with_type` | properties + property_types |
| `int_agents_with_agency` | agents + agencies |
| `int_location_enriched` | cities + regions |
| `int_payment_details_enriched` | payment_details (pass-through) |
| `int_properties_enriched` | int_properties_with_type + int_location_enriched + calculations |
| `int_agents_enriched` | int_agents_with_agency + int_location_enriched + calculations |
| `int_clients_enriched` | clients + int_location_enriched + calculations |
| `int_transactions_enriched` | transactions + all enriched intermediates |

---

## Marts Layer — Star Schema (8 models)

```
         dim_date
         dim_location
dim_agents ──── fct_transactions ──── dim_clients
         dim_properties
         dim_payment_details
```

| Model | Type | Rows | Description |
|---|---|---|---|
| `fct_transactions` | Fact | 1,000,000 | Transaction records with measures and FK references |
| `dim_properties` | Dimension | 50,000 | Properties enriched with type, location, energy and condition labels |
| `dim_agents` | Dimension | 500 | Agents with agency details and seniority bands |
| `dim_clients` | Dimension | 80,000 | Clients with age bands and verification status |
| `dim_location` | Dimension | 59 | Cities joined to their regions |
| `dim_payment_details` | Dimension | 200,000 | Payment records with financing details |
| `dim_date` | Dimension | 5,843 | Date spine 2015–2030 with calendar attributes |

---

## Seeds

| Seed | Description |
|---|---|
| `property_condition_labels` | Human-readable labels and rankings for property conditions |
| `energy_class_ratings` | Energy efficiency labels (A–G) with descriptions |
| `transaction_status_labels` | Status labels and closed flags |
| `payment_method_labels` | Payment method descriptions |

---

## Macros

| Macro | Description |
|---|---|
| `active_flag_label(col)` | Converts 0/1 flag to Active/Inactive label |
| `format_currency(col)` | Rounds a numeric column to 2 decimal places |
| `calculate_discount_pct(discount, price)` | Calculates discount as a percentage of listing price |
| `price_per_sqm(price, size)` | Calculates price per square metre |
| `format_date(col, format)` | Formats a date column to a specified string format |

---

## Snapshots (SCD Type 2)

| Snapshot | Tracks Changes To |
|---|---|
| `snp_properties` | listing_price, is_available, condition_status, energy_class |
| `snp_agents` | is_active, specialization, years_experience, agency_id |
| `snp_clients` | is_verified, address, city_id, phone, email |
| `snp_agencies` | is_active, city_id, phone, email, website |

---

## How to Run

### Prerequisites
- dbt Core 1.11+
- dbt-snowflake adapter
- Snowflake account with access to `real_estate_raw_db`

### Setup

```bash
# Install dependencies
dbt deps

# Test your connection
dbt debug

# Load seed data
dbt seed

# Run all models
dbt run

# Run snapshots
dbt snapshot

# Run all tests
dbt test

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

### Run specific layers

```bash
dbt run --select staging
dbt run --select intermediate
dbt run --select marts
```

---

## Testing

The project has **230+** tests across all layers:

- **Source tests** — not_null, unique, accepted_values, relationships
- **Intermediate tests** — not_null, unique, accepted_values
- **Mart tests** — not_null, unique, accepted_values, relationships (FK integrity)
- **Advanced tests (dbt_utils & dbt_expectations)**:
  - `expression_is_true` — agreed_price >= 0, commission >= 0, discount >= 0
  - `expect_table_row_count_to_be_between` — row count guards on all mart tables
  - `expect_column_values_to_be_between` — range checks on prices, ages, dates
- **Singular tests** — custom business logic:
  - Agreed price never exceeds listing price
  - Commission amount is always positive
  - Discount amount is never negative
  - Property age is never negative
  - Contract end date is always after start date
  - Price per sqm is always positive

---

## CI/CD

GitHub Actions workflow (`.github/workflows/dbt_ci.yml`) automatically runs on every pull request to `main`:

1. Installs dbt-snowflake
2. Creates `profiles.yml` from GitHub Secrets
3. Runs `dbt deps` → `dbt debug` → `dbt seed` → `dbt run` → `dbt test`

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `SNOWFLAKE_ACCOUNT` | Snowflake account identifier |
| `SNOWFLAKE_USER` | Snowflake username |
| `SNOWFLAKE_PASSWORD` | Snowflake password |

---

## Exposures

| Exposure | Type | Models Used |
|---|---|---|
| `real_estate_dashboard` | Dashboard | fct_transactions, all dims |
| `agent_performance_report` | Dashboard | fct_transactions, dim_agents |
| `property_listings_report` | Dashboard | dim_properties, dim_location |

---

## Connecting to BI Tools

The mart tables in Snowflake (`REAL_ESTATE_DB.ANALYTICS`) are ready to connect to any BI tool:

### Power BI
1. Get Data → Snowflake
2. Server: `RLNJPEN-FY43907.snowflakecomputing.com`
3. Warehouse: `TRANSFORMING`, Database: `REAL_ESTATE_DB`, Schema: `ANALYTICS`
4. Load `fct_transactions` as your fact and all `dim_*` tables as dimensions

### Tableau
1. Connect → Snowflake
2. Enter server, warehouse, database and schema
3. Drag `fct_transactions` to canvas and join to dims via the FK columns

### Looker
1. Create a LookML project
2. Define `fct_transactions` as the base explore
3. Join all dim tables using the FK relationships defined in `fct_transactions.yml`

---

## Owner

**Lightstone1** — flolightstone@gmail.com
