# GDPR Compliance Framework
**SnowTelco Communications - Data Protection**

## Purpose

This framework establishes SnowTelco's approach to compliance with the UK General Data Protection Regulation (UK GDPR) and Data Protection Act 2018.

---

## Data Protection Principles

### The Seven Principles

| Principle | SnowTelco Application |
|-----------|----------------------|
| **Lawfulness, fairness, transparency** | Clear privacy notices, legitimate processing |
| **Purpose limitation** | Data used only for stated purposes |
| **Data minimisation** | Collect only necessary data |
| **Accuracy** | Customer data verification, correction process |
| **Storage limitation** | Retention schedules, deletion procedures |
| **Integrity and confidentiality** | Security controls, encryption |
| **Accountability** | Documentation, DPO oversight |

---

## Lawful Bases for Processing

### SnowTelco Processing Activities

| Processing Activity | Lawful Basis | Data Categories |
|--------------------|--------------|-----------------|
| Service provision | Contract | Contact, billing, usage |
| Billing and payments | Contract | Payment, transaction |
| Customer support | Contract | Contact, service history |
| Network management | Legitimate interest | Usage, location |
| Marketing (opt-in) | Consent | Contact, preferences |
| Marketing (existing) | Legitimate interest | Contact |
| Fraud prevention | Legitimate interest | Transaction, behaviour |
| Legal compliance | Legal obligation | Various |
| Analytics | Legitimate interest | Anonymised usage |

### Consent Management

**Consent Requirements:**
- Freely given
- Specific
- Informed
- Unambiguous
- Withdrawable

**Consent Records:**
- Date and time
- Method (web, call, store)
- Specific consent given
- Privacy notice version
- Withdrawal if applicable

---

## Data Subject Rights

### Rights and Response Times

| Right | Maximum Response Time |
|-------|----------------------|
| Access (SAR) | 1 month |
| Rectification | 1 month |
| Erasure | 1 month |
| Restriction | Without undue delay |
| Portability | 1 month |
| Objection | Without undue delay |

### Handling Requests

**Step 1: Verification**
- Verify identity (photo ID, security questions)
- Confirm data subject is requester or authorised

**Step 2: Assessment**
- Identify request type
- Determine if extension needed (complex/volume)
- Check for exemptions

**Step 3: Fulfilment**
- Gather data from all systems
- Review for third-party data
- Redact where necessary
- Provide in accessible format

**Step 4: Response**
- Respond within timeframe
- Explain any refusals
- Inform of complaint rights

### Subject Access Request (SAR) Process

**Data Sources:**
- CRM system
- Billing system
- Call recordings
- Support tickets
- Email archives
- Marketing systems
- Network logs (limited)

**Exemptions:**
- Legal privilege
- Management forecasting
- Third-party data (where disproportionate)
- Crime prevention (limited)

---

## Data Retention

### Retention Schedule

| Data Category | Retention Period | Legal Basis |
|---------------|------------------|-------------|
| Customer account | 7 years post-closure | Contract, tax |
| Billing records | 7 years | Tax, disputes |
| Call detail records | 12 months | Ofcom requirement |
| Call recordings | 6 months (support), 7 years (PCI) | Quality, compliance |
| Marketing consent | Duration of consent + 3 years | Accountability |
| Support tickets | 3 years | Quality, disputes |
| Employee data | 7 years post-employment | Employment law |
| CCTV | 30 days | Security |

### Deletion Process

- Automated deletion where possible
- Manual review for exceptions
- Secure deletion (overwrite, degauss)
- Deletion confirmation logged

---

## Data Security

### Technical Measures

| Measure | Implementation |
|---------|----------------|
| Encryption at rest | AES-256 for sensitive data |
| Encryption in transit | TLS 1.2+ for all transfers |
| Access control | RBAC, least privilege |
| Authentication | MFA for all systems |
| Logging | All access logged and monitored |
| Backup | Encrypted, tested restoration |

### Organisational Measures

| Measure | Implementation |
|---------|----------------|
| Training | Annual mandatory training |
| Policies | Data protection policies |
| Contracts | DPA with all processors |
| Vetting | Background checks for data roles |
| Physical | Secure areas for data processing |

