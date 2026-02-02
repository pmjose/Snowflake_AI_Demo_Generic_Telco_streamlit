-- ========================================================================
-- SnowTelco Demo - Step 2: Download Data from GitHub
-- Downloads all CSV and document files to internal stage
-- Run time: ~5-10 minutes
-- Prerequisites: Run 01_infrastructure.sql first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- DOWNLOAD PROCEDURES
-- ========================================================================

-- Procedure to download a single file from GitHub to internal stage
CREATE OR REPLACE PROCEDURE download_file_from_github(github_path STRING, stage_path STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'requests')
EXTERNAL_ACCESS_INTEGRATIONS = (github_access_integration)
HANDLER = 'download_file'
AS
$$
import requests
from io import BytesIO

def download_file(session, github_path, stage_path):
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/"
    url = base_url + github_path
    
    try:
        response = requests.get(url, timeout=120)
        if response.status_code != 200:
            return f"FAILED: {github_path} - HTTP {response.status_code}"
        
        stage_file = f"@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE/{stage_path}"
        session.file.put_stream(
            input_stream=BytesIO(response.content),
            stage_location=stage_file,
            auto_compress=False,
            overwrite=True
        )
        
        return f"SUCCESS: {github_path} -> {stage_path} ({len(response.content)} bytes)"
    except Exception as e:
        return f"FAILED: {github_path} - {str(e)}"
$$;

-- Procedure to download all CSV data files
CREATE OR REPLACE PROCEDURE download_all_csv_files()
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
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/demo_data/"
    
    # List of all CSV files to download (~100 files)
    csv_files = [
        # Dimension tables
        "product_category_dim.csv", "product_dim.csv", "vendor_dim.csv", "customer_dim.csv",
        "account_dim.csv", "department_dim.csv", "region_dim.csv", "sales_rep_dim.csv",
        "campaign_dim.csv", "job_dim.csv", "employee_dim.csv", "support_category_dim.csv",
        "mobile_plan_dim.csv", "mobile_device_dim.csv", "mobile_network_dim.csv",
        "partner_dim.csv", "contact_center_agent_dim.csv",
        "warehouse_dim.csv", "fixed_asset_dim.csv", "service_dim.csv", "contract_dim.csv",
        "sla_dim.csv", "roaming_partner_dim.csv", "loyalty_program_dim.csv",
        "iot_device_type_dim.csv", "it_application_dim.csv", "channel_dim.csv", "location_dim.csv",
        "payment_method_dim.csv", "network_element_dim.csv", "number_range_dim.csv",
        # RAN (Radio Access Network) tables
        "ran_site_dim.csv", "ran_equipment_dim.csv", "ran_cell_dim.csv",
        "ran_performance_fact.csv", "ran_alarm_fact.csv",
        # Enhanced Analytics tables
        "competitor_dim.csv", "competitor_pricing_dim.csv", "technician_dim.csv",
        "customer_journey_fact.csv", "network_qoe_fact.csv", "customer_propensity_scores.csv",
        "field_visit_fact.csv", "market_share_fact.csv", "social_mention_fact.csv",
        "energy_consumption_fact.csv", "sustainability_metrics.csv",
        # Fraud Detection
        "fraud_type_dim.csv", "fraud_case_fact.csv",
        # B2B Contracts
        "b2b_contract_fact.csv",
        # Wholesale/MVNO
        "mvno_partner_dim.csv", "mvno_traffic_fact.csv", "mvno_settlement_fact.csv",
        # Retail Stores
        "retail_store_dim.csv", "retail_sales_fact.csv", "retail_footfall_fact.csv",
        # Enhanced HR
        "employee_detail_dim.csv", "employee_survey_fact.csv",
        # Fact tables - Core
        "sales_fact.csv", "finance_transactions.csv", "marketing_campaign_fact.csv",
        "sf_contacts.csv", "sf_accounts.csv", "sf_opportunities.csv", 
        "sf_quotas.csv", "sf_pipeline_snapshot.csv", "sf_opportunities_open.csv",
        "hr_employee_fact.csv",
        "mobile_subscriber_dim.csv", "mobile_usage_fact.csv", "mobile_churn_fact.csv",
        "number_port_fact.csv", "partner_performance_fact.csv", "order_dim.csv",
        "order_line_fact.csv", "service_instance_fact.csv", "invoice_fact.csv",
        "payment_fact.csv", "inventory_fact.csv",
        "network_alarm_fact.csv", "network_performance_fact.csv",
        "sla_measurement_fact.csv", "it_incident_fact.csv", "support_ticket_fact.csv",
        "complaint_fact.csv", "legal_matter_fact.csv", "contact_center_call_fact_1.csv", "contact_center_call_fact_2.csv",
        "loyalty_transaction_fact.csv", "iot_subscription_fact.csv", "iot_usage_fact.csv",
        "roaming_usage_fact.csv", "digital_interaction_fact_1.csv", "digital_interaction_fact_2.csv",
        "purchase_order_fact.csv", "purchase_order_line_fact.csv",
        # Revenue Assurance & Operations
        "credit_note_fact.csv", "billing_adjustment_fact.csv", "unbilled_usage_fact.csv",
        "sim_activation_fact.csv", "dispute_fact.csv"
    ]
    
    results = []
    success_count = 0
    fail_count = 0
    
    for csv_file in csv_files:
        url = base_url + csv_file
        stage_path = f"demo_data/{csv_file}"
        
        try:
            response = requests.get(url, timeout=120)
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

