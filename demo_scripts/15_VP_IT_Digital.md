# VP IT & Digital Demo Script (10 Minutes)
## SnowTelco UK - IT Operations & Service Management

---

## Persona: VP IT / Director of IT Operations

**Focus Areas:** IT incident management, SLA compliance, application health, service delivery

**Semantic Views Used:** IT_OPS, SLA, CUSTOMER_EXPERIENCE

---

## Opening (1 minute)

**Presenter Says:**
"As VP IT, you're responsible for the systems that power SnowTelco - from billing platforms to customer-facing apps. This platform gives you visibility into incident management, SLA compliance, and service delivery performance."

---

## Demo Questions

### Question 1: IT Incident Dashboard
> "Show me our open IT incidents by severity - how many P1, P2, P3, P4 issues do we have?"

**Expected Insights:**
- Open incidents by severity (P1, P2, P3, P4)
- Incident count by status (Open, Resolved, Closed)
- Most affected applications
- Average resolution time by severity

**Talking Point:** "Real-time visibility into IT incidents enables faster response."

---

### Question 2: Incident Resolution Performance
> "What's our Mean Time to Resolve (MTTR) by severity? Are we meeting our SLA targets?"

**Expected Insights:**
- MTTR by severity (P1: 4hr target, P2: 8hr, P3: 24hr, P4: 72hr)
- SLA compliance rate by severity
- Incidents resolved within SLA vs breached
- Resolution time trends

**Talking Point:** "Meeting SLA targets is critical - we track every minute."

---

### Question 3: Root Cause Analysis
> "What are the main root causes of our IT incidents? Show me categories and patterns."

**Expected Insights:**
- Incidents by root cause category
- Root cause distribution (Hardware, Software, Network, Human Error)
- Repeat incidents by root cause
- Root cause trends over time

**Talking Point:** "Understanding root causes helps prevent future incidents."

---

### Question 4: Application Health
> "Which applications have the most incidents? Show me the top affected systems."

**Expected Insights:**
- Incidents by application
- Critical applications with open issues
- Application criticality distribution
- Incident severity by application

**Talking Point:** "Focusing on high-impact applications protects business operations."

---

### Question 5: SLA Compliance Overview
> "How are we performing against our SLAs? Show me attainment rates and any breaches."

**Expected Insights:**
- SLA attainment percentage by category
- Total SLA breaches this month
- Breach minutes and trends
- Credits applicable from breaches
- Best and worst performing SLAs

**Talking Point:** "SLA delivery builds trust with the business and customers."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time IT incident visibility
- Resolution time tracking against SLA
- Root cause analysis for prevention
- Application health monitoring
- SLA compliance management

IT service excellence through data-driven management."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Incidents | Open by severity | it_incident_fact |
| MTTR | Mean Time to Resolve | it_incident_fact |
| SLA Met | Resolution within target | it_incident_fact |
| Root Cause | Incident categories | it_incident_fact |
| SLA Attainment | % SLAs met | sla_measurement_fact |
| Application | Affected systems | it_application_dim |

---

**Demo Duration:** 10 minutes  
**Audience:** VP IT, IT Directors, Service Managers  
**Key Message:** IT service excellence through incident management