---

## Data Breach Management

### Breach Classification

| Category | Definition | Action |
|----------|------------|--------|
| Category 1 | High risk to individuals | ICO + individuals notified |
| Category 2 | Risk to individuals | ICO notified, consider individuals |
| Category 3 | Low/no risk | Internal record only |

### Breach Response Process

**Within 1 Hour:**
1. Contain the breach
2. Notify DPO and IT Security
3. Begin investigation
4. Preserve evidence

**Within 24 Hours:**
1. Complete initial assessment
2. Determine scope and impact
3. Identify affected individuals
4. Draft notifications

**Within 72 Hours:**
1. Notify ICO (if required)
2. Notify affected individuals (if high risk)
3. Complete incident report

### ICO Notification

**Required Information:**
- Nature of breach
- Categories and approximate numbers affected
- Contact details (DPO)
- Likely consequences
- Measures taken/proposed

**ICO Contact:** casework@ico.org.uk | 0303 123 1113

---

## International Transfers

### Transfer Mechanisms

| Destination | Mechanism |
|-------------|-----------|
| EEA | Adequacy decision |
| UK Adequacy countries | Adequacy decision |
| USA | UK-US Data Bridge (DPF) |
| Other | SCCs + TIA |

### Transfer Impact Assessment (TIA)

Required for transfers to countries without adequacy:
1. Assess receiving country laws
2. Identify risks to data subjects
3. Implement supplementary measures
4. Document decision

### Current Processors (non-UK)

| Processor | Location | Mechanism |
|-----------|----------|-----------|
| Salesforce | USA | UK-US Data Bridge |
| AWS | Global | SCCs + TIA |
| Google | USA | UK-US Data Bridge |
| Microsoft | USA | UK-US Data Bridge |

---

## Third-Party Management

### Data Processing Agreements (DPA)

All processors must sign DPA including:
- Processing scope and purpose
- Security requirements
- Sub-processor controls
- Audit rights
- Breach notification
- Return/deletion of data

### Processor Audit

| Risk Level | Audit Frequency |
|------------|-----------------|
| High (PII heavy) | Annual on-site |
| Medium | Annual questionnaire |
| Low | Biennial questionnaire |

---

## Privacy by Design

### New Projects

**Privacy Impact Assessment (PIA) Required:**
- New processing activities
- New systems handling personal data
- Changes to existing processing
- High-risk processing

**PIA Process:**
1. Describe processing
2. Assess necessity and proportionality
3. Identify risks to individuals
4. Identify mitigation measures
5. DPO review and sign-off

### Default Settings

- Privacy-friendly defaults
- Opt-in for marketing
- Minimal data collection
- Clear consent flows

---

## Accountability

### Documentation

| Document | Owner | Review |
|----------|-------|--------|
| Record of Processing (RoPA) | DPO | Quarterly |
| Privacy Notices | Legal | Annual |
| DPIAs | Project Owner | Per project |
| Training Records | HR | Ongoing |
| Consent Records | Marketing | Ongoing |
| Breach Register | DPO | Ongoing |

### Data Protection Officer

**Contact:** dpo@snowtelco.com

**Responsibilities:**
- Advise on compliance
- Monitor compliance
- Training and awareness
- Liaison with ICO
- Data subject contact point

---

## Training

### Mandatory Training

| Role | Training | Frequency |
|------|----------|-----------|
| All staff | GDPR Awareness | Annual |
| Customer facing | Data handling | Annual |
| IT staff | Security and privacy | Annual |
| Managers | DSR handling | Annual |
| Marketing | Consent and preferences | Bi-annual |

---

## Contacts

| Query | Contact |
|-------|---------|
| DPO | dpo@snowtelco.com |
| Privacy Team | privacy@snowtelco.com |
| DSR Requests | sar@snowtelco.com |
| Legal | legal@snowtelco.com |

---

**Document Owner**: Data Protection Officer  
**Last Updated**: January 2025  
**Review Cycle**: Annual  
**Classification**: Internal
