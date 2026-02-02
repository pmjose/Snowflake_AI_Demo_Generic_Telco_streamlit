# Incident Management Process
**SnowTelco Communications - ITIL-Aligned Incident Management**

## Purpose

This document defines the incident management process for SnowTelco, ensuring rapid restoration of normal service operation while minimising business impact.

---

## Scope

This process applies to:
- All network infrastructure incidents
- Platform and application incidents
- Customer-impacting service degradations
- Security incidents (initial response)

---

## Definitions

| Term | Definition |
|------|------------|
| **Incident** | Unplanned interruption or reduction in quality of a service |
| **Major Incident** | Incident with significant business impact requiring coordinated response |
| **MTTR** | Mean Time to Resolve |
| **MTTA** | Mean Time to Acknowledge |

---

## Incident Priority Matrix

### Impact vs Urgency

| | High Urgency | Medium Urgency | Low Urgency |
|---|---|---|---|
| **High Impact** | P1 - Critical | P2 - High | P3 - Medium |
| **Medium Impact** | P2 - High | P3 - Medium | P4 - Low |
| **Low Impact** | P3 - Medium | P4 - Low | P4 - Low |

### Impact Definitions

| Level | Customer Impact | Revenue Impact |
|-------|-----------------|----------------|
| High | >1,000 customers or VIP | >£10,000/hour |
| Medium | 100-1,000 customers | £1,000-£10,000/hour |
| Low | <100 customers | <£1,000/hour |

### Urgency Definitions

| Level | Service Affected | Workaround |
|-------|------------------|------------|
| High | Core service completely unavailable | None available |
| Medium | Service degraded or partial outage | Limited workaround |
| Low | Minor degradation | Full workaround available |

---

## Priority SLAs

| Priority | Response | Update | Resolution | Escalation |
|----------|----------|--------|------------|------------|
| P1 - Critical | 15 min | 30 min | 4 hours | Immediate to Director |
| P2 - High | 30 min | 1 hour | 8 hours | 1 hour to Manager |
| P3 - Medium | 4 hours | 4 hours | 24 hours | 4 hours to Team Lead |
| P4 - Low | 8 hours | 24 hours | 72 hours | 24 hours |

---

## Incident Lifecycle

### 1. Detection and Logging

**Sources:**
- Automated monitoring alerts
- Customer contact (phone, email, chat)
- Partner reports
- Internal staff reports
- Social media monitoring

**Required Information:**
- Date/time of report
- Reporter details
- Service affected
- Symptoms described
- Customer impact
- Any recent changes

### 2. Categorisation

**Service Categories:**
| Category | Examples |
|----------|----------|
| Voice Services | Horizon, SIP Trunks, Teams Phone |
| Contact Centre | Horizon Contact, Cirrus, Amazon Connect |
| Connectivity | Broadband, Ethernet, SD-WAN |
| Mobile | Consumer mobile, roaming |
| Security | Cyber security services |
| IT Systems | Internal applications |

### 3. Prioritisation

Apply the Impact vs Urgency matrix to determine priority. Consider:
- Number of affected users/customers
- Revenue impact
- Regulatory implications
- SLA commitments
- Time of day (business hours vs overnight)

### 4. Initial Diagnosis

**L1 Troubleshooting (First 15 minutes):**
1. Review monitoring dashboards
2. Check for related alarms
3. Review recent changes
4. Check vendor status pages
5. Perform basic diagnostics
6. Attempt known fixes

**If unresolved, escalate to L2.**

### 5. Investigation and Diagnosis

**L2/L3 Activities:**
1. Deep technical analysis
2. Log file review
3. Packet captures if needed
4. Vendor engagement
5. Root cause identification
6. Solution development

### 6. Resolution and Recovery

**Resolution Steps:**
1. Implement fix
2. Verify service restoration
3. Confirm with customer/monitoring
4. Document resolution steps
5. Update knowledge base

### 7. Incident Closure

