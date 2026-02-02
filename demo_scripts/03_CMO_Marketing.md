# CMO Demo Script (10 Minutes)
## SnowTelco UK - Marketing Performance & Customer Insights

---

## Persona: Chief Marketing Officer

**Focus Areas:** Campaign performance, customer acquisition, brand health, NPS, churn prevention, competitive positioning

**Semantic Views Used:** MARKETING, MOBILE, PORTING

---

## Opening (1 minute)

**Presenter Says:**
"As CMO, you're responsible for growing our subscriber base while protecting brand health. This platform connects campaign performance data with customer behaviour insights - showing you what's working and where to invest next."

---

## Demo Questions

### Question 1: Campaign Performance
> "Which marketing campaigns have delivered the best ROI? Show me spend, leads generated, and impressions by campaign."

**Expected Insights:**
- Campaign spend vs leads generated
- Cost per acquisition by channel
- Top performing campaigns by ROI
- Impressions to lead ratio

**Talking Point:** "Every marketing pound tracked from spend to subscriber - real ROI visibility."

---

### Question 2: Customer Acquisition Channels
> "Where are our customers coming from? Break down by acquisition channel for Consumer vs B2B customers."

**Expected Insights:**
- Consumer channels: Online, Retail Store, App, Social Media, Comparison Site
- B2B channels: Direct Sales, Partner, Trade Show, LinkedIn
- Channel effectiveness by customer type
- Acquisition channel trends

**Talking Point:** "Understanding acquisition channels helps us optimize our media mix for each customer type."

---

### Question 3: NPS Analysis
> "What's our NPS score by customer type and segment? Compare Consumer vs SMB vs Enterprise, and show Budget through VIP."

**Expected Insights:**
- Overall NPS score (~7-8 average)
- NPS by customer type: Enterprise > SMB > Consumer
- NPS by segment: VIP > Premium > Standard > Budget
- B2B customers have ~40% survey response rate vs 30% for consumers
- NPS trends over time

**Talking Point:** "NPS is our north star for customer satisfaction - our B2B customers show higher satisfaction scores."

---

### Question 4: Churn Analysis
> "What are the top reasons customers are churning? Show me churn reasons by customer type and which competitors they're leaving for."

**Expected Insights:**
- Top churn reasons: Price, Network Coverage, Competitor Promotion, Customer Service
- Competitor destinations: EE, Vodafone, Three, Sky Mobile, giffgaff
- Churn rate by customer type (Consumer ~8%, B2B ~5%)
- High-value segment churn (Premium/VIP)

**Talking Point:** "Understanding why customers leave helps us take proactive retention actions."

---

### Question 5: Competitive Win/Loss
> "Show me our port-in versus port-out by competitor. Which carriers are we winning from and losing to?"

**Expected Insights:**
- Port-in sources: EE, Vodafone, Three, O2, Sky Mobile, Virgin Mobile
- Port-out destinations by competitor
- Net porting position (positive = gaining share)
- Port trends over time

**Talking Point:** "Real-time competitive intelligence - we can see exactly where we're winning and losing market share."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Campaign ROI at channel and campaign level
- Customer acquisition analysis
- Brand health monitoring through NPS
- Proactive churn risk identification
- Competitive intelligence from real data

Data-driven marketing decisions for subscriber growth."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Campaign ROI | Spend vs leads generated | marketing_campaign_fact |
| Acquisition Channel | Consumer vs B2B acquisition sources | mobile_subscriber_dim.acquisition_channel |
| NPS | Net Promoter Score by customer type (0-10) | mobile_usage_fact.nps_score |
| Churn Reasons | Why customers leave + competitor destination | mobile_churn_fact |
| Port-in/out | Competitor movement (EE, Vodafone, Three, etc.) | number_port_fact |
| Customer Type | Consumer / SMB / Enterprise split | mobile_subscriber_dim.customer_type |

---

**Demo Duration:** 10 minutes  
**Audience:** CMO, Marketing Directors, Brand Managers  
**Key Message:** Data-driven marketing for subscriber growth
