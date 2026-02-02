# SnowTelco MVNO Partnership Guide

## Overview

SnowTelco's wholesale division provides network access to Mobile Virtual Network Operators (MVNOs), enabling partners to offer mobile services using our infrastructure.

## Partnership Models

### Full MVNO
- Own HLR/HSS infrastructure
- Full control over service delivery
- Custom tariffs and billing
- Direct interconnect
- **Minimum commitment:** 100,000 subscribers

### Light MVNO
- Shared core network services
- SnowTelco billing platform
- Limited customization
- Faster time to market
- **Minimum commitment:** 25,000 subscribers

### Branded Reseller
- White-label service
- SnowTelco manages operations
- Partner handles sales and marketing
- Lowest barrier to entry
- **Minimum commitment:** 10,000 subscribers

## Commercial Terms

### Wholesale Pricing

| Service | Full MVNO | Light MVNO | Reseller |
|---------|-----------|------------|----------|
| Voice (per min) | £0.008 | £0.010 | £0.012 |
| SMS (per message) | £0.004 | £0.005 | £0.006 |
| Data (per GB) | £0.80 | £1.00 | £1.20 |
| 5G Premium | +20% | +25% | +30% |

### Minimum Commitments

| Model | Monthly Minimum | Annual Commitment |
|-------|-----------------|-------------------|
| Full MVNO | £500,000 | 3 years |
| Light MVNO | £100,000 | 2 years |
| Reseller | £25,000 | 1 year |

### Settlement Terms
- Monthly invoicing on 1st of month
- Payment due within 30 days
- Late payment: 2% per month
- Dispute window: 60 days

## Technical Integration

### Full MVNO Requirements
- S6a/S6d interface to HSS
- Diameter signaling gateway
- GTP-C/GTP-U for data
- CAMEL for prepaid
- MAP/Diameter for voice

### Light MVNO Requirements
- API integration for provisioning
- Branded portal access
- Wholesale reporting dashboard
- Webhook notifications

### Network Access
- 4G LTE: All bands
- 5G NSA: 3.5GHz band
- 5G SA: Available Q2 2026
- National roaming: Yes
- International roaming: 50+ countries

## Onboarding Process

### Timeline

| Phase | Duration | Activities |
|-------|----------|------------|
| Commercial | 2-4 weeks | Contract negotiation |
| Technical | 4-8 weeks | Integration development |
| Testing | 2-4 weeks | UAT, network testing |
| Pilot | 2-4 weeks | Limited launch |
| Go-Live | 1 week | Full commercial launch |

### Requirements Checklist

#### Commercial
- [ ] Signed MSA
- [ ] Bank guarantee/letter of credit
- [ ] Insurance certificates
- [ ] Regulatory approval (if required)

#### Technical
- [ ] Integration architecture approved
- [ ] Test environment access
- [ ] API credentials issued
- [ ] Number range allocated

#### Operational
- [ ] Support contacts defined
- [ ] Escalation matrix agreed
- [ ] Reporting requirements confirmed
- [ ] Billing validation complete

## Service Level Agreements

### Network SLAs

| Metric | Target | Measurement |
|--------|--------|-------------|
| Network Availability | 99.9% | Monthly |
| Voice Setup Success | 99.5% | Daily |
| Data Session Success | 99.0% | Daily |
| SMS Delivery | 99.5% | Daily |

### Support SLAs

| Severity | Response | Resolution |
|----------|----------|------------|
| P1 - Outage | 15 min | 4 hours |
| P2 - Degraded | 30 min | 8 hours |
| P3 - Issue | 4 hours | 24 hours |
| P4 - Query | 8 hours | 72 hours |

### Compensation
- SLA breach: Service credits
- Major outage: Pro-rata refund
- Consecutive failures: Contract review

## Reporting and Analytics

### Standard Reports (Included)
- Daily traffic summary
- Monthly invoice detail
- Network quality metrics
- Subscriber growth

### Premium Analytics (Additional Fee)
- Real-time dashboards
- Custom report builder
- Churn prediction
- Usage forecasting

## Partner Success

### Dedicated Support
- Partner Account Manager
- Technical Account Manager
- 24/7 Partner Support Center

### Partner Portal Features
- Self-service provisioning
- Real-time traffic monitoring
- Invoice and payment history
- Support ticket management

### Growth Programs
- Marketing development funds
- Co-branding opportunities
- Joint PR initiatives
- Partner events and training

## Current Partners

| Partner | Model | Segment | Subscribers |
|---------|-------|---------|-------------|
| BudgetMobile | Full MVNO | Value | 450,000 |
| TechTalk | Light MVNO | Business | 85,000 |
| YouthConnect | Reseller | Youth | 120,000 |
| SilverLine | Light MVNO | Senior | 65,000 |

## Contact

### New Partner Enquiries
- Email: wholesale@snowtelco.com
- Phone: +44 20 XXXX XXXX

### Existing Partner Support
- Portal: partners.snowtelco.com
- Email: partnersupport@snowtelco.com
- Phone: 0800 XXX XXXX

---

*Document Owner: VP Wholesale*
*Last Updated: January 2026*
*Classification: Partner Confidential*
