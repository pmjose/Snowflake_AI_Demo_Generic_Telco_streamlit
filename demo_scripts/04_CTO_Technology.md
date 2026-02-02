# CTO Demo Script (10 Minutes)
## SnowTelco UK - Technology & Network Strategy

---

## Persona: Chief Technology Officer

**Focus Areas:** Network strategy, 5G rollout, IT systems, technology investments, innovation, digital transformation

**Semantic Views Used:** NETWORK_OPS, NETWORK_QOE, IT_OPS, SLA, RAN

**Key Documents:** Digital_Transformation_Roadmap_2026.md, IT_Architecture_Overview.md

---

## Opening (1 minute)

**Presenter Says:**
"As CTO, you're driving SnowTelco's technology strategy - from 5G rollout to IT modernization. This platform gives you visibility across our entire technology estate, connecting network performance with business outcomes."

---

## Demo Questions

### Question 1: Network Infrastructure Performance
> "Show me our network performance metrics by city - availability, latency, and throughput. Which cities have the best and worst performance?"

**Expected Insights:**
- Network availability by city (target 99%+)
- Average latency by region (~25ms)
- Throughput capacity (Gbps)
- Top and bottom performing cities
- Regional patterns (London/SE, Midlands, North, Scotland)

**Talking Point:** "Complete visibility into network health across all UK regions - identifying where we need investment."

---

### Question 2: 5G Rollout Status
> "What's our 5G rollout status by region? Show me sites that are live, in progress, and planned."

**Expected Insights:**
- 5G site count by deployment status (Live, In Progress, Planned)
- Regional 5G coverage percentages
- Go-live timeline for planned sites
- 4G vs 5G site distribution

**Talking Point:** "5G is our strategic priority - tracking deployment progress across all regions."

---

### Question 3: Network Element Utilization
> "Which network elements have the highest utilization? Show me capacity hotspots that may need upgrades."

**Expected Insights:**
- Element utilization percentages
- High-utilization elements (>60%)
- Element types with capacity constraints
- Geographic distribution of hotspots

**Talking Point:** "Proactive capacity planning prevents performance degradation before it impacts customers."

---

### Question 4: IT Application Health
> "What's the status of our critical IT systems? Show me open incidents by severity and resolution times."

**Expected Insights:**
- Open incidents by severity (P1/P2/P3/P4)
- Mean time to resolve (MTTR)
- Most affected applications
- Root cause analysis

**Talking Point:** "IT system health directly impacts customer experience - we're tracking every incident."

---

### Question 5: Network Quality of Experience
> "What's the customer experience quality on our network? Show me download speeds, latency, and video quality scores by connection type."

**Expected Insights:**
- Average download/upload speeds (Mbps)
- Latency performance (ms)
- Video quality scores (1-5)
- Performance by connection type (3G/4G/5G)
- App category performance breakdown

**Talking Point:** "QoE metrics directly correlate with customer satisfaction - we track the experience that matters."

---

### Question 6: Digital Transformation Strategy (Document Search)
> "What are the key initiatives in our digital transformation roadmap for 2026?"

**Expected Insights:**
- Strategic pillars from Digital_Transformation_Roadmap_2026.md
- 5G Standalone deployment timeline
- Cloud migration targets
- AI/ML platform investments
- Technology investment breakdown

**Talking Point:** "The agent can also search internal strategy documents - combining structured data with unstructured insights."

---

### Question 7: Network SLA Compliance
> "Are we meeting our network SLAs? Show me SLA compliance rates and any breaches this month."

**Expected Insights:**
- SLA attainment percentage
- SLA breaches by category
- Breach minutes and credits applicable
- Performance trends over time

**Talking Point:** "SLA delivery is our commitment to customers - we track every metric."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time network performance monitoring by region
- 5G rollout tracking across all deployment stages
- Customer experience quality metrics
- IT system health and incident management
- SLA compliance tracking and breach analysis
- Strategy document search (Digital Transformation Roadmap)

Technology operations visibility at your fingertips - combining structured data with strategic documents."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| Availability | Network uptime % by city | network_performance_fact |
| Latency | Average network latency ms | network_performance_fact |
| Throughput | Network capacity Gbps | network_performance_fact |
| 5G Sites | Count by deployment status | ran_site_dim |
| 5G Coverage | % of sites with 5G | ran_site_dim |
| Download Speed | Average Mbps by connection type | network_qoe_fact |
| Video Quality | Streaming quality score (1-5) | network_qoe_fact |
| MTTR | Mean Time to Resolve | it_incident_fact |
| SLA Compliance | % SLAs met by category | sla_measurement_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** CTO, Technology Directors, Architects  
**Key Message:** Technology strategy visibility and ROI tracking
