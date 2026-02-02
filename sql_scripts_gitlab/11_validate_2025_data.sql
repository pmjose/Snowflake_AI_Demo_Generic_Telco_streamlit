-- ========================================================================
-- SnowTelco Demo - Step 11: Validate 2025 Historical Data
-- Run this after 10_load_2025_data.sql to verify data loaded
-- Run time: ~30 seconds
-- Prerequisites: Run 10_load_2025_data.sql first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- STEP 1: Validate 2025 Data Row Counts
-- ========================================================================

SELECT '=== 2025 HISTORICAL DATA VALIDATION ===' AS status;

WITH data_2025_counts AS (
    -- Billing
    SELECT 'invoice_fact' AS table_name, 'Billing' AS category, 
           COUNT(*) AS total_rows,
           COUNT(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 THEN 1 END) AS rows_2025
    FROM invoice_fact
    UNION ALL
    SELECT 'payment_fact', 'Billing',
           COUNT(*),
           COUNT(CASE WHEN payment_id >= 10000000 AND payment_id < 20000000 THEN 1 END)
    FROM payment_fact
    UNION ALL
    SELECT 'finance_transactions', 'Billing',
           COUNT(*),
           COUNT(CASE WHEN transaction_id >= 10000000 AND transaction_id < 20000000 THEN 1 END)
    FROM finance_transactions
    
    -- Network
    UNION ALL
    SELECT 'network_performance_fact', 'Network',
           COUNT(*),
           COUNT(CASE WHEN perf_id >= 10000000 AND perf_id < 20000000 THEN 1 END)
    FROM network_performance_fact
    UNION ALL
    SELECT 'network_alarm_fact', 'Network',
           COUNT(*),
           COUNT(CASE WHEN alarm_id >= 10000000 AND alarm_id < 20000000 THEN 1 END)
    FROM network_alarm_fact
    
    -- Support
    UNION ALL
    SELECT 'support_ticket_fact', 'Support',
           COUNT(*),
           COUNT(CASE WHEN ticket_id >= 10000000 AND ticket_id < 20000000 THEN 1 END)
    FROM support_ticket_fact
    UNION ALL
    SELECT 'contact_center_call_fact', 'Support',
           COUNT(*),
           COUNT(CASE WHEN call_id >= 10000000 AND call_id < 20000000 THEN 1 END)
    FROM contact_center_call_fact
    UNION ALL
    SELECT 'complaint_fact', 'Support',
           COUNT(*),
           COUNT(CASE WHEN complaint_id >= 10000000 AND complaint_id < 20000000 THEN 1 END)
    FROM complaint_fact
    
    -- Operations
    UNION ALL
    SELECT 'it_incident_fact', 'Operations',
           COUNT(*),
           COUNT(CASE WHEN incident_id >= 10000000 AND incident_id < 20000000 THEN 1 END)
    FROM it_incident_fact
    UNION ALL
    SELECT 'sla_measurement_fact', 'Operations',
           COUNT(*),
           COUNT(CASE WHEN measurement_id >= 10000000 AND measurement_id < 20000000 THEN 1 END)
    FROM sla_measurement_fact
    
    -- Digital & Loyalty
    UNION ALL
    SELECT 'digital_interaction_fact', 'Digital',
           COUNT(*),
           COUNT(CASE WHEN interaction_id >= 10000000 AND interaction_id < 20000000 THEN 1 END)
    FROM digital_interaction_fact
    UNION ALL
    SELECT 'loyalty_transaction_fact', 'Loyalty',
           COUNT(*),
           COUNT(CASE WHEN transaction_id >= 10000000 AND transaction_id < 20000000 THEN 1 END)
    FROM loyalty_transaction_fact
    
    -- Sales & Marketing
    UNION ALL
    SELECT 'sales_fact', 'Sales',
           COUNT(*),
           COUNT(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 THEN 1 END)
    FROM sales_fact
    UNION ALL
    SELECT 'marketing_campaign_fact', 'Marketing',
           COUNT(*),
           COUNT(CASE WHEN campaign_fact_id >= 10000000 AND campaign_fact_id < 20000000 THEN 1 END)
    FROM marketing_campaign_fact
    UNION ALL
    SELECT 'order_line_fact', 'Sales',
           COUNT(*),
           COUNT(CASE WHEN order_line_id >= 10000000 AND order_line_id < 20000000 THEN 1 END)
    FROM order_line_fact
    
    -- Mobile
    UNION ALL
    SELECT 'mobile_usage_fact', 'Mobile',
           COUNT(*),
           COUNT(CASE WHEN usage_id >= 10000000 AND usage_id < 20000000 THEN 1 END)
    FROM mobile_usage_fact
    UNION ALL
    SELECT 'sim_activation_fact', 'Mobile',
           COUNT(*),
           COUNT(CASE WHEN order_timestamp >= '2025-01-01' AND order_timestamp < '2026-01-01' THEN 1 END)
    FROM sim_activation_fact
    
    -- Other
    UNION ALL
    SELECT 'roaming_usage_fact', 'Roaming',
           COUNT(*),
           COUNT(CASE WHEN roaming_usage_id >= 10000000 AND roaming_usage_id < 20000000 THEN 1 END)
    FROM roaming_usage_fact
    UNION ALL
    SELECT 'iot_usage_fact', 'IoT',
           COUNT(*),
           COUNT(CASE WHEN usage_id >= 10000000 AND usage_id < 20000000 THEN 1 END)
    FROM iot_usage_fact
    
    -- CRM/Salesforce 2025
    UNION ALL
    SELECT 'sf_quotas', 'CRM',
           COUNT(*),
           COUNT(CASE WHEN quota_id LIKE 'QTA1%' THEN 1 END)
    FROM sf_quotas
    UNION ALL
    SELECT 'sf_pipeline_snapshot', 'CRM',
           COUNT(*),
           COUNT(CASE WHEN snapshot_id LIKE 'SNP1%' THEN 1 END)
    FROM sf_pipeline_snapshot
    UNION ALL
    SELECT 'sf_opportunities', 'CRM',
           COUNT(*),
           COUNT(CASE WHEN opportunity_id LIKE 'OPP3%' THEN 1 END)
    FROM sf_opportunities
)
SELECT 
    category,
    table_name,
    TO_VARCHAR(total_rows, '999,999,999') AS total_rows,
    TO_VARCHAR(rows_2025, '999,999,999') AS rows_2025,
    CASE 
        WHEN rows_2025 > 0 THEN '✓ 2025 DATA LOADED'
        ELSE '✗ NO 2025 DATA'
    END AS status
