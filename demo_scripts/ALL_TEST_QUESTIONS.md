# SnowTelco Demo Scripts - All Test Questions

This file contains all questions extracted from each demo script for systematic testing.

---

## 00_WOW_Executive_Showcase.md (10 Questions) - START HERE

> **Flagship demo script for maximum impact.** Showcases cross-domain analysis, conversational memory, data + document fusion.

### Q1: Executive Health Check
> "I'm preparing for a board meeting tomorrow. Give me a complete health check of SnowTelco - our subscriber base, revenue performance, customer satisfaction, and network quality. What are the 3 most critical things I need to know?"

**Expected:** Cross-domain summary from Mobile, Finance, Support, Network_OPS with prioritized insights

### Q2: Understanding Churn Risk
> "Tell me more about our churn situation. What's our current churn rate, which customer segments are most at risk, and how much revenue could we lose?"

**Expected:** Churn rate, high-risk segments, revenue-at-risk calculation

### Q3: At-Risk Customer Patterns
> "Show me the profile of our highest-risk customers. What do they have in common? Are there patterns we should be worried about?"

**Expected:** Cohort analysis, common attributes, pattern identification

### Q4: Policy-Aware Retention Offers
> "What retention offers can we make to these at-risk customers? Check our retention policy and tell me what discounts or incentives are available."

**Expected:** Data + Document fusion - retention offers based on customer value and policy constraints

### Q5: Competitive Pricing Analysis
> "How does our pricing compare to competitors? Are we losing customers because of price?"

**Expected:** Market intelligence, port-in/out by competitor, pricing comparison

### Q6: Network Impact on Churn
> "Is network quality contributing to our churn? Show me if there's a correlation between network problems and customer satisfaction in our worst-performing areas."

**Expected:** Correlation analysis between Network_QoE and churn, geographic breakdown

### Q7: Support Ticket Patterns
> "What about our support experience? Are churned customers calling us more before they leave? What are they complaining about?"

**Expected:** Pre-churn behavior patterns, complaint category analysis

### Q8: Prioritized Action Plan
> "Based on everything we've discussed, create a prioritized action plan for reducing churn. What should we do first, second, and third? Include specific customer segments and expected impact."

**Expected:** Synthesized recommendations with priorities and measurable outcomes

### Q9: Board Presentation Summary
> "Now create an executive summary for my board presentation. I need 5 bullet points covering: business performance, key risks, recommended actions, and expected outcomes. Make it suitable for a board audience."

**Expected:** Executive-level content generation, synthesized from entire conversation

### Q10: Supporting Data Request
> "Can you also show me a breakdown of revenue by region and customer type? I want to include this as a supporting chart."

**Expected:** Revenue breakdown suitable for visualization

---

## 01_CEO_Strategic.md (5 Questions)

### Q1: Business Health Dashboard
> "Give me an executive summary of SnowTelco's current performance - total subscribers, ARPU, and NPS split by B2C consumers versus B2B business customers."

**Expected:** Total subscribers (~30,000), ARPU by customer type, NPS scores by type

### Q2: Competitive Position
> "Show me our port-in versus port-out analysis - which competitors are we winning customers from and losing customers to?"

**Expected:** Port-in sources, port-out destinations, net porting position

### Q3: Network Quality & Customer Impact
> "What are our top network quality issues affecting customer satisfaction? Show me the correlation between network problems and NPS scores by city."

**Expected:** Network availability/latency by city, cities with lowest NPS, correlation analysis, priority investment areas

### Q4: Competitive Market Position
> "Compare our performance against our main competitors - how do we rank in terms of market share, customer satisfaction, and service quality?"

**Expected:** Market share position, NPS vs competitors, network performance benchmarks, partner satisfaction

### Q5: Strategic Priorities
> "Based on all this data, what are the 3 most critical strategic priorities I should focus on this quarter to drive growth while maintaining customer satisfaction?"

**Expected:** Data-driven strategic recommendations, growth opportunities, retention priorities, actionable initiatives

---

## 02_CFO_Finance.md (5 Questions)

### Q1: Revenue by Customer Type
> "Show me our revenue breakdown by customer type - Consumer, SMB, and Enterprise - with average bill amounts."

**Expected:** Revenue split (~70% Consumer, ~26% SMB, ~4% Enterprise), average bill by type

### Q2: ARPU Deep Dive
> "What's our ARPU by customer type and segment? Show me Consumer vs SMB vs Enterprise, and break down by value tier."

**Expected:** ARPU by customer type and segment tier

