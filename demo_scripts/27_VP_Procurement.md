# Demo Script 27: VP Procurement & Vendor Management

## Persona
**Role:** VP Procurement / Head of Vendor Management  
**Focus:** Vendor spend, supplier relationships, contract management, cost optimization  
**Duration:** 10 minutes

**Semantic Views Used:** FINANCE_SEMANTIC_VIEW, ASSET_SEMANTIC_VIEW

**Data Sources:** finance_transactions_fact, vendor_dim, purchase_order_fact

**Key Documents:** Procurement_Policy.md, Vendor_Management_Policy.md, AWS/Microsoft/Cisco Partnership Agreements

## Background
The VP Procurement manages SnowTelco's vendor relationships and £100M+ annual spend across technology, network equipment, professional services, and facilities. Key focus areas include cost optimization, vendor consolidation, contract compliance, and supplier risk management.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco uses AI-powered spend analytics to optimize vendor relationships, identify savings opportunities, and ensure procurement compliance across our supplier base."

---

### Question 1: Vendor Spend Overview
**Ask:** "What is our total vendor spend by category? Show me the top spending areas and approval status."

**Expected Insight:**
- Total spend by category (Technology, Network, Services, Facilities)
- Top vendors by spend
- Approved vs pending vs rejected transactions
- Month-over-month trends

**Talking Point:**
> "Technology and Network represent 70% of our vendor spend. We're focused on consolidating suppliers in these categories."

---

### Question 2: Top Vendors Analysis
**Ask:** "Who are our top 10 vendors by spend? Show me vendor names, total spend, and transaction counts."

**Expected Insight:**
- Top vendors ranked by spend
- Transaction volume by vendor
- Spend concentration analysis
- Strategic vs tactical vendors

**Talking Point:**
> "Our top 5 vendors account for 60% of spend. Concentration risk is a factor, but we benefit from volume discounts."

---

### Question 3: Procurement Method Analysis
**Ask:** "How is our spend distributed by procurement method? Show me RFP, contract, emergency, and quote-based purchases."

**Expected Insight:**
- Spend by procurement method
- Emergency purchase percentage (should be <5%)
- Contract compliance rate
- Competitive bid coverage

**Talking Point:**
> "92% of spend goes through approved procurement channels. We're working to reduce emergency purchases below 3%."

---

### Question 4: Department Spend
**Ask:** "What's our vendor spend by department? Which departments have the highest expenses?"

**Expected Insight:**
- Spend by department
- Budget vs actual by department
- Approval rates by department
- Category preferences by department

**Talking Point:**
> "Network Operations has the highest spend due to infrastructure investments. IT is our fastest growing category."

---

### Question 5: Approval Pipeline
**Ask:** "What's the status of our purchase approvals? Show me pending, approved, and rejected transactions."

**Expected Insight:**
- Approval status distribution
- Pending transaction value
- Average approval time
- Rejection reasons

**Talking Point:**
> "We maintain a 48-hour approval SLA for standard purchases. High-value items require additional review."

---

### Question 6: Vendor Contract Terms (Document Search)
**Ask:** "What are the key terms in our strategic vendor contracts? Show me our AWS, Microsoft, and Cisco agreements."

**Expected Insight:**
- Contract summaries from vendor agreement documents
- Key commercial terms
- SLA commitments
- Renewal dates

**Talking Point:**
> "The agent can also search our vendor contracts to provide context on commercial terms and commitments."

---

### Question 7: Cost Optimization Opportunities
**Ask:** "Where can we optimize vendor spend? Show me duplicate vendors, small transactions, and consolidation opportunities."

**Expected Insight:**
- Vendors with overlapping capabilities
- Small-value transactions (<£1000)
- One-time vs recurring spend
- P-card opportunity analysis

**Talking Point:**
> "We've identified £2M in potential savings through vendor consolidation and payment term optimization."

---

### Closing (1 minute)
> "With AI-powered spend analytics, SnowTelco can optimize vendor relationships, ensure procurement compliance, and identify savings opportunities. Strategic sourcing driven by data."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Total Spend | Total vendor expenditure | finance_transactions_fact |
| Vendor Count | Number of active vendors | vendor_dim |
| Transaction Count | Number of purchase transactions | finance_transactions_fact |
| Avg Transaction | Average transaction value | finance_transactions_fact |
| Approval Rate | % transactions approved | finance_transactions_fact |
| Emergency % | Emergency purchase percentage | finance_transactions_fact |
| Contract Coverage | % spend under contract | finance_transactions_fact |

---

## SQL Examples

```sql
-- Vendor spend summary
SELECT 
    v.vendor_name,
    v.vertical as category,
    COUNT(f.transaction_id) as transactions,
    SUM(f.amount) as total_spend,
    ROUND(AVG(f.amount), 2) as avg_transaction
FROM finance_transactions_fact f
JOIN vendor_dim v ON f.vendor_key = v.vendor_key
WHERE f.transaction_type = 'Expense'
GROUP BY v.vendor_name, v.vertical
ORDER BY total_spend DESC
LIMIT 20;

-- Spend by procurement method
SELECT 
    procurement_method,
    COUNT(*) as transactions,
    SUM(amount) as total_spend,
    ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER(), 1) as pct_of_spend
FROM finance_transactions_fact
WHERE transaction_type = 'Expense'
GROUP BY procurement_method
ORDER BY total_spend DESC;

-- Department spend analysis
SELECT 
    department,
    COUNT(*) as transactions,
    SUM(amount) as total_spend,
    ROUND(AVG(amount), 2) as avg_transaction,
    SUM(CASE WHEN approval_status = 'Approved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as approval_rate
FROM finance_transactions_fact
WHERE transaction_type = 'Expense'
GROUP BY department
ORDER BY total_spend DESC;

-- Approval pipeline
SELECT 
    approval_status,
    COUNT(*) as transactions,
    SUM(amount) as total_value,
    ROUND(AVG(amount), 2) as avg_value
FROM finance_transactions_fact
WHERE transaction_type = 'Expense'
    AND transaction_date >= DATEADD(month, -1, CURRENT_DATE)
GROUP BY approval_status
ORDER BY total_value DESC;

-- Small transaction analysis (consolidation opportunity)
SELECT 
    CASE 
        WHEN amount < 100 THEN 'Under £100'
        WHEN amount < 500 THEN '£100-500'
        WHEN amount < 1000 THEN '£500-1000'
        WHEN amount < 5000 THEN '£1000-5000'
        ELSE 'Over £5000'
    END as transaction_band,
    COUNT(*) as transactions,
    SUM(amount) as total_spend
FROM finance_transactions_fact
WHERE transaction_type = 'Expense'
GROUP BY transaction_band
ORDER BY transactions DESC;
```

---

**Demo Duration:** 10 minutes  
**Audience:** VP Procurement, Sourcing Managers, Finance Leaders  
**Key Message:** Strategic procurement through spend intelligence
