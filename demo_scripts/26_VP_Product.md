# Demo Script 26: VP Product Management

## Persona
**Role:** VP Product Management  
**Focus:** Product portfolio, plan performance, pricing strategy, feature adoption  
**Duration:** 10 minutes

**Semantic Views Used:** PLAN_SEMANTIC_VIEW, MOBILE_SEMANTIC_VIEW, MARKET_INTELLIGENCE_SEMANTIC_VIEW

**Data Sources:** mobile_plan_dim, mobile_subscriber_dim, market_competitor_dim

## Background
The VP Product manages SnowTelco's mobile plan portfolio across Consumer and B2B segments. Key focus areas include plan adoption rates, pricing competitiveness, feature utilization (5G, roaming), and new product development priorities.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco uses AI-powered analytics to understand product performance, optimize our plan portfolio, and identify opportunities for new products and features."

---

### Question 1: Plan Portfolio Overview
**Ask:** "What is our mobile plan portfolio? Show me all plans with pricing, data allowances, and 5G availability."

**Expected Insight:**
- Complete plan catalog
- Price points by plan type (Pay Monthly, SIM Only, PAYG, Family)
- Data allowances (GB)
- 5G inclusion status
- Contract lengths

**Talking Point:**
> "Our portfolio spans from £10 PAYG to £80+ premium plans. 5G is now included in 60% of our plans."

---

### Question 2: Plan Adoption by Subscriber
**Ask:** "Which plans have the most subscribers? Show me subscriber count by plan name and plan type."

**Expected Insight:**
- Top 10 plans by subscriber count
- Plan type distribution (Pay Monthly vs SIM Only vs PAYG)
- Consumer vs B2B plan adoption
- Average tenure by plan

**Talking Point:**
> "Our Unlimited 5G plan is the fastest growing, while legacy 4G plans are declining. Migration campaigns are driving upgrades."

---

### Question 3: 5G Adoption Analysis
**Ask:** "What's our 5G adoption rate? Show me subscribers on 5G vs 4G plans by customer segment."

**Expected Insight:**
- 5G subscriber percentage
- 5G adoption by customer type (Consumer/SMB/Enterprise)
- 5G adoption by segment (Budget/Standard/Premium/VIP)
- Growth trend

**Talking Point:**
> "5G adoption is highest in Premium and VIP segments. We need targeted campaigns to drive adoption in Budget segment."

---

### Question 4: Pricing Competitiveness
**Ask:** "How do our plan prices compare to competitors for similar data allowances?"

**Expected Insight:**
- SnowTelco pricing vs competitors
- Price positioning by data tier
- Competitive gaps
- Market average comparison

**Talking Point:**
> "We're competitively priced in the mid-market but premium to competitors at entry level. Price sensitivity analysis suggests room for adjustment."

---

### Question 5: Plan Feature Analysis
**Ask:** "Which plan features drive the most value? Show me plans with roaming included and family eligibility."

**Expected Insight:**
- Roaming-included plans
- Family-eligible plans
- Feature bundling patterns
- Premium feature uptake

**Talking Point:**
> "Roaming inclusion is a key differentiator for business travelers. Family plans show strong multi-line retention."

---

### Question 6: ARPU by Plan Type
**Ask:** "What's our ARPU by plan type? Compare Pay Monthly, SIM Only, and PAYG."

**Expected Insight:**
- ARPU by plan type
- ARPU by contract length
- High-value vs low-value plan distribution
- Revenue concentration

**Talking Point:**
> "Pay Monthly generates 3x the ARPU of SIM Only, but SIM Only has lower acquisition cost. The portfolio mix is shifting."

---

### Closing (1 minute)
> "With AI-powered product analytics, SnowTelco can optimize our plan portfolio, identify feature gaps, and make data-driven pricing decisions. Product strategy driven by customer behavior data."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Plan Count | Number of plans in portfolio | mobile_plan_dim |
| Subscribers | Customers on each plan | mobile_subscriber_dim |
| Monthly Price | Plan price point | mobile_plan_dim |
| Data Allowance | GB included in plan | mobile_plan_dim |
| 5G Included | Whether plan includes 5G | mobile_plan_dim |
| Contract Length | Months of commitment | mobile_plan_dim |
| ARPU | Average revenue per user | mobile_usage_fact |

---

## SQL Examples

```sql
-- Plan portfolio summary
SELECT 
    plan_name,
    plan_type,
    monthly_price,
    data_allowance_gb,
    minutes_allowance,
    "5g_included",
    roaming_included,
    contract_length_months
FROM mobile_plan_dim
ORDER BY monthly_price DESC;

-- Subscriber count by plan
SELECT 
    p.plan_name,
    p.plan_type,
    p.monthly_price,
    COUNT(s.subscriber_key) as subscriber_count
FROM mobile_subscriber_dim s
JOIN mobile_plan_dim p ON s.plan_key = p.plan_key
GROUP BY p.plan_name, p.plan_type, p.monthly_price
ORDER BY subscriber_count DESC;

-- 5G adoption by segment
SELECT 
    customer_segment,
    network_generation,
    COUNT(*) as subscribers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY customer_segment), 1) as pct
FROM mobile_subscriber_dim
WHERE status = 'Active'
GROUP BY customer_segment, network_generation
ORDER BY customer_segment, network_generation;

-- ARPU by plan type
SELECT 
    p.plan_type,
    COUNT(DISTINCT s.subscriber_key) as subscribers,
    ROUND(AVG(p.monthly_price), 2) as avg_plan_price,
    ROUND(SUM(u.total_revenue) / COUNT(DISTINCT s.subscriber_key), 2) as arpu
FROM mobile_subscriber_dim s
JOIN mobile_plan_dim p ON s.plan_key = p.plan_key
JOIN mobile_usage_fact u ON s.subscriber_key = u.subscriber_key
GROUP BY p.plan_type
ORDER BY arpu DESC;
```

---

**Demo Duration:** 10 minutes  
**Audience:** VP Product, Product Managers, Pricing Analysts  
**Key Message:** Data-driven product portfolio optimization
