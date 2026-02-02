# VP Customer Service Demo Script (10 Minutes)
## SnowTelco UK - Customer Service Excellence

---

## Persona: VP Customer Service / Director of Customer Experience

**Focus Areas:** Contact centre operations, ticket management, CSAT, complaint handling, service quality

**Semantic Views Used:** SUPPORT, SUPPORT_TICKET, COMPLAINT, MOBILE

---

## Opening (1 minute)

**Presenter Says:**
"As VP Customer Service, you're responsible for every customer interaction at SnowTelco. This platform gives you real-time visibility into contact centre performance, ticket resolution, and customer satisfaction - helping you deliver exceptional service."

---

## Demo Questions

### Question 1: Contact Centre Performance
> "Show me our contact centre performance - average handle time, wait time, and CSAT scores by queue."

**Expected Insights:**
- Average handle time by queue
- Average wait time trends
- CSAT scores by queue (1-5 scale)
- Call volume by queue type (Billing, Technical, Sales, Retention)
- Disposition breakdown (Resolved, Callback, Voicemail)

**Talking Point:** "Real-time visibility helps us manage capacity and meet service levels."

---

### Question 2: Support by Customer Type
> "How does our support performance differ between Consumer and B2B customers? Show me CSAT and handle times."

**Expected Insights:**
- CSAT by customer type (Consumer vs B2B)
- Handle time by customer type
- Queue distribution by customer type
- Business queue performance

**Talking Point:** "B2B customers have different support needs - we track performance separately."

---

### Question 3: Ticket Analysis
> "What are the top support ticket categories? Show me ticket volumes and resolution times by category."

**Expected Insights:**
- Tickets by category
- Average resolution time by category
- First response time
- Priority distribution (P1/P2/P3/P4)
- Channel breakdown (Phone, Email, Chat, Portal)

**Talking Point:** "Understanding contact reasons helps us fix root causes and reduce volume."

---

### Question 4: Complaint Management
> "Show me our formal complaint volumes and resolution times. What are the main complaint categories?"

**Expected Insights:**
- Complaint volume trends
- Complaint categories
- Average resolution time
- Compensation amounts paid
- Ombudsman escalation rate

**Talking Point:** "Complaint handling is critical for reputation and regulatory compliance."

---

### Question 5: Agent Performance
> "Who are our top performing agents by CSAT? Show me agent rankings and team performance."

**Expected Insights:**
- Agent CSAT rankings
- Team performance comparison
- Handle time by agent/team
- Skill group performance

**Talking Point:** "Great service comes from great people - we recognize and develop our best performers."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time contact centre monitoring
- Root cause analysis of customer issues
- CSAT tracking at every level
- Complaint management visibility
- Agent performance insights

Customer service excellence through data."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Service Level | % calls answered in target | contact_center_call_fact |
| AHT | Average Handle Time | contact_center_call_fact |
| CSAT | Customer Satisfaction Score | support_ticket_fact, contact_center_call_fact |
| Resolution Time | Ticket close time | support_ticket_fact |
| Complaint Rate | Complaints per 1000 subs | complaint_fact |
| Escalation Rate | % escalated to Ombudsman | complaint_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** VP Customer Service, Contact Centre Managers, Quality Leads  
**Key Message:** Customer service excellence through visibility
