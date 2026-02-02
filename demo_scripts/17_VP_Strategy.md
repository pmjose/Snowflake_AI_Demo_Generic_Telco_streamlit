# Demo Script 15: Market Intelligence & Competitive Analytics

## Persona: VP of Strategy / Head of Competitive Intelligence

**Name:** Alexandra Chen  
**Role:** VP of Strategy  
**Focus:** Market positioning, competitive analysis, pricing strategy, growth opportunities

---

## Background

Alexandra leads strategic planning at SnowTelco. She needs to understand market dynamics, track competitor movements, identify growth opportunities, and support pricing decisions with market intelligence.

---

## Demo Questions

### Market Position

1. **"What's our current market share vs competitors?"**
   - Expected: Market share comparison
   - Data: market_share_fact

2. **"How has our market share trended over the past year?"**
   - Expected: Market share trend
   - Data: market_share_fact

3. **"Which regions are we strongest/weakest in?"**
   - Expected: Regional market position
   - Data: market_share_fact

### Competitive Analysis

4. **"How does our ARPU compare to competitors?"**
   - Expected: ARPU benchmarking
   - Data: market_share_fact

5. **"Which competitors are gaining/losing share?"**
   - Expected: Net adds analysis
   - Data: market_share_fact

6. **"Compare our pricing to competitors for similar plans"**
   - Expected: Price comparison
   - Data: competitor_pricing_dim, mobile_plan_dim

### Growth Opportunities

7. **"What's the total addressable market by region?"**
   - Expected: Market size analysis
   - Data: market_share_fact

8. **"Which competitor's customers are most likely to switch?"**
   - Expected: Competitive vulnerability analysis
   - Data: market_share_fact (churn rates)

---

## Key Insights to Highlight

- SnowTelco is a growing challenger brand (~5% share)
- Opportunity in regions where competitors have high churn
- Price competitiveness analysis
- MVNO vs MNO market dynamics

---

## SQL Examples

```sql
-- Current market share (latest month)
SELECT 
    competitor_name,
    competitor_type,
    SUM(subscriber_count) as total_subscribers,
    ROUND(AVG(market_share_pct), 2) as market_share,
    ROUND(AVG(arpu), 2) as avg_arpu
FROM market_share_fact
WHERE report_date = (SELECT MAX(report_date) FROM market_share_fact)
    AND region = 'UK Total'
GROUP BY competitor_name, competitor_type
ORDER BY total_subscribers DESC;

-- Market share trend for SnowTelco
SELECT 
    report_month,
    SUM(subscriber_count) as subscribers,
    ROUND(AVG(market_share_pct), 2) as market_share,
    SUM(net_adds) as net_adds
FROM market_share_fact
WHERE competitor_name = 'SnowTelco' AND region = 'UK Total'
GROUP BY report_month
ORDER BY report_month;

-- Regional market position
SELECT 
    region,
    SUM(subscriber_count) as our_subscribers,
    ROUND(AVG(market_share_pct), 2) as our_share,
    ROUND(AVG(arpu), 2) as our_arpu
FROM market_share_fact
WHERE competitor_name = 'SnowTelco' 
    AND report_date = (SELECT MAX(report_date) FROM market_share_fact)
    AND region != 'UK Total'
GROUP BY region
ORDER BY our_share DESC;

-- Competitive pricing comparison
SELECT 
    cp.competitor_name,
    cp.plan_name,
    cp.data_allowance_gb,
    cp.monthly_price,
    cp.includes_5g,
    cp.contract_months
FROM competitor_pricing_dim cp
WHERE cp.data_allowance_gb >= 30
ORDER BY cp.monthly_price;

-- Competitors with highest churn (opportunity)
SELECT 
    competitor_name,
    region,
    ROUND(AVG(churn_rate_pct), 2) as avg_churn_rate,
    SUM(subscriber_count) as total_subs
FROM market_share_fact
WHERE report_date >= DATEADD(month, -3, CURRENT_DATE)
    AND competitor_name != 'SnowTelco'
GROUP BY competitor_name, region
HAVING AVG(churn_rate_pct) > 1.8
ORDER BY avg_churn_rate DESC;
```

---

## Demo Flow

1. Show current market position
2. Trend analysis over time
3. Regional strengths/weaknesses
4. Competitive pricing comparison
5. Identify growth opportunities