### Q3: Billing & Payment Status
> "What's our payment status distribution? Show me Paid vs Pending vs Overdue by customer type."

**Expected:** ~70% Paid, ~20% Pending, ~10% Overdue breakdown

### Q4: Cost Management
> "What are our top vendor expenses by department and what's the approval status?"

**Expected:** Vendor spend by category, approval status distribution

### Q5: Revenue at Risk
> "What revenue is at risk from churned customers? Show me lifetime value lost by customer type and segment."

**Expected:** Total lifetime value lost, churned revenue by type/segment

---

## 03_CMO_Marketing.md (5 Questions)

### Q1: Campaign Performance
> "Which marketing campaigns have delivered the best ROI? Show me spend, leads generated, and impressions by campaign."

**Expected:** Campaign spend vs leads, cost per acquisition, top campaigns

### Q2: Customer Acquisition Channels
> "Where are our customers coming from? Break down by acquisition channel for Consumer vs B2B customers."

**Expected:** Consumer channels (Online, Retail, App), B2B channels (Direct Sales, Partner)

### Q3: NPS Analysis
> "What's our NPS score by customer type and segment? Compare Consumer vs SMB vs Enterprise, and show Budget through VIP."

**Expected:** NPS by customer type and segment

### Q4: Churn Analysis
> "What are the top reasons customers are churning? Show me churn reasons by customer type and which competitors they're leaving for."

**Expected:** Top churn reasons, competitor destinations, churn rate by type

### Q5: Competitive Win/Loss
> "Show me our port-in versus port-out by competitor. Which carriers are we winning from and losing to?"

**Expected:** Port-in/out by competitor, net porting position

---

## 04_CTO_Technology.md (7 Questions)

### Q1: Network Infrastructure Performance
> "Show me our network performance metrics by city - availability, latency, and throughput. Which cities have the best and worst performance?"

**Expected:** Network availability by city (99%+), latency (~25ms), throughput (Gbps), top/bottom performing cities

### Q2: 5G Rollout Status
> "What's our 5G rollout status by region? Show me sites that are live, in progress, and planned."

**Expected:** 5G site count by deployment status (Live, In Progress, Planned), regional coverage, go-live timeline

### Q3: Network Element Utilization
> "Which network elements have the highest utilization? Show me capacity hotspots that may need upgrades."

**Expected:** Element utilization %, high-utilization elements (>60%), capacity constraints, geographic distribution

### Q4: IT Application Health
> "What's the status of our critical IT systems? Show me open incidents by severity and resolution times."

**Expected:** Open incidents by P1/P2/P3/P4, MTTR, affected applications

### Q5: Network Quality of Experience
> "What's the customer experience quality on our network? Show me download speeds, latency, and video quality scores by connection type."

**Expected:** Download/upload speeds (Mbps), latency (ms), video quality (1-5), performance by 3G/4G/5G

### Q6: Digital Transformation Strategy (Document Search)
> "What are the key initiatives in our digital transformation roadmap for 2026?"

**Expected:** Strategic pillars from Digital_Transformation_Roadmap_2026.md, 5G SA timeline, cloud migration targets

### Q7: Network SLA Compliance
> "Are we meeting our network SLAs? Show me SLA compliance rates and any breaches this month."

**Expected:** SLA attainment %, breaches by category, breach minutes, credits applicable

---

## 05_COO_Operations.md (6 Questions)

### Q1: Operational Dashboard
> "Give me a snapshot of our operational performance - contact centre wait times and CSAT, network availability, and SIM activation times."

**Expected:** Contact centre metrics, network availability, activation times

### Q2: Contact Centre Performance
> "How is our contact centre performing? Show me handle times, first call resolution rates, and CSAT by team."

**Expected:** AHT by queue, FCR rate, CSAT by team

### Q3: Order Fulfilment & Activation
> "What's our SIM activation performance? Show me average activation times by channel and any pending activations."

**Expected:** Activation time by channel, status distribution

### Q4: Asset & Inventory
> "What's our inventory position? Show me stock levels by warehouse and items at risk of stock-out."

**Expected:** Device inventory by warehouse, stock status

### Q5: Network Operations Health
> "What's the health of our network? Show me availability, alarms by severity, MTTR, and any critical issues."

**Expected:** Network availability, alarms by severity, MTTR by severity, average alarm duration, top alarm types

### Q6: Operational Excellence Framework (Document Search)
> "What are our operational KPI targets and process standards?"

**Expected:** KPI targets from Operational_Excellence_Playbook.md (availability 99.99%, MTTR <30 min, FCR 75%)

