# Change Management Process
**SnowTelco Communications - IT Service Management**

## Purpose

This document defines the change management process for SnowTelco, ensuring that changes to IT systems and infrastructure are implemented with minimal risk and disruption.

---

## Scope

### In Scope

- Production IT systems
- Network infrastructure
- Voice and data platforms
- Customer-facing applications
- Security systems
- Cloud infrastructure

### Out of Scope

- Development/test environments (unless impacting production)
- User desktop software (covered by standard changes)
- Content changes (marketing website)

---

## Change Types

### Standard Changes

Pre-approved, low-risk, routine changes.

| Change | Pre-Approval | Example |
|--------|--------------|---------|
| Password reset | Yes | User account |
| Patch deployment | Yes | Monthly Windows updates |
| User provisioning | Yes | New starter account |
| Certificate renewal | Yes | SSL certificates |
| Disk expansion | Yes | Virtual machine storage |

### Normal Changes

Require CAB approval, follow full process.

| Risk | Lead Time | Examples |
|------|-----------|----------|
| Low | 5 days | Firewall rule, DNS change |
| Medium | 10 days | Application release, DB change |
| High | 15 days | Infrastructure upgrade |

### Emergency Changes

Bypass normal process due to urgency.

**Criteria:**
- Critical service impacted
- Security vulnerability
- Regulatory requirement
- Significant financial impact

**Process:**
- Verbal approval from Change Manager + Technical Authority
- Post-implementation CAB review
- Full documentation within 48 hours

---

## Change Process

### 1. Request

**Required Information:**
- Description of change
- Business justification
- Risk assessment
- Implementation plan
- Rollback plan
- Testing evidence
- Affected CIs
- Scheduled time

### 2. Assessment

**Technical Review:**
- Feasibility check
- Resource availability
- Dependency analysis
- Risk evaluation

**Impact Assessment:**
- Service impact
- Customer impact
- Business impact
- Resource requirements

### 3. Approval

#### Approval Matrix

| Risk Level | Approver(s) |
|------------|-------------|
| Low | Change Manager |
| Medium | Change Manager + Technical Lead |
| High | CAB (Change Advisory Board) |
| Emergency | Change Manager + On-Call Director |

#### CAB Membership

| Role | Attendance |
|------|------------|
| Change Manager (Chair) | Mandatory |
| IT Operations Manager | Mandatory |
| Network Operations Manager | Mandatory |
| Security Representative | Mandatory |
| Application Owner(s) | As needed |
| Business Representative | As needed |

**CAB Schedule:** Tuesdays 14:00 and Thursdays 10:00

### 4. Implementation

**Pre-Implementation:**
- [ ] Approvals obtained
- [ ] Resources confirmed
- [ ] Communication sent
- [ ] Rollback plan ready
- [ ] Monitoring enhanced

**During Implementation:**
- Follow implementation plan
- Document any deviations
- Monitor for issues
- Communicate progress

**Post-Implementation:**
- Verify functionality
- Customer/service validation
- Update documentation
- Close change record

### 5. Review

**All Changes:**
- Implementation success/failure
- Lessons learned
- Documentation complete

**Failed Changes:**
- Root cause analysis
- Preventive actions
- Process improvements

---

## Change Windows

### Standard Windows

| Window | Time | Use |
|--------|------|-----|
| Standard Maintenance | Tuesday 02:00-06:00 | Routine changes |
| Standard Maintenance | Thursday 02:00-06:00 | Routine changes |
| Extended Maintenance | Sunday 00:00-06:00 | Major changes |

### Blackout Periods

No changes permitted:
- Christmas period (23 Dec - 2 Jan)
- Easter weekend
- Bank holiday weekends
- Month-end processing (last 2 days)
- Major business events

### Emergency Window

24/7 for emergency changes with appropriate approval.

---

## Risk Assessment

### Risk Matrix

| | Low Impact | Medium Impact | High Impact |
|---|---|---|---|
| **Low Probability** | Low | Low | Medium |
| **Medium Probability** | Low | Medium | High |
| **High Probability** | Medium | High | High |

### Risk Factors

| Factor | Low | Medium | High |
|--------|-----|--------|------|
| Service criticality | Non-critical | Important | Critical |
| Customer impact | None | Limited | Widespread |
| Complexity | Simple | Moderate | Complex |
| Experience | Routine | Some experience | First time |
| Rollback | Easy | Moderate | Difficult |

---

## Rollback

### Rollback Requirements

All changes must have documented rollback plan:
- Trigger criteria (when to rollback)
- Steps to reverse change
- Time estimate
- Resources required
- Success criteria

### Rollback Decision

**Triggers:**
- Service degradation
- Unexpected errors
- Performance impact
- Security concern
- Customer reports

**Authority:**
- Change Implementer (minor issues)
- Change Manager (significant issues)
- On-Call Director (major incident)

---

## Communication

### Notification Requirements

| Change Type | Notice | Audience |
|-------------|--------|----------|
| No customer impact | 24 hours | IT teams |
| Potential customer impact | 5 days | IT teams, support |
| Customer impact | 10 days | All stakeholders |
| Major outage | 15 days | Customers, public |

### Communication Channels

| Audience | Channel |
|----------|---------|
| IT Teams | Slack #changes |
| Support | Email + ServiceNow |
| Customers | Status page + Email |
| Public | Status page |

---

## Metrics

### KPIs

| Metric | Target |
|--------|--------|
| Change Success Rate | >95% |
| Emergency Change % | <10% |
| Changes Causing Incidents | <5% |
| Backlog Age | <5 days average |
| CAB Attendance | >80% |

### Reporting

| Report | Frequency | Audience |
|--------|-----------|----------|
| Change Summary | Weekly | IT Management |
| Failed Change Analysis | Monthly | IT Leadership |
| Metrics Dashboard | Monthly | CIO |

---

## Tools

### ServiceNow Change Management

**Record Requirements:**
- All fields completed
- CI relationships linked
- Approvals documented
- Implementation notes
- Closure comments

**Workflow States:**
- Draft → Assessment → Approval → Scheduled → Implementation → Review → Closed

---

## Roles and Responsibilities

| Role | Responsibilities |
|------|------------------|
| **Change Requester** | Submit complete request, implement, document |
| **Change Manager** | Process ownership, CAB chair, metrics |
| **Technical Authority** | Technical feasibility, risk assessment |
| **CAB Members** | Review, approve/reject, advice |
| **Change Implementer** | Execute change, communicate, rollback if needed |

---

## Compliance

### Audit Requirements

- All changes logged in ServiceNow
- Approvals documented
- Implementation evidence retained
- Post-implementation review completed

### Regulatory

- SOX controls for financial systems
- PCI DSS for payment systems
- ISO 27001 for security systems

---

**Document Owner**: IT Service Management  
**Last Updated**: January 2025  
**Review Cycle**: Annual  
**Classification**: Internal
