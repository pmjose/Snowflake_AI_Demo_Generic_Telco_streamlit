# Cloud Strategy
**SnowTelco Communications - Technology Strategy 2025-2028**

## Executive Summary

This document outlines SnowTelco's cloud strategy for the next three years. Our objective is to leverage cloud technologies to improve agility, reduce costs, and accelerate innovation while maintaining security and compliance.

---

## Strategic Objectives

### Vision

> "Cloud-first for innovation, right-fit for operations"

### Goals

| Goal | Target | Timeline |
|------|--------|----------|
| Reduce data centre footprint | 50% reduction | 2027 |
| Cloud-native applications | 80% of new apps | 2026 |
| Infrastructure automation | 95% IaC | 2026 |
| Cost optimisation | 20% TCO reduction | 2028 |
| Carbon reduction | Net zero IT | 2028 |

---

## Current State

### Infrastructure Landscape

| Environment | Location | Workloads |
|-------------|----------|-----------|
| Primary DC | London (LD4) | Core systems, voice platform |
| Secondary DC | Manchester (MA1) | DR, batch processing |
| AWS | eu-west-2 | Customer portal, APIs, analytics |
| Azure | UK South | Microsoft workloads, SaaS |
| SaaS | Various | CRM, HR, collaboration |

### Current Distribution

| Category | % Workloads | Direction |
|----------|-------------|-----------|
| On-premises | 45% | Decreasing |
| IaaS (AWS/Azure) | 25% | Stable |
| PaaS | 15% | Increasing |
| SaaS | 15% | Increasing |

---

## Target State (2028)

### Workload Distribution

| Category | Target % | Key Workloads |
|----------|----------|---------------|
| On-premises | 20% | Voice core, sensitive data |
| IaaS | 20% | Legacy lift-and-shift |
| PaaS | 35% | Modern applications |
| SaaS | 25% | Business applications |

### Multi-Cloud Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Customer Touchpoints                      │
│  (Web Portal, Mobile App, APIs, Contact Centre)             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      AWS (Primary Cloud)                     │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ Customer    │  │ Analytics &  │  │ API Gateway  │       │
│  │ Portal      │  │ Data Lake    │  │ & Services   │       │
│  └─────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Azure (Microsoft Stack)                   │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ Microsoft   │  │ Active       │  │ SharePoint   │       │
│  │ 365         │  │ Directory    │  │ Online       │       │
│  └─────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│               On-Premises (Critical Systems)                 │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ Voice       │  │ Network      │  │ Security     │       │
│  │ Platform    │  │ Management   │  │ Systems      │       │
│  └─────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

---

## Cloud Platform Strategy

### AWS (Primary Public Cloud)

**Use Cases:**
- Customer-facing applications
- Data analytics and AI/ML
- API services
- DevOps and CI/CD
- Disaster recovery

**Key Services:**

| Service | Use Case |
|---------|----------|
| EKS | Container orchestration |
| RDS/Aurora | Managed databases |
| S3 | Object storage, data lake |
| Lambda | Serverless compute |
| CloudFront | CDN for customer apps |
| Bedrock | AI/ML services |
| Connect | Cloud contact centre |

### Azure (Microsoft Ecosystem)

**Use Cases:**
- Microsoft 365 workloads
- Identity management (AAD)
- Windows-based applications
- Power Platform

**Key Services:**

| Service | Use Case |
|---------|----------|
| Azure AD | Identity provider |
| Azure DevOps | Development platform |
| Power BI | Business intelligence |
| Logic Apps | Integration workflows |

### On-Premises (Retained)

**Criteria for On-Premises:**
- Latency-sensitive voice traffic
- Regulatory requirements (data residency)
- Existing hardware investment
- Network infrastructure management

---

## Migration Roadmap

### Phase 1: Foundation (2025)

| Initiative | Q1 | Q2 | Q3 | Q4 |
|------------|----|----|----|----|
| Cloud landing zone | ✓ | | | |
| Network connectivity | ✓ | ✓ | | |
| Security baseline | | ✓ | | |
| First migrations | | | ✓ | ✓ |

**Workloads:**
- Customer portal (migrate to EKS)
- Development environments
- Non-production databases

### Phase 2: Scale (2026)