FROM data_2025_counts
ORDER BY category, table_name;

-- ========================================================================
-- STEP 2: Summary Totals
-- ========================================================================

SELECT '=== 2025 DATA SUMMARY ===' AS status;

SELECT 
    'Total 2025 Records Loaded' AS metric,
    TO_VARCHAR(SUM(rows_2025), '999,999,999') AS value
FROM (
    SELECT COUNT(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 THEN 1 END) AS rows_2025 FROM invoice_fact
    UNION ALL SELECT COUNT(CASE WHEN payment_id >= 10000000 AND payment_id < 20000000 THEN 1 END) FROM payment_fact
    UNION ALL SELECT COUNT(CASE WHEN perf_id >= 10000000 AND perf_id < 20000000 THEN 1 END) FROM network_performance_fact
    UNION ALL SELECT COUNT(CASE WHEN alarm_id >= 10000000 AND alarm_id < 20000000 THEN 1 END) FROM network_alarm_fact
    UNION ALL SELECT COUNT(CASE WHEN ticket_id >= 10000000 AND ticket_id < 20000000 THEN 1 END) FROM support_ticket_fact
    UNION ALL SELECT COUNT(CASE WHEN call_id >= 10000000 AND call_id < 20000000 THEN 1 END) FROM contact_center_call_fact
    UNION ALL SELECT COUNT(CASE WHEN complaint_id >= 10000000 AND complaint_id < 20000000 THEN 1 END) FROM complaint_fact
    UNION ALL SELECT COUNT(CASE WHEN incident_id >= 10000000 AND incident_id < 20000000 THEN 1 END) FROM it_incident_fact
    UNION ALL SELECT COUNT(CASE WHEN measurement_id >= 10000000 AND measurement_id < 20000000 THEN 1 END) FROM sla_measurement_fact
    UNION ALL SELECT COUNT(CASE WHEN interaction_id >= 10000000 AND interaction_id < 20000000 THEN 1 END) FROM digital_interaction_fact
    UNION ALL SELECT COUNT(CASE WHEN transaction_id >= 10000000 AND transaction_id < 20000000 THEN 1 END) FROM loyalty_transaction_fact
    UNION ALL SELECT COUNT(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 THEN 1 END) FROM sales_fact
    UNION ALL SELECT COUNT(CASE WHEN campaign_fact_id >= 10000000 AND campaign_fact_id < 20000000 THEN 1 END) FROM marketing_campaign_fact
    UNION ALL SELECT COUNT(CASE WHEN order_line_id >= 10000000 AND order_line_id < 20000000 THEN 1 END) FROM order_line_fact
    UNION ALL SELECT COUNT(CASE WHEN usage_id >= 10000000 AND usage_id < 20000000 THEN 1 END) FROM mobile_usage_fact
    UNION ALL SELECT COUNT(CASE WHEN order_timestamp >= '2025-01-01' AND order_timestamp < '2026-01-01' THEN 1 END) FROM sim_activation_fact
    UNION ALL SELECT COUNT(CASE WHEN roaming_usage_id >= 10000000 AND roaming_usage_id < 20000000 THEN 1 END) FROM roaming_usage_fact
    UNION ALL SELECT COUNT(CASE WHEN usage_id >= 10000000 AND usage_id < 20000000 THEN 1 END) FROM iot_usage_fact
    UNION ALL SELECT COUNT(CASE WHEN transaction_id >= 10000000 AND transaction_id < 20000000 THEN 1 END) FROM finance_transactions
);

