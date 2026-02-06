# SnowTelco

**Snowflake Intelligence Demo for Telecommunications**

*Transform how executives access business insights through natural language conversations with enterprise data.*

![Snowflake Intelligence](https://img.shields.io/badge/Snowflake-Intelligence-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white) ![Telecommunications](https://img.shields.io/badge/Industry-Telecommunications-orange?style=for-the-badge) ![Version 3.5](https://img.shields.io/badge/Version-3.5-green?style=for-the-badge) ![Streamlit](https://img.shields.io/badge/Streamlit-Dashboard-FF4B4B?style=for-the-badge&logo=streamlit&logoColor=white)

---

## Table of Contents

- [Overview](#overview)
- [Snowflake Intelligence](#snowflake-intelligence)
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

## Snowflake Intelligence

**Snowflake Intelligence** is the core technology powering this demo. It's Snowflake's enterprise AI platform that enables natural language conversations with your data.

### What is Snowflake Intelligence?

Snowflake Intelligence combines three powerful AI capabilities into a unified conversational interface:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SNOWFLAKE INTELLIGENCE                               │
│                    "Ask questions, get answers"                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐          │
│   │ CORTEX ANALYST  │   │ CORTEX SEARCH   │   │ CORTEX AGENT    │          │
│   │                 │   │                 │   │                 │          │
│   │ Text-to-SQL     │   │ Document Search │   │ Orchestration   │          │
│   │ Semantic Views  │   │ RAG Pipeline    │   │ Multi-Tool      │          │
│   │ Structured Data │   │ Unstructured    │   │ Reasoning       │          │
│   └─────────────────┘   └─────────────────┘   └─────────────────┘          │
│           │                     │                     │                     │
│           └─────────────────────┼─────────────────────┘                     │
│                                 ▼                                           │
│                    ┌─────────────────────────┐                              │
│                    │   UNIFIED EXPERIENCE    │                              │
│                    │   Natural Language UI   │                              │
│                    └─────────────────────────┘                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Core Components

| Component | Purpose | In This Demo |
|-----------|---------|--------------|
| **Cortex Analyst** | Converts natural language to SQL using semantic models | 38 semantic views covering all business domains |
| **Cortex Search** | Retrieves relevant documents for context-aware answers | 6 search services with 66 policy documents |
| **Cortex Agent** | Orchestrates tools, maintains conversation context | SnowTelco Executive Agent with multi-domain reasoning |

### How It Works

1. **User asks a question** → *"What's our churn rate by customer segment?"*

2. **Agent determines intent** → Identifies this as a structured data query

3. **Cortex Analyst generates SQL** → Uses MOBILE semantic view to write optimized query

4. **Results returned** → Agent formats response with insights and recommendations

5. **Follow-up questions** → Agent maintains context for conversational flow

### Accessing Snowflake Intelligence

After running the installation scripts, access the demo:

1. **Navigate to Snowflake Intelligence**
   - Log into Snowsight
   - Go to **AI & ML** → **Snowflake Intelligence**
   - Or direct URL: `https://app.snowflake.com/<account>/intelligence`

2. **Open the Agent**
   - Find **SnowTelco_Executive_Agent** in the list
   - Click to open the conversational interface

3. **Start Asking Questions**
   ```
   Example questions to try:
   
   📊 "Give me an executive summary of SnowTelco's performance"
   💰 "What's our revenue breakdown by customer type?"
   📉 "Which customers are at highest risk of churning?"
   🌐 "How is our network performing across different cities?"
   📋 "What does our retention policy say about discount limits?"
   ```

### Semantic Views - The Foundation

Semantic views are the "secret sauce" that enables accurate text-to-SQL. They provide:

| Feature | Benefit |
|---------|---------|
| **Business Context** | Column descriptions, synonyms, and relationships |
| **Guardrails** | Prevents incorrect joins and aggregations |
| **Optimization** | Pre-defined metrics and calculations |
| **Consistency** | Same definitions across all users |

Example semantic view structure:
```yaml
MOBILE_SEMANTIC_VIEW:
  - SUBSCRIBER_KEY (Primary Key)
  - CUSTOMER_TYPE: "Consumer, SMB, or Enterprise"
  - CUSTOMER_SEGMENT: "Budget, Standard, Premium, VIP"
  - MONTHLY_REVENUE: "Sum of usage charges"
  - CHURN_RISK: "Propensity score 0-100"
```

### Document Search - Grounded Answers

Cortex Search enables the agent to answer questions about policies, procedures, and reports:

| Search Service | Documents | Use Case |
|----------------|-----------|----------|
| `POLICY_SEARCH` | Retention policies, SLA definitions | "What discount can we offer?" |
| `NETWORK_SEARCH` | Coverage maps, capacity plans | "What's our 5G rollout status?" |
| `COMPLIANCE_SEARCH` | Ofcom requirements, GDPR | "What are our regulatory obligations?" |
| `HR_SEARCH` | Talent strategy, engagement | "What's our hiring plan?" |
| `STRATEGY_SEARCH` | Digital roadmap, AI strategy | "What are our 2026 priorities?" |
| `CORPORATE_SEARCH` | Annual reports, contracts | "What are our vendor terms?" |

### Multi-Turn Conversations

Snowflake Intelligence maintains context across questions:

```
User: "What's our churn rate?"
Agent: "Your overall churn rate is 1.5% monthly..."

User: "Break that down by segment"           ← Agent remembers "churn rate"
Agent: "Here's churn by segment: VIP 0.8%, Premium 1.2%..."

User: "Which customers in Premium are at risk?"  ← Agent remembers "Premium segment"
Agent: "I found 245 Premium customers with churn risk >70%..."

User: "What retention offers can we make?"   ← Agent searches policy documents
Agent: "According to your retention policy, Premium customers 
        can receive up to 20% discount for 6 months..."
```

### Why This Matters for Executives

| Traditional Approach | With Snowflake Intelligence |
|---------------------|----------------------------|
| Request report from analyst | Ask question directly |
| Wait hours/days | Get answer in seconds |
| Static PDF report | Interactive conversation |
| Single data source | Cross-domain analysis |
| No document context | Policy-aware recommendations |

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Interactive Dashboard** | Beautiful Streamlit app with 40+ persona dashboards and live animations |
| **28 Demo Scripts** | Ready-to-run executive conversations for every C-suite and VP persona |
| **38 Semantic Views** | Comprehensive coverage across all business domains |
| **16M+ Records** | Production-scale data demonstrating enterprise performance |
| **66 Policy Documents** | AI-grounded responses for procedures and compliance |
| **182 Test Questions** | Documented questions with expected insights |
| **TM Forum ODA Aligned** | Industry-standard telecommunications data model |
| **Multi-Year Data** | Historical data (2024-2026) for trend analysis |

---

## Interactive Dashboard

This repository includes a **Streamlit-powered interactive dashboard** (`demo_dashboard_app.py`) that provides a visual companion to the Snowflake Intelligence demos.

### Dashboard Features

| Feature | Description |
|---------|-------------|
| **40+ Persona Dashboards** | Executive Summary, C-Suite (CEO, CFO, CMO, CTO, etc.), VP-Level dashboards |
| **Live Animations** | Animated charts, gauges, network maps, and data visualizations |
| **SnowTelco Website** | Simulated customer-facing website with plans and pricing |
| **Persona Hub** | Central navigation with clickable tiles for all personas |
| **Real-time Alerts Ticker** | Live scrolling alerts in the sidebar |
| **Snowflake Integration** | Click-to-ask questions that open Snowflake Intelligence |

> **Note:** This dashboard is designed exclusively for **live demonstration purposes**. It uses pre-computed sample data embedded within the application rather than querying a database connection. This architecture ensures **instant load times and zero latency** during live presentations, trade shows, and customer events—delivering a seamless, reliable demo experience without external dependencies.

### Running the Dashboard

```bash
# Install dependencies
pip install streamlit pandas altair

# Run the dashboard
streamlit run demo_dashboard_app.py
```

The dashboard will open at `http://localhost:8501`

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

> **Location:** `demo_scripts/` folder

### 28 Ready-to-Run Executive Conversations

Each script provides a **10-minute guided demo** with talking points, sample questions, expected insights, and follow-up exploration.

### Folder Contents

```
demo_scripts/
├── 00_WOW_Executive_Showcase.md    # 🌟 Flagship demo - START HERE
├── 01_CEO_Strategic.md             # C-Suite scripts (01-10)
├── 02_CFO_Finance.md
├── 03_CMO_Marketing.md
├── 04_CTO_Technology.md
├── 05_COO_Operations.md
├── 06_CCO_Commercial.md
├── 07_CXO_Customer_Experience.md
├── 08_CNO_Network_QoE.md
├── 09_CDO_Data_Science.md
├── 10_CSO_Sustainability.md
├── 11_VP_Customer_Service.md       # VP/Director scripts (11-27)
├── 12_VP_Network_Operations.md
├── 13_Head_of_Partners.md
├── 14_VP_Billing_Revenue.md
├── 15_VP_IT_Digital.md
├── 16_VP_Field_Operations.md
├── 17_VP_Strategy.md
├── 18_VP_Communications.md
├── 19_Regulatory_Compliance.md
├── 20_VP_Security.md
├── 21_VP_Enterprise_Sales.md
├── 22_VP_Wholesale.md
├── 23_VP_Retail.md
├── 24_CHRO_People.md
├── 25_VP_Legal.md
├── 26_VP_Product.md
├── 27_VP_Procurement.md
├── ALL_TEST_QUESTIONS.md           # 📋 All 182 questions for testing
├── TESTING_PROMPT.md               # 🧪 Testing procedures
└── README.md                       # Folder documentation
```

### Testing Resources

| File | Purpose |
|------|---------|
| `ALL_TEST_QUESTIONS.md` | **182 questions** extracted from all scripts - copy/paste for systematic testing |
| `TESTING_PROMPT.md` | Testing procedures, evaluation criteria, report templates |

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

### One-Click Installation (Recommended)

Run a single SQL script that automatically fetches and executes all installation scripts from GitHub:

```sql
-- Copy and paste this into a Snowflake worksheet and run as ACCOUNTADMIN
-- Total time: ~20-30 minutes

USE ROLE ACCOUNTADMIN;

-- Setup GitHub access
CREATE OR REPLACE NETWORK RULE github_install_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('raw.githubusercontent.com:443');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION github_install_integration
  ALLOWED_NETWORK_RULES = (github_install_rule)
  ENABLED = TRUE;

-- Run master installation script
EXECUTE IMMEDIATE FROM 'https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/sql_scripts/00_install_all.sql';
```

This will automatically:
1. Create infrastructure (database, roles, warehouse)
2. Download all data files from GitHub
3. Create and load 100+ tables
4. Set up 38 semantic views
5. Configure 6 Cortex Search services
6. Create the Intelligence Agent
7. Load historical data (2024-2025)
8. Apply data enhancements

---

### Manual Installation (Alternative)

If you prefer step-by-step control, execute the SQL scripts in the `sql_scripts/` folder in numerical order.

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
| **Primary Date Range** | January 2026 – February 2026 (base data) |
| **Historical Data** | 2024 and 2025 data available for YoY analysis |
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
Snowflake_AI_Demo_Generic_Telco_streamlit/
│
├── demo_dashboard_app.py           # 🆕 Interactive Streamlit dashboard (40+ personas)
│
├── sql_scripts/                    # Installation scripts (run in order)
│   ├── 00_install_all.sql          # 🚀 ONE-CLICK INSTALL (runs all scripts from GitHub)
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
│   ├── ...                         # 100+ CSV files (base 2026 data)
│   └── additional_data/            # Historical data for YoY analysis
│       ├── 2024/csv/               # 24 CSV files (2024 historical)
│       └── 2025/csv/               # 24 CSV files (2025 historical)
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
| **Repository** | [github.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit](https://github.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit) |
| **Snowflake Intelligence Docs** | [docs.snowflake.com](https://docs.snowflake.com) |
| **TM Forum ODA** | [tmforum.org](https://www.tmforum.org/oda/) |

---

**Version 3.5** | Last Updated: February 2026

*Built for Snowflake Intelligence demonstrations — 40+ dashboards | 28 personas | 38 semantic views | 182 test questions | 66 documents*
