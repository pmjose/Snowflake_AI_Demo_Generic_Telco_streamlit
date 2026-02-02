-- ========================================================================
-- SnowTelco Demo - Step 15: Data Enhancements
-- Fixes data gaps and adds enhancements for improved demo quality
-- Run time: ~2-3 minutes
-- Prerequisites: Run 01-08 scripts first
-- Version: 1.0 - January 2026
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== APPLYING DATA ENHANCEMENTS ===' AS status;

-- ========================================================================
-- FIX 1: Populate network_generation for mobile subscribers
-- Issue: 93% of subscribers have NULL network_generation, breaking CTO/CNO queries
-- ========================================================================

SELECT '=== FIX 1: Populating network_generation ===' AS status;

-- First, check current state
SELECT 
    network_generation,
    COUNT(*) as subscriber_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM mobile_subscriber_dim
GROUP BY network_generation
ORDER BY subscriber_count DESC;

-- Update based on plan features (5G included or not)
UPDATE mobile_subscriber_dim s
SET network_generation = CASE 
    WHEN p."5g_included" = TRUE THEN '5G'
    ELSE '4G'
END
FROM mobile_plan_dim p
WHERE s.plan_key = p.plan_key
  AND s.network_generation IS NULL;

-- For any remaining NULLs, default to 4G
UPDATE mobile_subscriber_dim
SET network_generation = '4G'
WHERE network_generation IS NULL;

-- Verify fix
SELECT 
    network_generation,
    COUNT(*) as subscriber_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM mobile_subscriber_dim
GROUP BY network_generation
ORDER BY subscriber_count DESC;

SELECT '=== FIX 1 COMPLETE ===' AS status;

-- ========================================================================
-- FIX 2: Update 5G deployment data in RAN sites
-- Uses existing 'technology' column from table definition
-- ========================================================================

SELECT '=== FIX 2: Updating 5G deployment data in RAN sites ===' AS status;

-- Update existing technology column based on site name patterns
UPDATE ran_site_dim
SET technology = CASE 
    WHEN site_name ILIKE '%5G%' THEN '5G'
    WHEN site_type ILIKE '%5G%' THEN '5G'
    WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.4 THEN '5G'
    ELSE '4G'
END
WHERE technology IS NULL OR technology NOT IN ('4G', '5G');

-- Verify 5G site distribution
SELECT 
    county,
    technology,
    status,
    COUNT(*) as site_count
FROM ran_site_dim
GROUP BY county, technology, status
ORDER BY site_count DESC
LIMIT 20;

SELECT '=== FIX 2 COMPLETE ===' AS status;

-- ========================================================================
-- FIX 3: Update settlement status in MVNO data
-- Columns is_overdue and days_overdue already exist in table definition
-- ========================================================================

SELECT '=== FIX 3: Updating settlement status ===' AS status;

-- Update based on payment_status field
UPDATE mvno_settlement_fact m
SET m.is_overdue = CASE 
    WHEN m.payment_status = 'Overdue' THEN TRUE
    ELSE FALSE
END,
m.days_overdue = CASE 
    WHEN m.payment_status = 'Overdue' THEN 
        DATEDIFF(day, m.settlement_date, COALESCE(m.payment_date, CURRENT_DATE()))
    ELSE 0
END;

-- Verify
SELECT 
    payment_status,
    COUNT(*) as settlement_count,
    SUM(total_charges) as total_amount
FROM mvno_settlement_fact
GROUP BY payment_status;

SELECT '=== FIX 3 COMPLETE ===' AS status;

-- ========================================================================
-- FIX 4: Create date dimension table
-- Issue: No consistent date hierarchy for reporting
-- ========================================================================

SELECT '=== FIX 4: Creating date dimension ===' AS status;

