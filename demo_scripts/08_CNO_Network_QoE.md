# Demo Script 12: Network Quality of Experience Analytics

## Persona: Chief Networks Officer (CNO)

**Name:** Dr. James Mitchell  
**Role:** Chief Networks Officer  
**Focus:** Network performance, RAN operations, customer experience correlation, 5G rollout

---

## Background

James leads SnowTelco's network operations and is responsible for the entire radio access network (RAN) and core network infrastructure. He needs to understand how network performance impacts customer experience, optimize RAN capacity, identify coverage gaps, and prioritize network investments based on customer impact and business value.

---

## Demo Questions

### Network Performance

1. **"What's the average download speed by network generation (3G/4G/5G)?"**
   - Expected: Speed comparison showing 5G advantage
   - Data: network_qoe_fact

2. **"Show me the cells with the worst latency performance"**
   - Expected: Bottom performers requiring attention
   - Data: network_qoe_fact, ran_cell_dim

3. **"What's our video streaming quality score across the network?"**
   - Expected: Video quality distribution (1-5 scale)
   - Data: network_qoe_fact

### Customer Impact Analysis

4. **"How does network performance correlate with churn risk?"**
   - Expected: QoE metrics for high-risk vs low-risk customers
   - Data: network_qoe_fact, customer_propensity_scores

5. **"Which app categories are most affected by poor network quality?"**
   - Expected: App performance breakdown
   - Data: network_qoe_fact

6. **"Compare 5G vs 4G customer experience metrics"**
   - Expected: Side-by-side comparison
   - Data: network_qoe_fact

### Geographic Analysis

7. **"Show me QoE metrics by city"**
   - Expected: Geographic performance map
   - Data: network_qoe_fact, ran_site_dim

8. **"Which cells need capacity upgrades based on customer experience?"**
   - Expected: Priority list for network investment
   - Data: network_qoe_fact, ran_cell_dim

---

## Key Insights to Highlight

- 5G delivers 5-10x better speeds than 4G
- Video quality strongly correlated with customer satisfaction
- Geographic variations in network experience
- App-specific performance requirements

---

## SQL Examples

```sql
-- Speed by network generation
SELECT 
    connection_type,
    COUNT(*) as measurements,
    ROUND(AVG(download_speed_mbps), 2) as avg_download,
    ROUND(AVG(upload_speed_mbps), 2) as avg_upload,
    ROUND(AVG(latency_ms), 1) as avg_latency,
    ROUND(AVG(video_quality_score), 2) as avg_video_quality
FROM network_qoe_fact
WHERE measurement_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY connection_type
ORDER BY avg_download DESC;

-- QoE by cell with site info
SELECT 
    s.city,
    c.cell_name,
    c.technology,
    COUNT(q.qoe_id) as measurements,
    ROUND(AVG(q.download_speed_mbps), 2) as avg_speed,
    ROUND(AVG(q.video_quality_score), 2) as video_quality
FROM network_qoe_fact q
JOIN ran_cell_dim c ON q.cell_id = c.cell_id
JOIN ran_site_dim s ON c.site_id = s.site_id
GROUP BY s.city, c.cell_name, c.technology
ORDER BY video_quality ASC
LIMIT 20;

-- Churn risk correlation with QoE
SELECT 
    p.churn_risk_band,
    COUNT(DISTINCT q.subscriber_key) as subscribers,
    ROUND(AVG(q.download_speed_mbps), 2) as avg_speed,
    ROUND(AVG(q.video_quality_score), 2) as avg_video_quality
FROM network_qoe_fact q
JOIN customer_propensity_scores p ON q.subscriber_key = p.subscriber_key
GROUP BY p.churn_risk_band
ORDER BY p.churn_risk_band;
```

---

## Demo Flow

1. Show overall network performance metrics
2. Compare 5G vs 4G experience
3. Identify underperforming areas
4. Correlate with customer churn risk
5. Demonstrate investment prioritization
