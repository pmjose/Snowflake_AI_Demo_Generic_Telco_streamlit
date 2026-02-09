# SnowTelco Demo Scripts

Persona-based demo scripts for the SnowTelco AI Intelligence Platform. Each script takes approximately **10 minutes** and is designed for a specific UK telecom executive role.

Scripts are organized by **org chart hierarchy**: C-Suite executives first (01-10), then VP/Head level (11-27).

---

## Quick Start

1. Ensure the SnowTelco agent is deployed and working
2. Select the script matching your audience (see below)
3. Verify sample data is loaded
4. Follow the script: **Opening (1 min)** → **5 Questions (~7 min)** → **Closing (1 min)**

---

## Available Scripts (28 Total)

### Flagship Demo (00)

| # | Script | Role | Focus |
|---|--------|------|-------|
| 00 | WOW_Executive_Showcase | CEO / Board / Executive Sponsor | Cross-domain analysis, conversational flow, data + documents, action planning |

> **Start here for maximum impact.** Script 00 showcases the full power of Snowflake Intelligence through a storytelling flow that spans multiple business domains.

### C-Suite Executives (01-10)

| # | Script | Role | Focus |
|---|--------|------|-------|
| 01 | CEO_Strategic | Chief Executive Officer | Business performance, market position, strategic KPIs |
| 02 | CFO_Finance | Chief Financial Officer | Revenue, ARPU, billing, costs, compliance |
| 03 | CMO_Marketing | Chief Marketing Officer | Campaigns, customer acquisition, NPS, churn |
| 04 | CTO_Technology | Chief Technology Officer | Technology strategy, 5G, IT systems |
| 05 | COO_Operations | Chief Operating Officer | Operational efficiency, supply chain |
| 06 | CCO_Commercial | Chief Commercial Officer | Sales, revenue, partners, pricing |
| 07 | CXO_Customer_Experience | Chief Experience Officer | Journey analytics, sentiment, CX transformation |
| 08 | CNO_Network_QoE | Chief Networks Officer | QoE, RAN performance, 5G experience |
| 09 | CDO_Data_Science | Chief Data Officer | Propensity scores, churn prediction, CLV, AI/ML |
| 10 | CSO_Sustainability | Chief Sustainability Officer | ESG, carbon, energy, net zero progress |

### VP & Head Level (11-27)

| # | Script | Role | Focus |
|---|--------|------|-------|
| 11 | VP_Customer_Service | VP Customer Service | Contact centre metrics, tickets, CSAT scores |
| 12 | VP_Network_Operations | VP Network Operations | Alarms, network availability, capacity planning |
| 13 | Head_of_Partners | Head of Partners & Channels | Channel performance, commissions, partner health |
| 14 | VP_Billing_Revenue | VP Billing & Revenue | Collections, payments, revenue assurance |
| 15 | VP_IT_Digital | VP IT & Digital | IT health, incident management, digital channels |
| 16 | VP_Field_Operations | VP Field Operations | First-time fix, SLA, workforce, technicians |
| 17 | VP_Strategy | VP Strategy | Market share, competitive intelligence, pricing |
| 18 | VP_Communications | VP Communications | Social sentiment, brand reputation, PR |
| 19 | Regulatory_Compliance | Head of Regulatory | Ofcom requirements, SLA compliance, complaints |
| 20 | VP_Security | VP Security & Fraud | Fraud detection, loss prevention, ML models |
| 21 | VP_Enterprise_Sales | VP Enterprise Sales | B2B renewals, contract value, competitive threats |
| 22 | VP_Wholesale | VP Wholesale & MVNO | MVNO partners, wholesale revenue, settlements |
| 23 | VP_Retail | VP Retail Operations | Store sales, footfall, conversion, performance |
| 24 | CHRO_People | Chief People Officer | Workforce analytics, engagement, eNPS, retention |
| 25 | VP_Legal | VP Legal / General Counsel | Contracts, disputes, regulatory compliance, risk |
| 26 | VP_Product | VP Product Management | Plan portfolio, pricing, 5G adoption, features |
| 27 | VP_Procurement | VP Procurement | Vendor spend, suppliers, contracts, cost optimization |

---

## Selecting the Right Script