---

## 06_CCO_Commercial.md (5 Questions)

### Q1: Revenue Dashboard
> "Show me our revenue performance - total revenue by customer type and ARPU trends."

**Expected:** Revenue by Consumer/SMB/Enterprise, ARPU by segment

### Q2: Sales Pipeline
> "What does our B2B sales pipeline look like? Show me opportunities by stage and expected close dates."

**Expected:** Pipeline by stage, deal size by vertical, quota attainment

### Q3: Channel Performance
> "How are our partner channels performing? Show me partner revenue, commissions, and top performers by tier."

**Expected:** Partner revenue by tier, commission, top partners

### Q4: Product Mix & Subscriber Analysis
> "What's our subscriber mix? Show me 5G vs 4G adoption, plan types, and ARPU by network generation."

**Expected:** Subscribers by network generation, plan type distribution

### Q5: Competitive Position
> "How do we compare to competitors? Show me port-in vs port-out by carrier and competitor pricing."

**Expected:** Port balance by competitor, pricing comparison

---

## 07_CXO_Customer_Experience.md (8 Questions)

### Q1: Journey Stage Distribution
> "What's the distribution of customer interactions by journey stage?"

**Expected:** Counts by stage (Awareness, Consideration, Purchase, Support, Usage, Renewal)

### Q2: Effort Scores by Channel
> "Which channels have the highest customer effort scores?"

**Expected:** Channel comparison with effort scores

### Q3: Sentiment by Channel
> "Show me the average sentiment score by channel this month"

**Expected:** Sentiment across Website, App, Store, Call Center

### Q4: Conversion Rate by Channel
> "What's our conversion rate by channel? Show me conversions vs total interactions."

**Expected:** Conversion counts and totals by channel

### Q5: Resolution Rates
> "Which channels have the highest resolution rates?"

**Expected:** Resolution achieved % by channel

### Q6: Digital vs Physical
> "Compare digital vs physical channel performance - sentiment and effort scores"

**Expected:** Website/App vs Retail Store comparison

### Q7: Session Duration
> "What's the average session duration by journey stage?"

**Expected:** Engagement time by stage

### Q8: NPS by Segment
> "Show me customer satisfaction (NPS) by customer segment"

**Expected:** NPS for Budget, Standard, Premium, VIP

---

## 08_CNO_Network_QoE.md (8 Questions)

### Q1: Download Speed by Network
> "What's the average download speed by network generation (3G/4G/5G)?"

**Expected:** Speed comparison showing 5G advantage

### Q2: Latency Performance
> "Show me the cells with the worst latency performance"

**Expected:** Bottom performers requiring attention

### Q3: Video Quality
> "What's our video streaming quality score across the network?"

**Expected:** Video quality distribution (1-5)

### Q4: Churn Correlation
> "How does network performance correlate with churn risk?"

**Expected:** QoE metrics for high vs low risk customers

### Q5: App Performance
> "Which app categories are most affected by poor network quality?"

**Expected:** App performance breakdown

### Q6: 5G vs 4G Experience
> "Compare 5G vs 4G customer experience metrics"

**Expected:** Side-by-side comparison

### Q7: QoE by City
> "Show me QoE metrics by city"

**Expected:** Geographic performance

### Q8: Capacity Upgrades
> "Which cells need capacity upgrades based on customer experience?"

**Expected:** Priority list for investment

---

## 09_CDO_Data_Science.md (10 Questions)

### Q1: High Risk Customers
> "How many customers are at high risk of churning?"

**Expected:** Churn risk distribution

### Q2: Risk by Segment
> "Show me the churn risk by customer segment"

**Expected:** Segment-level risk analysis

### Q3: Revenue at Risk
> "What's the predicted revenue at risk from high-churn customers?"

**Expected:** CLV impact analysis

### Q4: Upsell Propensity
> "Which customers have the highest upsell propensity?"

**Expected:** Upsell opportunity list

### Q5: Next Best Action
> "Show me the next best action distribution"

**Expected:** NBA recommendations breakdown

### Q6: CLV by Type
> "What's the average predicted CLV by customer type?"

**Expected:** CLV by segment

### Q7: Confidence Scores
> "What's the confidence score distribution for our predictions?"

**Expected:** Model confidence metrics

### Q8: 5G vs Non-5G Churn
> "Compare churn risk for 5G vs non-5G customers"

**Expected:** Technology adoption impact

### Q9: AI/ML Strategic Objectives (Document Search)
> "What are our AI/ML strategic objectives and use cases for 2026?"

