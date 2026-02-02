# Demo Script 24: CHRO / Chief People Officer

## Persona
**Role:** Chief Human Resources Officer (CHRO)  
**Focus:** Workforce analytics, engagement, talent management  
**Duration:** 10 minutes

**Key Documents:** Talent_Strategy_2026.md, Employee_Engagement_Report_Q4_2025.md

## Background
The CHRO leads SnowTelco's people strategy for 2,000+ employees across retail stores, contact centres, network operations, and corporate offices. Key focus areas include employee engagement, retention, diversity, performance management, and workforce planning.

---

## Demo Flow

### Opening (1 minute)
> "Today I'll show you how SnowTelco uses AI-powered workforce analytics to understand employee engagement, identify retention risks, and make data-driven people decisions across our 2,000+ workforce."

---

### Question 1: Workforce Overview
**Ask:** "What is our current headcount by department and work location?"

**Expected Insight:**
- Total headcount by department
- Geographic distribution
- Work type split (On-site, Hybrid, Remote)
- Employment type mix (Full-time, Part-time)

**Talking Point:**
> "Retail Operations is our largest team, but we've seen significant growth in hybrid and remote roles in Network Engineering and IT."

---

### Question 2: Employee Engagement
**Ask:** "What are our employee engagement scores by department and how do they trend?"

**Expected Insight:**
- Overall engagement score
- Department-level scores
- Manager effectiveness ratings
- Career growth perceptions

**Talking Point:**
> "Our overall engagement is 3.8/5, but we see variation by department. Customer Service has room for improvement."

---

### Question 3: eNPS & Retention
**Ask:** "What is our employee Net Promoter Score and which teams have the highest/lowest?"

**Expected Insight:**
- Company-wide eNPS
- eNPS by department and location
- "Would recommend" percentages
- Correlation with tenure

**Talking Point:**
> "Our eNPS of +25 is above industry average, but we need to address pockets of dissatisfaction in specific teams."

---

### Question 4: Compensation & Performance
**Ask:** "What are our average salaries by job level and how does performance rating correlate?"

**Expected Insight:**
- Salary bands by level
- Performance distribution
- High performer compensation
- Department salary comparisons

**Talking Point:**
> "We're competitive at entry and mid-levels, but senior technical roles are slightly below market. That's a retention risk."

---

### Question 5: Workforce Planning
**Ask:** "What's our tenure distribution and which departments have the highest turnover risk?"

**Expected Insight:**
- Average tenure by department
- Employees by tenure bands
- Status distribution (Active, On Leave, Notice)
- Training investment by team

**Talking Point:**
> "Employees with 2-3 years tenure are our highest flight risk. Targeted retention programs are in development."

---

### Question 6: Talent Strategy (Document Search)
**Ask:** "What are our critical skills gaps and hiring priorities for 2026?"

**Expected Insight:**
- Skills gaps from Talent_Strategy_2026.md
- 5G Core Network: 50 needed
- AI/ML Engineering: 35 needed
- Cloud Architecture: 40 needed
- Hiring plan by function

**Talking Point:**
> "The agent can search our talent strategy documents to provide context on workforce planning."

---

### Question 7: Employee Engagement Insights (Document Search)
**Ask:** "What were the key findings from our latest employee engagement survey?"

**Expected Insight:**
- Results from Employee_Engagement_Report_Q4_2025.md
- eNPS score (+38)
- Top performing teams (Data Science: +52)
- Areas for improvement
- Action plans

**Talking Point:**
> "Combining real-time workforce data with our engagement survey findings gives a complete people picture."

---

### Closing (1 minute)
> "With AI-powered workforce analytics, SnowTelco can proactively address engagement issues, identify retention risks, and optimize our investment in people. The agent combines real-time workforce data with our talent strategy documents and engagement survey results for a complete picture."

---

## Key Metrics Reference

| Metric | Description |
|--------|-------------|
| Headcount | Total employee count |
| Engagement Score | Employee engagement (1-5) |
| eNPS | Employee Net Promoter Score (-100 to 100) |
| Tenure | Years of employment |
| Performance Rating | Annual rating (1-5) |
| Training Hours | YTD training investment |

---

## SQL Examples

```sql
-- Headcount by department and work type
SELECT 
    department,
    work_type,
    COUNT(*) as headcount,
    AVG(salary) as avg_salary,
    AVG(tenure_years) as avg_tenure
FROM employee_detail_dim
WHERE status = 'Active'
GROUP BY department, work_type
ORDER BY headcount DESC;

-- Engagement by department
SELECT 
    department,
    COUNT(*) as responses,
    AVG(engagement_score) as engagement,
    AVG(satisfaction_score) as satisfaction,
    AVG(manager_rating) as manager_effectiveness,
    AVG(enps_score) as enps
FROM employee_survey_fact
GROUP BY department
ORDER BY engagement DESC;

-- eNPS by work location
SELECT 
    work_location,
    COUNT(*) as responses,
    AVG(enps_score) as enps,
    SUM(CASE WHEN would_recommend THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as recommend_pct
FROM employee_survey_fact
GROUP BY work_location
ORDER BY enps DESC;

-- Tenure distribution
SELECT 
    CASE 
        WHEN tenure_years < 1 THEN '0-1 years'
        WHEN tenure_years < 2 THEN '1-2 years'
        WHEN tenure_years < 3 THEN '2-3 years'
        WHEN tenure_years < 5 THEN '3-5 years'
        ELSE '5+ years'
    END as tenure_band,
    COUNT(*) as employees,
    AVG(performance_rating) as avg_performance,
    AVG(salary) as avg_salary
FROM employee_detail_dim
WHERE status = 'Active'
GROUP BY tenure_band
ORDER BY tenure_band;
```
