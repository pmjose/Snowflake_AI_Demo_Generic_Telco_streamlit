-- =====================================================
-- SnowTelco Additional Data Loading Script
-- =====================================================
-- This script loads 2025 historical data into existing tables.
-- Run AFTER demo_setup.sql has been executed.
-- 
-- Data is APPENDED to existing tables (no data is deleted).
-- All 2025 records use ID ranges starting at 10,000,000+
-- to avoid collisions with existing data.
-- =====================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- =====================================================
-- STEP 1: DOWNLOAD 2025 DATA FROM GITHUB
-- =====================================================

SELECT '=== DOWNLOADING 2025 HISTORICAL DATA ===' AS status;

-- Create procedure to download 2025 data files
CREATE OR REPLACE PROCEDURE download_2025_data()
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
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/demo_data/additional_data/2025/csv/"
    
    # List of 2025 CSV files to download
    csv_files = [
        # Billing & Finance
        "invoice_fact_2025.csv",
        "payment_fact_2025.csv",
        "finance_transactions_2025.csv",
        
        # Network
        "network_performance_fact_2025_1.csv", "network_performance_fact_2025_2.csv",
        "network_alarm_fact_2025.csv",
        
        # Support & Service
        "support_ticket_fact_2025.csv",
        "contact_center_call_fact_2025_1.csv", "contact_center_call_fact_2025_2.csv",
        "complaint_fact_2025.csv",
        
        # Mobile
        "mobile_usage_fact_2025.csv",
        "sim_activation_fact_2025.csv",
        
        # IT & Operations
        "it_incident_fact_2025.csv",
        "sla_measurement_fact_2025.csv",
        
        # Digital & Loyalty
        "digital_interaction_fact_2025.csv",
        "loyalty_transaction_fact_2025.csv",
        
        # Sales & Marketing
        "sales_fact_2025.csv",
        "marketing_campaign_fact_2025.csv",
        "order_line_fact_2025.csv",
        
        # CRM/Salesforce
        "sf_quotas_2025.csv",
        "sf_pipeline_snapshot_2025.csv",
        "sf_opportunities_2025.csv",
        
        # Other
        "roaming_usage_fact_2025.csv",
        "iot_usage_fact_2025.csv"
    ]
    
    results = []
    success_count = 0
    fail_count = 0
    
    for csv_file in csv_files:
        url = base_url + csv_file
        stage_path = f"additional_data/2025/{csv_file}"
        
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

-- Download the files
CALL download_2025_data();

-- Refresh stage
ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- Verify files downloaded
SELECT '=== VERIFYING 2025 DATA FILES ===' AS status;
SELECT * FROM DIRECTORY(@INTERNAL_DATA_STAGE) 
WHERE RELATIVE_PATH LIKE '%additional_data/2025%'
ORDER BY RELATIVE_PATH;

-- =====================================================
-- STEP 2: LOAD 2025 DATA INTO EXISTING TABLES
-- =====================================================

SELECT '=== LOADING 2025 DATA INTO TABLES ===' AS status;

-- Invoice Fact (append to existing)
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

-- SIM Activation Fact
COPY INTO sim_activation_fact
FROM @INTERNAL_DATA_STAGE/additional_data/2025/sim_activation_fact_2025.csv
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
-- STEP 3: VERIFY DATA LOADED
-- =====================================================

SELECT '=== VERIFYING 2025 DATA LOADED ===' AS status;

-- Check record counts include 2025 data
SELECT 
    'invoice_fact' as table_name,
    COUNT(*) as total_rows,
    COUNT(CASE WHEN invoice_date >= '2025-01-01' AND invoice_date < '2026-01-01' THEN 1 END) as rows_2025
FROM invoice_fact
UNION ALL
SELECT 
    'payment_fact',
    COUNT(*),
    COUNT(CASE WHEN payment_date >= '2025-01-01' AND payment_date < '2026-01-01' THEN 1 END)
FROM payment_fact
UNION ALL
SELECT 
    'support_ticket_fact',
    COUNT(*),
    COUNT(CASE WHEN created_date >= '2025-01-01' AND created_date < '2026-01-01' THEN 1 END)
FROM support_ticket_fact
UNION ALL
SELECT 
    'network_performance_fact',
    COUNT(*),
    COUNT(CASE WHEN metric_date >= '2025-01-01' AND metric_date < '2026-01-01' THEN 1 END)
FROM network_performance_fact
UNION ALL
SELECT 
    'mobile_usage_fact',
    COUNT(*),
    COUNT(CASE WHEN usage_month LIKE '2025%' THEN 1 END)
FROM mobile_usage_fact
UNION ALL
SELECT 
    'sim_activation_fact',
    COUNT(*),
    COUNT(CASE WHEN order_timestamp >= '2025-01-01' AND order_timestamp < '2026-01-01' THEN 1 END)
FROM sim_activation_fact;

-- =====================================================
-- STEP 4: DOWNLOAD 2025 UNSTRUCTURED DOCUMENTS
-- =====================================================

SELECT '=== DOWNLOADING 2025 DOCUMENTS ===' AS status;

CREATE OR REPLACE PROCEDURE download_2025_docs()
RETURNS TABLE (file_name STRING, status STRING)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'requests')
EXTERNAL_ACCESS_INTEGRATIONS = (github_access_integration)
HANDLER = 'download_docs'
AS
$$
import requests
from io import BytesIO
from snowflake.snowpark.types import StructType, StructField, StringType

def download_docs(session):
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/demo_data/additional_data/2025/unstructured_docs/"
    
    docs = [
        "Annual_Report_FY2025.md",
        "Q1_FY2025_Results.md",
        "Q2_FY2025_Results.md",
        "Q3_FY2025_Results.md",
        "Q4_FY2025_Results.md",
        "5G_Rollout_Progress_2025.md",
        "NPS_Annual_Review_2025.md",
        "Board_Presentation_Q4_2025.md"
    ]
    
    results = []
    
    for doc in docs:
        url = base_url + doc
        stage_path = f"additional_data/2025/docs/{doc}"
        
        try:
            response = requests.get(url, timeout=60)
            if response.status_code == 200:
                stage_file = f"@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE/{stage_path}"
                session.file.put_stream(
                    input_stream=BytesIO(response.content),
                    stage_location=stage_file,
                    auto_compress=False,
                    overwrite=True
                )
                results.append([doc, "SUCCESS"])
            else:
                results.append([doc, f"FAILED: HTTP {response.status_code}"])
        except Exception as e:
            results.append([doc, f"FAILED: {str(e)[:50]}"])
    
    schema = StructType([
        StructField("FILE_NAME", StringType()),
        StructField("STATUS", StringType())
    ])
    return session.create_dataframe(results, schema)
$$;

CALL download_2025_docs();

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

SELECT '=== 2025 HISTORICAL DATA LOAD COMPLETE ===' AS status;
SELECT 'You can now query YoY comparisons using the semantic views.' AS next_steps;
SELECT 'Example: "Compare revenue between 2025 and 2026"' AS example_query;
