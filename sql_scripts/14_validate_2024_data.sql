-- =====================================================
-- SnowTelco 2024 Data Validation Script
-- =====================================================
-- Validates that 2024 data was loaded correctly
-- and verifies no ID collisions with existing data.
-- =====================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- =====================================================
-- CHECK 1: RECORD COUNTS BY YEAR
-- =====================================================

SELECT '=== RECORD COUNTS BY YEAR ===' AS validation_check;

SELECT 
    'invoice_fact' as table_name,
    COUNT(CASE WHEN invoice_date < '2024-01-01' THEN 1 END) as before_2024,
    COUNT(CASE WHEN invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN 1 END) as year_2024,
    COUNT(CASE WHEN invoice_date >= '2025-01-01' AND invoice_date < '2026-01-01' THEN 1 END) as year_2025,
    COUNT(CASE WHEN invoice_date >= '2026-01-01' THEN 1 END) as year_2026_plus,
    COUNT(*) as total
FROM invoice_fact
UNION ALL
SELECT 'sales_fact',
    COUNT(CASE WHEN date < '2024-01-01' THEN 1 END),
    COUNT(CASE WHEN date >= '2024-01-01' AND date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN date >= '2025-01-01' AND date < '2026-01-01' THEN 1 END),
    COUNT(CASE WHEN date >= '2026-01-01' THEN 1 END),
    COUNT(*)
FROM sales_fact
UNION ALL
SELECT 'support_ticket_fact',
    COUNT(CASE WHEN created_date < '2024-01-01' THEN 1 END),
    COUNT(CASE WHEN created_date >= '2024-01-01' AND created_date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN created_date >= '2025-01-01' AND created_date < '2026-01-01' THEN 1 END),
    COUNT(CASE WHEN created_date >= '2026-01-01' THEN 1 END),
    COUNT(*)
FROM support_ticket_fact
UNION ALL
SELECT 'network_alarm_fact',
    COUNT(CASE WHEN raised_time < '2024-01-01' THEN 1 END),
    COUNT(CASE WHEN raised_time >= '2024-01-01' AND raised_time < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN raised_time >= '2025-01-01' AND raised_time < '2026-01-01' THEN 1 END),
    COUNT(CASE WHEN raised_time >= '2026-01-01' THEN 1 END),
    COUNT(*)
FROM network_alarm_fact;

-- =====================================================
-- CHECK 2: ID RANGE VERIFICATION
-- =====================================================

SELECT '=== ID RANGE VERIFICATION ===' AS validation_check;
SELECT 'Ensuring 2024 data uses IDs 20,000,000+' AS note;

SELECT 
    'invoice_fact' as table_name,
    MIN(invoice_id) as min_id,
    MAX(invoice_id) as max_id,
    CASE 
        WHEN MIN(CASE WHEN invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN invoice_id END) >= 20000000 
        THEN 'PASS' 
        ELSE 'FAIL - 2024 IDs below 20M' 
    END as id_range_check
FROM invoice_fact
UNION ALL
SELECT 'sales_fact',
    MIN(sale_id),
    MAX(sale_id),
    CASE 
        WHEN MIN(CASE WHEN date >= '2024-01-01' AND date < '2025-01-01' THEN sale_id END) >= 20000000 
        THEN 'PASS' 
        ELSE 'FAIL - 2024 IDs below 20M' 
    END
FROM sales_fact
UNION ALL
SELECT 'support_ticket_fact',
    MIN(ticket_id),
    MAX(ticket_id),
    CASE 
        WHEN MIN(CASE WHEN created_date >= '2024-01-01' AND created_date < '2025-01-01' THEN ticket_id END) >= 20000000 
        THEN 'PASS' 
        ELSE 'FAIL - 2024 IDs below 20M' 
    END
FROM support_ticket_fact;

-- =====================================================
-- CHECK 3: DATA QUALITY - NO OVERLAPPING ID RANGES
-- =====================================================

SELECT '=== ID COLLISION CHECK ===' AS validation_check;

SELECT 'invoice_fact' as table_name,
    COUNT(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 AND invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN 1 END) as collisions_in_2025_range,
    COUNT(CASE WHEN invoice_id < 10000000 AND invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN 1 END) as collisions_in_base_range
FROM invoice_fact
UNION ALL
SELECT 'sales_fact',
    COUNT(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 AND date >= '2024-01-01' AND date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN sale_id < 10000000 AND date >= '2024-01-01' AND date < '2025-01-01' THEN 1 END)
FROM sales_fact;

-- =====================================================
-- CHECK 4: YOY GROWTH TRAJECTORY (Should show growth)
-- =====================================================

SELECT '=== YOY REVENUE TRAJECTORY ===' AS validation_check;

SELECT 
    YEAR(invoice_date) as year,
    SUM(total_amount) as total_revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(invoice_date)) as prev_year_revenue,
    ROUND((SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(invoice_date))) / 
          NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY YEAR(invoice_date)), 0) * 100, 2) as yoy_growth_pct
FROM invoice_fact
WHERE invoice_date >= '2024-01-01'
GROUP BY YEAR(invoice_date)
ORDER BY year;

-- =====================================================
-- CHECK 5: MONTHLY DISTRIBUTION CHECK
-- =====================================================

SELECT '=== 2024 MONTHLY DISTRIBUTION ===' AS validation_check;

SELECT 
    DATE_TRUNC('month', invoice_date) as month,
    COUNT(*) as invoice_count,
    ROUND(SUM(total_amount), 2) as total_revenue
FROM invoice_fact
WHERE invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY month;

-- =====================================================
-- SUMMARY
-- =====================================================

SELECT '=== VALIDATION COMPLETE ===' AS status;
SELECT 'If all checks show PASS and no collisions, 2024 data is ready for use.' AS summary;
