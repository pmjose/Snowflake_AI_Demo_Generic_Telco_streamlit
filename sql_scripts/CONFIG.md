# SnowTelco SQL Scripts Configuration

This folder contains all SQL scripts to deploy the SnowTelco demo environment.

## Object Naming

| Object | Name |
|--------|------|
| **Role** | `SnowTelco_V2_Demo` |
| **Warehouse** | `SnowTelco_V2_Demo_WH` |
| **Database** | `SnowTelco_V2` |
| **Schema** | `SnowTelco_V2_SCHEMA` |
| **Agent** | `SnowTelco_V2_Executive_Agent` |
| **Agent Display Name** | "SnowTelco Executive Agent V2" |

## Installation

Run the scripts **in numerical order**:

### Core Setup (Required)

```
01_infrastructure.sql    (~1 min)  - Creates database, role, warehouse
02_download_data.sql     (~5-10 min) - Downloads CSV data
03_create_tables.sql     (~30 sec) - Creates tables (incl. computed column definitions)
04_load_data.sql         (~3-5 min) - Loads data
05_semantic_views.sql    (~1 min)  - Creates semantic views (20)
06_enhanced_semantic_views.sql (~1 min) - Enhanced views (15)
07_cortex_search.sql     (~5 min)  - Document search
08_create_agent.sql      (~30 sec) - Creates agent
```

### Recommended Enhancements

```
15_data_enhancements.sql (~1 min)  - Populates computed columns (MTTR, overdue flags)
90_semantic_views_additional.sql (~30 sec) - Additional views (Porting, Plans, Legal)
```

> **Important:** The semantic views (05, 06, 90) will create successfully after step 4, but certain computed metrics (`mttr_minutes`, `alarm_duration_minutes`, `is_overdue`, `days_overdue`) will be NULL until `15_data_enhancements.sql` is executed.

### Optional Scripts

| Script | Purpose |
|--------|---------|
| `09_validate_data.sql` | Validate data load |
| `10_load_2025_data.sql` | Load 2025 historical data |
| `11_validate_2025_data.sql` | Validate 2025 data |
| `12_create_demo_user.sql` | Create demo user for presentations |
| `13_load_2024_data.sql` | Load 2024 historical data |
| `14_validate_2024_data.sql` | Validate 2024 data |
| `91_test_semantic_views.sql` | Test all semantic views |

## Script Dependencies

```
┌─────────────────────────────────────────────────────────────────────┐
│                    EXECUTION ORDER                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  01 → 02 → 03 → 04 → 05 → 06 → 07 → 08  (Core Setup - Required)    │
│                 │                                                   │
│                 └──── 15 ──── 90  (Recommended Enhancements)        │
│                                                                     │
│  The semantic views (05, 06, 90) reference columns that are:        │
│  • Defined in 03_create_tables.sql (columns exist in schema)        │
│  • Populated by 15_data_enhancements.sql (values calculated)        │
│                                                                     │
│  Views will CREATE successfully after step 4.                       │
│  Computed metrics require step 15 for non-NULL values.              │
└─────────────────────────────────────────────────────────────────────┘
```

## Accessing the Agent

After installation, find the agent at:

**Snowsight:** AI & ML > Snowflake Intelligence > **SnowTelco Executive Agent V2**

## Customization

To create a custom-named deployment, find-replace these patterns in order:

```
SnowTelco_V2_Demo_WH → YourName_Demo_WH
SnowTelco_V2_Demo → YourName_Demo
SnowTelco_V2_SCHEMA → YourName_SCHEMA
SnowTelco_V2_Executive_Agent → YourName_Executive_Agent
SnowTelco_V2 → YourName
```
