# Network Operations Centre (NOC) Playbook
**SnowTelco Communications - Network Operations**

## Executive Summary

This playbook defines the standard operating procedures for the SnowTelco Network Operations Centre (NOC). It covers monitoring, incident management, escalation procedures, and operational guidelines for maintaining 99.99% network availability.

---

## NOC Overview

### Operating Hours
- **24x7x365** continuous monitoring
- **Three shifts**: Day (06:00-14:00), Evening (14:00-22:00), Night (22:00-06:00)
- **Minimum staffing**: 4 engineers per shift

### NOC Locations
| Location | Role | Staff |
|----------|------|-------|
| London (Primary) | Main NOC | 25 |
| Manchester (Secondary) | Backup NOC | 15 |
| Glasgow (DR) | Disaster Recovery | 8 |

---

## Monitoring Infrastructure

### Network Management Systems

| System | Purpose | Vendor |
|--------|---------|--------|
| SolarWinds NPM | Network Performance | SolarWinds |
| Splunk | Log Analysis | Splunk |
| PagerDuty | Alerting | PagerDuty |
| ServiceNow | Ticketing | ServiceNow |
| Grafana | Dashboards | Grafana Labs |
| Prometheus | Metrics | Open Source |

### Key Dashboards

1. **Executive Dashboard** - High-level KPIs, SLA status
2. **Core Network** - Router/switch health, link utilization
3. **Voice Platform** - SBC status, call volumes, quality
4. **Mobile Network** - eNodeB/gNodeB status, coverage
5. **Customer Impact** - Service-affecting incidents

---

## Alarm Management

### Severity Classification

| Severity | Definition | Response Time | Example |
|----------|------------|---------------|---------|
| **Critical (P1)** | Service down, >1000 customers impacted | Immediate | Core router failure |
| **Major (P2)** | Degraded service, 100-1000 customers | 15 minutes | High packet loss on link |
| **Minor (P3)** | Partial impact, <100 customers | 1 hour | Single site offline |
| **Warning (P4)** | No customer impact, threshold breach | 4 hours | High CPU on device |
| **Info** | Informational only | Next business day | Config change |

### Alarm Thresholds

| Metric | Warning | Minor | Major | Critical |
|--------|---------|-------|-------|----------|
| CPU Utilization | 70% | 80% | 90% | 95% |
| Memory Utilization | 75% | 85% | 92% | 98% |
| Link Utilization | 60% | 75% | 85% | 95% |
| Packet Loss | 0.1% | 0.5% | 1% | 2% |
| Latency (ms) | 50 | 100 | 200 | 500 |

---

## Incident Management Process

### Incident Lifecycle

```
Detection → Triage → Diagnosis → Resolution → Closure → Review
```

### Step 1: Detection
- Automated alarm from NMS
- Customer report via support
- Proactive monitoring detection
- Partner/vendor notification

### Step 2: Triage (First 5 Minutes)
1. Acknowledge alarm in monitoring system
2. Assess customer impact
3. Classify severity (P1-P4)
4. Create incident ticket in ServiceNow
5. Notify relevant teams

### Step 3: Diagnosis
1. Gather diagnostic information
2. Review recent changes
3. Check for related alarms
4. Isolate root cause
5. Document findings

### Step 4: Resolution
1. Implement fix or workaround
2. Verify service restoration
3. Confirm customer impact resolved
4. Update ticket with resolution details

### Step 5: Closure
1. Complete root cause analysis
2. Document lessons learned
3. Identify preventive actions
4. Close ticket

---

## Escalation Matrix

### Technical Escalation

| Level | Timeframe | Role | Contact |
|-------|-----------|------|---------|
| L1 | Immediate | NOC Engineer | noc@snowtelco.com |
| L2 | 15 min (P1), 30 min (P2) | Senior Engineer | noc-senior@snowtelco.com |
| L3 | 30 min (P1), 1 hr (P2) | Principal Engineer | noc-principal@snowtelco.com |
| L4 | 1 hr (P1), 2 hr (P2) | Vendor Support | Per vendor SLA |

### Management Escalation