| Audience Type | Recommended Script |
|---------------|-------------------|
| **Maximum Impact / Executive Sponsor** | **00 - WOW Executive Showcase** |
| C-Suite / Board | 01 - CEO Strategic |
| Finance Team | 02 - CFO Finance |
| Marketing Team | 03 - CMO Marketing |
| Technology Leaders | 04 - CTO Technology |
| Operations Leaders | 05 - COO Operations |
| Sales Leaders | 06 - CCO Commercial |
| Customer Experience Teams | 07 - CXO Customer Experience |
| Network Teams | 08 - CNO Network QoE or 12 - VP Network Operations |
| Data Science / Analytics | 09 - CDO Data Science |
| Sustainability / ESG | 10 - CSO Sustainability |
| Contact Centre Leaders | 11 - VP Customer Service |
| Channel / Partner Teams | 13 - Head of Partners |
| Revenue / Billing Teams | 14 - VP Billing Revenue |
| IT Leadership | 15 - VP IT Digital |
| Field Operations Teams | 16 - VP Field Operations |
| Strategy / Planning | 17 - VP Strategy |
| Communications / PR | 18 - VP Communications |
| Regulatory / Compliance | 19 - Regulatory Compliance |
| Legal / General Counsel | 25 - VP Legal |
| Product Management | 26 - VP Product |
| Procurement / Sourcing | 27 - VP Procurement |

---

## Combining Scripts for Longer Demos

For 30+ minute sessions, combine related scripts:

**Executive Overview (30 min)**
- CEO Strategic + CFO Finance + CMO Marketing

**Technology & Network (30 min)**
- CTO Technology + CNO Network QoE + VP Network Operations

**Customer & Experience (30 min)**
- CXO Customer Experience + VP Customer Service + CDO Data Science

**Commercial Review (30 min)**
- CCO Commercial + Head of Partners + VP Billing Revenue

**Operations Deep Dive (30 min)**
- COO Operations + VP Field Operations + VP IT Digital

**Strategy & Intelligence (30 min)**
- VP Strategy + VP Communications + CSO Sustainability

---

## Data Sources by Domain

### Subscribers & Mobile
- `mobile_subscriber_dim` - Customer profiles
- `mobile_usage_fact` - Usage records
- `mobile_churn_fact` - Churn events
- `mobile_plan_dim` - Plan details

### Network & RAN
- `network_element_dim` - Core network equipment
- `network_alarm_fact` - Alarms and incidents
- `network_performance_fact` - KPIs and metrics
- `ran_site_dim` - Cell tower sites
- `ran_cell_dim` - Cells/sectors
- `ran_equipment_dim` - RAN equipment (gNodeB, eNodeB, etc.)
- `ran_performance_fact` - RAN KPIs
- `network_qoe_fact` - Quality of experience measurements

### Customer Experience & AI
- `customer_journey_fact` - Journey touchpoints
- `customer_propensity_scores` - ML churn/upsell scores
- `social_mention_fact` - Social media mentions

### Customer Service
- `support_ticket_fact` - Support tickets
- `contact_center_call_fact` - Call records
- `complaint_fact` - Formal complaints

### Field Operations
- `field_visit_fact` - Technician visits
- `technician_dim` - Field workforce

### Billing & Finance
- `invoice_fact` - Invoice records
- `payment_fact` - Payment transactions
- `finance_transactions` - Financial ledger

### Partners & Market
- `partner_dim` - Partner profiles
- `partner_performance_fact` - Partner metrics
- `competitor_dim` - Competitor info
- `competitor_pricing_dim` - Competitor pricing
- `market_share_fact` - Market share data

### SLA & Compliance
- `sla_dim` - SLA definitions
- `sla_measurement_fact` - SLA measurements

### ESG & Sustainability
- `energy_consumption_fact` - Site energy consumption
- `sustainability_metrics` - Company ESG metrics

---

## Demo Best Practices

1. **Know your audience** - Match the script to their role and interests
2. **Adapt the language** - Use terminology familiar to the persona
3. **Focus on insights** - Explain what the data means, not just the numbers
4. **Connect to decisions** - Show how insights drive business actions
5. **Be flexible** - Explore follow-up questions based on audience interest
6. **End with value** - Summarize the business impact delivered

---

## Known Limitations

When running demos, be aware of these current limitations:

**Data & Query Limitations:**
- Multi-metric charts with different scales may not render all metrics correctly
- Some complex queries may require multiple tool calls to gather complete data
- Historical data (2024-2025) must be loaded separately using the additional data scripts

**Semantic View Limitations:**
- NPS scores use a 1-10 scale (not traditional -100 to +100 NPS)
- Date filtering should use string comparison for `usage_month` (e.g., `>= '2025-01'`)
- Derived metrics with virtual facts may have limitations in some views

**Recommended Workarounds:**
- For time-series comparisons, ask about specific months rather than "last quarter"
- For pipeline analysis, use stage names explicitly (e.g., "Prospecting", "Qualification")
- If a chart doesn't render correctly, request the data in tabular format instead

---

## Customization

Adapt these scripts for your specific demo:

- Add customer-specific metrics or KPIs
- Adjust question wording for your audience
- Include follow-up questions based on responses
- Modify opening/closing to match your context

---

**Last Updated:** February 2026  
**Version:** 3.6 (Updated VP dashboards with AI-first Snowflake Intelligence tabs)
