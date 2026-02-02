# Demo Script 17: Sustainability & ESG Analytics

## Persona: Chief Sustainability Officer (CSO)

**Name:** Dr. Sarah Green  
**Role:** Chief Sustainability Officer  
**Focus:** Carbon reduction, renewable energy, net zero targets, ESG reporting

---

## Background

Sarah leads SnowTelco's sustainability initiatives. She's responsible for achieving net zero targets, reducing carbon footprint, improving energy efficiency, and reporting ESG metrics to investors and regulators.

---

## Demo Questions

### Energy & Carbon

1. **"What's our total energy consumption this year?"**
   - Expected: Energy usage trends
   - Data: sustainability_metrics

2. **"What percentage of our energy comes from renewable sources?"**
   - Expected: Renewable energy progress
   - Data: energy_consumption_fact, sustainability_metrics

3. **"Show me our carbon emissions trend"**
   - Expected: Carbon reduction progress
   - Data: sustainability_metrics

4. **"Which sites consume the most energy?"**
   - Expected: Site-level consumption
   - Data: energy_consumption_fact, ran_site_dim

### Efficiency & Optimization

5. **"What's our average PUE (Power Usage Effectiveness) ratio?"**
   - Expected: Energy efficiency metrics
   - Data: energy_consumption_fact

6. **"Compare energy consumption by site type (Macro vs Small Cell)"**
   - Expected: Site type analysis
   - Data: energy_consumption_fact, ran_site_dim

7. **"Which sites have the highest carbon intensity?"**
   - Expected: Priority sites for green energy
   - Data: energy_consumption_fact

### ESG Progress

8. **"What's our progress toward net zero?"**
   - Expected: Net zero roadmap status
   - Data: sustainability_metrics

9. **"How many customers are on green tariffs?"**
   - Expected: Green product adoption
   - Data: sustainability_metrics

10. **"What's our e-waste recycling rate?"**
    - Expected: Circular economy metrics
    - Data: sustainability_metrics

---

## Key Insights to Highlight

- Renewable energy increasing (40% → 65% over reporting period)
- Carbon emissions decreasing year-over-year
- Small cells are more energy efficient than macro sites
- Net zero progress tracking

---

## SQL Examples

```sql
-- Monthly sustainability overview
SELECT 
    metric_month,
    total_energy_mwh,
    renewable_energy_pct,
    total_carbon_tonnes,
    sustainability_score,
    net_zero_progress_pct
FROM sustainability_metrics
ORDER BY metric_date;

-- Energy consumption by site type
SELECT 
    s.site_type,
    COUNT(DISTINCT s.site_id) as sites,
    ROUND(AVG(e.energy_kwh), 2) as avg_daily_kwh,
    ROUND(AVG(e.renewable_pct), 1) as avg_renewable_pct,
    ROUND(AVG(e.carbon_emissions_kg), 2) as avg_daily_carbon_kg,
    ROUND(AVG(e.pue_ratio), 2) as avg_pue
FROM energy_consumption_fact e
JOIN ran_site_dim s ON e.site_id = s.site_id
WHERE e.measurement_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY s.site_type
ORDER BY avg_daily_kwh DESC;

-- Top energy consuming sites
SELECT 
    s.site_name,
    s.city,
    s.site_type,
    ROUND(SUM(e.energy_kwh), 0) as total_kwh,
    ROUND(AVG(e.renewable_pct), 1) as renewable_pct,
    ROUND(SUM(e.carbon_emissions_kg), 0) as total_carbon_kg
FROM energy_consumption_fact e
JOIN ran_site_dim s ON e.site_id = s.site_id
WHERE e.measurement_date >= DATEADD(month, -3, CURRENT_DATE)
GROUP BY s.site_name, s.city, s.site_type
ORDER BY total_kwh DESC
LIMIT 20;

-- Sites needing green energy transition
SELECT 
    s.site_name,
    s.city,
    ROUND(AVG(e.renewable_pct), 1) as renewable_pct,
    ROUND(SUM(e.grid_kwh), 0) as grid_kwh,
    ROUND(SUM(e.carbon_emissions_kg), 0) as carbon_kg
FROM energy_consumption_fact e
JOIN ran_site_dim s ON e.site_id = s.site_id
WHERE e.measurement_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY s.site_name, s.city
HAVING AVG(e.renewable_pct) < 50
ORDER BY carbon_kg DESC
LIMIT 20;

-- Carbon intensity trend
SELECT 
    metric_month,
    carbon_intensity,
    total_carbon_tonnes,
    renewable_energy_pct
FROM sustainability_metrics
ORDER BY metric_date;

-- Green tariff adoption
SELECT 
    metric_month,
    green_tariff_subscribers,
    ROUND(green_tariff_subscribers * 100.0 / 30000, 1) as adoption_pct
FROM sustainability_metrics
ORDER BY metric_date;
```

---

## Demo Flow

1. Show overall ESG dashboard
2. Energy consumption analysis
3. Carbon footprint tracking
4. Net zero progress
5. Identify optimization opportunities
6. Demonstrate ESG reporting capabilities

---

## Key Metrics for ESG Reporting

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Renewable Energy % | 65% | 100% | On Track |
| Carbon Intensity | 0.18 | 0.10 | Improving |
| PUE Ratio | 1.5 | 1.3 | In Progress |
| E-Waste Recycling | 92% | 95% | On Track |
| Net Zero Progress | 30% | 100% by 2040 | On Track |