-- ========================================================================
-- STEP 3: Date Range Verification (ensure data is from 2025)
-- ========================================================================

SELECT '=== 2025 DATE RANGE VERIFICATION ===' AS status;

SELECT 
    table_name,
    TO_CHAR(record_count, '999,999,999') AS records_2025,
    TO_VARCHAR(min_date, 'YYYY-MM-DD') AS earliest_date,
    TO_VARCHAR(max_date, 'YYYY-MM-DD') AS latest_date,
    CASE 
        WHEN YEAR(min_date) = 2025 AND YEAR(max_date) = 2025 THEN '✓ Valid 2025 Range'
        WHEN min_date IS NULL THEN '⚠ No 2025 Data'
        ELSE '⚠ Date Range Issue'
    END AS status
FROM (
    SELECT 'invoice_fact' AS table_name, 
           COUNT(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 THEN 1 END) AS record_count,
           MIN(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 THEN invoice_date END) AS min_date,
           MAX(CASE WHEN invoice_id >= 10000000 AND invoice_id < 20000000 THEN invoice_date END) AS max_date
    FROM invoice_fact
    UNION ALL
    SELECT 'sales_fact',
           COUNT(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 THEN 1 END),
           MIN(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 THEN date END),
           MAX(CASE WHEN sale_id >= 10000000 AND sale_id < 20000000 THEN date END)
    FROM sales_fact
    UNION ALL
    SELECT 'support_ticket_fact',
           COUNT(CASE WHEN ticket_id >= 10000000 AND ticket_id < 20000000 THEN 1 END),
           MIN(CASE WHEN ticket_id >= 10000000 AND ticket_id < 20000000 THEN created_date END),
           MAX(CASE WHEN ticket_id >= 10000000 AND ticket_id < 20000000 THEN created_date END)
    FROM support_ticket_fact
    UNION ALL
    SELECT 'network_alarm_fact',
           COUNT(CASE WHEN alarm_id >= 10000000 AND alarm_id < 20000000 THEN 1 END),
           MIN(CASE WHEN alarm_id >= 10000000 AND alarm_id < 20000000 THEN raised_time END),
           MAX(CASE WHEN alarm_id >= 10000000 AND alarm_id < 20000000 THEN raised_time END)
    FROM network_alarm_fact
)
ORDER BY table_name;

-- ========================================================================
-- Expected Results:
-- - Total 2025 records: ~7 million
-- - All date ranges should be within 2025
-- - All ID ranges should be 10,000,000 - 19,999,999
-- ========================================================================
