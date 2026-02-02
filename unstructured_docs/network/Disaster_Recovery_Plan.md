# Disaster Recovery Plan
**SnowTelco Communications - Business Continuity**

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 3.0 | January 2025 | IT Operations | Annual review |
| 2.5 | July 2024 | IT Operations | Cloud DR updates |
| 2.0 | January 2024 | IT Operations | Major revision |

**Classification**: Confidential  
**Review Cycle**: Annual (or after major incident)

---

## Executive Summary

This Disaster Recovery Plan (DRP) defines the procedures for recovering SnowTelco's critical IT systems and network infrastructure following a disaster or major incident. The plan ensures business continuity and minimises customer impact.

### Recovery Objectives

| Objective | Target |
|-----------|--------|
| **RTO** (Recovery Time Objective) | 4 hours (critical), 24 hours (standard) |
| **RPO** (Recovery Point Objective) | 1 hour (critical), 24 hours (standard) |
| **MTPD** (Max Tolerable Period of Disruption) | 72 hours |

---

## Scope

### In Scope
- Core network infrastructure
- Voice platforms (Horizon, SIP)
- Customer portals and apps
- Billing and CRM systems
- Data centres (London, Manchester, Glasgow)
- Cloud services (AWS, Azure)

### Out of Scope
- End-user devices
- Third-party services (vendor DR plans apply)
- Physical office facilities (separate BCP)

---

## Disaster Classification

### Level 1 - Localised Incident
- Single system or service affected
- <100 customers impacted
- Recovery within normal operations
- Example: Server failure, application crash

### Level 2 - Significant Incident
- Multiple systems affected
- 100-1000 customers impacted
- DR team activation required
- Example: Data centre power issue, network outage

### Level 3 - Major Disaster
- Critical infrastructure failure
- >1000 customers impacted
- Full DR plan activation
- Example: Data centre loss, cyber attack, natural disaster

---

## DR Team Structure

### DR Steering Committee

| Role | Name | Contact |
|------|------|---------|
| DR Director | Sarah Chen (CTO) | +44 7700 900010 |
| IT Operations Lead | James Wilson | +44 7700 900011 |
| Network Operations Lead | Emma Thompson | +44 7700 900012 |
| Business Continuity Lead | Michael Brown | +44 7700 900013 |

### DR Response Team

| Role | Responsibility |
|------|----------------|
| **Incident Commander** | Overall coordination |
| **Technical Lead** | Technical recovery execution |
| **Communications Lead** | Stakeholder updates |
| **Logistics Lead** | Resources and facilities |
| **Documentation Lead** | Timeline and decisions |

---

## Critical Systems Inventory

### Tier 1 - Critical (RTO: 4 hours)

| System | RPO | DR Site | Technology |
|--------|-----|---------|------------|
| Voice Platform (Horizon) | 1 hr | Manchester | Active-Active |
| SIP Trunking | 1 hr | Manchester | Active-Active |
| Core Network | 1 hr | Manchester | Active-Passive |
| Billing System | 1 hr | AWS | Multi-AZ |
| Customer Portal | 1 hr | AWS | Multi-Region |

### Tier 2 - Important (RTO: 24 hours)

| System | RPO | DR Site | Technology |
|--------|-----|---------|------------|
| CRM | 4 hr | AWS | Daily backup |
| Email System | 4 hr | Azure | Geo-redundant |
| ERP | 24 hr | On-prem | Daily backup |
| HR System | 24 hr | Cloud | Daily backup |

### Tier 3 - Standard (RTO: 72 hours)

| System | RPO | DR Site | Technology |
|--------|-----|---------|------------|
| Reporting/BI | 24 hr | AWS | Weekly backup |
| Development Systems | 24 hr | Various | As needed |
| Archive Systems | 7 days | Tape | Weekly |

---

## Data Centre Configuration

### Primary: London (LD4)

| Component | Capacity | Redundancy |
|-----------|----------|------------|
| Compute | 500 servers | N+1 |
| Storage | 2 PB | RAID, replication |
| Network | 100 Gbps | Dual carriers |
| Power | 5 MW | 2N UPS, generator |
| Cooling | N+1 | Redundant CRAC |

### Secondary: Manchester (MA1)

| Component | Capacity | Redundancy |
|-----------|----------|------------|
| Compute | 350 servers | N+1 |
| Storage | 1.5 PB | RAID, replication |
| Network | 50 Gbps | Dual carriers |
| Power | 3 MW | N+1 UPS, generator |
| Cooling | N+1 | Redundant CRAC |

### Tertiary: Glasgow (GL1)

| Component | Capacity | Purpose |
|-----------|----------|---------|
| Compute | 100 servers | DR only |
| Storage | 500 TB | Backup target |
| Network | 10 Gbps | DR traffic |

---

