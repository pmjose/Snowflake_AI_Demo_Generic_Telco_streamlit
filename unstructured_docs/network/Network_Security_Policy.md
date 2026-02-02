# Network Security Policy
**SnowTelco Communications - Information Security**

## Document Control

| Version | Date | Author | Approved By |
|---------|------|--------|-------------|
| 2.0 | January 2025 | CISO | Executive Board |

**Classification**: Internal  
**Review Cycle**: Annual

---

## Purpose

This policy establishes the security requirements for SnowTelco's network infrastructure to protect company assets, customer data, and ensure regulatory compliance.

---

## Scope

This policy applies to:
- All network infrastructure (routers, switches, firewalls)
- Wireless networks
- Remote access systems
- Cloud network components
- Third-party connections
- All employees, contractors, and third parties

---

## Network Security Principles

### Defence in Depth

Multiple layers of security controls:
1. **Perimeter** - Firewalls, IPS, DDoS protection
2. **Network** - Segmentation, access controls
3. **Endpoint** - Host-based security, EDR
4. **Application** - WAF, secure coding
5. **Data** - Encryption, DLP

### Zero Trust

- Never trust, always verify
- Least privilege access
- Assume breach mentality
- Continuous verification

---

## Network Architecture Security

### Network Segmentation

| Zone | Purpose | Security Level |
|------|---------|----------------|
| DMZ | Public-facing services | High |
| Production | Customer-facing systems | Critical |
| Corporate | Internal business systems | Medium |
| Management | Network management | Critical |
| Development | Dev/test environments | Medium |
| Guest | Visitor access | Low |

### Inter-Zone Rules

- All traffic between zones must pass through firewall
- Default deny all, explicit allow required
- No direct production to development access
- Management zone accessible only via jump hosts

### VLAN Requirements

| VLAN Type | Requirements |
|-----------|--------------|
| Voice | QoS prioritised, isolated |
| Data | Standard corporate access |
| Server | Restricted access, logged |
| IoT | Isolated, limited internet |
| Guest | Internet only, no internal |

---

## Access Control

### Network Access Control (NAC)

- All devices must authenticate before network access
- Corporate devices: Certificate-based 802.1X
- BYOD: MAB with limited access
- Guest: Captive portal, time-limited

### Firewall Rules

**Rule Requirements:**
- Business justification documented
- Source/destination specific (no "any")
- Time-limited where appropriate
- Regular review (quarterly)
- Logged and monitored

**Prohibited:**
- "Any-any" rules
- Direct internet to internal
- Unencrypted management access
- Permanent vendor access

### VPN Access

| Type | Use Case | Authentication |
|------|----------|----------------|
| Site-to-Site | Office connectivity | Certificates |
| Remote Access | Work from home | MFA required |
| Vendor | Third-party access | MFA + time-limited |

---

## Wireless Security

### Corporate WiFi

| Requirement | Standard |
|-------------|----------|
| Encryption | WPA3-Enterprise |
| Authentication | 802.1X with certificates |
| SSID | Hidden for corporate |
| Rogue AP Detection | Enabled |

### Guest WiFi

| Requirement | Standard |
|-------------|----------|
| Encryption | WPA3-Personal |
| Isolation | Separate VLAN |
| Bandwidth | Rate limited |
| Terms | Acceptance required |
| Duration | 24 hours max |

---

## Encryption Standards

### In Transit

| Traffic Type | Minimum Standard |
|--------------|------------------|
| External web | TLS 1.2+ |
| Internal web | TLS 1.2+ |
| API traffic | TLS 1.2+ with mutual auth |
| Email | TLS 1.2+ (opportunistic) |
| VPN | IKEv2 with AES-256 |
| Database | TLS or SSH tunnel |

### At Rest

| Data Type | Requirement |
|-----------|-------------|
| Customer PII | AES-256 |
| Payment data | AES-256 + tokenisation |
| Credentials | Vault with HSM |
| Backups | AES-256 |

---

## Monitoring and Logging

### Required Logging

All network devices must log:
- Authentication events
- Configuration changes
- Access control decisions
- Security events
- Administrative access

### Log Retention

| Log Type | Retention |
|----------|-----------|
| Security events | 12 months online, 7 years archive |
| Access logs | 12 months |
| Config changes | 7 years |
| Flow data | 90 days |

### Monitoring Requirements

| Activity | Frequency |
|----------|-----------|
| Security event review | Real-time |
| Firewall rule review | Quarterly |
| Access audit | Monthly |
| Vulnerability scan | Weekly |
| Penetration test | Annual |

---

## Vulnerability Management

### Scanning

- Internal scan: Weekly (automated)
- External scan: Weekly (automated)
- Web application scan: Monthly
- Penetration test: Annual

### Patching SLAs

| Severity | SLA |
|----------|-----|
| Critical | 7 days |
| High | 14 days |
| Medium | 30 days |
| Low | 90 days |

---

## Incident Response

### Network Security Incidents

1. **Detect** - SIEM alert, IDS/IPS, user report
2. **Contain** - Isolate affected systems
3. **Investigate** - Determine scope and impact
4. **Eradicate** - Remove threat
5. **Recover** - Restore services
6. **Learn** - Post-incident review

### Escalation

| Severity | Escalation |
|----------|------------|
| Critical | CISO immediately |
| High | Security Manager within 1 hr |
| Medium | Security Team within 4 hrs |
| Low | Normal triage |

---

## Third-Party Access

### Requirements

- Business justification required
- Signed NDA and security agreement
- Minimum necessary access
- Time-limited (max 90 days, renewable)
- MFA mandatory
- Activity logged and reviewed

### Vendor Risk Assessment

All vendors must:
- Complete security questionnaire
- Provide SOC 2 Type II or equivalent
- Accept security audit rights
- Notify of security incidents

---

## Compliance

### Regulatory Requirements

| Regulation | Requirement |
|------------|-------------|
| GDPR | Data protection, breach notification |
| Ofcom | Network security, lawful intercept |
| PCI DSS | Payment card security |
| ISO 27001 | Information security management |

### Audit and Assessment

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Internal audit | Annual | Internal Audit |
| External audit | Annual | External auditor |
| ISO 27001 surveillance | Annual | Certification body |
| Penetration test | Annual | Third party |

---

## Exceptions

Security exceptions require:
1. Business justification
2. Risk assessment
3. Compensating controls
4. Time limit (max 12 months)
5. CISO approval

---

## Enforcement

Violations may result in:
- Disciplinary action
- Termination of access
- Legal action
- Regulatory notification

---

**Document Owner**: Chief Information Security Officer  
**Last Updated**: January 2025  
**Next Review**: January 2026