**Expected:** Strategy from AI_ML_Strategy_2026.md, churn reduction targets (25%), ARPU uplift goals

### Q10: Network AI Use Cases (Document Search)
> "What AI/ML use cases are we deploying for network intelligence?"

**Expected:** Predictive maintenance, anomaly detection, traffic forecasting from AI_ML_Strategy_2026.md

---

## 10_CSO_Sustainability.md (10 Questions)

### Q1: Energy Consumption
> "What's our total energy consumption this year?"

**Expected:** Energy usage trends

### Q2: Renewable Energy
> "What percentage of our energy comes from renewable sources?"

**Expected:** Renewable energy progress

### Q3: Carbon Emissions
> "Show me our carbon emissions trend"

**Expected:** Carbon reduction progress

### Q4: Site Energy
> "Which sites consume the most energy?"

**Expected:** Site-level consumption

### Q5: PUE Ratio
> "What's our average PUE (Power Usage Effectiveness) ratio?"

**Expected:** Energy efficiency metrics

### Q6: Site Type Comparison
> "Compare energy consumption by site type (Macro vs Small Cell)"

**Expected:** Site type analysis

### Q7: Carbon Intensity
> "Which sites have the highest carbon intensity?"

**Expected:** Priority sites for green energy

### Q8: Net Zero Progress
> "What's our progress toward net zero?"

**Expected:** Net zero roadmap status

### Q9: Green Tariff Customers
> "How many customers are on green tariffs?"

**Expected:** Green product adoption

### Q10: E-Waste Recycling
> "What's our e-waste recycling rate?"

**Expected:** Circular economy metrics

---

## 11_VP_Customer_Service.md (5 Questions)

### Q1: Contact Centre Performance
> "Show me our contact centre performance - average handle time, wait time, and CSAT scores by queue."

**Expected:** AHT, wait time, CSAT by queue

### Q2: Support by Customer Type
> "How does our support performance differ between Consumer and B2B customers? Show me CSAT and handle times."

**Expected:** CSAT and handle time by customer type

### Q3: Ticket Analysis
> "What are the top support ticket categories? Show me ticket volumes and resolution times by category."

**Expected:** Tickets by category, resolution time, priority distribution

### Q4: Complaint Management
> "Show me our formal complaint volumes and resolution times. What are the main complaint categories?"

**Expected:** Complaint volumes, categories, resolution time, ombudsman rate

### Q5: Agent Performance
> "Who are our top performing agents by CSAT? Show me agent rankings and team performance."

**Expected:** Agent CSAT rankings, team performance

---

## 12_VP_Network_Operations.md (5 Questions)

### Q1: Network Health Dashboard
> "Show me the current health of our network - average availability, latency, and throughput across all elements."

**Expected:** Availability (~99.5-99.9%), latency, throughput

### Q2: Alarm Analysis & MTTR
> "Show me our network alarms - alarm counts by severity, MTTR, and average alarm duration."

**Expected:** Alarm volume by severity, MTTR by severity, average alarm duration, acknowledgment status

### Q3: Performance by Region
> "How is our network performing by region? Show me availability and latency for London, Manchester, Birmingham, and other major cities."

**Expected:** Availability and latency by city

### Q4: Capacity Utilization
> "Which network elements have the highest utilization? Show me elements above 60% utilization."

**Expected:** High utilization elements, capacity candidates

### Q5: SLA Compliance
> "Are we meeting our SLAs? Show me SLA measurements - how many met versus breached this month."

**Expected:** SLA attainment rate, breaches, credits

---

## 13_Head_of_Partners.md (5 Questions)

### Q1: Channel Dashboard
> "Give me an overview of our partner channel - total partners, active this month, and revenue contribution."

**Expected:** Total partners, active partners, revenue through channel

### Q2: Partner Performance
> "Who are our top performing partners this quarter? Show me by revenue, orders, and customer acquisition."

**Expected:** Top partners by revenue/orders/new customers

### Q3: Commission Management
> "What commissions have we paid this month and what's accrued for next payment?"

**Expected:** Commission paid, accrued, by tier

### Q4: Partner Health
> "Which partners are underperforming or at risk? Show me activity levels and engagement indicators."

**Expected:** Declining partners, inactive partners, support tickets

### Q5: Recruitment Pipeline
> "What does our partner recruitment pipeline look like? How many new partners have we onboarded?"

**Expected:** Recruitment pipeline, new partners, time to first sale

---