**Closure Criteria:**
- Service restored to normal operation
- Customer confirmed resolution (for customer-reported)
- Root cause documented
- Prevention measures identified
- All ticket fields completed

---

## Major Incident Process

### Declaration Criteria

A Major Incident should be declared when:
- P1 priority confirmed
- Multiple services affected
- Significant customer impact (>1,000)
- Potential regulatory/media attention
- Executive decision

### Major Incident Roles

| Role | Responsibility |
|------|----------------|
| **Incident Commander** | Overall coordination, decisions, communications |
| **Technical Lead** | Technical investigation and resolution |
| **Communications Lead** | Customer and internal updates |
| **Scribe** | Document timeline and actions |

### Major Incident Bridge

**Standing Bridge:** +44 800 123 4567, PIN: 12345

**Bridge Etiquette:**
- Mute when not speaking
- State name before speaking
- Keep updates brief
- Avoid side conversations
- Focus on resolution

### Communication Cadence

| Audience | Frequency | Channel |
|----------|-----------|---------|
| Technical Team | Continuous | Bridge call |
| Executive Team | 30 minutes | Email + Slack |
| Customer Services | 15 minutes | Email + Teams |
| Customers | 30 minutes | Status page + Email |

---

## Post-Incident Review

### Timeline

| Activity | Deadline |
|----------|----------|
| Preliminary RCA | 24 hours (P1), 48 hours (P2) |
| Full RCA Report | 5 working days |
| Action Items Assigned | 5 working days |
| Action Items Completed | As per priority |

### RCA Template

1. **Executive Summary**
2. **Timeline of Events**
3. **Root Cause Analysis (5 Whys)**
4. **Customer Impact**
5. **Financial Impact**
6. **What Went Well**
7. **What Could Be Improved**
8. **Action Items**
9. **Lessons Learned**

---

## Escalation Procedures

### Technical Escalation Path

```
L1 NOC Engineer
    ↓ (15 min P1, 30 min P2)
L2 Senior Engineer
    ↓ (30 min P1, 1 hr P2)
L3 Principal Engineer
    ↓ (1 hr P1, 2 hr P2)
L4 Vendor/Specialist
```

### Management Escalation Path

```
NOC Manager
    ↓ (30 min P1)
Network Director
    ↓ (1 hr P1)
CTO
    ↓ (2 hr P1)
CEO
```

### When to Escalate

- SLA target approaching
- Technical expertise needed
- Customer pressure
- Resource constraints
- No progress in expected timeframe

---

## Metrics and Reporting

### Key Performance Indicators

| KPI | Target | Measurement |
|-----|--------|-------------|
| MTTA (P1) | <15 min | Monthly average |
| MTTR (P1) | <4 hours | Monthly average |
| MTTR (P2) | <8 hours | Monthly average |
| First Contact Resolution | >40% | Monthly |
| SLA Compliance | >95% | Monthly |
| Customer Satisfaction | >4.0/5.0 | Quarterly |

### Reports

| Report | Frequency | Audience |
|--------|-----------|----------|
| Daily Incident Summary | Daily | NOC, Management |
| Weekly Incident Review | Weekly | Operations Team |
| Monthly Incident Analysis | Monthly | Leadership |
| Quarterly Trend Report | Quarterly | Executive |

---

## Tools

| Tool | Purpose | Access |
|------|---------|--------|
| ServiceNow | Ticket management | All support staff |
| PagerDuty | Alerting and escalation | NOC, On-call |
| Confluence | Documentation | All staff |
| Slack | Communication | All staff |
| StatusPage | Customer communication | NOC, Comms |

---

## Training Requirements

| Role | Required Training |
|------|-------------------|
| L1 Engineer | ITIL Foundation, Product training |
| L2 Engineer | ITIL Practitioner, Advanced product |
| NOC Manager | ITIL Service Operation, Leadership |
| Incident Commander | Major Incident Management |

---

**Document Owner**: Service Operations  
**Last Updated**: January 2025  
**Review Cycle**: Quarterly  
**Classification**: Internal
