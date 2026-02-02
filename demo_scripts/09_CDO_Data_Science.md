# Demo Script 13: AI/ML Propensity Analytics

## Persona: Chief Data Officer / Head of Data Science

**Name:** Dr. Priya Sharma  
**Role:** Chief Data Officer  
**Focus:** Predictive analytics, ML operations, data-driven decision making

**Key Documents:** AI_ML_Strategy_2026.md

---

## Background

Priya leads the data science team at SnowTelco. She's responsible for building and deploying ML models that predict customer behavior, enabling proactive retention, personalized offers, and optimized customer lifetime value.

---

## Demo Questions

### Churn Prediction

1. **"How many customers are at high risk of churning?"**
   - Expected: Churn risk distribution
   - Data: customer_propensity_scores

2. **"Show me the churn risk by customer segment"**
   - Expected: Segment-level risk analysis
   - Data: customer_propensity_scores, mobile_subscriber_dim

3. **"What's the predicted revenue at risk from high-churn customers?"**
   - Expected: CLV impact analysis
   - Data: customer_propensity_scores

### Propensity Analysis

4. **"Which customers have the highest upsell propensity?"**
   - Expected: Upsell opportunity list
   - Data: customer_propensity_scores

5. **"Show me the next best action distribution"**
   - Expected: NBA recommendations breakdown
   - Data: customer_propensity_scores

6. **"What's the average predicted CLV by customer type?"**
   - Expected: CLV by segment
   - Data: customer_propensity_scores, mobile_subscriber_dim

### Model Performance

7. **"What's the confidence score distribution for our predictions?"**
   - Expected: Model confidence metrics
   - Data: customer_propensity_scores

8. **"Compare churn risk for 5G vs non-5G customers"**
   - Expected: Technology adoption impact
   - Data: customer_propensity_scores, mobile_subscriber_dim

### AI/ML Strategy (Document Search)

9. **"What are our AI/ML strategic objectives and use cases for 2026?"**
   - Expected: Strategy from AI_ML_Strategy_2026.md
   - Insights: Churn reduction targets, ARPU uplift goals, automation initiatives

10. **"What AI/ML use cases are we deploying for network intelligence?"**
    - Expected: Predictive maintenance, anomaly detection, traffic forecasting
    - Data: AI_ML_Strategy_2026.md

---

## Key Insights to Highlight

- Predictive models enable proactive customer management
- High-risk customers identified before they churn
- Personalized next best actions drive engagement
- CLV predictions guide investment decisions
- AI/ML strategy drives 25% churn reduction target
- Network AI for predictive maintenance and anomaly detection

---

## SQL Examples

```sql
-- Churn risk distribution
SELECT 
    churn_risk_band,
    COUNT(*) as customers,
    ROUND(AVG(churn_risk_score) * 100, 1) as avg_risk_pct,
    ROUND(SUM(predicted_clv), 0) as total_clv_at_risk
FROM customer_propensity_scores
GROUP BY churn_risk_band
ORDER BY avg_risk_pct DESC;

-- Next best action distribution
SELECT 
    next_best_action,
    COUNT(*) as customers,
    ROUND(AVG(churn_risk_score) * 100, 1) as avg_churn_risk,
    ROUND(AVG(upsell_propensity) * 100, 1) as avg_upsell_propensity
FROM customer_propensity_scores
GROUP BY next_best_action
ORDER BY customers DESC;

-- High-value at-risk customers
SELECT 
    s.subscriber_key,
    s.first_name || ' ' || s.last_name as customer_name,
    s.customer_type,
    s.customer_segment,
    p.churn_risk_score,
    p.predicted_clv,
    p.next_best_action
FROM customer_propensity_scores p
JOIN mobile_subscriber_dim s ON p.subscriber_key = s.subscriber_key
WHERE p.churn_risk_band = 'High' AND p.clv_segment IN ('High', 'Medium')
ORDER BY p.predicted_clv DESC
LIMIT 50;

-- Churn risk by network generation
SELECT 
    s.network_generation,
    COUNT(*) as customers,
    ROUND(AVG(p.churn_risk_score) * 100, 1) as avg_churn_risk,
    ROUND(AVG(p.predicted_clv), 0) as avg_clv
FROM customer_propensity_scores p
JOIN mobile_subscriber_dim s ON p.subscriber_key = s.subscriber_key
GROUP BY s.network_generation
ORDER BY avg_churn_risk DESC;
```

---

## Demo Flow

1. Show overall churn risk distribution
2. Identify high-value at-risk customers
3. Review next best action recommendations
4. Demonstrate proactive retention strategies
5. Show CLV optimization opportunities