## 14_VP_Billing_Revenue.md (5 Questions)

### Q1: Billing Dashboard
> "Show me our billing performance - total invoices, amount billed, and average invoice value."

**Expected:** Total invoices, amount billed, average invoice

### Q2: Payment Status Analysis
> "What's our payment status distribution? Show me Paid vs Pending vs Overdue by customer type."

**Expected:** Payment status by customer type

### Q3: Revenue Assurance
> "Are there any revenue leakage risks? Show me unbilled usage, credit notes, and adjustments."

**Expected:** Unbilled usage value, credit notes, adjustments

### Q4: Credit Note Analysis
> "How many credit notes have we issued? Show me amounts by reason and approval status."

**Expected:** Credit totals by reason, approval status

### Q5: Billing Disputes
> "Show me our billing disputes - volumes, categories, and resolution times."

**Expected:** Disputes by category, resolution time, outcomes

---

## 15_VP_IT_Digital.md (5 Questions)

### Q1: IT Incident Dashboard
> "Show me our open IT incidents by severity - how many P1, P2, P3, P4 issues do we have?"

**Expected:** Open incidents by P1/P2/P3/P4

### Q2: Incident Resolution Performance
> "What's our Mean Time to Resolve (MTTR) by severity? Are we meeting our SLA targets?"

**Expected:** MTTR by severity, SLA compliance

### Q3: Root Cause Analysis
> "What are the main root causes of our IT incidents? Show me categories and patterns."

**Expected:** Incidents by root cause category

### Q4: Application Health
> "Which applications have the most incidents? Show me the top affected systems."

**Expected:** Incidents by application

### Q5: SLA Compliance Overview
> "How are we performing against our SLAs? Show me attainment rates and any breaches."

**Expected:** SLA attainment %, breaches

---

## 16_VP_Field_Operations.md (11 Questions)

### Q1: First Time Fix Rate
> "What's our overall first-time fix rate?"

**Expected:** FTF rate (target >85%)

### Q2: Technician Rankings
> "Show me technician performance rankings"

**Expected:** Leaderboard by CSAT and FTF

### Q3: Top CSAT Technicians
> "Which technicians have the highest customer satisfaction scores?"

**Expected:** Top performers

### Q4: SLA by Region
> "What's our SLA compliance rate by region?"

**Expected:** Regional SLA performance

### Q5: Delay Time
> "Show me the average delay time by visit type"

**Expected:** Punctuality analysis

### Q6: Rescheduled Visits
> "How many visits were rescheduled last month and why?"

**Expected:** Reschedule analysis

### Q7: Cost per Visit
> "What's the average cost per visit by type?"

**Expected:** Cost breakdown

### Q8: Parts Costs
> "Which visit types have the highest parts costs?"

**Expected:** Parts usage analysis

### Q9: Visit Volume Trend
> "Show me the trend in field visit volume over the past year"

**Expected:** Demand forecasting data

### Q10: Field Operations Standards (Document Search)
> "What are our field technician KPI targets and safety requirements?"

**Expected:** Standards from Field_Operations_Handbook.md (FTF 90%, Jobs/Day 6, Safety protocols)

### Q11: Field Escalation Process (Document Search)
> "What is our escalation process for field visits?"

**Expected:** Escalation criteria from Field_Operations_Handbook.md

---

## 17_VP_Strategy.md (8 Questions)

### Q1: Market Share
> "What's our current market share vs competitors?"

**Expected:** Market share comparison

### Q2: Market Share Trend
> "How has our market share trended over the past year?"

**Expected:** Market share trend

### Q3: Regional Position
> "Which regions are we strongest/weakest in?"

**Expected:** Regional market position

### Q4: ARPU Comparison
> "How does our ARPU compare to competitors?"

**Expected:** ARPU benchmarking

### Q5: Competitor Movement
> "Which competitors are gaining/losing share?"

**Expected:** Net adds analysis

### Q6: Pricing Comparison
> "Compare our pricing to competitors for similar plans"

**Expected:** Price comparison

### Q7: Market Size
> "What's the total addressable market by region?"

**Expected:** Market size analysis

### Q8: Competitive Vulnerability
> "Which competitor's customers are most likely to switch?"

**Expected:** Competitor churn analysis

---

## 18_VP_Communications.md (11 Questions)

### Q1: Overall Sentiment
> "What's our overall social media sentiment this month?"

**Expected:** Sentiment distribution (positive/negative/neutral)

### Q2: Sentiment Trend
> "Show me the sentiment trend over the past week"

