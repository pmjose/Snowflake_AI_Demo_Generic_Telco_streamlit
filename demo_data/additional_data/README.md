# Additional Data - Historical 2025 Data

This folder contains historical data for calendar year 2025, providing one full year of data before the main 2026 dataset.

## Contents

```
additional_data/
├── 2025/
│   ├── csv/                    # Fact table CSVs for Jan-Dec 2025
│   └── unstructured_docs/      # Historical documents dated 2025
└── README.md                   # This file
```

## Data Volume Summary

| Year | Records | Files | Size | ID Offset |
|------|---------|-------|------|-----------|
| 2025 | ~7M | 27 | ~608 MB | 10,000,000+ |

## 2025 Data Details

| Category | Records | Files |
|----------|---------|-------|
| Billing (invoices, payments) | ~800K | 4 |
| Network (performance, alarms) | ~2M | 3 |
| Support (tickets, calls) | ~1.2M | 5 |
| Operations (IT, SLA) | ~500K | 2 |
| Digital & Loyalty | ~1.2M | 2 |
| Sales & Marketing | ~100K | 3 |
| CRM (quotas, pipeline, opportunities) | ~18K | 3 |
| Other (roaming, IoT, orders) | ~530K | 5 |

## ID Ranges

To avoid collisions, 2025 uses distinct ID ranges:

| Year | ID Range | Example |
|------|----------|---------|
| Existing (2026) | 1 - 9,999,999 | invoice_id: 1 - 500,000 |
| 2025 | 10,000,000 - 19,999,999 | invoice_id: 10,000,001 - 10,400,000 |

## YoY Growth Story

The data shows consistent year-over-year growth:

| Metric | 2025 | 2026 |
|--------|------|------|
| Revenue Factor | 0.95x | 1.00x |
| Subscribers | ~927K | ~1M |
| NPS | +42 | +45 |
| 5G Coverage | 72% | 85% |
| Churn | 1.8% | 1.5% |

## How to Load

```sql
-- Run from Snowflake worksheet
-- Ensure 01_demo_setup.sql and 02_semantic_views.sql have been run first
!source sql_scripts/04_load_additional_data_2025.sql
```

Or copy the contents of `sql_scripts/04_load_additional_data_2025.sql` and execute.

## Manual Upload Alternative

1. Upload CSV files to your Snowflake stage:
   ```sql
   PUT file://demo_data/additional_data/2025/csv/*.csv @INTERNAL_DATA_STAGE/additional_data/2025/;
   ```

2. Run COPY INTO for each table (see SQL script for examples)

## File Naming Convention

Large files are split to stay under 95MB:

- `invoice_fact_2025_1.csv`, `invoice_fact_2025_2.csv`
- `network_performance_fact_2025_1.csv`, `network_performance_fact_2025_2.csv`
- `contact_center_call_fact_2025_1.csv`, `contact_center_call_fact_2025_2.csv`

## Regenerating Data

To regenerate 2025 historical data:

```bash
cd /path/to/Snowflake_AI_Demo_Generic_Telco
python scripts/generate_2025_data.py
```

## Unstructured Documents

2025 includes 8 historical documents:
- Annual Report
- Q1-Q4 Results
- 5G Rollout Progress
- NPS Annual Review
- Board Presentation Q4

These provide rich context for the AI agent to answer questions about historical performance.

## Notes

- This data is **optional** - the main demo works without it
- Loading provides historical context for YoY comparisons
- All semantic views work automatically after loading (no changes needed)
- Data shows realistic YoY improvement patterns (2025 < 2026)
