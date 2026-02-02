# SnowTelco Demo Script: WOW Executive Showcase

## Overview

| Attribute | Details |
|-----------|---------|
| **Persona** | CEO / Board Member / Executive Sponsor |
| **Duration** | 10-15 minutes |
| **Difficulty** | Advanced (showcases full platform capabilities) |
| **Purpose** | Maximum impact demonstration for executive audiences |

## Why This Script?

This script is designed to **WOW** your audience by demonstrating:

- **Cross-domain analysis** - Single questions spanning multiple business areas
- **Conversational memory** - Building context through follow-up questions
- **Data + Document fusion** - Combining structured data with policy documents
- **Predictive insights** - ML-driven churn and propensity analysis
- **Actionable recommendations** - Moving from insights to decisions
- **Content generation** - Creating executive summaries and presentations

**Recommended as the first demo script for maximum impact.**

---

## Semantic Views Used

`MOBILE, FINANCE, NETWORK_OPS, NETWORK_QOE, SUPPORT, PROPENSITY, MARKET_INTELLIGENCE, PARTNER, PORTING, CUSTOMER_EXPERIENCE, SLA`

**Document Search:** Retention policies, escalation procedures, competitor analysis

---

## Demo Flow: The Board Meeting Preparation

### Scene Setting

*"Imagine you're the CEO of SnowTelco. You have a board meeting tomorrow morning and need to quickly get up to speed on the business. Let's see how Snowflake Intelligence can prepare you in minutes instead of hours."*

---

## Part 1: The Big Picture (Cross-Domain Analysis)

### Q1: Executive Health Check

> **"I'm preparing for a board meeting tomorrow. Give me a complete health check of SnowTelco - our subscriber base, revenue performance, customer satisfaction, and network quality. What are the 3 most critical things I need to know?"**

**What to highlight:**
- The agent queries MULTIPLE semantic views simultaneously (Mobile, Finance, Support, Network_OPS)
- It synthesizes data into executive-level insights
- It prioritizes and identifies the "critical" items without being asked for specific metrics

**Expected response themes:**
- Subscriber count and growth trends
- Revenue/ARPU by segment
- NPS scores and satisfaction trends
- Network availability and performance
- Top risks or concerns identified

**Presenter note:** *"Notice how one natural language question replaced what would typically be 5-6 separate reports from different departments."*

---

## Part 2: Drilling Into Risk (Conversational Memory)

### Q2: Understanding Churn Risk

> **"Tell me more about our churn situation. What's our current churn rate, which customer segments are most at risk, and how much revenue could we lose?"**

**What to highlight:**
- The agent remembers the context from Q1
- Deep analysis of churn using Propensity semantic view
- Revenue-at-risk calculation

**Expected response themes:**
- Monthly/quarterly churn rate
- High-risk segments identified
- Predicted revenue impact
- Comparison to previous periods

---

### Q3: Identifying At-Risk Customers

> **"Show me the profile of our highest-risk customers. What do they have in common? Are there patterns we should be worried about?"**

**What to highlight:**
- Pattern recognition across customer attributes
- The agent identifies commonalities (tenure, segment, region, etc.)
- Actionable segmentation for retention campaigns

**Presenter note:** *"This kind of analysis would typically require a data scientist. The agent is doing cohort analysis in natural language."*

---

## Part 3: Data + Documents Fusion (The WOW Moment)

### Q4: Policy-Aware Recommendations

> **"What retention offers can we make to these at-risk customers? Check our retention policy and tell me what discounts or incentives are available."**

**What to highlight:**
- This question requires BOTH structured data AND unstructured documents
- The agent searches retention policy documents via Cortex Search
- Combines customer value data with policy constraints

**Expected response themes:**
- Retention offer tiers based on customer value
- Policy-compliant discount ranges
- Recommended actions per segment

**Presenter note:** *"This is where it gets powerful - the agent isn't just querying databases, it's also reading your policy documents and combining them with live data."*

---

### Q5: Competitive Context

> **"How does our pricing compare to competitors? Are we losing customers because of price?"**

**What to highlight:**
- Market Intelligence semantic view
- Porting data showing competitor flows
- Price positioning analysis

**Expected response themes:**
- Port-in vs port-out by competitor
- Pricing comparison
- Churn reason analysis (price sensitivity %)

---

## Part 4: Root Cause Analysis (Operational Deep Dive)

### Q6: Network Impact on Churn

> **"Is network quality contributing to our churn? Show me if there's a correlation between network problems and customer satisfaction in our worst-performing areas."**

**What to highlight:**
- Correlation analysis between Network_QOE and churn
- Geographic analysis
- Root cause identification

**Expected response themes:**
- Cities/regions with network issues
- NPS correlation with network metrics
- Specific problem areas identified

---

### Q7: Support Ticket Patterns

> **"What about our support experience? Are churned customers calling us more before they leave? What are they complaining about?"**