**Expected:** Daily sentiment trend

### Q3: Platform Sentiment
> "Which platforms have the most negative mentions?"

**Expected:** Platform sentiment comparison

### Q4: Topic Distribution
> "What topics are customers talking about most?"

**Expected:** Topic distribution

### Q5: Network Complaints
> "Show me negative mentions about network quality"

**Expected:** Network-related complaints

### Q6: Worst Topics
> "Which topics have the worst sentiment?"

**Expected:** Topic sentiment ranking

### Q7: Response Backlog
> "How many mentions require a response that we haven't responded to?"

**Expected:** Response backlog

### Q8: Response Time
> "What's our average response time to negative mentions?"

**Expected:** Response time metrics

### Q9: Influencer Priority
> "Show me high-reach negative mentions from influencers"

**Expected:** Priority response list

### Q10: Crisis Response Protocol (Document Search)
> "What is our crisis response protocol and escalation timeline?"

**Expected:** Process from Crisis_Communications_Playbook.md (golden hour activities, stakeholder notification)

### Q11: Network Outage Templates (Document Search)
> "What are our message templates for network outage communications?"

**Expected:** Templates from Crisis_Communications_Playbook.md (holding statements, status updates)

---

## 19_Regulatory_Compliance.md (5 Questions)

### Q1: Compliance Dashboard
> "Show me our regulatory compliance status - SLA performance, complaint metrics, and any areas of concern."

**Expected:** SLA attainment, complaint ratio, ombudsman rate

### Q2: SLA Performance
> "How are we performing against our published SLAs? Show me breach rates and credit liability."

**Expected:** SLA by category, breach count, credit value

### Q3: Complaint Handling
> "Are we meeting Ofcom complaint handling requirements? Show me resolution times and escalation rates."

**Expected:** Resolution time (target: 8 weeks), ADR rate, categories

### Q4: Network Quality
> "Are we meeting our network quality commitments? Show me coverage, availability, and performance metrics."

**Expected:** Coverage, availability, call drop rate

### Q5: Regulatory Reporting
> "What data do we need for our quarterly Ofcom submission? Summarize key metrics."

**Expected:** Subscriber counts, complaint volumes, resolution times

---

## 20_VP_Security.md (5 Questions)

### Q1: Fraud Overview
> "What is our total fraud detection volume by category and what losses have we prevented this year?"

**Expected:** Total cases, breakdown by category, prevented losses

### Q2: Detection Methods
> "How effective are our different detection methods - ML models vs rule engines vs manual review?"

**Expected:** Case volume by method, ML confidence

### Q3: High-Severity Fraud
> "Show me critical and high severity fraud cases - what types are causing the most damage?"

**Expected:** SIM swap, IRSF trends, geographic hotspots

### Q4: Resolution Performance
> "What's our fraud case resolution rate and average time to resolution?"

**Expected:** Cases by status, resolution types

### Q5: Repeat Offenders & Trends
> "Are we seeing repeat offenders and what monthly trends do we have in fraud activity?"

**Expected:** Repeat offender %, monthly trends

---

## 21_VP_Enterprise_Sales.md (5 Questions)

### Q1: Portfolio Overview
> "What is our total B2B contract portfolio value by product type and renewal status?"

**Expected:** Total ACV by product, renewal status breakdown

### Q2: Renewal Pipeline
> "Show me contracts coming up for renewal in the next 90 days with their renewal probability."

**Expected:** Contracts by days to renewal, probability distribution

### Q3: Competitive Threats
> "Which contracts have competitive threats and who are we losing deals to?"

**Expected:** High threat accounts, competitor breakdown

### Q4: Upsell Opportunities
> "What upgrade and expansion opportunities do we have in the renewal pipeline?"

**Expected:** Proposed upgrades vs downgrades, potential value

### Q5: At-Risk Analysis
> "What is our total at-risk contract value and what's driving churn risk?"

**Expected:** ACV with probability < 70%, correlation factors

---

## 22_VP_Wholesale.md (6 Questions)

### Q1: MVNO Portfolio Overview
> "What is our total MVNO partner portfolio and wholesale revenue by partner?"

**Expected:** Active MVNO partners, revenue by partner

### Q2: Traffic Analysis
> "Show me MVNO traffic trends - voice, SMS, and data volumes by partner."

**Expected:** Monthly traffic volumes, network type mix

### Q3: Revenue by Traffic Type
> "What's our wholesale revenue breakdown by voice, SMS, and data?"

**Expected:** Revenue split, average rates

