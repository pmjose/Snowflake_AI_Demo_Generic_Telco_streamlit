# VP Billing & Revenue Demo Script (10 Minutes)
## SnowTelco UK - Billing Operations & Revenue Assurance

---

## Persona: VP Billing & Revenue / Director of Revenue Management

**Focus Areas:** Billing accuracy, payment status, revenue assurance, dispute management

**Semantic Views Used:** BILLING, MOBILE, REVENUE_ASSURANCE, DISPUTE

---

## Opening (1 minute)

**Presenter Says:**
"As VP Billing & Revenue, you're responsible for ensuring every pound owed is billed and collected. This platform gives you complete visibility into billing performance, payment status, and revenue assurance - helping you maximize revenue capture."

---

## Demo Questions

### Question 1: Billing Dashboard
> "Show me our billing performance - total invoices, amount billed, and average invoice value."

**Expected Insights:**
- Total invoices generated
- Total amount billed (£)
- Average invoice value
- Invoice status distribution (Paid, Pending, Overdue)
- Invoices by customer type

**Talking Point:** "Every bill must be accurate and timely - it's the foundation of customer trust."

---

### Question 2: Payment Status Analysis
> "What's our payment status distribution? Show me Paid vs Pending vs Overdue by customer type."

**Expected Insights:**
- Payment status breakdown (Paid, Pending, Overdue)
- Payment status by customer type (Consumer, SMB, Enterprise)
- Revenue at risk from overdue payments
- Payment status trends over time

**Talking Point:** "Understanding payment status helps prioritize collections efforts."

---

### Question 3: Revenue Assurance
> "Are there any revenue leakage risks? Show me unbilled usage, credit notes, and adjustments."

**Expected Insights:**
- Total unbilled usage value (revenue leakage)
- Unbilled usage by type (Data Overage, Roaming, Premium Services)
- Reasons for unbilled usage (Mediation Delay, Rating Error)
- Credit notes issued and reasons
- Billing adjustments by type

**Talking Point:** "Revenue assurance catches leakage before it impacts the P&L."

---

### Question 4: Credit Note Analysis
> "How many credit notes have we issued? Show me amounts by reason and approval status."

**Expected Insights:**
- Total credits issued (£)
- Credit notes by reason (Billing Error, Outage, Goodwill)
- Average credit amount
- Approval status distribution
- Credits by customer segment

**Talking Point:** "Understanding credit patterns helps identify systemic billing issues."

---

### Question 5: Billing Disputes
> "Show me our billing disputes - volumes, categories, and resolution times."

**Expected Insights:**
- Total disputes by category (Incorrect Charge, Service Not Received, Rate Dispute)
- Average disputed amount
- Average days to resolve
- Resolution outcomes (Full Credit, Partial Credit, No Action)
- SLA compliance for dispute resolution

**Talking Point:** "Resolving billing issues quickly protects customer relationships."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Complete billing performance visibility
- Payment status tracking
- Revenue assurance monitoring
- Credit note analysis
- Billing dispute management

Revenue protection through data-driven billing operations."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Total Billed | Monthly invoice amount | invoice_fact |
| Payment Status | Paid/Pending/Overdue | mobile_usage_fact |
| Unbilled Revenue | Revenue leakage | unbilled_usage_fact |
| Credits Issued | Credit note amounts | credit_note_fact |
| Adjustments | Billing corrections | billing_adjustment_fact |
| Disputes | Billing complaints | dispute_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** VP Billing, Revenue Managers, Collections Managers  
**Key Message:** Revenue protection through billing excellence
