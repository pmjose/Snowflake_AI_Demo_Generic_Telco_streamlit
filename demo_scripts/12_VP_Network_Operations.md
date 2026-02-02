# VP Network Operations Demo Script (10 Minutes)
## SnowTelco UK - Network Performance & Reliability

---

## Persona: VP Network Operations / Head of Network Management Centre

**Focus Areas:** Network availability, alarm management, capacity planning, incident response, SLA delivery

**Semantic Views Used:** NETWORK_OPS, NETWORK_ALARM, SLA, MOBILE, RAN

---

## Opening (1 minute)

**Presenter Says:**
"As VP Network Operations, you're responsible for SnowTelco's network reliability - the foundation of our customer experience. This platform gives you real-time visibility into network health, capacity, and incidents across our entire 4G and 5G estate."

---

## Demo Questions

### Question 1: Network Health Dashboard
> "Show me the current health of our network - average availability, latency, and throughput across all elements."

**Expected Insights:**
- Overall network availability (~99.5-99.9%)
- Average latency (~8-15ms)
- Throughput metrics by element type
- Utilization percentages
- Element status breakdown (Active/Degraded/Maintenance/Offline)

**Talking Point:** "Real-time network health monitoring across our entire infrastructure."

---

### Question 2: Alarm Analysis & MTTR
> "Show me our network alarms - alarm counts by severity, MTTR, and average alarm duration."

**Expected Insights:**
- Alarm volume by severity (Critical, Major, Minor)
- Mean Time to Repair (MTTR) by severity
- Average alarm duration in minutes
- Acknowledged vs unacknowledged alarms
- Top alarm types
- Ticket linkage

**Talking Point:** "MTTR is our key operational metric - tracking repair times by severity helps prioritize resources."

---

### Question 3: Performance by Region
> "How is our network performing by region? Show me availability and latency for London, Manchester, Birmingham, and other major cities."

**Expected Insights:**
- Availability by city/region
- Latency by city/region
- Throughput by city/region
- Best and worst performing regions

**Talking Point:** "Regional performance insights drive our capacity investment decisions."

---

### Question 4: Capacity Utilization
> "Which network elements have the highest utilization? Show me elements above 60% utilization."

**Expected Insights:**
- High utilization elements
- Utilization distribution
- Element types with highest utilization
- Capacity upgrade candidates

**Talking Point:** "Proactive capacity planning ensures we stay ahead of demand."

---

### Question 5: SLA Compliance
> "Are we meeting our SLAs? Show me SLA measurements - how many met versus breached this month."

**Expected Insights:**
- SLA attainment rate
- Breaches by SLA category
- Breach minutes total
- Credits applicable
- SLA trends over time

**Talking Point:** "SLA delivery is our commitment to customers - we track every metric."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time network health monitoring
- Alarm analysis with MTTR tracking
- Performance metrics across all technologies
- Capacity planning intelligence
- SLA tracking and breach management

Network excellence through data-driven operations - with MTTR as our key metric."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Availability | Network uptime % | network_performance_fact |
| MTTA | Mean Time to Acknowledge | network_alarm_fact |
| MTTR | Mean Time to Resolve | network_alarm_fact |
| Throughput | Average Gbps | network_performance_fact |
| Latency | Average ms | network_performance_fact |
| Utilization | Capacity usage % | network_performance_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** VP Network Ops, NOC Managers, Capacity Planners  
**Key Message:** Network excellence through real-time visibility