-- Procedure to download all unstructured documents
CREATE OR REPLACE PROCEDURE download_all_docs()
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
    base_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/unstructured_docs/"
    
    docs = [
        # Finance documents
        "finance/Q3_FY2026_Financial_Report.md", "finance/ARPU_Trends_Analysis_Q3_FY2026.md",
        "finance/Subscriber_Unit_Economics.md",
        "finance/Expense_Policy_2025.md", "finance/Vendor_Management_Policy.md",
        "finance/ESG_Sustainability_Report_2024.md", "finance/Ofcom_Annual_Compliance_Report.md",
        "finance/Procurement_Policy.md", "finance/Credit_Management_Policy.md",
        "finance/GDPR_Compliance_Framework.md", "finance/Fraud_Prevention_Guide.md",
        "finance/Data_Classification_Policy.md", "finance/it_ops_finance.md",
        "finance/vendor_contracts/AWS_UK_Partnership_Agreement.md",
        "finance/vendor_contracts/Microsoft_UK_Partnership_Agreement.md",
        "finance/vendor_contracts/Cisco_UK_Partnership_Agreement.md",
        "finance/vendor_contracts/Sample_Return_Policies_Summary.md",
        # HR documents
        "hr/Employee_Handbook_2025.md", "hr/Performance_Review_Guidelines.md",
        "hr/Employee_Engagement_Report_Q4_2025.md", "hr/Talent_Strategy_2026.md",
        # Marketing documents
        "marketing/2025_Marketing_Strategy.md",
        "marketing/Campaign_ROI_Analysis_2024.md", "marketing/NPS_Customer_Satisfaction_Report.md",
        "marketing/Campaign_Performance_Report.md", "marketing/Crisis_Communications_Playbook.md",
        # Sales documents
        "sales/Customer_Service_Playbook.md", "sales/Device_Lifecycle_Management.md",
        "sales/Churn_Reduction_Playbook.md", "sales/Customer_Success_Stories.md",
        "sales/Retail_Store_Performance_Playbook.md", "sales/Sales_Playbook_2025.md",
        "sales/Customer_Experience_Report_Q4_2024.md", "sales/MVNO_Partnership_Guide.md",
        # Strategy documents
        "strategy/Cloud_Strategy.md", "strategy/Spectrum_License_Summary.md",
        "strategy/Board_Presentation_Q4_2024.md", "strategy/Market_Position_Analysis_2025.md",
        "strategy/Subscriber_Growth_Report_Q4_2024.md", "strategy/Telco_Merger_Impact.md",
        "strategy/eSIM_Adoption_Report_2024.md", "strategy/Brexit_Roaming_Impact_Analysis.md",
        "strategy/Investor_Relations_FAQ.md",
        "strategy/Board_Presentation_Q3_FY2026.md", "strategy/Market_Position_Analysis_2026.md",
        "strategy/Subscriber_Growth_Report_Q3_FY2026.md",
        "strategy/AI_ML_Strategy_2026.md", "strategy/Digital_Transformation_Roadmap_2026.md",
        "strategy/Operational_Excellence_Playbook.md",
        # Network documents
        "network/5G_Network_Strategy_2025.md", "network/Network_Coverage_Analysis_2025.md",
        "network/Network_Operations_Playbook.md", "network/Incident_Management_Process.md",
        "network/Change_Management_Process.md", "network/Disaster_Recovery_Plan.md",
        "network/Network_Security_Policy.md", "network/IT_Service_Catalog.md",
        "network/Field_Operations_Handbook.md", "network/IT_Architecture_Overview.md",
        # Demo documents
        "demo/Demo_Script_CEO.md", "demo/Demo_Script_CFO.md", "demo/Demo_Script_CMO.md",
        "demo/Demo_Script_Full_30min.md", "demo/SnowTelco_Key_Facts.md"
    ]
    
    results = []
    success_count = 0
    fail_count = 0
    
    for doc in docs:
        url = base_url + doc
        stage_path = f"unstructured_docs/{doc}"
        
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
                results.append([doc, f"SUCCESS ({len(response.content)} bytes)"])
                success_count += 1
            else:
                results.append([doc, f"FAILED: HTTP {response.status_code}"])
                fail_count += 1
        except Exception as e:
            results.append([doc, f"FAILED: {str(e)[:100]}"])
            fail_count += 1
    
    results.append(["--- SUMMARY ---", f"Success: {success_count}, Failed: {fail_count}"])
    
    schema = StructType([
        StructField("FILE_NAME", StringType()),
        StructField("STATUS", StringType())
    ])
    return session.create_dataframe(results, schema)