CREATE OR REPLACE TABLE date_dim AS
WITH date_range AS (
    SELECT DATEADD(day, ROW_NUMBER() OVER (ORDER BY NULL) - 1, '2020-01-01'::DATE) as full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 3000))  -- ~8 years of dates
)
SELECT 
    TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD')) as date_key,
    full_date,
    YEAR(full_date) as year,
    QUARTER(full_date) as quarter,
    MONTH(full_date) as month,
    MONTHNAME(full_date) as month_name,
    WEEKOFYEAR(full_date) as week_of_year,
    DAYOFWEEK(full_date) as day_of_week,
    DAYNAME(full_date) as day_name,
    DAYOFMONTH(full_date) as day_of_month,
    DAYOFYEAR(full_date) as day_of_year,
    CASE WHEN DAYOFWEEK(full_date) IN (0, 6) THEN TRUE ELSE FALSE END as is_weekend,
    FALSE as is_holiday,  -- Can be populated with UK holidays
    CASE WHEN MONTH(full_date) >= 4 THEN YEAR(full_date) ELSE YEAR(full_date) - 1 END as fiscal_year,
    CASE 
        WHEN MONTH(full_date) IN (4, 5, 6) THEN 1
        WHEN MONTH(full_date) IN (7, 8, 9) THEN 2
        WHEN MONTH(full_date) IN (10, 11, 12) THEN 3
        ELSE 4
    END as fiscal_quarter,
    TO_CHAR(full_date, 'YYYY-MM') as year_month,
    TO_CHAR(full_date, 'YYYY-Q') || QUARTER(full_date) as year_quarter
FROM date_range
WHERE full_date <= DATEADD(year, 2, CURRENT_DATE());

SELECT COUNT(*) as date_count, MIN(full_date) as min_date, MAX(full_date) as max_date FROM date_dim;

SELECT '=== FIX 4 COMPLETE ===' AS status;

-- ========================================================================
-- ENHANCEMENT: Update alarm metrics in network alarm data
-- Columns alarm_duration_minutes and mttr_minutes already exist in table
-- ========================================================================

SELECT '=== ENHANCEMENT: Updating alarm metrics ===' AS status;

-- Calculate alarm duration and MTTR
UPDATE network_alarm_fact n
SET n.alarm_duration_minutes = CASE 
    WHEN n.cleared_time IS NOT NULL THEN DATEDIFF(minute, n.raised_time, n.cleared_time)
    ELSE DATEDIFF(minute, n.raised_time, CURRENT_TIMESTAMP())
END,
n.mttr_minutes = CASE 
    WHEN n.cleared_time IS NOT NULL THEN DATEDIFF(minute, n.raised_time, n.cleared_time)
    ELSE NULL
END
WHERE n.alarm_duration_minutes IS NULL OR n.mttr_minutes IS NULL;

-- Verify
SELECT 
    severity,
    COUNT(*) as alarm_count,
    ROUND(AVG(alarm_duration_minutes), 2) as avg_duration_mins,
    ROUND(AVG(mttr_minutes), 2) as avg_mttr_mins
FROM network_alarm_fact
GROUP BY severity
ORDER BY severity;

SELECT '=== ENHANCEMENT COMPLETE ===' AS status;

-- ========================================================================
-- VERIFICATION - Combined into single result
-- ========================================================================

SELECT 
    table_name,
    enhancement,
    affected_rows,
    'All enhancements complete' AS status
FROM (
    SELECT 1 AS sort_order, 'mobile_subscriber_dim' AS table_name, 'network_generation populated' AS enhancement,
        (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE network_generation IS NOT NULL) AS affected_rows
    UNION ALL
    SELECT 2, 'ran_site_dim', '5G technology updated',
        (SELECT COUNT(*) FROM ran_site_dim WHERE technology = '5G')
    UNION ALL
    SELECT 3, 'mvno_settlement_fact', 'is_overdue column added',
        (SELECT COUNT(*) FROM mvno_settlement_fact WHERE is_overdue = TRUE)
    UNION ALL
    SELECT 4, 'date_dim', 'Date dimension created',
        (SELECT COUNT(*) FROM date_dim)
    UNION ALL
    SELECT 5, 'network_alarm_fact', 'MTTR metrics added',
        (SELECT COUNT(*) FROM network_alarm_fact WHERE mttr_minutes IS NOT NULL)
)
ORDER BY sort_order;