| Severity | 30 min | 1 hour | 2 hours | 4 hours |
|----------|--------|--------|---------|---------|
| P1 | NOC Manager | Network Director | CTO | CEO |
| P2 | NOC Manager | Network Director | - | CTO |
| P3 | - | NOC Manager | - | - |
| P4 | - | - | - | - |

---

## Major Incident Process

### Major Incident Criteria
- P1 severity
- Multiple services affected
- >1000 customers impacted
- Media/regulatory attention

### Major Incident Bridge

1. **Declare Major Incident** - NOC Manager authority
2. **Open Bridge Call** - Dial: +44 800 123 4567, PIN: 12345
3. **Assign Roles**:
   - Incident Commander (IC)
   - Technical Lead (TL)
   - Communications Lead (CL)
   - Scribe
4. **15-minute updates** minimum
5. **Customer communications** every 30 minutes

### Communication Templates

**Internal Update:**
```
MAJOR INCIDENT UPDATE
Incident: [INC Number]
Time: [HH:MM]
Status: [Investigating/Identified/Monitoring/Resolved]
Impact: [Description]
Next Update: [HH:MM]
Bridge: +44 800 123 4567, PIN 12345
```

**Customer Communication:**
```
SnowTelco Service Update

We are currently investigating an issue affecting [service].
Impact: [Description]
Start Time: [HH:MM]
Current Status: [Status]
Next Update: [Time]

We apologise for any inconvenience.
```

---

## Change Management

### Change Windows
- **Standard Changes**: 02:00-06:00 Tuesday/Thursday
- **Emergency Changes**: Any time with CTO approval
- **Maintenance Windows**: Sunday 02:00-06:00 monthly

### Change Types

| Type | Approval | Lead Time | Rollback Plan |
|------|----------|-----------|---------------|
| Standard | Pre-approved | 5 days | Required |
| Normal | CAB | 10 days | Required |
| Emergency | Manager + CTO | Immediate | Required |

### Pre-Change Checklist
- [ ] Change ticket approved
- [ ] Rollback plan documented
- [ ] Customer notification sent (if required)
- [ ] NOC briefed
- [ ] Monitoring enhanced
- [ ] On-call engineer available

---

## Vendor Management

### Key Vendors

| Vendor | Service | SLA | Escalation |
|--------|---------|-----|------------|
| Cisco | Network Equipment | 4hr NBD | TAC Portal |
| Nokia | Radio Network | 2hr | Nokia Care |
| Ericsson | Core Network | 2hr | GCSB |
| BT Wholesale | PSTN/Numbering | 4hr | BT Portal |
| AWS | Cloud Services | 15min | Support Console |

### Vendor Escalation Process
1. Open ticket via vendor portal
2. Provide diagnostic information
3. Request severity escalation if needed
4. Engage SnowTelco vendor manager for P1/P2

---

## Tools and Access

### Required Access
- SolarWinds NPM (read/write)
- ServiceNow (create/update tickets)
- PagerDuty (acknowledge/resolve)
- Network devices (SSH - change approval required)
- Grafana dashboards (read)

### Useful Commands

**Cisco:**
```
show interface status
show ip route
show processes cpu history
show logging
```

**Juniper:**
```
show interfaces terse
show route
show chassis routing-engine
show log messages
```

---

## Reporting

### Shift Handover
- Completed at each shift change
- Document open incidents
- Highlight risks and upcoming changes
- Update shared handover log

### Daily Reports
- Generated automatically at 08:00
- Sent to: noc-reports@snowtelco.com
- Contains: Incidents, SLA performance, capacity alerts

### Weekly NOC Review
- Every Monday 10:00
- Review major incidents
- Analyse trends
- Plan improvements

---

## Contact List

| Role | Name | Phone | Email |
|------|------|-------|-------|
| NOC Manager | James Wilson | +44 7700 900001 | j.wilson@snowtelco.com |
| Network Director | Sarah Chen | +44 7700 900002 | s.chen@snowtelco.com |
| On-Call Engineer | Rotating | +44 800 999 000 | oncall@snowtelco.com |
| Vendor Manager | Michael Brown | +44 7700 900003 | m.brown@snowtelco.com |

---

**Document Owner**: Network Operations  
**Last Updated**: January 2025  
**Review Cycle**: Quarterly  
**Classification**: Internal