$$;

-- ========================================================================
-- CLEAR EXISTING STAGE DATA (ensures fresh download)
-- ========================================================================

SELECT '=== CLEARING EXISTING STAGE DATA ===' AS status;
SELECT '    Removing old files to ensure clean state...' AS note;

-- Remove existing CSV data files
REMOVE @INTERNAL_DATA_STAGE/demo_data/;

-- Remove existing unstructured documents  
REMOVE @INTERNAL_DATA_STAGE/unstructured_docs/;

SELECT '    Stage cleared. Ready for fresh download.' AS status;

-- ========================================================================
-- EXECUTE DOWNLOADS
-- ========================================================================

SELECT '=== DOWNLOADING CSV DATA FILES FROM GITHUB ===' AS status;
SELECT '    This may take 5-10 minutes for ~100 files...' AS note;
CALL download_all_csv_files();

SELECT '=== DOWNLOADING UNSTRUCTURED DOCUMENTS FROM GITHUB ===' AS status;
CALL download_all_docs();

-- Refresh stage directory
ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT '=== DOWNLOAD COMPLETE ===' AS status;
SELECT COUNT(*) AS total_files_downloaded FROM DIRECTORY(@INTERNAL_DATA_STAGE);

-- Check if key files exist
SELECT 
    RELATIVE_PATH,
    SIZE
FROM DIRECTORY(@INTERNAL_DATA_STAGE)
WHERE RELATIVE_PATH LIKE '%subscriber%' OR RELATIVE_PATH LIKE '%invoice%'
LIMIT 5;

SELECT 'Next step: Run 03_create_tables.sql' AS next_step;
