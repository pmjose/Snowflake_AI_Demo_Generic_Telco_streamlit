# Demo Script 21: VP Enterprise Sales

## Persona
**Role:** VP Enterprise Sales  
**Focus:** B2B contract renewals, enterprise revenue retention, competitive threats  
**Duration:** 10 minutes

## Background
The VP Enterprise Sales manages SnowTelco's B2B portfolio including UCaaS, CCaaS, SIP Trunking, SD-WAN, and Managed Security solutions. The team focuses on protecting and growing enterprise revenue through proactive renewal management, competitive positioning, and upsell/cross-sell opportunities.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco manages our enterprise contract portfolio - identifying at-risk renewals, competitive threats, and expansion opportunities worth millions in annual contract value."

---

### Question 1: Portfolio Overview
**Ask:** "What is our total B2B contract portfolio value by product type and renewal status?"

**Expected Insight:**
- Total ACV (Annual Contract Value) by product
- Breakdown by renewal status (Active, Pending, In Negotiation, Churned)
- Contract term distribution
- Regional concentration

**Talking Point:**
> "Our UCaaS and CCaaS products represent the largest share of enterprise revenue. Let's drill into the renewal pipeline."

---

### Question 2: Renewal Pipeline
**Ask:** "Show me contracts coming up for renewal in the next 90 days with their renewal probability."

**Expected Insight:**
- Contracts by days to renewal
- Renewal probability distribution
- Total at-risk ACV
- Account manager workload

**Talking Point:**
> "Contracts with probability below 70% need immediate attention. That's where we focus our retention efforts."

---

### Question 3: Competitive Threats
**Ask:** "Which contracts have competitive threats and who are we losing deals to?"

**Expected Insight:**
- High threat accounts and values
- Competitor breakdown (BT, Vodafone, Virgin Media O2, etc.)
- Threat level by product type
- Impact on renewal probability

**Talking Point:**
> "BT and Vodafone are our biggest competitive threats in enterprise. We need differentiated value propositions for these accounts."

---

### Question 4: Upsell Opportunities
**Ask:** "What upgrade and expansion opportunities do we have in the renewal pipeline?"

**Expected Insight:**
- Proposed upgrades vs downgrades
- Potential value change (positive/negative)
- Cross-sell opportunities
- NPS correlation with upsell

**Talking Point:**
> "High NPS customers are 3x more likely to upgrade. Our customer success program is paying dividends."

---

### Question 5: At-Risk Analysis
**Ask:** "What is our total at-risk contract value and what's driving churn risk?"

**Expected Insight:**
- Total ACV with renewal probability < 70%
- Correlation with support tickets
- NPS impact on churn
- Industry-specific patterns

**Talking Point:**
> "£X million in ACV is at risk. The common thread? High support ticket volume and low NPS. We're deploying customer success managers to these accounts."

---

### Closing (1 minute)
> "With AI-driven renewal analytics, SnowTelco can proactively identify at-risk contracts worth millions in ACV, understand competitive dynamics, and prioritize retention and expansion efforts for maximum revenue impact."

---

## Key Metrics Reference

| Metric | Description |
|--------|-------------|
| ACV | Annual Contract Value |
| TCV | Total Contract Value |
| Renewal Probability | ML-predicted likelihood of renewal (0-1) |
| Days to Renewal | Days until contract end date |
| At-Risk ACV | ACV where probability < 70% |
| Competitor Threat | Threat level (None, Low, Medium, High) |
| NPS | Net Promoter Score (1-10) |

---

## SQL Examples

```sql
-- Renewal pipeline summary
SELECT 
    renewal_status,
    COUNT(*) as contracts,
    SUM(annual_contract_value) as total_acv,
    AVG(renewal_probability) as avg_probability
FROM b2b_contract_fact
GROUP BY renewal_status
ORDER BY total_acv DESC;

-- At-risk contracts by competitor
SELECT 
    competitor_name,
    COUNT(*) as threatened_contracts,
    SUM(annual_contract_value) as at_risk_acv,
    AVG(renewal_probability) as avg_probability
FROM b2b_contract_fact
WHERE competitor_threat IN ('Medium', 'High')
GROUP BY competitor_name
ORDER BY at_risk_acv DESC;

-- Contracts expiring in 90 days
SELECT 
    contract_id,
    account_name,
    contract_type,
    annual_contract_value,
    renewal_probability,
    competitor_threat,
    days_to_renewal
FROM b2b_contract_fact
WHERE days_to_renewal <= 90 AND days_to_renewal > 0
ORDER BY annual_contract_value DESC;
```