### Q4: Settlement Performance & Overdue Tracking
> "Show me overdue MVNO settlements - which partners have overdue payments and how many days overdue?"

**Expected:** Overdue settlements count, days overdue by partner, is_overdue flag, settlement status

### Q5: Partner Performance & Growth
> "Which MVNO partners are growing fastest and which are underperforming their commitments?"

**Expected:** Subscriber growth, minimum commitment attainment

### Q6: Partnership Terms (Document Search)
> "What are our wholesale pricing tiers and minimum commitment terms for different MVNO types?"

**Expected:** Pricing from MVNO_Partnership_Guide.md (voice/SMS/data rates, minimum commitments)

---

## 23_VP_Retail.md (5 Questions)

### Q1: Network Overview
> "What is our total retail sales revenue by store type and region?"

**Expected:** Revenue by store type (Flagship, Standard, Express, Kiosk)

### Q2: Product Mix
> "What are our top selling product categories and how do contract vs PAYG sales compare?"

**Expected:** Sales by category, contract vs PAYG mix

### Q3: Footfall & Conversion
> "What are our footfall trends and conversion rates by store type?"

**Expected:** Footfall patterns, conversion rates (15-35%)

### Q4: Store Performance
> "Which stores are our top and bottom performers by sales per square foot?"

**Expected:** Top/bottom stores, sales per sqft

### Q5: Staff Performance
> "How are retail staff performing in terms of commission and sales per employee?"

**Expected:** Sales per staff, commission distribution

---

## 24_CHRO_People.md (7 Questions)

### Q1: Workforce Overview
> "What is our current headcount by department and work location?"

**Expected:** Headcount by department, geographic distribution

### Q2: Employee Engagement
> "What are our employee engagement scores by department and how do they trend?"

**Expected:** Overall engagement, department scores

### Q3: eNPS & Retention
> "What is our employee Net Promoter Score and which teams have the highest/lowest?"

**Expected:** Company-wide eNPS, by department/location

### Q4: Compensation & Performance
> "What are our average salaries by job level and how does performance rating correlate?"

**Expected:** Salary bands by level, performance distribution

### Q5: Workforce Planning
> "What's our tenure distribution and which departments have the highest turnover risk?"

**Expected:** Tenure by department, status distribution

### Q6: Talent Strategy (Document Search)
> "What are our critical skills gaps and hiring priorities for 2026?"

**Expected:** Skills gaps from Talent_Strategy_2026.md (5G: 50, AI/ML: 35, Cloud: 40), hiring plan

### Q7: Employee Engagement Insights (Document Search)
> "What were the key findings from our latest employee engagement survey?"

**Expected:** Results from Employee_Engagement_Report_Q4_2025.md (eNPS +38, top teams, action plans)

---

## 25_VP_Legal.md (7 Questions)

### Q1: Contract Portfolio Overview
> "What is our B2B contract portfolio? Show me total contract value, contracts by status, and upcoming renewals in the next 90 days."

**Expected:** Total TCV/ACV, contracts by status, expiring contracts

### Q2: Regulatory Complaints Analysis
> "Show me our formal complaint trends - how many Ofcom escalations and ombudsman cases do we have? What are the main complaint categories?"

**Expected:** Complaints by type, categories, resolution rates, compensation

### Q3: SLA Compliance & Breach Risk
> "What's our SLA compliance rate? Show me any breaches and potential financial exposure from SLA credits."

**Expected:** SLA attainment %, breaches by category, credit exposure

### Q4: Vendor Contract Terms (Document Search)
> "What are the key liability and indemnity terms in our strategic vendor contracts? Search our AWS and Microsoft agreements."

**Expected:** Liability caps, indemnification clauses from vendor agreements

### Q5: GDPR & Data Protection Compliance
> "What is our GDPR compliance framework? Show me our data protection obligations and any privacy-related complaints."

**Expected:** GDPR framework summary, privacy complaints count

### Q6: Legal Matters & Disputes
> "What active legal matters do we have? Show me open disputes, litigation status, and potential financial exposure."

**Expected:** Active matters by type, status, exposure amounts

### Q7: Contract Risk Assessment
> "Which B2B contracts have the highest risk? Show me contracts with competitor threats, low renewal probability, or support issues."

**Expected:** High-risk contracts, competitor threats, renewal probability

---

## 26_VP_Product.md (6 Questions)

### Q1: Plan Portfolio Overview
> "What is our mobile plan portfolio? Show me all plans with pricing, data allowances, and 5G availability."

**Expected:** Complete plan catalog, price points, data allowances, 5G status, contract lengths

