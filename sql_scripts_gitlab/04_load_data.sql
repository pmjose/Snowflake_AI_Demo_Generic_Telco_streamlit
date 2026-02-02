-- ========================================================================
-- SnowTelco Demo - Step 4: Load Data
-- Loads all data DIRECTLY from Git repository into tables
-- Run time: ~3-5 minutes
-- Prerequisites: Run 00_git_setup.sql, 01_infrastructure.sql, 03_create_tables.sql
-- 
-- NOTE: Data is loaded directly from the Git repo stage - no intermediate
-- copy step required! This is faster and simpler.
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== LOADING DATA INTO TABLES ===' AS status;
SELECT '    This may take 3-5 minutes...' AS note;

    -- LOAD DIMENSION DATA FROM GIT REPOSITORY
    -- ========================================================================

    -- Load Product Category Dimension
    COPY INTO product_category_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/product_category_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Product Dimension
    COPY INTO product_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/product_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Vendor Dimension
    COPY INTO vendor_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/vendor_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Customer Dimension
    COPY INTO customer_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/customer_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Account Dimension
    COPY INTO account_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/account_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Department Dimension
    COPY INTO department_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/department_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Region Dimension
    COPY INTO region_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/region_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Sales Rep Dimension
    COPY INTO sales_rep_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sales_rep_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Campaign Dimension
    COPY INTO campaign_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/campaign_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Channel Dimension
    COPY INTO channel_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/channel_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Employee Dimension
    COPY INTO employee_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/employee_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Job Dimension
    COPY INTO job_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/job_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Location Dimension
    COPY INTO location_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/location_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD FACT DATA FROM GIT REPOSITORY
    -- ========================================================================

    -- Load Sales Fact
    COPY INTO sales_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sales_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Finance Transactions
    COPY INTO finance_transactions
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/finance_transactions.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Marketing Campaign Fact
    COPY INTO marketing_campaign_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/marketing_campaign_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load HR Employee Fact (with boolean transformation for attrition_flag)
    COPY INTO hr_employee_fact (
        hr_fact_id, date, employee_key, department_key, job_key, location_key, salary, attrition_flag
    )
    FROM (
        SELECT 
            $1, $2, $3, $4, $5, $6, $7,
            CASE WHEN $8 IN ('True', 'TRUE', '1') THEN 1 ELSE 0 END
        FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/hr_employee_fact.csv
    )
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD SALESFORCE DATA FROM GIT REPOSITORY
    -- ========================================================================

    -- Load Salesforce Accounts
    COPY INTO sf_accounts
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_accounts.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Salesforce Opportunities
    COPY INTO sf_opportunities
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_opportunities.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Salesforce Contacts
    COPY INTO sf_contacts
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_contacts.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Salesforce Quotas (Sales Targets)
    COPY INTO sf_quotas
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_quotas.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Salesforce Pipeline Snapshots
    COPY INTO sf_pipeline_snapshot
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_pipeline_snapshot.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Salesforce Open Pipeline (2026 opportunities)
    COPY INTO sf_opportunities
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sf_opportunities_open.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD MOBILE TELCO DATA
    -- ========================================================================

    -- Load Mobile Plan Dimension
    COPY INTO mobile_plan_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_plan_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Mobile Device Dimension
    COPY INTO mobile_device_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_device_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Mobile Network Dimension
    COPY INTO mobile_network_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_network_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Mobile Subscriber Dimension
    COPY INTO mobile_subscriber_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_subscriber_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Mobile Usage Fact
    COPY INTO mobile_usage_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_usage_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Mobile Churn Fact (with boolean transformation and NULL competitor handling)
    COPY INTO mobile_churn_fact (
        churn_id, subscriber_key, churn_date, churn_reason, churn_reason_detail,
        competitor_name, tenure_months, lifetime_value, retention_attempts,
        retention_offer_made, retention_offer_accepted, final_bill_status,
        port_out, win_back_eligible
    )
    FROM (
        SELECT 
            $1, $2, $3, $4, $5, 
            COALESCE(NULLIF(TRIM($6), ''), 'Unknown / Non-Competitive'),
            $7, $8, $9,
            CASE WHEN $10 IN ('True', 'TRUE', '1') THEN TRUE ELSE FALSE END,
            CASE WHEN $11 IN ('True', 'TRUE', '1') THEN TRUE ELSE FALSE END,
            $12,
            CASE WHEN $13 IN ('True', 'TRUE', '1') THEN TRUE ELSE FALSE END,
            CASE WHEN $14 IN ('True', 'TRUE', '1') THEN TRUE ELSE FALSE END
        FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mobile_churn_fact.csv
    )
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD TM FORUM ODA PHASE 1 DATA
    -- ========================================================================

    -- Load Service Dimension
    COPY INTO service_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/service_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Support Category Dimension
    COPY INTO support_category_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/support_category_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Order Dimension
    COPY INTO order_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/order_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Order Line Fact
    COPY INTO order_line_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/order_line_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Invoice Fact
    COPY INTO invoice_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/invoice_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Service Instance Fact
    COPY INTO service_instance_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/service_instance_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Support Ticket Fact
    COPY INTO support_ticket_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/support_ticket_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Network Element Dimension
    COPY INTO network_element_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/network_element_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- RAN (Radio Access Network) Data Loads
    -- ========================================================================

    -- Load RAN Site Dimension
    COPY INTO ran_site_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/ran_site_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load RAN Equipment Dimension
    COPY INTO ran_equipment_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/ran_equipment_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load RAN Cell Dimension
    COPY INTO ran_cell_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/ran_cell_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load RAN Performance Fact
    COPY INTO ran_performance_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/ran_performance_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load RAN Alarm Fact
    COPY INTO ran_alarm_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/ran_alarm_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- Enhanced Analytics Data Loads
    -- ========================================================================

    -- Load Competitor Dimension
    COPY INTO competitor_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/competitor_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Competitor Pricing Dimension
    COPY INTO competitor_pricing_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/competitor_pricing_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Technician Dimension
    COPY INTO technician_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/technician_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Customer Journey Fact
    COPY INTO customer_journey_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/customer_journey_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Network QoE Fact
    COPY INTO network_qoe_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/network_qoe_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Customer Propensity Scores
    COPY INTO customer_propensity_scores
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/customer_propensity_scores.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Field Visit Fact
    COPY INTO field_visit_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/field_visit_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Market Share Fact
    COPY INTO market_share_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/market_share_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Social Mention Fact
    COPY INTO social_mention_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/social_mention_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Energy Consumption Fact
    COPY INTO energy_consumption_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/energy_consumption_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Sustainability Metrics
    COPY INTO sustainability_metrics
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sustainability_metrics.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- FRAUD DETECTION DATA
    -- ========================================================================

    -- Load Fraud Type Dimension
    COPY INTO fraud_type_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/fraud_type_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Fraud Case Fact
    COPY INTO fraud_case_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/fraud_case_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- B2B CONTRACT RENEWALS DATA
    -- ========================================================================

    -- Load B2B Contract Fact
    COPY INTO b2b_contract_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/b2b_contract_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- WHOLESALE / MVNO DATA
    -- ========================================================================

    -- Load MVNO Partner Dimension
    COPY INTO mvno_partner_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mvno_partner_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load MVNO Traffic Fact
    COPY INTO mvno_traffic_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mvno_traffic_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load MVNO Settlement Fact
    COPY INTO mvno_settlement_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/mvno_settlement_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- RETAIL STORE DATA
    -- ========================================================================

    -- Load Retail Store Dimension
    COPY INTO retail_store_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/retail_store_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Retail Sales Fact
    COPY INTO retail_sales_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/retail_sales_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Retail Footfall Fact
    COPY INTO retail_footfall_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/retail_footfall_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- ENHANCED HR DATA
    -- ========================================================================

    -- Load Employee Detail Dimension
    COPY INTO employee_detail_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/employee_detail_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Employee Survey Fact
    COPY INTO employee_survey_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/employee_survey_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Network Alarm Fact
    COPY INTO network_alarm_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/network_alarm_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Network Performance Fact
    COPY INTO network_performance_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/network_performance_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD TM FORUM ODA PHASE 2 DATA
    -- ========================================================================

    -- Load Partner Dimension
    COPY INTO partner_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/partner_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Partner Performance Fact (with boolean transformation)
    COPY INTO partner_performance_fact (
        perf_id, partner_key, month, orders_count, order_value, revenue,
        new_customers, churn_rate, nps_score, support_tickets, 
        training_completed, commission_earned
    )
    FROM (
        SELECT 
            $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
            CASE WHEN $11 IN ('1', '1.0', 'TRUE', 'true') THEN TRUE ELSE FALSE END,
            $12
        FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/partner_performance_fact.csv
    )
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Contact Center Agent Dimension
    COPY INTO contact_center_agent_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/contact_center_agent_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Contact Center Call Fact (split files)
    COPY INTO contact_center_call_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/contact_center_call_fact_1.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    COPY INTO contact_center_call_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/contact_center_call_fact_2.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Payment Method Dimension
    COPY INTO payment_method_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/payment_method_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Payment Fact
    COPY INTO payment_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/payment_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Warehouse Dimension
    COPY INTO warehouse_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/warehouse_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Inventory Fact
    COPY INTO inventory_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/inventory_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Purchase Order Fact
    COPY INTO purchase_order_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/purchase_order_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Purchase Order Line Fact
    COPY INTO purchase_order_line_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/purchase_order_line_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Fixed Asset Dimension
    COPY INTO fixed_asset_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/fixed_asset_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Contract Dimension
    COPY INTO contract_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/contract_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD TM FORUM ODA PHASE 3 DATA
    -- ========================================================================

    -- Load SLA Dimension
    COPY INTO sla_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sla_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load SLA Measurement Fact
    COPY INTO sla_measurement_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sla_measurement_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Roaming Partner Dimension
    COPY INTO roaming_partner_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/roaming_partner_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Roaming Usage Fact
    COPY INTO roaming_usage_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/roaming_usage_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Number Range Dimension
    COPY INTO number_range_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/number_range_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Number Port Fact
    COPY INTO number_port_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/number_port_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load IT Application Dimension
    COPY INTO it_application_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/it_application_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load IT Incident Fact
    COPY INTO it_incident_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/it_incident_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Complaint Fact
    COPY INTO complaint_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/complaint_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Legal Matter Fact
    COPY INTO legal_matter_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/legal_matter_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD TM FORUM ODA PHASE 4 DATA
    -- ========================================================================

    -- Load Loyalty Program Dimension
    COPY INTO loyalty_program_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/loyalty_program_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Loyalty Transaction Fact
    COPY INTO loyalty_transaction_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/loyalty_transaction_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load IoT Device Type Dimension
    COPY INTO iot_device_type_dim
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/iot_device_type_dim.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load IoT Subscription Fact
    COPY INTO iot_subscription_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/iot_subscription_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load IoT Usage Fact
    COPY INTO iot_usage_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/iot_usage_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Digital Interaction Fact (split files)
    COPY INTO digital_interaction_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/digital_interaction_fact_1.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';
    
    COPY INTO digital_interaction_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/digital_interaction_fact_2.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- ========================================================================
    -- LOAD NEW ENHANCEMENT TABLES FROM GIT REPOSITORY
    -- ========================================================================

    -- Load Credit Note Fact (Revenue Assurance)
    COPY INTO credit_note_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/credit_note_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Billing Adjustment Fact (Revenue Assurance)
    COPY INTO billing_adjustment_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/billing_adjustment_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Unbilled Usage Fact (Revenue Leakage)
    COPY INTO unbilled_usage_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/unbilled_usage_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load SIM Activation Fact (Operations)
    COPY INTO sim_activation_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/sim_activation_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';

    -- Load Dispute Fact (Billing)
    COPY INTO dispute_fact
    FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/dispute_fact.csv
    FILE_FORMAT = CSV_FORMAT
    ON_ERROR = 'CONTINUE';


-- ========================================================================
-- VERIFICATION - Combined into single result
-- ========================================================================

SELECT 
    table_name,
    row_count,
    'NEXT: Run 05_semantic_views.sql' AS next_step
FROM (
    SELECT 'DATA LOAD COMPLETE' AS table_name, NULL AS row_count
    UNION ALL SELECT 'mobile_subscriber_dim', COUNT(*) FROM mobile_subscriber_dim
    UNION ALL SELECT 'invoice_fact', COUNT(*) FROM invoice_fact
    UNION ALL SELECT 'support_ticket_fact', COUNT(*) FROM support_ticket_fact
    UNION ALL SELECT 'network_alarm_fact', COUNT(*) FROM network_alarm_fact
    UNION ALL SELECT 'retail_sales_fact', COUNT(*) FROM retail_sales_fact
    UNION ALL SELECT 'sales_fact', COUNT(*) FROM sales_fact
    UNION ALL SELECT 'finance_transactions', COUNT(*) FROM finance_transactions
);
