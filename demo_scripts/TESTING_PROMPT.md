# SnowTelco Demo Scripts Testing Prompt

## Objective

You are a testing agent responsible for validating SnowTelco's Snowflake Intelligence demo scripts. Your task is to systematically test each demo script by asking all questions, evaluating the AI responses for accuracy, and documenting whether visualizations (charts/graphs) are generated.

---

## IMPORTANT: Testing Must Be Done in the Browser UI

**All testing MUST be performed through the Snowflake Intelligence web interface (Snowsight).**

- Navigate to [Snowsight](https://app.snowflake.com) and access **Snowflake Intelligence**
- Do NOT test via API calls, CLI, or programmatic methods
- The browser UI is required to:
  - Evaluate chart/visualization generation
  - Test the actual user experience
  - Verify response formatting and presentation
  - Capture suggested follow-up questions from the agent

**Testing URL:** Access Snowflake Intelligence through Snowsight > AI & ML > Snowflake Intelligence

---

## MFA Bypass for Automated Testing

If MFA is enabled on the test account, you may need to temporarily bypass it for automated testing:

```sql
-- Run this as ACCOUNTADMIN to bypass MFA for 60 minutes
ALTER USER <username> SET MINS_TO_BYPASS_MFA = 60;
```

**Important Notes:**
- This grants a 60-minute window where MFA is not required
- Re-run the command if testing exceeds 60 minutes
- Only use for automated testing accounts, not production users
- The setting automatically expires after the specified time

---

## Quick Reference

| Resource | File | Purpose |
|----------|------|---------|
| **Questions** | `demo_scripts/ALL_TEST_QUESTIONS.md` | All 150 questions to test (USE THIS) |
| **Instructions** | `demo_scripts/TESTING_PROMPT.md` | This file - testing procedures |
| **Templates** | `demo_scripts/test_reports_TEMPLATE/` | Sample report formats |

**Start by reading `ALL_TEST_QUESTIONS.md`** - it has all questions pre-extracted for fast testing.

---

## Setup Instructions

### 1. Clear Context / Start Fresh

**IMPORTANT: Before testing, clear any existing conversation history in Snowflake Intelligence.**

- Start a new conversation/session
- Do NOT carry context from previous testing sessions
- Clear history between EACH demo script to ensure independent results

**Between Scripts:**
- After completing all questions for one script, clear the conversation
- Start fresh for the next script
- This prevents the AI from using context from previous questions which could artificially improve or skew results

**Why this matters:**
- Each script should be tested independently
- Real demo users won't have prior context
- Ensures accurate baseline measurements
- Identifies questions that fail without context assistance

### 2. Create Test Output Folder

Before starting, create a new test folder with today's date:

```
demo_scripts/test_reports_YYYY-MM-DD/
```

For example: `demo_scripts/test_reports_2026-01-30/`

### 3. Demo Scripts to Test

Test the following scripts in order:

| # | Script File | Persona |
|---|-------------|---------|
| **00** | **00_WOW_Executive_Showcase.md** | **CEO / Board (Flagship)** |
| 01 | 01_CEO_Strategic.md | CEO |
| 02 | 02_CFO_Finance.md | CFO |
| 03 | 03_CMO_Marketing.md | CMO |
| 04 | 04_CTO_Technology.md | CTO |
| 05 | 05_COO_Operations.md | COO |
| 06 | 06_CCO_Commercial.md | CCO |
| 07 | 07_CXO_Customer_Experience.md | CXO |
| 08 | 08_CNO_Network_QoE.md | CNO |
| 09 | 09_CDO_Data_Science.md | CDO |
| 10 | 10_CSO_Sustainability.md | CSO |
| 11 | 11_VP_Customer_Service.md | VP Customer Service |
| 12 | 12_VP_Network_Operations.md | VP Network Ops |
| 13 | 13_Head_of_Partners.md | Head of Partners |
| 14 | 14_VP_Billing_Revenue.md | VP Billing |
| 15 | 15_VP_IT_Digital.md | VP IT |
| 16 | 16_VP_Field_Operations.md | VP Field Ops |
| 17 | 17_VP_Strategy.md | VP Strategy |
| 18 | 18_VP_Communications.md | VP Communications |
| 19 | 19_Regulatory_Compliance.md | Regulatory |
| 20 | 20_VP_Security.md | VP Security |
| 21 | 21_VP_Enterprise_Sales.md | VP Enterprise Sales |
| 22 | 22_VP_Wholesale.md | VP Wholesale |
| 23 | 23_VP_Retail.md | VP Retail |
| 24 | 24_CHRO_People.md | CHRO |
| 25 | 25_VP_Legal.md | VP Legal |
| 26 | 26_VP_Product.md | VP Product |
| 27 | 27_VP_Procurement.md | VP Procurement |

---

## Questions Source File

**IMPORTANT: Use the consolidated questions file for faster testing:**

```
demo_scripts/ALL_TEST_QUESTIONS.md
```

This file contains all **182 questions** extracted from 28 scripts, organized by script with:
- Exact question text to copy/paste
- Expected insights for validation
- Question count per script

**Do NOT read individual demo script files** - use `ALL_TEST_QUESTIONS.md` instead for efficiency.

---

## Testing Procedure

For each script section in `ALL_TEST_QUESTIONS.md`, follow this workflow:

### Step 1: Load Questions from ALL_TEST_QUESTIONS.md

1. Open `demo_scripts/ALL_TEST_QUESTIONS.md`
2. Navigate to the script section (e.g., `## 01_CEO_Strategic.md`)
3. Each question has:
   - **Question text** in blockquote format `> "..."`
   - **Expected insights** listed below each question
4. Process all questions for one script before moving to the next

### Step 2: Execute Each Question

For each question in the section:

1. **Navigate** to the Snowflake Intelligence UI
2. **Enter** the exact question text from the demo script
3. **Wait** for the response to complete (including any chart rendering)
4. **Capture** the following:
   - The full text response
   - Whether a chart/graph was generated (Yes/No)
   - The chart type if generated (Bar, Line, Pie, Table, etc.)
   - Any error messages displayed
   - Response time (if measurable)

### Step 3: Evaluate Response Accuracy

For each response, evaluate against these criteria:

#### Data Accuracy Checks
- [ ] Response contains relevant data (not "no data found")
- [ ] Numbers are reasonable (not all zeros, not obviously wrong)
- [ ] Data matches expected insights from the script
- [ ] Correct time periods referenced (2024-2026 data expected)
- [ ] No NULL values where data should exist
- [ ] Correct dimensions used (customer_type, segment, etc.)

#### Response Quality Checks
- [ ] Question was understood correctly
- [ ] Response addresses all parts of the question
- [ ] Data is broken down as requested (by type, segment, region, etc.)
- [ ] Comparisons are made when requested

#### Visualization Checks
- [ ] Chart generated when data is suitable for visualization
- [ ] Chart type is appropriate for the data
- [ ] Chart is readable and properly labeled
- [ ] Chart data matches the text response

#### Agent Suggested Questions
- [ ] If data is not available, did the agent suggest alternative questions?
- [ ] If yes, capture ALL suggested questions exactly as provided
- [ ] These suggestions are valuable for improving demo scripts

**IMPORTANT:** When the agent responds with "no data available" or similar, it often suggests alternative questions that WOULD work. Always capture these suggestions in the report - they help identify:
- Better question phrasing
- Available data that could answer similar questions
- Semantic view gaps or naming issues

### Step 4: Classify Each Result

Assign one of these statuses to each question:

| Status | Criteria |
|--------|----------|
| **PASS** | Accurate data returned, matches expected insights, visualization appropriate |
| **PARTIAL** | Data returned but incomplete, missing some dimensions, or minor inaccuracies |
| **FAIL** | Wrong data, significant errors, or completely misunderstood question |
| **NO_DATA** | Query executed but returned no results or "no data available" |
| **ERROR** | System error, timeout, or failed to execute |
| **NULL_VALUES** | Data returned but contains unexpected NULL/empty values |

---

## Report Format

Create one report file per demo script in the test folder.

### Report Filename Convention

```
{script_number}_{persona}_Test_Report.md
```

Example: `01_CEO_Strategic_Test_Report.md`

### Report Template

Use this exact template for each report:

```markdown
# Test Report: {Persona} Demo Script

**Test Date:** YYYY-MM-DD HH:MM  
**Script Tested:** {script_filename}  
**Tester:** Automated Test System  
**Snowflake Environment:** [Environment Name]

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Total Questions | X |
| Passed | X |
| Partial | X |
| Failed | X |
| No Data | X |
| Errors | X |
| Charts Generated | X of Y |
| Overall Score | XX% |

### Summary Notes
[Brief 2-3 sentence summary of overall script performance, major issues found]

---

## Detailed Results

### Question 1: [Question Title from Script]

**Question Asked:**
> "[Exact question text]"

**Expected Insights:**
- [List from demo script]

**Actual Response:**
[Paste or summarize the actual response received]

**Evaluation:**

| Check | Result |
|-------|--------|
| Data Returned | Yes/No |
| Data Accurate | Yes/No/Partial |
| Matches Expected | Yes/No/Partial |
| Nulls Present | Yes/No |
| Chart Generated | Yes/No |
| Chart Type | [Type or N/A] |
| Chart Appropriate | Yes/No/N/A |

**Status:** [PASS/PARTIAL/FAIL/NO_DATA/ERROR/NULL_VALUES]

**Issues Found:**
- [List any issues, or "None"]

**Agent Suggested Questions:**
- [If NO_DATA or FAIL: List any alternative questions the agent suggested]
- [If none suggested, write "None"]

**Recommendations:**
- [Any suggestions for fixing issues, or "None"]

---

### Question 2: [Continue for each question...]

[Repeat the above structure for each question]

---

## Issues Summary

### Critical Issues (Must Fix)
1. [List any FAIL or ERROR items]

### Minor Issues (Should Fix)
1. [List any PARTIAL items]

### Data Gaps Identified
1. [List any NO_DATA or NULL_VALUES items with details]

### Agent Suggested Alternative Questions
[Compile all suggested questions from the agent here - these are valuable for improving demo scripts]

| Original Question | Agent Suggested Alternative |
|-------------------|----------------------------|
| [Question that failed] | [Suggested question that would work] |
| ... | ... |

---

## Recommendations

### Immediate Actions
1. [Priority fixes needed]

### Future Improvements
1. [Nice-to-have enhancements]

---

## Appendix: Raw Response Data

[Optional: Include full raw responses if needed for debugging]
```

---

## Master Summary Report

After testing all scripts, create a master summary report:

### Filename: `00_MASTER_TEST_SUMMARY.md`

### Template:

```markdown
# SnowTelco Demo Scripts - Master Test Summary

**Test Date:** YYYY-MM-DD  
**Total Scripts Tested:** 25  
**Total Questions Tested:** XXX

---

## Overall Results

| Status | Count | Percentage |
|--------|-------|------------|
| PASS | X | XX% |
| PARTIAL | X | XX% |
| FAIL | X | XX% |
| NO_DATA | X | XX% |
| ERROR | X | XX% |
| NULL_VALUES | X | XX% |

### Chart Generation Rate
- Questions where charts were generated: X of Y (XX%)
- Questions where charts should have been generated: X
- Missing charts: X

---

## Results by Script

| Script | Pass | Partial | Fail | No Data | Error | Charts | Score |
|--------|------|---------|------|---------|-------|--------|-------|
| 01_CEO_Strategic | X | X | X | X | X | X/Y | XX% |
| 02_CFO_Finance | X | X | X | X | X | X/Y | XX% |
| ... | ... | ... | ... | ... | ... | ... | ... |

---

## Top Issues

### 1. Data Gaps
[List semantic views or data tables with missing/incomplete data]

### 2. Query Understanding Issues
[List questions that were consistently misunderstood]

### 3. Visualization Gaps
[List question types that should generate charts but don't]

### 4. NULL Value Problems
[List dimensions/metrics with NULL issues]

---

## Recommendations

### Priority 1: Critical Fixes
1. [Issues blocking demo]

### Priority 2: Important Improvements
1. [Issues affecting demo quality]

### Priority 3: Nice to Have
1. [Enhancement opportunities]

---

## Scripts Requiring Attention

### Red (Multiple Failures)
- [List scripts with >2 FAIL results]

### Yellow (Partial Issues)
- [List scripts with >2 PARTIAL results]

### Green (Ready for Demo)
- [List scripts with >80% PASS rate]
```

---

## Special Instructions

### Handling Common Scenarios

#### Scenario 1: "No data available" Response
- Record as `NO_DATA`
- Check if the semantic view exists
- Note which table/view should have data
- Suggest checking data loading scripts

#### Scenario 2: Response with NULL values
- Record as `NULL_VALUES` if NULLs affect the answer
- Note which fields are NULL
- Check if NULLs are in dimension or fact columns

#### Scenario 3: Wrong time period
- If data is only from 2024 when 2025-2026 expected, mark as `PARTIAL`
- Note the date range returned vs expected

#### Scenario 4: Chart not generated for numeric data
- Note in "Chart Generated: No"
- Add to recommendations: "This question should generate a chart"

#### Scenario 5: System error or timeout
- Record as `ERROR`
- Capture the error message exactly
- Note if it's reproducible

### Questions to Flag for Manual Review

Flag these patterns for human review:
1. Any question with `FAIL` status
2. Any question with `ERROR` status
3. Questions where the response seems correct but doesn't match expected insights
4. Questions where chart data doesn't match text response

---

## Validation Checklist

Before finalizing reports, verify:

- [ ] Used `ALL_TEST_QUESTIONS.md` as question source
- [ ] All 28 scripts tested (182 total questions)
- [ ] All questions from each script tested
- [ ] Each question has a clear status assigned
- [ ] Chart generation noted for every question
- [ ] Issues summarized accurately
- [ ] Recommendations are actionable
- [ ] Master summary created (`00_MASTER_TEST_SUMMARY.md`)
- [ ] All reports saved to test folder (`test_reports_YYYY-MM-DD/`)

---

## Expected Data Ranges

When validating responses, use these expected ranges:

| Metric | Expected Range |
|--------|----------------|
| Total Subscribers | ~30,000 |
| Consumer % | ~70% |
| SMB % | ~26% |
| Enterprise % | ~4% |
| ARPU Consumer | £25-40 |
| ARPU SMB | £50-80 |
| ARPU Enterprise | £100-150 |
| NPS Score | 1-10 scale |
| Churn Rate | 1-5% monthly |
| Network Availability | 99.5%+ |
| Data Date Range | 2024-01 to 2026-02 |

---

## Notes

- **Use `ALL_TEST_QUESTIONS.md`** - do not read individual script files (faster)
- If Snowflake Intelligence UI is slow, wait up to 60 seconds for responses
- Clear the conversation between scripts to avoid context carryover
- Take screenshots of any unusual behavior for debugging
- Note the time of testing in case of data freshness issues
- Total questions: 175 across 27 scripts (see summary table in ALL_TEST_QUESTIONS.md)
- Includes 13 document search questions testing internal documents (Strategy, Playbooks, Handbooks, Contracts)
- New personas: VP Product (plan analytics), VP Procurement (vendor spend)