## Recovery Procedures

### Phase 1: Assessment (0-30 minutes)

1. **Receive Alert**
   - NOC detects incident
   - Initial assessment performed
   - DR team notified

2. **Impact Assessment**
   - Identify affected systems
   - Estimate customer impact
   - Classify disaster level

3. **Declaration Decision**
   - DR Director decides on activation
   - Communicate to stakeholders
   - Activate DR team

### Phase 2: Activation (30 min - 2 hours)

1. **Notify DR Team**
   - Call tree activation
   - Assemble response team
   - Open command centre

2. **Assess DR Site Readiness**
   - Verify DR systems available
   - Check data replication status
   - Confirm network connectivity

3. **Execute Recovery Runbooks**
   - Follow system-specific procedures
   - Document all actions
   - Update stakeholders every 30 min

### Phase 3: Recovery (2-4 hours)

1. **System Recovery**
   - Restore Tier 1 systems first
   - Validate functionality
   - Perform data integrity checks

2. **Network Failover**
   - Update DNS records
   - Reroute traffic
   - Verify connectivity

3. **Application Testing**
   - Run smoke tests
   - Verify integrations
   - Test customer access

### Phase 4: Validation (4-8 hours)

1. **Service Verification**
   - Monitor for errors
   - Check performance
   - Validate SLA compliance

2. **Customer Communication**
   - Update status page
   - Notify key customers
   - Prepare public statement

3. **Stabilisation**
   - Address issues
   - Optimise performance
   - Increase monitoring

### Phase 5: Return to Normal

1. **Primary Site Recovery**
   - Repair/rebuild primary
   - Test thoroughly
   - Plan failback window

2. **Failback Execution**
   - Migrate services back
   - Verify functionality
   - Update documentation

3. **Post-Incident Review**
   - Conduct lessons learned
   - Update DR plan
   - Implement improvements

---

## Communication Plan

### Internal Communication

| Audience | Channel | Frequency | Owner |
|----------|---------|-----------|-------|
| DR Team | Bridge Call | Continuous | IC |
| Executives | Email + Call | 30 min | Comms Lead |
| All Staff | Email + Slack | 1 hour | Comms Lead |
| NOC | Bridge Call | Continuous | Tech Lead |

### External Communication

| Audience | Channel | Frequency | Approval |
|----------|---------|-----------|----------|
| Enterprise Customers | Email + Phone | 30 min | Account Mgr |
| All Customers | Status Page | 30 min | Comms Lead |
| Media | Press Release | As needed | Marketing |
| Regulators | Email | Within 24 hrs | Legal |

### Status Page

URL: status.snowtelco.com

Update template:
```
[TIME] - [STATUS]
We are currently experiencing [issue description].
Impact: [affected services]
Current Status: [Investigating/Identified/Monitoring/Resolved]
Next Update: [time]
```

---

## Testing Schedule

### Test Types

| Type | Frequency | Scope | Duration |
|------|-----------|-------|----------|
| Tabletop Exercise | Quarterly | Process review | 2 hours |
| Component Test | Monthly | Individual systems | 4 hours |
| Partial Failover | Bi-annual | Tier 1 systems | 8 hours |
| Full DR Test | Annual | All systems | 24 hours |

### 2025 Test Schedule

| Date | Type | Systems | Lead |
|------|------|---------|------|
| Feb 15 | Tabletop | All | BC Lead |
| Mar 22 | Component | Voice Platform | Network Ops |
| May 10 | Partial | Tier 1 | IT Ops |
| Aug 23 | Component | Billing | IT Ops |
| Oct 18 | Tabletop | All | BC Lead |
| Nov 15 | Full DR | All | DR Director |

---

## Vendor Contacts

| Vendor | Service | Emergency Contact | SLA |
|--------|---------|-------------------|-----|
| Equinix | Data Centre | +44 800 XXX XXXX | 4 hr |
| BT | Connectivity | +44 800 XXX XXXX | 4 hr |
| AWS | Cloud | Support Console | 15 min |
| Microsoft | Azure/O365 | Support Portal | 1 hr |
| Cisco | Network | TAC | 4 hr |

---

## Appendices

### Appendix A: Call Tree

[Diagram of notification cascade]

### Appendix B: System Runbooks

| System | Location |
|--------|----------|
| Voice Platform | Confluence > DR > Runbooks > Voice |
| Billing | Confluence > DR > Runbooks > Billing |
| Network | Confluence > DR > Runbooks > Network |

### Appendix C: Emergency Contacts

[Full contact list - restricted distribution]

### Appendix D: Site Access Procedures

[Physical access requirements for each site]

---

**Document Owner**: IT Operations  
**Emergency Contact**: +44 800 123 9999  
**DR Bridge**: +44 800 123 4567 PIN 99999  
**Classification**: Confidential
