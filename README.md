# SnowTelco

**Snowflake Intelligence Demo for Telecommunications**

*Transform how executives access business insights through natural language conversations with enterprise data.*

![Snowflake Intelligence](https://img.shields.io/badge/Snowflake-Intelligence-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white) ![Telecommunications](https://img.shields.io/badge/Industry-Telecommunications-orange?style=for-the-badge) ![Version 3.4](https://img.shields.io/badge/Version-3.4-green?style=for-the-badge)

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [About SnowTelco](#about-snowtelco)
- [Demo Scripts](#demo-scripts)
- [Sample Conversations](#sample-conversations)
- [Installation](#installation)
- [Architecture](#architecture)
- [Data Coverage](#data-coverage)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Repository Structure](#repository-structure)

---

## Overview

**SnowTelco** is a comprehensive demonstration of Snowflake Intelligence capabilities using a realistic telecommunications company scenario. It enables business executives to have natural language conversations with enterprise data—no SQL knowledge required.

### The Problem We Solve

> Business leaders face a critical gap: **data exists everywhere, but insights remain locked behind technical barriers.** Executives must wait for reports, depend on analysts, or learn complex tools to answer simple questions about their own business.

### The Solution

With Snowflake Intelligence, executives can simply ask:

> *"What's our churn rate this quarter, and which customer segments are most at risk?"*

Within seconds, the AI agent queries millions of records, analyzes patterns, and delivers actionable insights.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **28 Demo Scripts** | Ready-to-run executive conversations for every C-suite and VP persona |
| **38 Semantic Views** | Comprehensive coverage across all business domains |
| **16M+ Records** | Production-scale data demonstrating enterprise performance |
| **66 Policy Documents** | AI-grounded responses for procedures and compliance |
| **182 Test Questions** | Documented questions with expected insights |
| **TM Forum ODA Aligned** | Industry-standard telecommunications data model |
| **Multi-Year Data** | Historical data (2020-2026) for trend analysis |

---

## About SnowTelco

**SnowTelco Group PLC** is a fictional UK telecommunications provider serving enterprise and consumer markets.

### Business Units

| Division | Products & Services | Scale |
|----------|---------------------|-------|
| **B2B Enterprise** | UCaaS, CCaaS, SIP Trunks, SD-WAN, Managed Security | 500+ enterprise accounts |
| **Consumer Mobile** | Pay Monthly, SIM Only, 4G/5G plans | 30,000+ subscribers |
| **Wholesale** | MVNO partnerships, interconnect services | 12 MVNO partners |
| **Retail** | 170 stores across UK | 200K+ monthly transactions |
| **Partner Channel** | Reseller program, dealer network | 350+ partners |

### Key Metrics

| Metric | Value |
|--------|-------|
| Annual Revenue | £850M+ |
| Customer NPS | +45 |
| 5G Coverage | 85% UK population |
| Network Availability | 99.9% |
| Employee Count | 2,000+ |

---

## Demo Scripts

### 28 Ready-to-Run Executive Conversations

Each script provides a **10-minute guided demo** with talking points, sample questions, expected insights, and follow-up exploration.

#### Flagship Demo (Start Here)

| Script | Persona | Key Focus Areas |
|--------|---------|-----------------|
| `00_WOW_Executive_Showcase.md` | CEO / Board / Executive Sponsor | Cross-domain analysis, conversational flow, data + documents, action planning |

> **Recommended for maximum impact.** This script showcases the full power of Snowflake Intelligence through a storytelling flow spanning multiple business domains.

#### C-Suite Executives (10 Scripts)

| Script | Persona | Key Focus Areas |
|--------|---------|-----------------|
| `01_CEO_Strategic.md` | Chief Executive Officer | Business performance, market position, strategic priorities |
| `02_CFO_Finance.md` | Chief Financial Officer | Revenue, ARPU, billing, cost management |
| `03_CMO_Marketing.md` | Chief Marketing Officer | Campaigns, acquisition, NPS, brand sentiment |
| `04_CTO_Technology.md` | Chief Technology Officer | Network performance, 5G rollout, IT operations |
| `05_COO_Operations.md` | Chief Operating Officer | Operational efficiency, SLAs, MTTR |
| `06_CCO_Commercial.md` | Chief Commercial Officer | Sales pipeline, partner performance, revenue |
| `07_CXO_Customer_Experience.md` | Chief Experience Officer | Customer journey, sentiment, experience metrics |
| `08_CNO_Network_QoE.md` | Chief Network Officer | Network QoE, performance, coverage quality |
| `09_CDO_Data_Science.md` | Chief Data Officer | Propensity scores, churn prediction, AI/ML strategy |
| `10_CSO_Sustainability.md` | Chief Sustainability Officer | ESG metrics, carbon footprint, sustainability |

#### VP & Department Heads (17 Scripts)

| Script | Persona | Key Focus Areas |
|--------|---------|-----------------|
| `11_VP_Customer_Service.md` | VP Customer Service | Contact center, CSAT, ticket resolution |
| `12_VP_Network_Operations.md` | VP Network Operations | Alarms, availability, capacity, MTTR |
| `13_Head_of_Partners.md` | Head of Partners | Channel performance, recruitment, commissions |
| `14_VP_Billing_Revenue.md` | VP Billing & Revenue | Invoicing, payments, disputes |
| `15_VP_IT_Digital.md` | VP IT & Digital | IT incidents, application health, SLAs |
| `16_VP_Field_Operations.md` | VP Field Operations | First-time fix, workforce, scheduling |
| `17_VP_Strategy.md` | VP Strategy | Market intelligence, competitive analysis |
| `18_VP_Communications.md` | VP Communications | Social media, sentiment, crisis response |
| `19_Regulatory_Compliance.md` | Regulatory & Compliance | SLAs, complaints, Ofcom metrics |
| `20_VP_Security.md` | VP Security | Fraud detection, loss prevention |
| `21_VP_Enterprise_Sales.md` | VP Enterprise Sales | B2B contracts, renewals, pipeline |
| `22_VP_Wholesale.md` | VP Wholesale | MVNO partners, wholesale revenue, overdue settlements |
| `23_VP_Retail.md` | VP Retail | Store performance, footfall, conversion |
| `24_CHRO_People.md` | Chief HR Officer | Workforce engagement, eNPS, talent strategy |
| `25_VP_Legal.md` | VP Legal / General Counsel | Contracts, disputes, regulatory compliance, risk |
| `26_VP_Product.md` | VP Product Management | Plan portfolio, pricing, 5G adoption, features |
| `27_VP_Procurement.md` | VP Procurement | Vendor spend, suppliers, contracts, cost optimization |

---

## Sample Conversations

### Example 1: CEO Strategic Review

**Executive:** *"Give me an executive summary of SnowTelco's performance."*

**Agent:** Based on your data, here's the executive summary:

- **Subscribers:** 30,000+ active mobile customers
- **Revenue Mix:** 70% Consumer, 26% SMB, 4% Enterprise  
- **NPS Score:** +45 (Premium segment: +62, Budget: +28)
- **Churn Rate:** 1.5% monthly (down from 1.8% last quarter)

Your strongest performance is in the **South East region** with 23% of subscribers and highest ARPU at £42.50.

---

### Example 2: CFO Revenue Analysis

**Executive:** *"What's our ARPU by customer type?"*

**Agent:** Here's your ARPU breakdown:

| Customer Type | ARPU | % of Base |
|--------------|------|-----------|
| Enterprise | £485 | 4% |
| SMB | £125 | 26% |
| Consumer | £38 | 70% |

Enterprise ARPU is trending up 8% YoY driven by UCaaS bundle adoption.

---

### Example 3: CTO Network Review

**Executive:** *"How is our network performing?"*

**Agent:** Network performance summary:

- **Availability:** 99.7% average across all cities
- **Latency:** 25ms average (target: <30ms) ✓
- **Throughput:** 4.2 Gbps average

**Top Performing Cities:** Edinburgh (99.9%), Bristol (99.8%)  
**Needs Attention:** Manchester (98.9%) - 3 elements above 80% utilization

---

## Installation

### Prerequisites

| Requirement | Details |
|-------------|---------|
| **Snowflake Edition** | Enterprise or Business Critical |
| **Role** | ACCOUNTADMIN (for initial setup) |
| **Snowflake Intelligence** | Must be enabled for your account |
| **Cortex** | Must be available in your region |
| **Region** | AWS or Azure with Cortex LLM support |

### Quick Start (15-20 minutes)

Execute the SQL scripts in the `sql_scripts/` folder in numerical order.

---

#### Core Setup (Required)

These scripts create the complete demo environment. **Execute in numerical order:**

| Step | Script | Time | Purpose |
|------|--------|------|---------|
| 1 | `01_infrastructure.sql` | ~1 min | Database, roles, network access |
| 2 | `02_download_data.sql` | ~5-10 min | Download CSV files from GitHub |
| 3 | `03_create_tables.sql` | ~30 sec | Create 100+ tables (includes computed column definitions) |
| 4 | `04_load_data.sql` | ~3-5 min | Load all data |
| 5 | `05_semantic_views.sql` | ~1 min | Core semantic views (20) |
| 6 | `06_enhanced_semantic_views.sql` | ~1 min | Enhanced views (15) |
| 7 | `07_cortex_search.sql` | ~5 min | Document search services |
| 8 | `08_create_agent.sql` | ~30 sec | Create Intelligence agent |

**After completing steps 1-8, your demo is ready to use!**

---

#### Recommended - Data Enhancements

For full functionality of all semantic views, run the data enhancement script:

| Step | Script | Time | Purpose |
|------|--------|------|---------|
| 9 | `15_data_enhancements.sql` | ~1 min | Populates computed columns (MTTR, alarm duration, overdue flags) |
| 10 | `90_semantic_views_additional.sql` | ~30 sec | Additional views (Porting, Plans, Legal) |

> **Note:** The semantic views in steps 5-6 will create successfully without step 9, but certain computed metrics (like `mttr_minutes`, `alarm_duration_minutes`, `is_overdue`, `days_overdue`) will be NULL until `15_data_enhancements.sql` is executed. Run step 9 for complete demo functionality.

---

#### Optional - Historical Data

Load additional years for year-over-year trend analysis:

| Script | Purpose | Records Added |
|--------|---------|---------------|
| `10_load_2025_data.sql` | Load 2025 historical data | +360K records |
| `11_validate_2025_data.sql` | Validate 2025 data | Verification only |
| `13_load_2024_data.sql` | Load 2024 historical data | +360K records |
| `14_validate_2024_data.sql` | Validate 2024 data | Verification only |

> **Note:** Historical data enables queries like "Compare revenue trends across 2024, 2025, and 2026" but is not required for basic demos.

---

#### Optional - Validation & Utilities

| Script | Purpose |
|--------|---------|
| `09_validate_data.sql` | Validate base data load (row counts) |
| `12_create_demo_user.sql` | Create a demo user for presentations |
| `91_test_semantic_views.sql` | Test all semantic views |

---

#### Important: Script Dependencies

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

**Affected Semantic Views:**
- `NETWORK_ALARM_SEMANTIC_VIEW` - `mttr_minutes`, `alarm_duration_minutes`
- `WHOLESALE_MVNO_SEMANTIC_VIEW` - `is_overdue`, `days_overdue`

### Post-Installation

1. Navigate to **AI & ML → Snowflake Intelligence**
2. Open **SnowTelco_Executive_Agent**
3. Start asking questions!

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SNOWFLAKE INTELLIGENCE                           │
│                  SnowTelco Executive Agent                          │
│                     (Natural Language Interface)                    │
└─────────────────────────────────────────────────────────────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          ▼                       ▼                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  CORTEX ANALYST │     │  CORTEX SEARCH  │     │  UTILITY TOOLS  │
│                 │     │                 │     │                 │
│  38 Semantic    │     │  6 Document     │     │  Email, Web     │
│  Views          │     │  Search Services│     │  Scraping, URLs │
└─────────────────┘     └─────────────────┘     └─────────────────┘
          │                       │
          ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│   STRUCTURED    │     │  UNSTRUCTURED   │
│   DATA          │     │  DATA           │
│                 │     │                 │
│  100+ Tables    │     │  66 Documents   │
│  16M+ Records   │     │  Policies &     │
│  ~1.5 GB        │     │  Reports        │
└─────────────────┘     └─────────────────┘
```

### Semantic Views (38 Total)

#### Core Business Views (20)

| Category | Semantic Views |
|----------|----------------|
| **Finance** | FINANCE, BILLING, PAYMENT, REVENUE_ASSURANCE |
| **Sales** | SALES, SALES_PIPELINE, ORDER |
| **Operations** | NETWORK_OPS, SUPPORT, IT_OPS, SLA, NETWORK_ALARM |
| **Customer** | MOBILE, PORTING, ACTIVATION, PARTNER |
| **Other** | MARKETING, HR, ASSET, DISPUTE |

#### Enhanced Analytics Views (18)

| Category | Semantic Views |
|----------|----------------|
| **Customer Analytics** | CUSTOMER_EXPERIENCE, PROPENSITY, PLAN |
| **Network Analytics** | NETWORK_QOE, RAN |
| **Operations Analytics** | FIELD_OPERATIONS, WORKFORCE, SUPPORT_TICKET |
| **Business Analytics** | MARKET_INTELLIGENCE, SOCIAL_SENTIMENT, FRAUD_DETECTION |
| **Segment Analytics** | B2B_CONTRACT, WHOLESALE_MVNO, RETAIL, SUSTAINABILITY |
| **Compliance & Legal** | COMPLAINT, LEGAL_MATTER |

---

## Data Coverage

### Structured Data (16M+ Records)

| Domain | Tables | Sample Data |
|--------|--------|-------------|
| **Customers** | mobile_subscriber_dim, customer_dim | 30K subscribers, segments, lifecycle |
| **Revenue** | invoice_fact, payment_fact, billing_fact | Invoices, payments, ARPU |
| **Network** | network_element_dim, network_performance_fact | 475 sites, 1,720 cells, KPIs |
| **Operations** | support_ticket_fact, contact_center_call_fact | 1.2M+ tickets, calls, SLAs |
| **Sales** | sf_opportunities, sales_fact | Pipeline, B2B contracts |
| **Marketing** | marketing_campaign_fact, social_media_mentions | Campaigns, NPS, sentiment |
| **HR** | employee_dim, workforce_planning | 2K+ employees, engagement |
| **ESG** | sustainability_metrics | Energy, carbon, e-waste |

### Unstructured Documents (66 Files)

| Category | Documents |
|----------|-----------|
| **Network** | Coverage maps, outage procedures, capacity planning, field operations handbook |
| **Customer Service** | Escalation procedures, complaint handling, SLA policies |
| **Products** | Tariff guides, bundle configurations, device policies |
| **Compliance** | Ofcom requirements, data protection, GDPR framework |
| **Strategy** | Digital transformation roadmap, AI/ML strategy, operational excellence |
| **HR** | Talent strategy, employee engagement reports |
| **Corporate** | Annual reports, investor presentations, vendor contracts |

### Data Characteristics

| Attribute | Value |
|-----------|-------|
| **Primary Date Range** | January 2025 – February 2026 |
| **Historical Data** | Customer tenure from 2020 |
| **Currency** | GBP (£) |
| **Geography** | UK regions and cities |
| **Industry Standard** | TM Forum ODA aligned |

---

## Verification

After installation, verify everything is working:

```sql
-- Check tables created
SELECT COUNT(*) AS table_count 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'SNOWTELCO_SCHEMA';
-- Expected: ~100

-- Check semantic views
SHOW SEMANTIC VIEWS IN SnowTelco.SnowTelco_SCHEMA;
-- Expected: 38 views

-- Check Cortex search services
SHOW CORTEX SEARCH SERVICES IN SnowTelco.SnowTelco_SCHEMA;
-- Expected: 6 services

-- Check agent exists
SHOW AGENTS;
-- Expected: SnowTelco_Executive_Agent

-- Sample data verification
SELECT COUNT(*) FROM mobile_subscriber_dim;  -- ~30,000
SELECT COUNT(*) FROM invoice_fact;           -- ~400,000
SELECT COUNT(*) FROM support_ticket_fact;    -- ~200,000

-- Verify computed columns (after running 15_data_enhancements.sql)
SELECT COUNT(*) FROM network_alarm_fact WHERE mttr_minutes IS NOT NULL;
-- Expected: >0 (if 15_data_enhancements.sql was executed)

SELECT COUNT(*) FROM mvno_settlement_fact WHERE is_overdue IS NOT NULL;
-- Expected: >0 (if 15_data_enhancements.sql was executed)
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **External access failed** | Ensure external access integration is enabled in your account settings |
| **Cortex not available** | Verify your region supports Cortex LLM functions |
| **Agent creation failed** | Confirm Enterprise edition with Snowflake Intelligence enabled |
| **Download timeout** | Increase `STATEMENT_TIMEOUT_IN_SECONDS` to 3600 |
| **Permission denied** | Run scripts with ACCOUNTADMIN role |
| **Semantic view errors** | Check that all tables are created before running semantic views |
| **No data returned** | Verify data was loaded by checking table counts |
| **MTTR/Duration metrics NULL** | Run `15_data_enhancements.sql` to populate computed columns |
| **Overdue settlement metrics NULL** | Run `15_data_enhancements.sql` to calculate overdue flags |

---

## Repository Structure

```
Snowflake_AI_Demo_Generic_Telco/
│
├── sql_scripts/                    # Installation scripts (run in order)
│   ├── 01_infrastructure.sql       # Database, roles, network
│   ├── 02_download_data.sql        # Download CSV files
│   ├── 03_create_tables.sql        # Create all tables (incl. computed columns)
│   ├── 04_load_data.sql            # Load data into tables
│   ├── 05_semantic_views.sql       # Core semantic views (20)
│   ├── 06_enhanced_semantic_views.sql # Enhanced analytics views (15)
│   ├── 07_cortex_search.sql        # Document search services
│   ├── 08_create_agent.sql         # Intelligence agent
│   ├── 15_data_enhancements.sql    # ⚠️ RECOMMENDED: Populates computed columns
│   ├── 90_semantic_views_additional.sql # Additional views (Porting, Plans, Legal)
│   └── ...                         # Optional/utility scripts
│
├── demo_data/                      # CSV data files (~1.5 GB)
│   ├── mobile_subscriber_dim.csv   # Subscriber dimension
│   ├── legal_matter_fact.csv       # Legal matters & disputes
│   └── ...                         # 100+ CSV files
│
├── demo_scripts/                   # Demo guides (28 scripts)
│   ├── 00_WOW_Executive_Showcase.md # Flagship demo
│   ├── 01_CEO_Strategic.md
│   ├── 25_VP_Legal.md              # New: Legal persona
│   ├── 26_VP_Product.md            # New: Product persona
│   ├── 27_VP_Procurement.md        # New: Procurement persona
│   ├── ALL_TEST_QUESTIONS.md       # 182 test questions
│   ├── TESTING_PROMPT.md           # Testing guidelines
│   └── ...
│
├── unstructured_docs/              # Policy documents (66 files)
│   ├── strategy/                   # Strategy docs (Digital, AI/ML)
│   ├── network/                    # Network docs (Field Ops)
│   ├── finance/                    # Finance & vendor contracts
│   ├── hr/                         # HR & talent strategy
│   └── ...
│
├── reports/                        # Financial reports
│   ├── SnowTelco_Annual_Report_FY2025.md
│   └── ...
│
├── scripts/                        # Python data generators
│   ├── generate_2025_data.py
│   └── regenerate_data_feb_2026.py
│
└── README.md                       # This file
```

---

## Business Value

| Capability | Traditional Approach | With Snowflake Intelligence |
|------------|---------------------|----------------------------|
| **Ad-hoc Analysis** | Days (analyst queue) | Seconds |
| **Cross-functional Insights** | Multiple reports needed | Single conversation |
| **Data Exploration** | SQL knowledge required | Natural language |
| **Document Search** | Manual search across systems | AI-powered retrieval |
| **Trend Identification** | Scheduled reports | Real-time queries |
| **Executive Accessibility** | Training required | Intuitive interface |

---

## Support & Resources

| Resource | Link |
|----------|------|
| **Repository** | [github.com/pmjose/Snowflake_AI_Demo_Generic_Telco](https://github.com/pmjose/Snowflake_AI_Demo_Generic_Telco) |
| **Snowflake Intelligence Docs** | [docs.snowflake.com](https://docs.snowflake.com) |
| **TM Forum ODA** | [tmforum.org](https://www.tmforum.org/oda/) |

---

**Version 3.4** | Last Updated: January 2026

*Built for Snowflake Intelligence demonstrations — 28 personas | 38 semantic views | 182 test questions | 66 documents*
