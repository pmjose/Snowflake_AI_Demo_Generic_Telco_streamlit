# CFO Demo Script (10 Minutes)
## SnowTelco UK - Financial Performance & Analysis

---

## Persona: Chief Financial Officer

**Focus Areas:** Revenue, margins, ARPU trends, billing efficiency, cost management, vendor spend, compliance

**Semantic Views Used:** FINANCE, BILLING, MOBILE, SALES

---

## Opening (1 minute)

**Presenter Says:**
"As CFO, you need complete visibility into SnowTelco's financial health - from high-level revenue trends down to individual transaction details. This platform provides that visibility in natural language, connecting our financial data with supporting documents."

---

## Demo Questions

### Question 1: Revenue by Customer Type
> "Show me our revenue breakdown by customer type - Consumer, SMB, and Enterprise - with average bill amounts."

**Expected Insights:**
- Revenue split: Consumer (~70%) vs SMB (~26%) vs Enterprise (~4%)
- Average bill amount by customer type (Enterprise highest at £100+)
- Total monthly revenue trends
- Revenue per segment tier (Budget/Standard/Premium/VIP)

**Talking Point:** "Complete revenue visibility by customer type - our B2B segment delivers significantly higher ARPU."

---

### Question 2: ARPU Deep Dive
> "What's our ARPU by customer type and segment? Show me Consumer vs SMB vs Enterprise, and break down by value tier."

**Expected Insights:**
- ARPU by customer type: Enterprise (~£100-150) > SMB (~£50-80) > Consumer (~£25-40)
- ARPU by segment: VIP > Premium > Standard > Budget
- ARPU trends by month
- Plan type impact on ARPU

**Talking Point:** "Understanding ARPU drivers helps us optimize pricing and focus on high-value segments."

---

### Question 3: Billing & Payment Status
> "What's our payment status distribution? Show me Paid vs Pending vs Overdue by customer type."

**Expected Insights:**
- Payment status breakdown: ~70% Paid, ~20% Pending, ~10% Overdue
- Payment status by customer type
- Payment status by segment
- Overdue trends over time

**Talking Point:** "Healthy collections are critical for cash flow - B2B customers typically have better payment performance."

---

### Question 4: Cost Management
> "What are our top vendor expenses by department and what's the approval status?"

**Expected Insights:**
- Vendor spend by category
- Approval status distribution (Approved/Pending/Rejected)
- Procurement method breakdown (RFP, Contract, Emergency)
- Department-level spend analysis

**Talking Point:** "Vendor spend visibility helps us negotiate better terms and ensure compliance."

---

### Question 5: Revenue at Risk
> "What revenue is at risk from churned customers? Show me lifetime value lost by customer type and segment."

**Expected Insights:**
- Total lifetime value lost to churn
- Churned revenue by customer type
- High-value segment churn (Premium/VIP)
- Competitor destinations for churned customers

**Talking Point:** "Understanding revenue at risk helps us prioritize retention investments."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform enables:
- Complete revenue visibility across all product lines
- ARPU analysis at segment and plan level
- Collections and cash flow monitoring
- Vendor spend management
- Financial compliance oversight

Real-time financial intelligence for better decision-making."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Revenue by Type | Consumer / SMB / Enterprise revenue | mobile_usage_fact.bill_amount |
| ARPU | Average bill by customer type & segment | mobile_usage_fact.bill_amount |
| Payment Status | Paid / Pending / Overdue distribution | mobile_usage_fact.payment_status |
| Lifetime Value | Revenue at risk from churn | mobile_churn_fact.lifetime_value |
| Vendor Spend | By category and vendor | finance_transactions, vendor_dim |
| Approval Status | Transaction compliance | finance_transactions.approval_status |

---

**Demo Duration:** 10 minutes  
**Audience:** CFO, Finance Directors, Controllers  
**Key Message:** Financial visibility and control
