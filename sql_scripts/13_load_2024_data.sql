-- =====================================================
-- SnowTelco 2024 Historical Data Loading Script
-- =====================================================
-- This script loads 2024 historical data into existing tables.
-- Run AFTER demo_setup.sql has been executed.
-- 
-- Data is APPENDED to existing tables (no data is deleted).
-- All 2024 records use ID ranges starting at 20,000,000+
-- to avoid collisions with existing data (base: 1-10M, 2025: 10M+).
-- =====================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- =====================================================
-- STEP 1: DOWNLOAD 2024 DATA FROM GITHUB
-- =====================================================

SELECT '=== DOWNLOADING 2024 HISTORICAL DATA ===' AS status;

CREATE OR REPLACE PROCEDURE download_2024_data()
RETURNS TABLE (file_name STRING, status STRING)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'requests')
EXTERNAL_ACCESS_INTEGRATIONS = (github_access_integration)
HANDLER = 'download_all'
AS
$$
import requests
from io import BytesIO
from snowflake.snowpark.types import StructType, StructField, StringType

def download_all(session):
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/demo_data/additional_data/2024/csv/"
    
    csv_files = [
        "invoice_fact_2024.csv",
        "payment_fact_2024.csv",
        "finance_transactions_2024.csv",
        "network_performance_fact_2024_1.csv", "network_performance_fact_2024_2.csv",
        "network_alarm_fact_2024.csv",
        "support_ticket_fact_2024.csv",
        "contact_center_call_fact_2024_1.csv", "contact_center_call_fact_2024_2.csv",
        "complaint_fact_2024.csv",
        "mobile_usage_fact_2024.csv",
        "sim_activation_fact_2024.csv",
        "it_incident_fact_2024.csv",
        "sla_measurement_fact_2024.csv",
        "digital_interaction_fact_2024.csv",
        "loyalty_transaction_fact_2024.csv",
        "sales_fact_2024.csv",
        "marketing_campaign_fact_2024.csv",
        "order_line_fact_2024.csv",
        "sf_quotas_2024.csv",
        "sf_pipeline_snapshot_2024.csv",
        "sf_opportunities_2024.csv",
        "roaming_usage_fact_2024.csv",
        "iot_usage_fact_2024.csv"
    ]
    
    results = []
    success_count = 0
    fail_count = 0
    
    for csv_file in csv_files:
        url = base_url + csv_file
        stage_path = f"additional_data/2024/{csv_file}"
        
        try:
            response = requests.get(url, timeout=180)
            if response.status_code == 200:
                stage_file = f"@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE/{stage_path}"
                session.file.put_stream(
                    input_stream=BytesIO(response.content),
                    stage_location=stage_file,
                    auto_compress=False,
                    overwrite=True
                )
                results.append([csv_file, f"SUCCESS ({len(response.content)} bytes)"])
                success_count += 1
            else:
                results.append([csv_file, f"FAILED: HTTP {response.status_code}"])
                fail_count += 1
        except Exception as e:
            results.append([csv_file, f"FAILED: {str(e)[:100]}"])
            fail_count += 1
    
    results.append(["--- SUMMARY ---", f"Success: {success_count}, Failed: {fail_count}"])
    
    schema = StructType([
        StructField("FILE_NAME", StringType()),
        StructField("STATUS", StringType())
    ])
    return session.create_dataframe(results, schema)
$$;

CALL download_2024_data();

ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

SELECT '=== VERIFYING 2024 DATA FILES ===' AS status;
SELECT * FROM DIRECTORY(@INTERNAL_DATA_STAGE) 
WHERE RELATIVE_PATH LIKE '%additional_data/2024%'
ORDER BY RELATIVE_PATH;

-- =====================================================
-- STEP 2: LOAD 2024 DATA INTO EXISTING TABLES
-- =====================================================

SELECT '=== LOADING 2024 DATA INTO TABLES ===' AS status;

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
-- STEP 3: VERIFY DATA LOADED
-- =====================================================

SELECT '=== VERIFYING 2024 DATA LOADED ===' AS status;

SELECT 
    'invoice_fact' as table_name,
    COUNT(*) as total_rows,
    COUNT(CASE WHEN invoice_date >= '2024-01-01' AND invoice_date < '2025-01-01' THEN 1 END) as rows_2024,
    COUNT(CASE WHEN invoice_date >= '2025-01-01' AND invoice_date < '2026-01-01' THEN 1 END) as rows_2025
FROM invoice_fact
UNION ALL
SELECT 
    'payment_fact',
    COUNT(*),
    COUNT(CASE WHEN payment_date >= '2024-01-01' AND payment_date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN payment_date >= '2025-01-01' AND payment_date < '2026-01-01' THEN 1 END)
FROM payment_fact
UNION ALL
SELECT 
    'support_ticket_fact',
    COUNT(*),
    COUNT(CASE WHEN created_date >= '2024-01-01' AND created_date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN created_date >= '2025-01-01' AND created_date < '2026-01-01' THEN 1 END)
FROM support_ticket_fact
UNION ALL
SELECT 
    'network_performance_fact',
    COUNT(*),
    COUNT(CASE WHEN metric_date >= '2024-01-01' AND metric_date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN metric_date >= '2025-01-01' AND metric_date < '2026-01-01' THEN 1 END)
FROM network_performance_fact
UNION ALL
SELECT 
    'mobile_usage_fact',
    COUNT(*),
    COUNT(CASE WHEN usage_month LIKE '2024%' THEN 1 END),
    COUNT(CASE WHEN usage_month LIKE '2025%' THEN 1 END)
FROM mobile_usage_fact
UNION ALL
SELECT 
    'sales_fact',
    COUNT(*),
    COUNT(CASE WHEN date >= '2024-01-01' AND date < '2025-01-01' THEN 1 END),
    COUNT(CASE WHEN date >= '2025-01-01' AND date < '2026-01-01' THEN 1 END)
FROM sales_fact;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

SELECT '=== 2024 HISTORICAL DATA LOAD COMPLETE ===' AS status;
SELECT 'You can now query multi-year comparisons (2024 vs 2025 vs 2026).' AS next_steps;
SELECT 'Example: "Compare revenue trends across 2024, 2025, and 2026"' AS example_query;
