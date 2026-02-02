# Voice Network and Platform Analysis 2025
**SnowTelco Communications - Infrastructure Report**

## Executive Summary

This report provides a comprehensive analysis of SnowTelco's voice network infrastructure, platform performance, and service quality metrics. As a leading UK UCaaS provider, network reliability is critical to customer satisfaction and competitive positioning.

---

## Network Architecture Overview

### Core Infrastructure

| Component | Primary | Secondary | Tertiary |
|-----------|---------|-----------|----------|
| Data Centres | London (LD4) | Manchester (MA1) | Glasgow (GL1) |
| SBC Clusters | 12 | 8 | 4 |
| Media Servers | 48 | 32 | 16 |
| Total Capacity | 500K concurrent calls | 350K | 150K |
| Geographic Redundancy | Active-Active | Active-Passive | DR |

### Network Connectivity

| Connection Type | Capacity | Utilisation |
|-----------------|----------|-------------|
| SnowTelco Tier 1 | 100 Gbps | 42% |
| SnowTelco | 40 Gbps | 38% |
| CityFibre | 20 Gbps | 35% |
| Colt | 20 Gbps | 28% |
| Zayo | 10 Gbps | 22% |
| **Total** | **190 Gbps** | **38%** |

---

## Platform Performance Metrics

### Uptime and Reliability

| Service | Q4 2024 | FY 2024 | SLA Target |
|---------|---------|---------|------------|
| Horizon | 99.97% | 99.96% | 99.95% |
| Teams Phone | 99.99% | 99.98% | 99.99% |
| SIP Trunking | 99.98% | 99.97% | 99.95% |
| Contact Centre | 99.95% | 99.94% | 99.9% |
| **Blended** | **99.97%** | **99.96%** | **99.95%** |

### Incident History

| Severity | Q4 2024 | Q3 2024 | Q2 2024 | Q1 2024 |
|----------|---------|---------|---------|---------|
| P1 (Critical) | 0 | 1 | 0 | 0 |
| P2 (Major) | 2 | 3 | 2 | 4 |
| P3 (Minor) | 8 | 12 | 10 | 11 |
| P4 (Low) | 45 | 52 | 48 | 55 |
| **Total** | **55** | **68** | **60** | **70** |

### Mean Time to Resolution

| Severity | Target | Q4 Actual | Trend |
|----------|--------|-----------|-------|
| P1 | <1 hour | 42 mins | ✓ |
| P2 | <4 hours | 2.8 hours | ✓ |
| P3 | <24 hours | 8.5 hours | ✓ |
| P4 | <72 hours | 28 hours | ✓ |

---

## Voice Quality Metrics

### Call Quality Scores

| Metric | Q4 2024 | Benchmark | Rating |
|--------|---------|-----------|--------|
| MOS (Mean Opinion Score) | 4.35 | 4.0 | Excellent |
| Jitter (avg) | 8ms | <15ms | Excellent |
| Packet Loss | 0.02% | <0.5% | Excellent |
| Latency (avg) | 25ms | <50ms | Excellent |
| Echo Return Loss | 45dB | >30dB | Excellent |

### Call Quality by Product

| Product | MOS Score | Jitter | Packet Loss |
|---------|-----------|--------|-------------|
| Horizon Desktop | 4.38 | 6ms | 0.01% |
| Horizon Mobile | 4.28 | 12ms | 0.04% |
| Teams Phone | 4.42 | 5ms | 0.01% |
| SIP Trunking | 4.32 | 9ms | 0.03% |
| Contact Centre | 4.35 | 7ms | 0.02% |

---

## Capacity Planning

### Current Utilisation

| Resource | Capacity | Current Use | Headroom |
|----------|----------|-------------|----------|
| Concurrent Calls | 1M | 380K peak | 62% |
| Registrations | 2M | 920K | 54% |
| SIP Channels | 2M | 1.2M | 40% |
| Recording Storage | 5 PB | 2.8 PB | 44% |
| API Calls/sec | 50K | 18K | 64% |

### 2025 Capacity Investment

