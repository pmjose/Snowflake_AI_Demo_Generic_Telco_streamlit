-- =====================================================
-- SnowTelco 2025 Data Loading Script
-- =====================================================
-- This script loads 2025 historical data into existing tables.
-- Prerequisites: Run 00-09 scripts first
-- 
-- STEP 1: Copy 2025 files from Git to internal stage
-- STEP 2: Load data from internal stage into tables
-- =====================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- =====================================================
-- STEP 1: COPY 2025 FILES FROM GIT TO INTERNAL STAGE
-- =====================================================

COPY FILES
INTO @INTERNAL_DATA_STAGE/additional_data/2025/
FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/additional_data/2025/csv/
PATTERN='.*\.csv';

ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- =====================================================
-- STEP 2: LOAD 2025 DATA INTO EXISTING TABLES
-- =====================================================

-- Invoice Fact
COPY INTO invoice_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/invoice_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Payment Fact
COPY INTO payment_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/payment_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Finance Transactions
COPY INTO finance_transactions
FROM @INTERNAL_DATA_STAGE/additional_data/2025/finance_transactions_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Network Performance Fact
COPY INTO network_performance_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/network_performance_fact_2025_1.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO network_performance_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/network_performance_fact_2025_2.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Network Alarm Fact
COPY INTO network_alarm_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/network_alarm_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Support Ticket Fact
COPY INTO support_ticket_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/support_ticket_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Contact Center Call Fact
COPY INTO contact_center_call_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/contact_center_call_fact_2025_1.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO contact_center_call_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/contact_center_call_fact_2025_2.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Complaint Fact
COPY INTO complaint_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/complaint_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Mobile Usage Fact
COPY INTO mobile_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/mobile_usage_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- IT Incident Fact
COPY INTO it_incident_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/it_incident_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- SLA Measurement Fact
COPY INTO sla_measurement_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sla_measurement_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Digital Interaction Fact
COPY INTO digital_interaction_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/digital_interaction_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Loyalty Transaction Fact
COPY INTO loyalty_transaction_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/loyalty_transaction_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Sales Fact
COPY INTO sales_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sales_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Marketing Campaign Fact
COPY INTO marketing_campaign_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/marketing_campaign_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Order Line Fact
COPY INTO order_line_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/order_line_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- Roaming Usage Fact
COPY INTO roaming_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/roaming_usage_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- IoT Usage Fact
COPY INTO iot_usage_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/iot_usage_fact_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- CRM/Salesforce Data
COPY INTO sf_quotas
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sf_quotas_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sf_pipeline_snapshot
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sf_pipeline_snapshot_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

COPY INTO sf_opportunities
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sf_opportunities_2025.csv
FILE_FORMAT = CSV_FORMAT
ON_ERROR = 'CONTINUE';

-- =====================================================
-- VERIFICATION - Combined into single result
-- =====================================================

SELECT 
    table_name,
    total_rows,
    rows_2025,
    'YoY comparisons now available' AS next_step
FROM (
    SELECT '2025 DATA LOAD COMPLETE' as table_name, NULL as total_rows, NULL as rows_2025
    UNION ALL
    SELECT 'invoice_fact', COUNT(*), COUNT(CASE WHEN invoice_date >= '2025-01-01' AND invoice_date < '2026-01-01' THEN 1 END) FROM invoice_fact
    UNION ALL
    SELECT 'payment_fact', COUNT(*), COUNT(CASE WHEN payment_date >= '2025-01-01' AND payment_date < '2026-01-01' THEN 1 END) FROM payment_fact
    UNION ALL
    SELECT 'support_ticket_fact', COUNT(*), COUNT(CASE WHEN created_date >= '2025-01-01' AND created_date < '2026-01-01' THEN 1 END) FROM support_ticket_fact
    UNION ALL
    SELECT 'network_performance_fact', COUNT(*), COUNT(CASE WHEN metric_date >= '2025-01-01' AND metric_date < '2026-01-01' THEN 1 END) FROM network_performance_fact
    UNION ALL
    SELECT 'mobile_usage_fact', COUNT(*), COUNT(CASE WHEN usage_month LIKE '2025%' THEN 1 END) FROM mobile_usage_fact
    UNION ALL
    SELECT 'sales_fact', COUNT(*), COUNT(CASE WHEN date >= '2025-01-01' AND date < '2026-01-01' THEN 1 END) FROM sales_fact
);
