# Fraud Prevention Guide
**SnowTelco Communications - Risk & Compliance**

## Purpose

This guide outlines the fraud prevention controls, detection mechanisms, and response procedures for SnowTelco. It covers both internal fraud and external fraud targeting customers and the company.

---

## Fraud Categories

### External Fraud (Customer/Network)

| Type | Description | Risk Level |
|------|-------------|------------|
| Subscription Fraud | Fake identities to obtain services | High |
| SIM Swap Fraud | Unauthorised SIM replacement | Critical |
| Account Takeover | Stolen credentials access | High |
| Premium Rate Fraud | IRSF, Wangiri | High |
| Device Fraud | Insurance claims, non-payment | Medium |
| Roaming Fraud | Excessive roaming charges | Medium |
| Dealer Fraud | False activations for commission | Medium |

### Internal Fraud

| Type | Description | Risk Level |
|------|-------------|------------|
| Financial Fraud | Expense fraud, theft | High |
| Procurement Fraud | Kickbacks, bid rigging | High |
| Data Theft | Selling customer information | Critical |
| Service Abuse | Free services for personal use | Medium |
| Time Fraud | False timesheets | Low |

---

## Fraud Prevention Controls

### Identity Verification

**New Customer Onboarding:**

| Verification | Consumer | Business |
|--------------|----------|----------|
| ID Document | Photo ID required | Company registration |
| Address | Utility bill/bank statement | Business address proof |
| Payment | Initial payment from named account | Credit check + trade references |
| Credit Check | Mandatory | Mandatory |
| Fraud Database | Check against CIFAS | Check against CIFAS |

**Enhanced Verification Triggers:**
- Credit score <500
- Multiple applications from same address
- Recently issued ID documents
- Inconsistent information
- High-risk postcode

### SIM Swap Controls

**Mandatory Verification:**
1. Full account verification
2. Security question
3. SMS OTP to existing SIM (if possible)
4. Photo ID (in-store) or Video ID (remote)
5. 24-hour cooling off period
6. Notification to registered email/SMS

**Fraud Indicators:**
- Recent change of contact details
- Multiple swap attempts
- Unusual call to contact centre
- Request for immediate activation
- Third-party making request

### Account Security

**Authentication Requirements:**

| Channel | Verification |
|---------|--------------|
| Contact Centre | Account PIN + security question |
| Online Portal | Username + password + MFA |
| Mobile App | Biometric + PIN |
| Retail Store | Photo ID + account details |

**Account Alerts:**
- Login from new device
- Password change
- Contact details change
- SIM swap request
- Unusual usage pattern

---

## Fraud Detection

### Real-Time Monitoring

**Network Fraud Detection System:**

| Monitor | Threshold | Action |
|---------|-----------|--------|
| IRSF (Int'l Revenue Share) | >£100/day to high-risk | Block + alert |
| Premium Rate | >£50/day | Warning + velocity check |
| Roaming Data | >10GB/day | Alert + customer contact |
| Call Duration | >6 hours continuous | Investigation |
| Call Volume | >200 calls/day | Investigation |

**Customer Behaviour Analytics:**
- Unusual usage patterns
- Sudden increase in spend
- Geographic anomalies
- Time-of-day patterns

### Credit Management

| Credit Tier | Limit | Monitoring |
|-------------|-------|------------|
| Standard | £100 | Monthly |
| Medium | £250 | Weekly |
| High | £500 | Daily |
| Premium | £1000 | Real-time |

**Credit Alerts:**
- 75% credit used → SMS warning
- 90% credit used → Service restriction
- 100% credit used → Barring (outbound)

### Dealer/Channel Fraud

**Monitoring:**
- Activation patterns (velocity)
- Customer quality (churn within 30 days)
- Credit check override frequency
- Commission claim patterns

**Red Flags:**
- High volume, low quality activations
- Multiple activations same address
- Unusual commission patterns
- Customer complaints

---

## Fraud Response

### Incident Classification

| Category | Definition | Response Time |
|----------|------------|---------------|
| Critical | Large-scale attack, data breach | Immediate |
| High | Individual account compromise | 1 hour |
| Medium | Suspicious activity confirmed | 4 hours |
| Low | Anomaly requiring investigation | 24 hours |

### Response Process

1. **Detect** - Automated alert or report
2. **Contain** - Suspend account/service if needed
3. **Investigate** - Gather evidence, determine scope
4. **Remediate** - Restore service, refund if appropriate
5. **Report** - Internal report, police if warranted
6. **Learn** - Update controls, share intelligence

### Customer Communication

**If Fraud Victim:**
> "We've detected suspicious activity on your account. For your protection, we've temporarily restricted certain services. Our fraud team will contact you within [timeframe] to verify your identity and restore your account."

**If Fraud Perpetrator:**
- Do not alert (preserve evidence)
- Escalate to Fraud Investigation team
- Document all evidence
- Engage Legal if prosecution considered

---

## Fraud Investigation

### Investigation Team

| Role | Responsibility |
|------|----------------|
| Fraud Analyst | Initial investigation, evidence gathering |
| Senior Analyst | Complex cases, patterns |
| Fraud Manager | Escalations, law enforcement |
| Legal | Prosecution, civil recovery |

### Evidence Preservation

**Required Documentation:**
- Call recordings
- System logs (access, changes)
- Transaction records
- IP addresses
- Customer communications
- ID documents

**Chain of Custody:**
- Secure storage
- Access log
- Tamper evidence
- Legal admissibility

### Law Enforcement

**Report to Police When:**
- Loss >£5,000
- Organised crime indicators
- Insider involvement
- Violence or threats
- Repeat offender

**Reporting:**
- Action Fraud: Online report
- Local Police: Physical crime
- NCA: Organised crime
- ICO: Data breach

---

## Fraud Metrics

### Key Performance Indicators

| KPI | Target | Actual |
|-----|--------|--------|
| Fraud Loss Rate | <0.5% revenue | 0.3% |
| Detection Rate | >80% | 85% |
| False Positive Rate | <10% | 8% |
| Average Detection Time | <24 hours | 18 hours |
| Recovery Rate | >40% | 45% |

### Reporting

| Report | Frequency | Audience |
|--------|-----------|----------|
| Fraud Dashboard | Real-time | Fraud Team |
| Weekly Summary | Weekly | Management |
| Monthly Report | Monthly | Executive |
| Quarterly Review | Quarterly | Board |

---

## Training

### Required Training

| Role | Training | Frequency |
|------|----------|-----------|
| All Staff | Fraud Awareness | Annual |
| Customer Service | Fraud Detection | Quarterly |
| Sales/Dealers | Prevention & Detection | Quarterly |
| Finance | Internal Fraud | Annual |
| Fraud Team | Advanced Techniques | Ongoing |

---

## Contacts

| Team | Contact |
|------|---------|
| Fraud Team | fraud@snowtelco.com |
| Fraud Hotline | +44 800 123 5555 |
| Ethics Hotline | ethics@snowtelco.com |
| Legal | legal@snowtelco.com |

---

**Document Owner**: Head of Fraud & Risk  
**Last Updated**: January 2025  
**Review Cycle**: Quarterly  
**Classification**: Internal - Confidential
