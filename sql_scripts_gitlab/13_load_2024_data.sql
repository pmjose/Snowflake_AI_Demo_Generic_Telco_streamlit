-- =====================================================
-- SnowTelco 2024 Historical Data Loading Script
-- =====================================================
-- This script loads 2024 historical data into existing tables.
-- Prerequisites: Run 00-04 and 10 scripts first
-- 
-- STEP 1: Copy 2024 files from Git to internal stage
-- STEP 2: Load data from internal stage into tables
-- =====================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- =====================================================
-- STEP 1: COPY 2024 FILES FROM GIT TO INTERNAL STAGE
-- =====================================================

COPY FILES
INTO @INTERNAL_DATA_STAGE/additional_data/2024/
FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/additional_data/2024/csv/
PATTERN='.*\.csv';

ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- =====================================================
-- STEP 2: LOAD 2024 DATA INTO EXISTING TABLES
-- =====================================================

COPY INTO invoice_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/invoice_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO payment_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/payment_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO finance_transactions
FROM @INTERNAL_DATA_STAGE/additional_data/2024/finance_transactions_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO network_performance_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/network_performance_fact_2024_1.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO network_performance_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/network_performance_fact_2024_2.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO network_alarm_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/network_alarm_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO support_ticket_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/support_ticket_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO contact_center_call_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/contact_center_call_fact_2024_1.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO contact_center_call_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/contact_center_call_fact_2024_2.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO complaint_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/complaint_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO mobile_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/mobile_usage_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sim_activation_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sim_activation_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO it_incident_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/it_incident_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sla_measurement_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sla_measurement_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO digital_interaction_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/digital_interaction_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO loyalty_transaction_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/loyalty_transaction_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sales_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sales_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO marketing_campaign_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/marketing_campaign_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO order_line_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/order_line_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO roaming_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/roaming_usage_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO iot_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2024/iot_usage_fact_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sf_quotas
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sf_quotas_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sf_pipeline_snapshot
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sf_pipeline_snapshot_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sf_opportunities
FROM @INTERNAL_DATA_STAGE/additional_data/2024/sf_opportunities_2024.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- =====================================================
-- VERIFICATION - Combined into single result
-- =====================================================

SELECT 
    table_name,
    total_rows,
    rows_2024,
    rows_2025,
    'Multi-year comparisons now available' AS next_step
FROM (
    SELECT '2024 DATA LOAD COMPLETE' as table_name, NULL as total_rows, NULL as rows_2024, NULL as rows_2025
    UNION ALL
    SELECT 'invoice_fact', COUNT(*), COUNT(CASE WHEN invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN 1 END), COUNT(CASE WHEN invoice_date >= '2025-01-01' AND invoice_date < '2026-01-01' THEN 1 END) FROM invoice_fact
    UNION ALL
    SELECT 'payment_fact', COUNT(*), COUNT(CASE WHEN payment_date >= '2024-01-01' AND payment_date < '2025-01-01' THEN 1 END), COUNT(CASE WHEN payment_date >= '2025-01-01' AND payment_date < '2026-01-01' THEN 1 END) FROM payment_fact
    UNION ALL
    SELECT 'support_ticket_fact', COUNT(*), COUNT(CASE WHEN created_date >= '2024-01-01' AND created_date < '2025-01-01' THEN 1 END), COUNT(CASE WHEN created_date >= '2025-01-01' AND created_date < '2026-01-01' THEN 1 END) FROM support_ticket_fact
    UNION ALL
    SELECT 'network_performance_fact', COUNT(*), COUNT(CASE WHEN metric_date >= '2024-01-01' AND metric_date < '2025-01-01' THEN 1 END), COUNT(CASE WHEN metric_date >= '2025-01-01' AND metric_date < '2026-01-01' THEN 1 END) FROM network_performance_fact
    UNION ALL
    SELECT 'mobile_usage_fact', COUNT(*), COUNT(CASE WHEN usage_month LIKE '2024%' THEN 1 END), COUNT(CASE WHEN usage_month LIKE '2025%' THEN 1 END) FROM mobile_usage_fact
    UNION ALL
    SELECT 'sales_fact', COUNT(*), COUNT(CASE WHEN date >= '2024-01-01' AND date < '2025-01-01' THEN 1 END), COUNT(CASE WHEN date >= '2025-01-01' AND date < '2026-01-01' THEN 1 END) FROM sales_fact
);