| Initiative | Investment | Capacity Add | Timeline |
|------------|------------|--------------|----------|
| SBC Upgrade | £3M | +200K calls | Q2 2025 |
| Third DC (Edinburgh) | £8M | +300K calls | Q4 2025 |
| Storage Expansion | £2M | +3 PB | Q1 2025 |
| API Infrastructure | £1.5M | +30K/sec | Q2 2025 |
| Network Upgrade | £2.5M | +50 Gbps | Q3 2025 |

---

## Geographic Analysis

### Call Volume by Region

| Region | Q4 Daily Avg | Peak Hour | Growth |
|--------|--------------|-----------|--------|
| London | 850K | 95K | +18% |
| South East | 520K | 58K | +15% |
| North West | 480K | 54K | +22% |
| West Midlands | 380K | 42K | +19% |
| Yorkshire | 320K | 36K | +17% |
| Scotland | 280K | 32K | +25% |
| South West | 240K | 27K | +14% |
| Other | 430K | 48K | +12% |
| **Total UK** | **3.5M** | **392K** | **+18%** |

### International Calling

| Destination | Q4 Minutes | Revenue | Trend |
|-------------|------------|---------|-------|
| EU Countries | 45M | £1.8M | +8% |
| USA/Canada | 28M | £1.1M | +5% |
| India | 18M | £0.9M | +12% |
| Other | 32M | £1.6M | +6% |
| **Total** | **123M** | **£5.4M** | **+7%** |

---

## Security Posture

### Security Metrics

| Metric | Q4 2024 | Target | Status |
|--------|---------|--------|--------|
| DDoS Attacks Mitigated | 142 | N/A | ✓ |
| Fraud Attempts Blocked | 2,850 | N/A | ✓ |
| SIP Authentication Failures | 0.02% | <0.1% | ✓ |
| TLS Encryption | 100% | 100% | ✓ |
| SRTP Adoption | 92% | 95% | ↑ |

### Compliance Status

| Certification | Status | Renewal |
|---------------|--------|---------|
| ISO 27001 | Current | Mar 2025 |
| SOC 2 Type II | Current | Jun 2025 |
| Cyber Essentials Plus | Current | Sep 2025 |
| PCI DSS (Contact Centre) | Current | Dec 2025 |
| GDPR | Compliant | N/A |

---

## Carrier Relationships

### Tier 1 Carriers

| Carrier | Services | Volume | Contract |
|---------|----------|--------|----------|
| SnowTelco Wholesale | PSTN, Numbering | 60% | 2027 |
| SnowTelco | Mobile, SIP | 25% | 2026 |
| SnowTelco Mobile | MVNO | 10% | N/A |
| SnowTelco | Connectivity | 5% | 2025 |

### Number Porting Performance

| Metric | Q4 2024 | Target |
|--------|---------|--------|
| Port-in Success Rate | 98.5% | 98% |
| Avg Port-in Time | 4.2 days | 5 days |
| Emergency Port Success | 99.8% | 99.5% |
| Number Return Rate | 0.8% | <1% |

---

## Support and Maintenance

### Planned Maintenance

| Activity | Frequency | Duration | Impact |
|----------|-----------|----------|--------|
| SBC Patching | Monthly | 2 hours | None (rolling) |
| Platform Updates | Quarterly | 4 hours | Minimal |
| DC Maintenance | Bi-annual | 8 hours | Failover |
| Major Upgrades | Annual | 12 hours | Scheduled |

### 2025 Maintenance Schedule

| Date | Activity | Duration | Risk |
|------|----------|----------|------|
| Feb 15 | SBC Cluster Upgrade | 4 hours | Low |
| Apr 12 | Platform v8.2 Release | 6 hours | Medium |
| Jul 20 | DC Power Upgrade (LD4) | 8 hours | Low |
| Oct 18 | Platform v9.0 Release | 8 hours | Medium |
| Nov 22 | DR Test | 4 hours | Low |

---

## Benchmarking

### vs Industry Standards

| Metric | SnowTelco | Industry Avg | vs Competitor |
|--------|-------|--------------|---------------|
| Uptime | 99.97% | 99.9% | +0.07pp |
| MOS Score | 4.35 | 4.1 | +0.25 |
| MTTR (P1) | 42 min | 90 min | -53% |
| Call Success Rate | 99.8% | 99.5% | +0.3pp |

---

**Prepared by**: Network Operations  
**Date**: January 2025  
**Classification**: Internal
