# Demo Script 22: VP Wholesale & MVNO Partnerships

## Persona
**Role:** VP Wholesale & MVNO Partnerships  
**Focus:** MVNO traffic, wholesale revenue, partner settlements  
**Duration:** 10 minutes

**Semantic Views Used:** WHOLESALE_MVNO_SEMANTIC_VIEW

**Data Sources:** mvno_partner_dim, mvno_traffic_fact, mvno_settlement_fact

**Key Documents:** MVNO_Partnership_Guide.md

## Background
The VP Wholesale manages SnowTelco's role as an MNO (Mobile Network Operator) providing network capacity to MVNO (Mobile Virtual Network Operator) partners. This includes managing wholesale agreements, traffic volumes, settlement processes, and partner relationships with virtual operators like Giffgaff, Lebara, Lycamobile, and others.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco manages our wholesale business - tracking MVNO partner traffic, revenue, settlements, and identifying opportunities to grow this strategic revenue stream."

---

### Question 1: MVNO Portfolio Overview
**Ask:** "What is our total MVNO partner portfolio and wholesale revenue by partner?"

**Expected Insight:**
- Number of active MVNO partners
- Total wholesale revenue
- Revenue breakdown by partner
- Subscriber counts by MVNO

**Talking Point:**
> "Our top 3 MVNOs - Tesco Mobile, Lebara, and Lycamobile - represent 60% of wholesale revenue. Diversification is a priority."

---

### Question 2: Traffic Analysis
**Ask:** "Show me MVNO traffic trends - voice, SMS, and data volumes by partner."

**Expected Insight:**
- Monthly traffic volumes (voice minutes, SMS, data GB)
- Traffic mix by network type (3G/4G/5G)
- Peak hour utilization
- YoY growth rates

**Talking Point:**
> "Data traffic is growing 40% YoY while voice declines. Our wholesale pricing model needs to reflect this shift."

---

### Question 3: Revenue by Traffic Type
**Ask:** "What's our wholesale revenue breakdown by voice, SMS, and data?"

**Expected Insight:**
- Revenue split (voice, SMS, data, interconnect)
- Average rates by traffic type
- Revenue per subscriber trends
- Margin analysis

**Talking Point:**
> "Data now represents 55% of wholesale revenue, up from 40% two years ago. The 5G premium is driving value."

---

### Question 4: Settlement Performance & Overdue Tracking
**Ask:** "Show me overdue MVNO settlements - which partners have overdue payments and how many days overdue?"

**Expected Insight:**
- Overdue settlements count and total value
- Days overdue by partner
- Settlement status distribution (Paid, Pending, Overdue)
- Total outstanding amounts
- Minimum commitment shortfalls

**Talking Point:**
> "With the new overdue tracking, we can identify partners consistently late on payments and take proactive action."

---

### Question 5: Partner Performance & Growth
**Ask:** "Which MVNO partners are growing fastest and which are underperforming their commitments?"

**Expected Insight:**
- Subscriber growth by partner
- Revenue growth trends
- Minimum commitment attainment
- New partner pipeline

**Talking Point:**
> "Digital-native MVNOs targeting youth segments are our fastest growing partners. Traditional ethnic-focused MVNOs face headwinds."

---

### Question 6: Partnership Terms (Document Search)
**Ask:** "What are our wholesale pricing tiers and minimum commitment terms for different MVNO types?"

**Expected Insight:**
- Pricing from MVNO_Partnership_Guide.md
- Voice/SMS/Data rates by MVNO type
- Minimum commitment levels
- Settlement terms (30-day payment)

**Talking Point:**
> "The agent can also search our partnership documentation to provide context on commercial terms."

---

### Closing (1 minute)
> "SnowTelco's wholesale business generates significant recurring revenue with minimal customer acquisition cost. With AI-powered analytics, we can optimize partner mix, pricing strategies, and settlement processes to maximize this strategic revenue stream."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Wholesale Revenue | Revenue from MVNO network usage | mvno_traffic_fact |
| Voice Minutes | Minutes of voice traffic | mvno_traffic_fact |
| SMS Count | Number of SMS messages | mvno_traffic_fact |
| Data (GB) | Data traffic in gigabytes | mvno_traffic_fact |
| Active Subscribers | MVNO subscribers on SnowTelco network | mvno_traffic_fact |
| Settlement Amount | Monthly settlement value | mvno_settlement_fact |
| Minimum Commitment | Contractual minimum payment | mvno_settlement_fact |
| Shortfall | Gap vs minimum commitment | mvno_settlement_fact |
| Is Overdue | Whether settlement is past due | mvno_settlement_fact |
| Days Overdue | Number of days past due date | mvno_settlement_fact |
| MVNO Partner Count | Number of active MVNOs | mvno_partner_dim |

---

## SQL Examples

```sql
-- MVNO revenue summary
SELECT 
    m.mvno_name,
    m.mvno_type,
    SUM(t.total_revenue) as wholesale_revenue,
    SUM(t.data_gb) as total_data_gb,
    SUM(t.active_subscribers) as total_subs
FROM mvno_traffic_fact t
JOIN mvno_partner_dim m ON t.mvno_id = m.mvno_id
GROUP BY m.mvno_name, m.mvno_type
ORDER BY wholesale_revenue DESC;

-- Monthly traffic trends
SELECT 
    traffic_month,
    SUM(voice_minutes) as voice,
    SUM(sms_count) as sms,
    SUM(data_gb) as data_gb,
    SUM(total_revenue) as revenue
FROM mvno_traffic_fact
GROUP BY traffic_month
ORDER BY traffic_month;

-- Settlement status
SELECT 
    m.mvno_name,
    s.settlement_month,
    s.total_charges,
    s.minimum_commitment,
    s.shortfall_charge,
    s.payment_status
FROM mvno_settlement_fact s
JOIN mvno_partner_dim m ON s.mvno_id = m.mvno_id
WHERE s.payment_status != 'Paid'
ORDER BY s.total_charges DESC;
```
