# Demo Script 25: VP Legal & General Counsel

## Persona
**Role:** VP Legal / General Counsel  
**Focus:** Contracts, regulatory compliance, disputes, risk management  
**Duration:** 10 minutes

**Semantic Views Used:** B2B_CONTRACT_SEMANTIC_VIEW, COMPLAINT_SEMANTIC_VIEW, SLA_SEMANTIC_VIEW, FINANCE_SEMANTIC_VIEW

**Data Sources:** b2b_contract_fact, complaint_fact, sla_measurement_fact, contract_dim, legal_matter_fact

**Key Documents:** GDPR_Compliance_Framework.md, Ofcom_Annual_Compliance_Report.md, vendor_contracts/*.md

## Background
The VP Legal oversees SnowTelco's legal affairs including commercial contracts, regulatory compliance, dispute resolution, and corporate governance. Key focus areas include contract portfolio management, Ofcom regulatory compliance, customer disputes, and litigation risk.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco uses AI-powered analytics to manage legal risk, track contract obligations, monitor regulatory compliance, and identify potential disputes before they escalate."

---

### Question 1: Contract Portfolio Overview
**Ask:** "What is our B2B contract portfolio? Show me total contract value, contracts by status, and upcoming renewals in the next 90 days."

**Expected Insight:**
- Total contract value (TCV) and annual contract value (ACV)
- Contracts by status (Active, Pending, In Negotiation)
- Contracts expiring in next 90 days
- High-value contracts at risk

**Talking Point:**
> "We have £50M+ in annual contract value. 15 contracts worth £8M are up for renewal in the next quarter - these need legal review."

---

### Question 2: Regulatory Complaints Analysis
**Ask:** "Show me our formal complaint trends - how many Ofcom escalations and ombudsman cases do we have? What are the main complaint categories?"

**Expected Insight:**
- Total complaints by type (Ofcom, Ombudsman, Internal)
- Complaint categories (Billing, Service, Contract Terms, Privacy)
- Resolution rates and average resolution time
- Compensation paid

**Talking Point:**
> "Ofcom escalations are down 15% YoY. Contract Terms complaints are our fastest growing category - we may need to review our T&Cs."

---

### Question 3: SLA Compliance & Breach Risk
**Ask:** "What's our SLA compliance rate? Show me any breaches and potential financial exposure from SLA credits."

**Expected Insight:**
- Overall SLA attainment percentage
- Breaches by SLA category
- Financial exposure from credits
- Trending issues

**Talking Point:**
> "We're at 98.5% SLA compliance. Network availability breaches in Q4 resulted in £150K in credits - a legal review of force majeure clauses is warranted."

---

### Question 4: Vendor Contract Terms (Document Search)
**Ask:** "What are the key liability and indemnity terms in our strategic vendor contracts? Search our AWS and Microsoft agreements."

**Expected Insight:**
- Liability caps from vendor agreements
- Indemnification clauses
- Termination provisions
- Data protection obligations

**Talking Point:**
> "The agent can search our executed contracts to surface specific legal terms - useful for quick reference during negotiations."

---

### Question 5: GDPR & Data Protection Compliance
**Ask:** "What is our GDPR compliance framework? Show me our data protection obligations and any privacy-related complaints."

**Expected Insight:**
- GDPR framework summary from compliance document
- Privacy-related complaints count
- Data subject rights obligations
- Breach notification requirements

**Talking Point:**
> "Privacy complaints represent 5% of our total complaints. Our GDPR framework requires 72-hour breach notification - we've had zero reportable breaches."

---

### Question 6: Legal Matters & Disputes
**Ask:** "What active legal matters do we have? Show me open disputes, litigation status, and potential financial exposure."

**Expected Insight:**
- Active legal matters by type
- Dispute status (Open, Under Review, Settled)
- Financial reserves/exposure
- Priority matters

**Talking Point:**
> "We have 12 active matters with £2M potential exposure. 3 are employment disputes, 5 are customer contract disputes."

---

### Question 7: Contract Risk Assessment
**Ask:** "Which B2B contracts have the highest risk? Show me contracts with competitor threats, low renewal probability, or support issues."

**Expected Insight:**
- Contracts with competitor threat (High/Medium)
- Low renewal probability contracts
- Contracts with high support tickets
- Recommended actions

**Talking Point:**
> "5 contracts worth £3M have high competitor threat. Legal should review retention terms and any exclusivity provisions."

---

### Closing (1 minute)
> "With AI-powered legal analytics, SnowTelco can proactively manage contract risk, ensure regulatory compliance, and identify disputes early. Legal intelligence driven by data."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Total Contract Value | Sum of all contract values | b2b_contract_fact |
| Annual Contract Value | Yearly contract revenue | b2b_contract_fact |
| Ofcom Complaints | Regulatory escalations | complaint_fact |
| SLA Attainment | Compliance percentage | sla_measurement_fact |
| Breach Credits | Financial exposure from SLA breaches | sla_measurement_fact |
| Legal Matters | Active disputes/litigation | legal_matter_fact |
| Privacy Complaints | GDPR-related issues | complaint_fact |

---

## SQL Examples

```sql
-- Contract portfolio summary
SELECT 
    renewal_status,
    COUNT(*) as contracts,
    SUM(annual_contract_value) as total_acv,
    SUM(total_contract_value) as total_tcv
FROM b2b_contract_fact
GROUP BY renewal_status
ORDER BY total_acv DESC;

-- Contracts expiring in 90 days
SELECT 
    account_name,
    contract_type,
    contract_end_date,
    annual_contract_value,
    renewal_probability,
    competitor_threat
FROM b2b_contract_fact
WHERE contract_end_date BETWEEN CURRENT_DATE AND DATEADD(day, 90, CURRENT_DATE)
ORDER BY annual_contract_value DESC;

-- Regulatory complaints
SELECT 
    escalation_type,
    category,
    COUNT(*) as complaints,
    AVG(resolution_days) as avg_resolution_days,
    SUM(compensation_amount) as total_compensation
FROM complaint_fact
WHERE escalation_type IN ('Ofcom', 'Ombudsman')
GROUP BY escalation_type, category
ORDER BY complaints DESC;

-- SLA breach analysis
SELECT 
    s.sla_name,
    s.sla_category,
    COUNT(*) as measurements,
    SUM(CASE WHEN m.is_breach = TRUE THEN 1 ELSE 0 END) as breaches,
    SUM(m.credit_amount) as total_credits
FROM sla_measurement_fact m
JOIN sla_dim s ON m.sla_key = s.sla_key
GROUP BY s.sla_name, s.sla_category
ORDER BY total_credits DESC;

-- High-risk contracts
SELECT 
    account_name,
    contract_type,
    annual_contract_value,
    renewal_probability,
    competitor_threat,
    competitor_name,
    days_to_renewal
FROM b2b_contract_fact
WHERE competitor_threat IN ('High', 'Medium')
   OR renewal_probability < 0.5
ORDER BY annual_contract_value DESC;

-- Legal matters summary
SELECT 
    matter_type,
    status,
    COUNT(*) as matters,
    SUM(potential_exposure) as total_exposure,
    SUM(reserved_amount) as total_reserved
FROM legal_matter_fact
WHERE status != 'Closed'
GROUP BY matter_type, status
ORDER BY total_exposure DESC;
```

---

**Demo Duration:** 10 minutes  
**Audience:** VP Legal, General Counsel, Compliance Officers  
**Key Message:** Proactive legal risk management through data intelligence
