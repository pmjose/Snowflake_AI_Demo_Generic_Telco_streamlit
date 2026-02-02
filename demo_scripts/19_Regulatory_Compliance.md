# Regulatory & Compliance Demo Script (10 Minutes)
## SnowTelco UK - Regulatory Compliance & SLA Management

---

## Persona: Head of Regulatory Affairs / Compliance Director

**Focus Areas:** Ofcom compliance, SLA management, GDPR, complaint handling, service quality reporting

**Semantic Views Used:** SLA, COMPLAINT, NETWORK_OPS, MOBILE

---

## Opening (1 minute)

**Presenter Says:**
"As Head of Regulatory Affairs, you're responsible for ensuring SnowTelco meets all regulatory requirements - from Ofcom rules to GDPR. This platform gives you visibility into compliance metrics, SLA performance, and regulatory reporting data."

---

## Demo Questions

### Question 1: Compliance Dashboard
> "Show me our regulatory compliance status - SLA performance, complaint metrics, and any areas of concern."

**Expected Insights:**
- SLA attainment rate overall
- Complaint-to-subscriber ratio
- Ombudsman escalation rate
- Network availability vs licence requirements
- GDPR compliance indicators
- Regulatory reporting status

**Talking Point:** "Compliance visibility prevents regulatory risk and protects our licence."

---

### Question 2: SLA Performance
> "How are we performing against our published SLAs? Show me breach rates and credit liability."

**Expected Insights:**
- SLA attainment by category (Availability, Performance, Support)
- Breach count this period
- Credit value issued
- SLA trend over time
- Worst performing SLAs
- Customer impact analysis

**Talking Point:** "SLA performance is both a customer promise and a regulatory requirement."

---

### Question 3: Complaint Handling
> "Are we meeting Ofcom complaint handling requirements? Show me resolution times and escalation rates."

**Expected Insights:**
- Complaints received this period
- Average resolution time (target: 8 weeks)
- Escalation to ADR/Ombudsman rate
- Complaint categories
- Compensation paid
- Repeat complaint rate

**Talking Point:** "Complaint handling is heavily regulated - we track every case."

---

### Question 4: Network Quality
> "Are we meeting our network quality commitments? Show me coverage, availability, and performance metrics."

**Expected Insights:**
- Population coverage vs commitment
- Network availability vs licence
- Call drop rate
- Data speeds achieved
- Quality of Service metrics
- Geographic performance variation

**Talking Point:** "Network quality directly impacts regulatory compliance and customer satisfaction."

---

### Question 5: Regulatory Reporting
> "What data do we need for our quarterly Ofcom submission? Summarize key metrics."

**Expected Insights:**
- Subscriber counts by type
- Complaint volumes and rates
- Average resolution times
- ADR referral rates
- Network quality metrics
- Price transparency compliance

**Talking Point:** "Automated regulatory reporting ensures accuracy and timeliness."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time compliance monitoring
- SLA performance and breach tracking
- Ofcom complaint handling visibility
- Network quality compliance
- Regulatory reporting automation

Regulatory compliance through data-driven management."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| SLA Attainment | % SLAs met | sla_measurement_fact |
| Complaint Rate | Complaints per 1000 subs | complaint_fact |
| Resolution Time | Average days to resolve | complaint_fact |
| Escalation Rate | % to Ombudsman/ADR | complaint_fact |
| Network Availability | Uptime % | network_performance_fact |
| Coverage | % population covered | mobile_network_dim |

---

## Ofcom Reporting Requirements Reference

| Report | Frequency | Key Metrics |
|--------|-----------|-------------|
| Complaints Data | Quarterly | Volumes, categories, resolution times |
| ADR Referrals | Quarterly | Referral rate, outcomes |
| Quality of Service | Annual | Speed, coverage, availability |
| Pricing Transparency | Annual | Tariff changes, notifications |

---

**Demo Duration:** 10 minutes  
**Audience:** Regulatory Affairs, Compliance Officers, Legal  
**Key Message:** Regulatory compliance through visibility
