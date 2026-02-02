# Demo Script 07: Customer Experience Analytics

## Persona: Chief Experience Officer (CXO)

**Name:** Sophie Anderson  
**Role:** Chief Experience Officer  
**Focus:** Customer journey optimization, NPS improvement, experience transformation

**Semantic Views Used:** CUSTOMER_EXPERIENCE, MOBILE, SUPPORT

---

## Background

Sophie leads the customer experience transformation at SnowTelco. She needs to understand customer journeys across all touchpoints, identify friction points, and drive improvements in customer satisfaction and loyalty.

---

## Demo Questions

### Journey Analysis

1. **"What's the distribution of customer interactions by journey stage?"**
   - Expected: Counts by stage (Awareness, Consideration, Purchase, Support, Usage, Renewal)
   - Data: customer_journey_fact

2. **"Which channels have the highest customer effort scores?"**
   - Expected: Channel comparison with average effort scores (lower is better)
   - Data: customer_journey_fact

3. **"Show me the average sentiment score by channel this month"**
   - Expected: Sentiment comparison across Website, App, Store, Call Center
   - Data: customer_journey_fact

### Experience Optimization

4. **"What's our conversion rate by channel? Show me conversions vs total interactions."**
   - Expected: Conversion counts and totals by channel
   - Data: customer_journey_fact (conversion_flag dimension)

5. **"Which channels have the highest resolution rates?"**
   - Expected: Resolution achieved percentage by channel
   - Data: customer_journey_fact

6. **"Compare digital vs physical channel performance - sentiment and effort scores"**
   - Expected: Website/App vs Retail Store comparison
   - Data: customer_journey_fact

### Engagement Metrics

7. **"What's the average session duration by journey stage?"**
   - Expected: Engagement time analysis by stage
   - Data: customer_journey_fact

8. **"Show me customer satisfaction (NPS) by customer segment"**
   - Expected: NPS scores for Budget, Standard, Premium, VIP customers
   - Data: mobile_usage_fact

---

## Key Insights to Highlight

- Journey stage distribution (Usage and Support are highest volume)
- Sentiment patterns by channel
- Digital channels typically have lower effort scores
- Premium/VIP customers have higher NPS

---

## SQL Examples

```sql
-- Journey stage distribution
SELECT 
    journey_stage,
    COUNT(*) as interactions,
    AVG(sentiment_score) as avg_sentiment,
    AVG(effort_score) as avg_effort,
    SUM(CASE WHEN conversion_flag THEN 1 ELSE 0 END) as conversions
FROM customer_journey_fact
WHERE interaction_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY journey_stage
ORDER BY interactions DESC;

-- Channel sentiment analysis
SELECT 
    channel,
    COUNT(*) as touchpoints,
    AVG(sentiment_score) as avg_sentiment,
    AVG(effort_score) as avg_effort,
    SUM(CASE WHEN resolution_achieved THEN 1 ELSE 0 END) / COUNT(*) * 100 as resolution_rate
FROM customer_journey_fact
GROUP BY channel
ORDER BY avg_sentiment DESC;
```

---

## Demo Flow

1. Start with journey stage distribution
2. Compare channel performance (sentiment, effort)
3. Show conversion metrics by channel
4. Analyze session duration patterns
5. Link to NPS by customer segment
