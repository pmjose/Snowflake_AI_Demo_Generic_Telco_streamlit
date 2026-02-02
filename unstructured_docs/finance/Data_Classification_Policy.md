# Data Classification Policy
**SnowTelco Communications - Information Security**

## Purpose

This policy establishes the framework for classifying and handling data at SnowTelco based on its sensitivity and value to the organisation.

---

## Scope

This policy applies to:
- All SnowTelco data (digital and physical)
- All employees, contractors, and third parties
- All systems processing SnowTelco data

---

## Classification Levels

### Overview

| Level | Definition | Examples |
|-------|------------|----------|
| **Public** | Information intended for public release | Marketing materials, press releases |
| **Internal** | Business information for internal use | Policies, procedures, org charts |
| **Confidential** | Sensitive business information | Financial data, contracts, strategies |
| **Restricted** | Highly sensitive data requiring protection | Customer PII, payment data, credentials |

---

## Classification Definitions

### Public

**Definition:** Information that has been approved for public release and would cause no harm if disclosed.

**Examples:**
- Published marketing content
- Public website content
- Press releases
- Job postings
- Product brochures

**Handling:**
- No special handling required
- May be shared freely
- No labelling required

### Internal

**Definition:** Information intended for use within SnowTelco that is not sensitive but should not be shared externally without approval.

**Examples:**
- Internal policies and procedures
- Organisation charts
- Internal announcements
- Training materials
- Meeting minutes (non-sensitive)

**Handling:**
- Share only with SnowTelco employees/contractors
- External sharing requires management approval
- Standard business security controls
- Label as "Internal" where practical

### Confidential

**Definition:** Sensitive business information that could harm SnowTelco competitively or financially if disclosed.

**Examples:**
- Financial reports and forecasts
- Business strategies and plans
- Customer lists and analytics
- Contracts and agreements
- Pricing information
- Vendor information
- System architecture diagrams
- Audit reports

**Handling:**
- Need-to-know access only
- Encryption required for transmission
- Secure storage (encrypted or access-controlled)
- NDA required for external sharing
- Label as "Confidential"
- Secure disposal required

### Restricted

**Definition:** Highly sensitive data that requires the highest level of protection and would cause significant harm if disclosed.

**Examples:**
- Customer personal information (PII)
- Payment card data (PCI)
- Employee personal information
- Authentication credentials
- Encryption keys
- Security vulnerabilities
- Legal/regulatory matters
- M&A information

**Handling:**
- Strict need-to-know access
- Encryption mandatory (at rest and in transit)
- Multi-factor authentication required
- Audit logging required
- Restricted to approved systems only
- No external sharing without Legal/DPO approval
- Label as "Restricted"
- Secure disposal with verification

---

## Data Handling Requirements

### Storage

| Classification | Requirements |
|----------------|--------------|
| Public | Standard storage |
| Internal | Access-controlled systems |
| Confidential | Encrypted storage, access control |
| Restricted | Encrypted, access control, audit logging |

### Transmission

| Classification | Email | File Transfer | Physical |
|----------------|-------|---------------|----------|
| Public | Standard | Standard | Standard |
| Internal | Standard | Standard | Secure courier |
| Confidential | Encrypted | SFTP/encrypted | Tracked courier |
| Restricted | Encrypted + approval | SFTP + encryption | Hand delivery only |

### Disposal

| Classification | Digital | Physical |
|----------------|---------|----------|
| Public | Standard delete | Standard disposal |
| Internal | Secure delete | Shredding |
| Confidential | Secure wipe | Cross-cut shredding |
| Restricted | DOD wipe/destroy | Cross-cut + verification |

### Retention

Refer to Data Retention Policy for specific retention periods by data type.

---

## Labelling Requirements

### Digital Assets

| Classification | Label Required | Method |
|----------------|----------------|--------|
| Public | No | N/A |
| Internal | Recommended | Header/footer, metadata |
| Confidential | Yes | Header/footer, filename, metadata |
| Restricted | Yes | Header/footer, filename, metadata, DRM |

**Label Format:**
```
CONFIDENTIAL - SnowTelco Communications
```

### Physical Assets

| Classification | Label Required | Method |
|----------------|----------------|--------|
| Public | No | N/A |
| Internal | Recommended | Stamp or sticker |
| Confidential | Yes | Stamp, cover sheet |
| Restricted | Yes | Stamp, cover sheet, sealed envelope |

---

## Access Control

### Access Principles

1. **Least Privilege** - Minimum access required
2. **Need-to-Know** - Business justification required
3. **Segregation** - Sensitive functions separated
4. **Review** - Regular access reviews

### Approval Requirements

| Classification | Approval |
|----------------|----------|
| Public | None |
| Internal | Manager |
| Confidential | Manager + Data Owner |
| Restricted | Director + Data Owner + Security |

### Access Reviews

| Classification | Review Frequency |
|----------------|------------------|
| Public | Not required |
| Internal | Annual |
| Confidential | Semi-annual |
| Restricted | Quarterly |

---

## Special Data Categories

### Personal Data (GDPR)

All personal data is classified as minimum Confidential.

Special category data (health, biometrics, etc.) is Restricted.

Refer to GDPR Compliance Framework for detailed handling.

### Payment Card Data (PCI)

All payment card data is classified as Restricted.

Must be processed only in PCI-compliant environments.

### Credentials and Keys

All authentication credentials and encryption keys are Restricted.

Must be stored in approved secrets management systems.

---

## Responsibilities

### Data Owners

- Assign classification to data
- Approve access requests
- Review access periodically
- Ensure compliance with policy

### Data Custodians

- Implement security controls
- Maintain systems securely
- Report security incidents
- Support audits

### All Employees

- Handle data according to classification
- Report mishandling or incidents
- Complete required training
- Protect credentials

---

## Compliance

### Monitoring

- DLP systems monitor Confidential/Restricted data
- Access logging for sensitive systems
- Regular compliance audits

### Violations

Violations may result in:
- Disciplinary action
- Termination
- Legal action
- Regulatory notification

### Reporting

Report data handling concerns to:
- Line manager
- Information Security: security@snowtelco.com
- Ethics hotline (anonymous)

---

## Training

| Role | Training | Frequency |
|------|----------|-----------|
| All employees | Data Classification Basics | Annual |
| Data handlers | Advanced Data Handling | Annual |
| Data owners | Owner responsibilities | Annual |
| IT/Security | Technical controls | Annual |

---

## Related Documents

- GDPR Compliance Framework
- Information Security Policy
- Data Retention Policy
- Acceptable Use Policy
- Incident Response Plan

---

**Document Owner**: Chief Information Security Officer  
**Last Updated**: January 2025  
**Review Cycle**: Annual  
**Classification**: Internal