| Initiative | Q1 | Q2 | Q3 | Q4 |
|------------|----|----|----|----|
| Production apps | ✓ | ✓ | | |
| Data platform | | ✓ | ✓ | |
| DR in cloud | | | ✓ | ✓ |
| Analytics migration | | | | ✓ |

**Workloads:**
- Production APIs
- Analytics platform
- Reporting systems
- Batch processing

### Phase 3: Optimise (2027-2028)

| Initiative | 2027 H1 | 2027 H2 | 2028 H1 | 2028 H2 |
|------------|---------|---------|---------|---------|
| Legacy modernisation | ✓ | ✓ | | |
| DC consolidation | | ✓ | ✓ | |
| Cost optimisation | | | ✓ | ✓ |
| Cloud-native rewrite | | | | ✓ |

---

## Cloud Operating Model

### Governance

**Cloud Centre of Excellence (CCoE):**
- Architecture standards
- Security policies
- Cost management
- Best practices

**Roles:**

| Role | Responsibility |
|------|----------------|
| Cloud Architect | Design, standards |
| Platform Engineer | Infrastructure automation |
| FinOps Analyst | Cost optimisation |
| Security Engineer | Cloud security |

### Financial Management (FinOps)

**Cost Controls:**
- Budget alerts (80%, 100%)
- Reserved instances (1-3 year)
- Spot instances for batch
- Right-sizing recommendations
- Unused resource cleanup

**Target Cost Distribution:**

| Category | Target % |
|----------|----------|
| Compute | 40% |
| Storage | 20% |
| Network | 15% |
| Database | 15% |
| Other | 10% |

### Security

**Cloud Security Framework:**

| Control | Implementation |
|---------|----------------|
| Identity | SSO via Azure AD |
| Network | VPC, security groups, WAF |
| Data | Encryption at rest/transit |
| Compliance | Continuous compliance monitoring |
| Logging | Centralised SIEM |

---

## Technology Standards

### Infrastructure as Code

| Tool | Use |
|------|-----|
| Terraform | AWS/Azure infrastructure |
| Ansible | Configuration management |
| CloudFormation | AWS-specific resources |
| Helm | Kubernetes deployments |

### Container Strategy

| Technology | Use |
|------------|-----|
| Docker | Container runtime |
| Kubernetes (EKS) | Orchestration |
| ECR | Container registry |
| Istio | Service mesh |

### CI/CD Pipeline

```
Code → Build → Test → Security Scan → Deploy (Dev) → Test → Deploy (Staging) → Test → Deploy (Prod)
```

---

## Risk Management

### Key Risks

| Risk | Mitigation |
|------|------------|
| Vendor lock-in | Multi-cloud, portable workloads |
| Security breach | Zero trust, encryption, monitoring |
| Cost overrun | FinOps practices, budgets |
| Skill gap | Training, hiring, partners |
| Data sovereignty | UK region only for PII |

### Compliance

| Requirement | Approach |
|-------------|----------|
| GDPR | UK regions, data classification |
| PCI DSS | Dedicated environments, controls |
| ISO 27001 | Continuous compliance |
| Ofcom | Data residency compliance |

---

## Investment

### Three-Year Investment

| Year | Investment | Savings | Net |
|------|------------|---------|-----|
| 2025 | £5M | £1M | -£4M |
| 2026 | £4M | £3M | -£1M |
| 2027 | £2M | £4M | +£2M |
| 2028 | £1M | £5M | +£4M |
| **Total** | **£12M** | **£13M** | **+£1M** |

### Benefits

- Agility: Faster time-to-market
- Scalability: Handle demand spikes
- Innovation: Access to new services
- Resilience: Improved DR/HA
- Sustainability: Reduced carbon footprint

---

## Success Metrics

| Metric | Baseline | 2026 | 2028 |
|--------|----------|------|------|
| Cloud spend % of IT | 25% | 45% | 60% |
| Deployment frequency | Monthly | Weekly | Daily |
| Infrastructure lead time | 4 weeks | 1 day | 1 hour |
| System availability | 99.9% | 99.95% | 99.99% |
| Carbon per transaction | Baseline | -30% | -60% |

---

**Document Owner**: Chief Technology Officer  
**Last Updated**: January 2025  
**Review Cycle**: Annual  
**Classification**: Internal