### Q2: Plan Adoption by Subscriber
> "Which plans have the most subscribers? Show me subscriber count by plan name and plan type."

**Expected:** Top plans by subscriber count, plan type distribution, Consumer vs B2B adoption

### Q3: 5G Adoption Analysis
> "What's our 5G adoption rate? Show me subscribers on 5G vs 4G plans by customer segment."

**Expected:** 5G subscriber percentage, adoption by customer type and segment

### Q4: Pricing Competitiveness
> "How do our plan prices compare to competitors for similar data allowances?"

**Expected:** SnowTelco vs competitor pricing, price positioning, market average

### Q5: Plan Feature Analysis
> "Which plan features drive the most value? Show me plans with roaming included and family eligibility."

**Expected:** Roaming-included plans, family-eligible plans, feature uptake

### Q6: ARPU by Plan Type
> "What's our ARPU by plan type? Compare Pay Monthly, SIM Only, and PAYG."

**Expected:** ARPU by plan type, revenue concentration, high-value plan distribution

---

## 27_VP_Procurement.md (7 Questions)

### Q1: Vendor Spend Overview
> "What is our total vendor spend by category? Show me the top spending areas and approval status."

**Expected:** Total spend by category, top vendors, approval status distribution

### Q2: Top Vendors Analysis
> "Who are our top 10 vendors by spend? Show me vendor names, total spend, and transaction counts."

**Expected:** Top vendors ranked by spend, transaction volumes, spend concentration

### Q3: Procurement Method Analysis
> "How is our spend distributed by procurement method? Show me RFP, contract, emergency, and quote-based purchases."

**Expected:** Spend by procurement method, emergency purchase %, contract compliance rate

### Q4: Department Spend
> "What's our vendor spend by department? Which departments have the highest expenses?"

**Expected:** Spend by department, approval rates by department

### Q5: Approval Pipeline
> "What's the status of our purchase approvals? Show me pending, approved, and rejected transactions."

**Expected:** Approval status distribution, pending value, average approval time

### Q6: Vendor Contract Terms (Document Search)
> "What are the key terms in our strategic vendor contracts? Show me our AWS, Microsoft, and Cisco agreements."

**Expected:** Contract summaries from vendor agreement documents, key commercial terms

### Q7: Cost Optimization Opportunities
> "Where can we optimize vendor spend? Show me duplicate vendors, small transactions, and consolidation opportunities."

**Expected:** Consolidation opportunities, small-value transactions, savings potential

---

## Summary Statistics

| Script | Questions | Changes |
|--------|-----------|---------|
| **00_WOW_Executive_Showcase** | **10** | **Flagship demo - start here** |
| 01_CEO_Strategic | 5 | |
| 02_CFO_Finance | 5 | |
| 03_CMO_Marketing | 5 | |
| 04_CTO_Technology | 7 | +2 (5G rollout, Digital Transformation doc) |
| 05_COO_Operations | 6 | +1 (Operational Excellence doc) |
| 06_CCO_Commercial | 5 | |
| 07_CXO_Customer_Experience | 8 | |
| 08_CNO_Network_QoE | 8 | |
| 09_CDO_Data_Science | 10 | +2 (AI/ML Strategy docs) |
| 10_CSO_Sustainability | 10 | |
| 11_VP_Customer_Service | 5 | |
| 12_VP_Network_Operations | 5 | Updated Q2 for MTTR |
| 13_Head_of_Partners | 5 | |
| 14_VP_Billing_Revenue | 5 | |
| 15_VP_IT_Digital | 5 | |
| 16_VP_Field_Operations | 11 | +2 (Field Ops Handbook docs) |
| 17_VP_Strategy | 8 | |
| 18_VP_Communications | 11 | +2 (Crisis Playbook docs) |
| 19_Regulatory_Compliance | 5 | |
| 20_VP_Security | 5 | |
| 21_VP_Enterprise_Sales | 5 | |
| 22_VP_Wholesale | 6 | +1 (MVNO Partnership doc), updated Q4 for overdue |
| 23_VP_Retail | 5 | |
| 24_CHRO_People | 7 | +2 (Talent Strategy, Engagement docs) |
| 25_VP_Legal | 7 | NEW - Legal matters, contracts, compliance |
| 26_VP_Product | 6 | NEW - Plan portfolio analytics |
| 27_VP_Procurement | 7 | NEW - Vendor spend analytics |
| **TOTAL** | **182** | +32 new questions (13 updates + 3 new personas) |
