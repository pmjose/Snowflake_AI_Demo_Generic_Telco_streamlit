# Demo Script 23: VP Retail Operations

## Persona
**Role:** VP Retail Operations  
**Focus:** Store performance, sales, footfall, conversion  
**Duration:** 10 minutes

## Background
The VP Retail Operations manages SnowTelco's network of 170 retail stores across the UK, including flagship stores, standard high street locations, express stores, and kiosks. Key focus areas include sales performance, footfall conversion, staffing, and store profitability.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco manages our retail network of 170 stores - tracking sales performance, footfall patterns, and conversion rates to optimize store operations and drive revenue."

---

### Question 1: Network Overview
**Ask:** "What is our total retail sales revenue by store type and region?"

**Expected Insight:**
- Total retail revenue
- Breakdown by store type (Flagship, Standard, Express, Kiosk)
- Regional performance comparison
- Store count by type

**Talking Point:**
> "Our flagship stores generate 3x the revenue of standard stores, but standard stores deliver better per-square-foot performance."

---

### Question 2: Product Mix
**Ask:** "What are our top selling product categories and how do contract vs PAYG sales compare?"

**Expected Insight:**
- Sales by product category (Handsets, SIM Only, Accessories)
- Contract vs PAYG mix
- Average transaction values
- Trade-in volumes

**Talking Point:**
> "Handsets drive 30% of transactions but represent more value. Accessories are high margin opportunities we're expanding."

---

### Question 3: Footfall & Conversion
**Ask:** "What are our footfall trends and conversion rates by store type?"

**Expected Insight:**
- Weekly footfall patterns
- Conversion rates (typically 15-35%)
- Weekend vs weekday performance
- Weather impact on traffic

**Talking Point:**
> "Conversion is our key lever - improving from 20% to 25% across the network would add millions in revenue."

---

### Question 4: Store Performance
**Ask:** "Which stores are our top and bottom performers by sales per square foot?"

**Expected Insight:**
- Top performing stores
- Underperforming locations
- Sales per sqft benchmarks
- Regional variations

**Talking Point:**
> "Our London flagship leads on absolute revenue, but Reading Express delivers the best ROI on space."

---

### Question 5: Staff Performance
**Ask:** "How are retail staff performing in terms of commission and sales per employee?"

**Expected Insight:**
- Average sales per staff member
- Commission distribution
- Top performers
- Training correlation

**Talking Point:**
> "Our top 20% of staff generate 50% of sales. Their techniques inform our training programs."

---

### Closing (1 minute)
> "With 170 stores generating significant revenue, retail remains a critical channel for SnowTelco. AI-powered analytics help us optimize store mix, staffing, and inventory to maximize returns."

---

## Key Metrics Reference

| Metric | Description |
|--------|-------------|
| Sales Revenue | Total retail sales value |
| Footfall | Store visitor count |
| Conversion Rate | Transactions / Visitors |
| ATV | Average Transaction Value |
| Sales/SqFt | Revenue per square foot |
| Commission | Staff commission earned |

---

## SQL Examples

```sql
-- Sales by store type and region
SELECT 
    s.store_type,
    s.region,
    COUNT(DISTINCT s.store_id) as stores,
    SUM(r.total_amount) as revenue,
    AVG(r.total_amount) as avg_transaction
FROM retail_sales_fact r
JOIN retail_store_dim s ON r.store_id = s.store_id
GROUP BY s.store_type, s.region
ORDER BY revenue DESC;

-- Footfall and conversion by day of week
SELECT 
    day_of_week,
    SUM(visitor_count) as visitors,
    SUM(transaction_count) as transactions,
    ROUND(AVG(conversion_rate) * 100, 1) as avg_conversion_pct
FROM retail_footfall_fact
GROUP BY day_of_week
ORDER BY CASE day_of_week 
    WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 
    WHEN 'Wednesday' THEN 3 WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6 
    WHEN 'Sunday' THEN 7 END;

-- Top stores by sales per sqft
SELECT 
    s.store_name,
    s.store_type,
    s.city,
    s.store_sqft,
    SUM(r.total_amount) as revenue,
    ROUND(SUM(r.total_amount) / s.store_sqft, 2) as revenue_per_sqft
FROM retail_sales_fact r
JOIN retail_store_dim s ON r.store_id = s.store_id
GROUP BY s.store_name, s.store_type, s.city, s.store_sqft
ORDER BY revenue_per_sqft DESC
LIMIT 10;
```
