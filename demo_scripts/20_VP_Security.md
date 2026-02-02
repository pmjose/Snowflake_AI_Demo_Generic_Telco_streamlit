# Demo Script 20: VP Security & Fraud Prevention

## Persona
**Role:** VP Security & Fraud Prevention  
**Focus:** Fraud detection, loss prevention, security analytics  
**Duration:** 10 minutes

## Background
The VP Security oversees SnowTelco's fraud prevention operations, managing a team that uses ML models, rule engines, and manual review to detect and prevent telecom fraud. Key concerns include SIM swap fraud, subscription fraud, international revenue share fraud (IRSF), and internal fraud.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco's security team uses AI-powered analytics to detect fraud in real-time, quantify losses prevented, and identify patterns across fraud categories."

---

### Question 1: Fraud Overview
**Ask:** "What is our total fraud detection volume by category and what losses have we prevented this year?"

**Expected Insight:**
- Total fraud cases detected
- Breakdown by category (Identity, Traffic, Device, Channel, Internal)
- Total suspected amounts vs actual losses vs prevented losses
- Detection rate and prevention effectiveness

**Talking Point:**
> "Our ML models are catching fraud early - look at the ratio of prevented loss to actual loss. That's the ROI of our detection capabilities."

---

### Question 2: Detection Methods
**Ask:** "How effective are our different detection methods - ML models vs rule engines vs manual review?"

**Expected Insight:**
- Case volume by detection method
- ML model confidence scores
- Time to detection by method
- False positive rates

**Talking Point:**
> "ML models catch 35% of cases with high confidence, but the combination of all methods gives us comprehensive coverage."

---

### Question 3: High-Severity Fraud
**Ask:** "Show me critical and high severity fraud cases - what types are causing the most damage?"

**Expected Insight:**
- SIM swap and account takeover trends
- IRSF and PBX hacking volumes
- Average amounts by severity level
- Geographic hotspots

**Talking Point:**
> "SIM swap and account takeover are our biggest threats - they lead to complete account compromise. We've invested heavily in real-time detection here."

---

### Question 4: Resolution Performance
**Ask:** "What's our fraud case resolution rate and average time to resolution?"

**Expected Insight:**
- Cases by status (Detected, Investigating, Confirmed, Resolved)
- Resolution types (Account Blocked, Refund, Law Enforcement)
- Escalation rates
- Team workload distribution

**Talking Point:**
> "Quick resolution is critical - every hour a fraud case remains open, we're exposed to additional losses."

---

### Question 5: Repeat Offenders & Trends
**Ask:** "Are we seeing repeat offenders and what monthly trends do we have in fraud activity?"

**Expected Insight:**
- Repeat offender percentage
- Month-over-month fraud trends
- Seasonal patterns
- Emerging fraud types

**Talking Point:**
> "Repeat offenders represent 15% of cases but a disproportionate share of losses. Our blocklists and identity verification are key defenses."

---

### Closing (1 minute)
> "With AI-powered fraud detection, SnowTelco prevented over £X million in losses this year. Our multi-layered approach combining ML, rules, and human review ensures we stay ahead of evolving fraud tactics."

---

## Key Metrics Reference

| Metric | Description |
|--------|-------------|
| Fraud Cases | Total detected fraud incidents |
| Suspected Amount | Total value of suspected fraud |
| Actual Loss | Financial loss from undetected/unresolved fraud |
| Prevented Loss | Losses stopped by early detection |
| Detection Rate | % of fraud caught before loss |
| ML Confidence | Model confidence score (0-1) |
| Risk Score | Case risk score (0-100) |

---

## SQL Examples

```sql
-- Fraud summary by category
SELECT 
    ft.category,
    COUNT(*) as cases,
    SUM(suspected_amount) as suspected,
    SUM(actual_loss) as losses,
    SUM(prevented_loss) as prevented
FROM fraud_case_fact f
JOIN fraud_type_dim ft ON f.fraud_type_id = ft.fraud_type_id
GROUP BY ft.category
ORDER BY prevented DESC;

-- Detection method effectiveness
SELECT 
    detection_method,
    COUNT(*) as cases,
    AVG(ml_confidence_score) as avg_confidence,
    SUM(prevented_loss) as total_prevented
FROM fraud_case_fact
GROUP BY detection_method;
```
