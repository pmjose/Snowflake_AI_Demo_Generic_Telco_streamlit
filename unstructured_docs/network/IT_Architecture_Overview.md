# SnowTelco IT Architecture Overview

## System Landscape

### Core Business Systems

#### BSS (Business Support Systems)
| System | Vendor | Purpose |
|--------|--------|---------|
| CRM | Salesforce | Customer relationship management |
| Billing | Amdocs | Rating, charging, billing |
| Order Management | Oracle | Order orchestration |
| Product Catalog | Netcracker | Product and offer management |

#### OSS (Operations Support Systems)
| System | Vendor | Purpose |
|--------|--------|---------|
| Network Management | Nokia NSP | Network monitoring and control |
| Service Assurance | IBM Maximo | Incident and problem management |
| Inventory | Comarch | Network inventory management |
| Workforce Management | ServiceMax | Field technician scheduling |

### Data Platform Architecture

```
                    ┌─────────────────────────────┐
                    │   Snowflake Data Cloud      │
                    │   (Enterprise Data Platform) │
                    └─────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   ┌────▼────┐          ┌────▼────┐          ┌────▼────┐
   │ Raw     │          │ Curated │          │ Analytics│
   │ Layer   │          │ Layer   │          │ Layer    │
   └─────────┘          └─────────┘          └─────────┘
        │                     │                     │
   ┌────▼────┐          ┌────▼────┐          ┌────▼────┐
   │ BSS/OSS │          │ Semantic│          │ Cortex  │
   │ Feeds   │          │ Models  │          │ AI/ML   │
   └─────────┘          └─────────┘          └─────────┘
```

### Integration Architecture

#### API Gateway
- Kong Enterprise for API management
- OAuth 2.0 / OpenID Connect authentication
- Rate limiting: 1000 requests/minute per partner
- 99.9% uptime SLA

#### Event Streaming
- Kafka cluster for real-time events
- 50M+ events/day processing capacity
- Topics: customer, network, billing, orders

### Cloud Infrastructure

#### AWS Deployment (Primary)
- **Regions:** eu-west-2 (London), eu-west-1 (Dublin - DR)
- **Services:** EC2, EKS, RDS, S3, Lambda
- **Spend:** £8M annually

#### Azure Deployment (Secondary)
- **Regions:** UK South, UK West
- **Services:** AKS, Cosmos DB, Functions
- **Spend:** £3M annually

### Security Architecture

#### Zero Trust Framework
- Identity-based access control (Okta)
- Micro-segmentation (Illumio)
- Continuous verification

#### Security Operations
- 24/7 SOC monitoring
- SIEM: Splunk Enterprise
- Threat intelligence: Recorded Future
- Incident response: <15 minute SLA for P1

### Disaster Recovery

| Tier | RPO | RTO | Systems |
|------|-----|-----|---------|
| Tier 1 | 0 | 15 min | Billing, Network |
| Tier 2 | 1 hour | 4 hours | CRM, Orders |
| Tier 3 | 24 hours | 24 hours | Analytics, Reporting |

## Technology Standards

### Development
- Languages: Java, Python, TypeScript
- Frameworks: Spring Boot, FastAPI, React
- CI/CD: GitLab, ArgoCD
- Containers: Kubernetes (EKS/AKS)

### Data
- Warehouse: Snowflake
- Streaming: Kafka, Kinesis
- ETL: dbt, Airflow
- AI/ML: Snowflake Cortex, SageMaker

### Monitoring
- APM: Datadog
- Logging: ELK Stack
- Metrics: Prometheus/Grafana

---

*Document Owner: VP IT & Digital*
*Last Updated: January 2026*
*Classification: Internal*
