# Demo Script 14: Field Operations Analytics

## Persona: VP of Field Operations

**Name:** Mark Thompson  
**Role:** VP of Field Operations  
**Focus:** Workforce optimization, SLA compliance, cost management, first-time fix rates

**Key Documents:** Field_Operations_Handbook.md

---

## Background

Mark manages SnowTelco's field workforce of 200+ technicians. He needs to optimize scheduling, improve first-time fix rates, reduce costs, and ensure SLA compliance for customer visits and network maintenance.

---

## Demo Questions

### Workforce Performance

1. **"What's our overall first-time fix rate?"**
   - Expected: FTF rate metric (target >85%)
   - Data: field_visit_fact

2. **"Show me technician performance rankings"**
   - Expected: Leaderboard by CSAT and FTF
   - Data: field_visit_fact, technician_dim

3. **"Which technicians have the highest customer satisfaction scores?"**
   - Expected: Top performers
   - Data: field_visit_fact, technician_dim

### SLA & Efficiency

4. **"What's our SLA compliance rate by region?"**
   - Expected: Regional SLA performance
   - Data: field_visit_fact, technician_dim

5. **"Show me the average delay time by visit type"**
   - Expected: Punctuality analysis
   - Data: field_visit_fact

6. **"How many visits were rescheduled last month and why?"**
   - Expected: Reschedule analysis
   - Data: field_visit_fact

### Cost Analysis

7. **"What's the average cost per visit by type?"**
   - Expected: Cost breakdown
   - Data: field_visit_fact

8. **"Which visit types have the highest parts costs?"**
   - Expected: Parts usage analysis
   - Data: field_visit_fact

9. **"Show me the trend in field visit volume over the past year"**
   - Expected: Demand forecasting data
   - Data: field_visit_fact

### Field Operations Standards (Document Search)

10. **"What are our field technician KPI targets and safety requirements?"**
    - Expected: Standards from Field_Operations_Handbook.md
    - Insights: First Time Fix target (90%), Jobs per Day target (6), Safety protocols

11. **"What is our escalation process for field visits?"**
    - Expected: Escalation criteria from handbook
    - Data: Field_Operations_Handbook.md

---

## Key Insights to Highlight

- First-time fix rate drives customer satisfaction (target 90%)
- SLA compliance varies by region (target 95%)
- Parts costs significant for emergency repairs
- Technician skill level impacts outcomes
- Field Operations Handbook provides standards and escalation procedures

---

## SQL Examples

```sql
-- Overall field operations KPIs
SELECT 
    COUNT(*) as total_visits,
    ROUND(SUM(CASE WHEN first_time_fix THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as ftf_rate,
    ROUND(SUM(CASE WHEN sla_met THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as sla_compliance,
    ROUND(AVG(CASE WHEN outcome = 'Completed' THEN csat_score END), 2) as avg_csat,
    ROUND(AVG(total_cost), 2) as avg_cost_per_visit
FROM field_visit_fact
WHERE visit_date >= DATEADD(month, -1, CURRENT_DATE);

-- Technician performance ranking
SELECT 
    t.technician_name,
    t.skill_level,
    t.region,
    COUNT(f.visit_id) as visits,
    ROUND(SUM(CASE WHEN f.first_time_fix THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as ftf_rate,
    ROUND(AVG(f.csat_score), 2) as avg_csat,
    ROUND(AVG(f.delay_mins), 1) as avg_delay
FROM field_visit_fact f
JOIN technician_dim t ON f.technician_id = t.technician_id
WHERE f.visit_date >= DATEADD(month, -3, CURRENT_DATE)
GROUP BY t.technician_name, t.skill_level, t.region
HAVING COUNT(*) >= 10
ORDER BY avg_csat DESC, ftf_rate DESC
LIMIT 20;

-- Cost analysis by visit type
SELECT 
    visit_type,
    COUNT(*) as visits,
    ROUND(AVG(labor_cost), 2) as avg_labor_cost,
    ROUND(AVG(parts_cost), 2) as avg_parts_cost,
    ROUND(AVG(total_cost), 2) as avg_total_cost,
    ROUND(SUM(total_cost), 0) as total_spend
FROM field_visit_fact
WHERE visit_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY visit_type
ORDER BY total_spend DESC;

-- SLA compliance by region
SELECT 
    t.region,
    COUNT(f.visit_id) as visits,
    ROUND(SUM(CASE WHEN f.sla_met THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as sla_rate,
    ROUND(AVG(f.delay_mins), 1) as avg_delay_mins
FROM field_visit_fact f
JOIN technician_dim t ON f.technician_id = t.technician_id
GROUP BY t.region
ORDER BY sla_rate DESC;
```

---

## Demo Flow

1. Show overall field operations dashboard
2. Review technician performance rankings
3. Analyze SLA compliance by region
4. Examine cost drivers
5. Discuss optimization opportunities
