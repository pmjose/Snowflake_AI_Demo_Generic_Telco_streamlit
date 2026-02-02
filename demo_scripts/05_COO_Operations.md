# COO Demo Script (10 Minutes)
## SnowTelco UK - Operations Excellence

---

## Persona: Chief Operating Officer

**Focus Areas:** Operational efficiency, process performance, service quality, supply chain, workforce productivity

**Semantic Views Used:** SUPPORT, SUPPORT_TICKET, NETWORK_OPS, NETWORK_ALARM, ACTIVATION, ASSET, ORDER

**Key Documents:** Operational_Excellence_Playbook.md

---

## Opening (1 minute)

**Presenter Says:**
"As COO, you're responsible for operational excellence across SnowTelco. This platform connects all operational data - from contact centres to network operations to supply chain - giving you a single view of operational performance."

---

## Demo Questions

### Question 1: Operational Dashboard
> "Give me a snapshot of our operational performance - contact centre wait times and CSAT, network availability, and SIM activation times."

**Expected Insights:**
- Contact centre: average wait time, CSAT scores by queue
- Network operations: availability percentage, active alarms by severity
- SIM activation: average activation time, pending activations
- Support tickets: open tickets by priority

**Talking Point:** "One question gives you the complete operational health of the business."

---

### Question 2: Contact Centre Performance
> "How is our contact centre performing? Show me handle times, first call resolution rates, and CSAT by team."

**Expected Insights:**
- Average handle time (AHT) by queue
- First call resolution rate
- Customer satisfaction (CSAT) score by team
- Call volume by queue
- Wait times by queue

**Talking Point:** "Contact centre efficiency directly impacts customer satisfaction."

---

### Question 3: Order Fulfilment & Activation
> "What's our SIM activation performance? Show me average activation times by channel and any pending activations."

**Expected Insights:**
- Average time to activate by channel (Retail, Online, Telesales)
- Activation status distribution (Completed vs Pending)
- Activation type breakdown (New, SIM Swap, Replacement)
- Order backlog by status

**Talking Point:** "Fast, accurate order fulfilment drives customer satisfaction and reduces contacts."

---

### Question 4: Asset & Inventory
> "What's our inventory position? Show me stock levels by warehouse and items at risk of stock-out."

**Expected Insights:**
- Device inventory by warehouse
- Stock status distribution (In Stock, Low, Out)
- Items with low stock levels
- Total stock value

**Talking Point:** "Right inventory in the right place - critical for sales and customer satisfaction."

---

### Question 5: Network Operations Health
> "What's the health of our network? Show me availability, alarms by severity, MTTR, and any critical issues."

**Expected Insights:**
- Network availability percentage by element type
- Active alarms by severity (Critical, Major, Minor)
- Mean Time to Repair (MTTR) by severity
- Average alarm duration
- Top alarm types
- Network utilization hotspots

**Talking Point:** "Network reliability is the foundation of customer experience - MTTR is our key operational metric."

---

### Question 6: Operational Excellence Framework (Document Search)
> "What are our operational KPI targets and process standards?"

**Expected Insights:**
- KPI targets from Operational_Excellence_Playbook.md
- Network availability target (99.99%)
- MTTR target (<30 min)
- First Contact Resolution target (75%)
- SLA compliance target (95%)

**Talking Point:** "The agent searches our internal playbooks to provide context alongside the live metrics."

---

## Closing (1 minute)

**Presenter Says:**
"In 10 minutes, you've seen how this platform provides:
- Real-time operational dashboard
- Contact centre performance management
- Order fulfilment and activation tracking
- Inventory and supply chain visibility
- Network operations with MTTR tracking
- Operational playbook integration

Operational excellence driven by data - with targets from our internal standards."

---

## Key Metrics Reference

| Metric | Description | Data Source |
|--------|-------------|-------------|
| AHT | Average Handle Time | contact_center_call_fact |
| FCR | First Call Resolution | contact_center_call_fact |
| CSAT | Customer Satisfaction | contact_center_call_fact |
| Activation Time | Order to activation hours | sim_activation_fact |
| Inventory | Stock by warehouse | inventory_fact |
| Availability | Network uptime % | network_performance_fact |
| MTTR | Mean Time to Repair (minutes) | network_alarm_fact |
| Alarm Duration | Average alarm duration | network_alarm_fact |

---

**Demo Duration:** 10 minutes  
**Audience:** COO, Operations Directors, Process Owners  
**Key Message:** Operational excellence through visibility
