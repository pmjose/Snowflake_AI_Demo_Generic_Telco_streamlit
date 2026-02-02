# CEO Demo Script (10 Minutes)
## SnowTelco UK - Strategic Executive Overview

---

## Persona: Chief Executive Officer

**Focus Areas:** Overall business performance, market position, strategic KPIs, competitive landscape, investor metrics

**Semantic Views Used:** MOBILE, PORTING, NETWORK_OPS, MARKET_INTELLIGENCE

---

## Opening (1 minute)

**Presenter Says:**
"Welcome to SnowTelco's AI-powered intelligence platform. As CEO, you need instant access to strategic insights across all business operations. This platform combines our operational data with strategy documents, accessible through natural language - no SQL required."

---

## Demo Questions

### Question 1: Business Health Dashboard
> "Give me an executive summary of SnowTelco's current performance - total subscribers, ARPU, and NPS split by B2C consumers versus B2B business customers."

**Expected Insights:**
- Total mobile subscribers: ~30,000 (70% Consumer, 26% SMB, 4% Enterprise)
- Average Revenue Per User (ARPU) by customer type
- NPS scores by customer type and segment
- Revenue split: Consumer vs SMB vs Enterprise

**Talking Point:** "One question gives you the complete health of the business - subscriber base, revenue quality, and customer satisfaction across both B2C and B2B."

---

### Question 2: Competitive Position
> "Show me our port-in versus port-out analysis - which competitors are we winning customers from and losing customers to?"

**Expected Insights:**
- Port-in sources: EE, Vodafone, Three, O2, Sky Mobile, etc.
- Port-out destinations by competitor
- Net porting position (positive = gaining market share)
- Competitor trends over time

**Talking Point:** "Real-time competitive intelligence - we're tracking exactly where customers are coming from and going to."

---

### Question 3: Network Quality & Customer Impact
> "What are our top network quality issues affecting customer satisfaction? Show me the correlation between network problems and NPS scores by city."

**Expected Insights:**
- Network availability and latency by city
- Cities with lowest NPS scores
- Correlation between network issues and customer satisfaction
- Priority areas requiring infrastructure investment

**Talking Point:** "Connecting network performance to customer satisfaction helps us prioritize infrastructure investments."

---

### Question 4: Competitive Market Position
> "Compare our performance against our main competitors - how do we rank in terms of market share, customer satisfaction, and service quality?"

**Expected Insights:**
- SnowTelco market share position
- NPS vs competitors
- Network performance benchmarks
- Partner satisfaction comparison

**Talking Point:** "Understanding our competitive position helps us identify strategic advantages and areas to improve."

---

### Question 5: Strategic Priorities
> "Based on all this data, what are the 3 most critical strategic priorities I should focus on this quarter to drive growth while maintaining customer satisfaction?"

**Expected Insights:**
- Data-driven strategic recommendations
- Growth opportunities (B2B, specific markets)
- Retention priorities (network investments, NPS improvement)
- Actionable initiatives with expected impact

**Talking Point:** "AI-powered insights synthesize across all our data to surface the most impactful strategic priorities."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Instant strategic insights across all business units
- Competitive intelligence in real-time
- Network performance correlated with customer satisfaction
- AI-synthesized strategic recommendations

This is the power of Snowflake Intelligence - your entire business, accessible in natural language."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Total Subscribers | Active mobile subscribers (~30,000) | mobile_subscriber_dim |
| Customer Type | Consumer (70%) / SMB (26%) / Enterprise (4%) | mobile_subscriber_dim.customer_type |
| ARPU | Average Revenue Per User by type/segment | mobile_usage_fact.bill_amount |
| NPS | Net Promoter Score by city/segment | mobile_usage_fact.nps_score |
| Port-in/out | Number porting by competitor | number_port_fact |
| Network Availability | Uptime % by city | network_performance_fact |
| Latency | Network latency ms by region | network_performance_fact |
| Market Share | Competitive position | market_share_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** CEO, Board members, Investors  
**Key Message:** Strategic intelligence at your fingertips