**What to highlight:**
- Support semantic view analysis
- Pre-churn behavior patterns
- Complaint category analysis

**Presenter note:** *"The agent is now acting like a business analyst, connecting dots across multiple data sources."*

---

## Part 5: Action Planning (From Insights to Decisions)

### Q8: Prioritized Action Plan

> **"Based on everything we've discussed, create a prioritized action plan for reducing churn. What should we do first, second, and third? Include specific customer segments and expected impact."**

**What to highlight:**
- The agent synthesizes ALL previous context
- Generates actionable recommendations
- Prioritizes by impact
- Includes measurable outcomes

**Expected response themes:**
1. Immediate actions (high-risk VIP customers)
2. Short-term campaigns (segment-specific offers)
3. Strategic initiatives (network investment, pricing review)

**Presenter note:** *"We've gone from 'what's happening' to 'what should we do' in a single conversation."*

---

## Part 6: Content Generation (The Finale)

### Q9: Board Presentation Summary

> **"Now create an executive summary for my board presentation. I need 5 bullet points covering: business performance, key risks, recommended actions, and expected outcomes. Make it suitable for a board audience."**

**What to highlight:**
- Content generation capability
- Executive-appropriate language
- Synthesizes entire conversation into presentation format

**Expected format:**
```
SNOWTELCO EXECUTIVE SUMMARY - BOARD PRESENTATION

1. BUSINESS PERFORMANCE: [Key metrics]
2. CUSTOMER HEALTH: [NPS, churn, satisfaction]
3. KEY RISKS IDENTIFIED: [Top 3 concerns]
4. RECOMMENDED ACTIONS: [Prioritized initiatives]
5. EXPECTED OUTCOMES: [Projected impact]
```

---

### Q10: (Optional) Follow-Up Data Request

> **"Can you also show me a breakdown of revenue by region and customer type? I want to include this as a supporting chart."**

**What to highlight:**
- The agent can generate data for visualizations
- Maintains context even after the summary
- Ready for follow-up questions

---

## Closing the Demo

### Presenter Summary Points

1. **Speed:** "What you just saw would traditionally take a team of analysts days to compile. We did it in 10 minutes."

2. **Accessibility:** "No SQL, no dashboard training, no waiting for reports. Just ask questions in plain English."

3. **Intelligence:** "The agent doesn't just retrieve data - it analyzes, correlates, and recommends."

4. **Context:** "It remembered our entire conversation and built upon previous answers."

5. **Governance:** "All of this runs on your governed Snowflake data - no data leaves your environment."

---

## Alternative Opening Questions

If you want to vary the demo, try these powerful openers:

### Crisis Mode
> *"We're seeing customer complaints spike 40% this week. What's happening, how many customers are affected, what's the revenue at risk, and what should we do about it?"*

### Competitive Threat
> *"Our competitor just announced a major price cut. How exposed are we? Which of our customers are most price-sensitive and likely to switch?"*

### Board Question Simulation
> *"A board member asked why our NPS dropped last quarter. Investigate this and give me talking points for my response."*

### Investment Decision
> *"We have budget for one major initiative - network expansion OR customer retention program. Which would have more impact on revenue? Show me the analysis."*

---

## Key Metrics Reference

| Metric | Source View | Typical Value |
|--------|-------------|---------------|
| Total Subscribers | MOBILE | ~30,000 |
| Monthly Churn Rate | MOBILE, PROPENSITY | 1.5-2.0% |
| Average NPS | MOBILE, CUSTOMER_EXPERIENCE | +35 to +50 |
| Network Availability | NETWORK_OPS | 99.5-99.9% |
| Revenue at Risk (High Churn) | PROPENSITY | £2-3M |
| ARPU - Consumer | MOBILE, FINANCE | £35-45 |
| ARPU - Enterprise | MOBILE, FINANCE | £400-500 |
| Support Tickets/Month | SUPPORT | ~15-20K |

---

## Demo Tips

### Do's
- Let the agent finish its response before asking follow-ups
- React naturally to the responses ("That's concerning..." or "Good, what about...")
- Point out when the agent connects information from different sources
- Emphasize the conversational flow and context retention

### Don'ts
- Don't rush through - let the audience absorb each response
- Don't ask overly specific technical questions (save that for CTO demo)
- Don't interrupt the "story" with tangential questions
- Don't forget to highlight the document search capability

### Recovery Phrases
If the agent doesn't return expected data:
- "Let me rephrase that..." 
- "Let's approach this differently..."
- "That's interesting - let's dig into [specific area] instead..."

---

## Post-Demo Discussion Points

1. **"How long would this analysis take your team today?"**
2. **"What if every executive could access insights this easily?"**
3. **"Imagine your sales team asking about pipeline, or HR asking about attrition..."**
4. **"This is YOUR data, governed by YOUR policies, in YOUR Snowflake account."**

---

*This demo script showcases the full power of Snowflake Intelligence - from data analysis to document search to actionable insights, all through natural conversation.*
