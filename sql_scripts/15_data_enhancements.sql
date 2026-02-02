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
-- FIX 2: Add 5G deployment columns to RAN sites
-- Issue: CTO Q1 (5G rollout status by region) fails - no deployment data
-- ========================================================================

SELECT '=== FIX 2: Adding 5G deployment data to RAN sites ===' AS status;

-- Add deployment columns if they don't exist
ALTER TABLE ran_site_dim ADD COLUMN IF NOT EXISTS deployment_status VARCHAR(50) DEFAULT 'Live';
ALTER TABLE ran_site_dim ADD COLUMN IF NOT EXISTS go_live_date DATE;
ALTER TABLE ran_site_dim ADD COLUMN IF NOT EXISTS technology_generation VARCHAR(20) DEFAULT '4G';

-- Set technology based on site name patterns
UPDATE ran_site_dim
SET technology_generation = CASE 
    WHEN site_name ILIKE '%5G%' THEN '5G'
    WHEN site_type ILIKE '%5G%' THEN '5G'
    WHEN RANDOM() < 0.4 THEN '5G'  -- 40% of sites are 5G
    ELSE '4G'
END
WHERE technology_generation IS NULL OR technology_generation = '4G';

-- Set deployment status (most are Live, some In Progress, few Planned)
UPDATE ran_site_dim
SET deployment_status = CASE 
    WHEN technology_generation = '5G' AND RANDOM() < 0.1 THEN 'Planned'
    WHEN technology_generation = '5G' AND RANDOM() < 0.2 THEN 'In Progress'
    ELSE 'Live'
END;

-- Set go-live dates (past dates for Live, future for Planned)
UPDATE ran_site_dim
SET go_live_date = CASE 
    WHEN deployment_status = 'Live' THEN DATEADD(day, -FLOOR(RANDOM() * 730), CURRENT_DATE())
    WHEN deployment_status = 'In Progress' THEN DATEADD(day, FLOOR(RANDOM() * 90), CURRENT_DATE())
    WHEN deployment_status = 'Planned' THEN DATEADD(day, 90 + FLOOR(RANDOM() * 180), CURRENT_DATE())
END;

-- Verify 5G site distribution
SELECT 
    region,
    technology_generation,
    deployment_status,
    COUNT(*) as site_count
FROM ran_site_dim
GROUP BY region, technology_generation, deployment_status
ORDER BY region, technology_generation, deployment_status;

SELECT '=== FIX 2 COMPLETE ===' AS status;

-- ========================================================================
-- FIX 3: Add settlement status to MVNO data
-- Issue: VP Wholesale Q4 can't filter overdue settlements properly
-- ========================================================================

SELECT '=== FIX 3: Adding settlement status columns ===' AS status;

-- Add is_overdue column if it doesn't exist
ALTER TABLE mvno_settlement_fact ADD COLUMN IF NOT EXISTS is_overdue BOOLEAN DEFAULT FALSE;
ALTER TABLE mvno_settlement_fact ADD COLUMN IF NOT EXISTS days_overdue INTEGER DEFAULT 0;

-- Update based on payment_status field (Overdue vs Paid/Pending)
-- For 'Overdue' status, calculate days since settlement_date
UPDATE mvno_settlement_fact
SET is_overdue = CASE 
    WHEN payment_status = 'Overdue' THEN TRUE
    ELSE FALSE
END,
days_overdue = CASE 
    WHEN payment_status = 'Overdue' THEN 
        DATEDIFF(day, settlement_date, COALESCE(payment_date, CURRENT_DATE()))
    ELSE 0
END;

-- Verify
SELECT 
    is_overdue,
    payment_status,
    COUNT(*) as settlement_count,
    SUM(total_charges) as total_amount
FROM mvno_settlement_fact
GROUP BY is_overdue, payment_status;

SELECT '=== FIX 3 COMPLETE ===' AS status;

-- ========================================================================
-- FIX 4: Create date dimension table
-- Issue: No consistent date hierarchy for reporting
-- ========================================================================

SELECT '=== FIX 4: Creating date dimension ===' AS status;

CREATE OR REPLACE TABLE date_dim AS
WITH date_range AS (
    SELECT DATEADD(day, SEQ4(), '2020-01-01'::DATE) as full_date
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
-- ENHANCEMENT: Add alarm metrics to network alarm data
-- Issue: NETWORK_ALARM_SEMANTIC_VIEW needs fact columns
-- ========================================================================

SELECT '=== ENHANCEMENT: Adding alarm metrics ===' AS status;

-- Add MTTR (Mean Time To Repair) column if not exists
ALTER TABLE network_alarm_fact ADD COLUMN IF NOT EXISTS mttr_minutes INTEGER;
ALTER TABLE network_alarm_fact ADD COLUMN IF NOT EXISTS alarm_duration_minutes INTEGER;

-- Calculate alarm duration (time from raised to cleared)
-- MTTR approximated as time from raised to cleared (repair time)
UPDATE network_alarm_fact
SET alarm_duration_minutes = CASE 
    WHEN cleared_time IS NOT NULL THEN DATEDIFF(minute, raised_time, cleared_time)
    ELSE DATEDIFF(minute, raised_time, CURRENT_TIMESTAMP())
END,
mttr_minutes = CASE 
    WHEN cleared_time IS NOT NULL THEN DATEDIFF(minute, raised_time, cleared_time)
    ELSE NULL
END
WHERE alarm_duration_minutes IS NULL OR mttr_minutes IS NULL;

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
-- VERIFICATION
-- ========================================================================

SELECT '=== DATA ENHANCEMENTS COMPLETE ===' AS status;

-- Summary of changes
SELECT 'mobile_subscriber_dim' as table_name, 'network_generation populated' as enhancement,
    (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE network_generation IS NOT NULL) as affected_rows
UNION ALL
SELECT 'ran_site_dim', '5G deployment data added',
    (SELECT COUNT(*) FROM ran_site_dim WHERE technology_generation = '5G')
UNION ALL
SELECT 'mvno_settlement_fact', 'is_overdue column added',
    (SELECT COUNT(*) FROM mvno_settlement_fact WHERE is_overdue = TRUE)
UNION ALL
SELECT 'date_dim', 'Date dimension created',
    (SELECT COUNT(*) FROM date_dim)
UNION ALL
SELECT 'network_alarm_fact', 'MTTR metrics added',
    (SELECT COUNT(*) FROM network_alarm_fact WHERE mttr_minutes IS NOT NULL);

SELECT '*** Run 08_create_agent.sql again to refresh the agent with enhanced data ***' AS next_step;
