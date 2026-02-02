# SnowTelco Operational Excellence Playbook

## Introduction

This playbook defines SnowTelco's approach to operational excellence across all business functions, driving efficiency, quality, and continuous improvement.

## Operational Framework

### Core Principles

1. **Customer First** - Every process optimized for customer outcome
2. **Data-Driven Decisions** - Metrics guide all operational choices
3. **Continuous Improvement** - Kaizen mindset across all teams
4. **Standardization** - Consistent processes, repeatable results
5. **Automation** - Eliminate manual work where possible

### Key Performance Metrics

#### Network Operations
| Metric | Target | Current |
|--------|--------|---------|
| Network Availability | 99.99% | 99.97% |
| Mean Time to Repair | <30 min | 42 min |
| P1 Incident Resolution | <4 hours | 3.2 hours |
| Change Success Rate | >98% | 97.5% |

#### Customer Operations
| Metric | Target | Current |
|--------|--------|---------|
| First Contact Resolution | 75% | 68% |
| Average Handle Time | <8 min | 9.2 min |
| Customer Effort Score | <3.0 | 3.4 |
| NPS | +50 | +45 |

#### Field Operations
| Metric | Target | Current |
|--------|--------|---------|
| First Time Fix Rate | 90% | 85% |
| Technician Utilization | 80% | 72% |
| SLA Compliance | 95% | 92% |
| Jobs per Day | 6 | 5.2 |

## Process Standards

### Incident Management

#### Severity Classification
| Severity | Definition | Response | Resolution |
|----------|------------|----------|------------|
| P1 | Service outage >10K customers | 15 min | 4 hours |
| P2 | Degraded service >1K customers | 30 min | 8 hours |
| P3 | Limited impact <1K customers | 2 hours | 24 hours |
| P4 | Minor issue, workaround available | 4 hours | 72 hours |

#### Escalation Matrix
- **15 minutes:** NOC Manager
- **30 minutes:** VP Network Operations
- **1 hour:** COO
- **2 hours:** CEO (P1 only)

### Change Management

#### Change Types
1. **Standard** - Pre-approved, low risk
2. **Normal** - CAB approval required
3. **Emergency** - Expedited approval for critical fixes

#### Change Windows
- **Standard:** Tuesday/Wednesday 02:00-06:00
- **Major:** Sunday 02:00-06:00
- **Emergency:** Any time with COO approval

### Capacity Management

#### Thresholds
| Resource | Warning | Critical | Action |
|----------|---------|----------|--------|
| CPU | 70% | 85% | Scale up |
| Memory | 75% | 90% | Scale up |
| Storage | 80% | 90% | Provision |
| Network | 70% | 85% | Add capacity |

## Continuous Improvement

### Lean Six Sigma Program

- All managers Green Belt certified
- 10 Black Belt resources dedicated to improvement
- Target: £5M annual savings from process improvement

### Automation Initiatives

| Initiative | Status | Annual Savings |
|------------|--------|----------------|
| Ticket auto-resolution | Live | £1.2M |
| Network auto-healing | Pilot | £800K |
| Bill dispute automation | Live | £400K |
| Workforce scheduling AI | Development | £600K |

### Quality Assurance

- Monthly process audits
- Quarterly customer journey mapping
- Annual TM Forum benchmark assessment

## Governance

### Operational Reviews

| Forum | Frequency | Attendees | Focus |
|-------|-----------|-----------|-------|
| Daily Stand-up | Daily | Team leads | Current issues |
| Weekly Ops Review | Weekly | VP/Directors | KPI performance |
| Monthly Business Review | Monthly | COO + VPs | Strategic metrics |
| Quarterly Planning | Quarterly | Executive team | Initiatives |

### Reporting

- Real-time dashboards in Snowflake
- Daily automated reports to leadership
- Weekly customer impact summary
- Monthly board operational metrics

---

*Document Owner: COO*
*Last Updated: January 2026*
*Classification: Internal*
