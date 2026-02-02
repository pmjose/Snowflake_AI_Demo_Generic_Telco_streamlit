-- ========================================================================
-- SnowTelco Demo - Step 9: Validate Data Load
-- Run this after setup to verify all data loaded correctly
-- Run time: ~30 seconds
-- Prerequisites: Run 01-04 scripts first
-- Version: 3.1 - Updated January 2026
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- COMPREHENSIVE VALIDATION - ALL TABLES IN ONE VIEW
-- ========================================================================

SELECT 
    table_name,
    table_type,
    row_count,
    expected_min,
    CASE 
        WHEN row_count >= expected_min THEN 'PASS'
        WHEN row_count > 0 THEN 'PARTIAL'
        ELSE 'FAIL'
    END AS status
FROM (
    -- DIMENSION TABLES
    SELECT 'product_category_dim' AS table_name, 'Dimension' AS table_type, COUNT(*) AS row_count, 3 AS expected_min FROM product_category_dim
    UNION ALL SELECT 'product_dim', 'Dimension', COUNT(*), 10 FROM product_dim
    UNION ALL SELECT 'vendor_dim', 'Dimension', COUNT(*), 10 FROM vendor_dim
    UNION ALL SELECT 'customer_dim', 'Dimension', COUNT(*), 50 FROM customer_dim
    UNION ALL SELECT 'account_dim', 'Dimension', COUNT(*), 3 FROM account_dim
    UNION ALL SELECT 'department_dim', 'Dimension', COUNT(*), 3 FROM department_dim
    UNION ALL SELECT 'region_dim', 'Dimension', COUNT(*), 3 FROM region_dim
    UNION ALL SELECT 'sales_rep_dim', 'Dimension', COUNT(*), 10 FROM sales_rep_dim
    UNION ALL SELECT 'campaign_dim', 'Dimension', COUNT(*), 5 FROM campaign_dim
    UNION ALL SELECT 'channel_dim', 'Dimension', COUNT(*), 3 FROM channel_dim
    UNION ALL SELECT 'job_dim', 'Dimension', COUNT(*), 5 FROM job_dim
    UNION ALL SELECT 'employee_dim', 'Dimension', COUNT(*), 50 FROM employee_dim
    UNION ALL SELECT 'location_dim', 'Dimension', COUNT(*), 3 FROM location_dim
    UNION ALL SELECT 'support_category_dim', 'Dimension', COUNT(*), 3 FROM support_category_dim
    UNION ALL SELECT 'mobile_plan_dim', 'Dimension', COUNT(*), 5 FROM mobile_plan_dim
    UNION ALL SELECT 'mobile_device_dim', 'Dimension', COUNT(*), 20 FROM mobile_device_dim
    UNION ALL SELECT 'mobile_network_dim', 'Dimension', COUNT(*), 10 FROM mobile_network_dim
    UNION ALL SELECT 'mobile_subscriber_dim', 'Dimension', COUNT(*), 25000 FROM mobile_subscriber_dim
    UNION ALL SELECT 'partner_dim', 'Dimension', COUNT(*), 5 FROM partner_dim
    UNION ALL SELECT 'contact_center_agent_dim', 'Dimension', COUNT(*), 20 FROM contact_center_agent_dim
    UNION ALL SELECT 'warehouse_dim', 'Dimension', COUNT(*), 3 FROM warehouse_dim
    UNION ALL SELECT 'fixed_asset_dim', 'Dimension', COUNT(*), 50 FROM fixed_asset_dim
    UNION ALL SELECT 'service_dim', 'Dimension', COUNT(*), 5 FROM service_dim
    UNION ALL SELECT 'contract_dim', 'Dimension', COUNT(*), 50 FROM contract_dim
    UNION ALL SELECT 'sla_dim', 'Dimension', COUNT(*), 3 FROM sla_dim
    UNION ALL SELECT 'roaming_partner_dim', 'Dimension', COUNT(*), 5 FROM roaming_partner_dim
    UNION ALL SELECT 'number_range_dim', 'Dimension', COUNT(*), 5 FROM number_range_dim
    UNION ALL SELECT 'loyalty_program_dim', 'Dimension', COUNT(*), 3 FROM loyalty_program_dim
    UNION ALL SELECT 'iot_device_type_dim', 'Dimension', COUNT(*), 5 FROM iot_device_type_dim
    UNION ALL SELECT 'it_application_dim', 'Dimension', COUNT(*), 10 FROM it_application_dim
    UNION ALL SELECT 'order_dim', 'Dimension', COUNT(*), 500 FROM order_dim
    UNION ALL SELECT 'payment_method_dim', 'Dimension', COUNT(*), 3 FROM payment_method_dim
    UNION ALL SELECT 'network_element_dim', 'Dimension', COUNT(*), 50 FROM network_element_dim
    
    -- RAN TABLES
    UNION ALL SELECT 'ran_site_dim', 'RAN', COUNT(*), 50 FROM ran_site_dim
    UNION ALL SELECT 'ran_equipment_dim', 'RAN', COUNT(*), 200 FROM ran_equipment_dim
    UNION ALL SELECT 'ran_cell_dim', 'RAN', COUNT(*), 200 FROM ran_cell_dim
    UNION ALL SELECT 'ran_performance_fact', 'RAN Fact', COUNT(*), 50000 FROM ran_performance_fact
    UNION ALL SELECT 'ran_alarm_fact', 'RAN Fact', COUNT(*), 2000 FROM ran_alarm_fact
    
    -- ENHANCED ANALYTICS
    UNION ALL SELECT 'competitor_dim', 'Analytics', COUNT(*), 3 FROM competitor_dim
    UNION ALL SELECT 'competitor_pricing_dim', 'Analytics', COUNT(*), 10 FROM competitor_pricing_dim
    UNION ALL SELECT 'technician_dim', 'Analytics', COUNT(*), 50 FROM technician_dim
    UNION ALL SELECT 'customer_journey_fact', 'Analytics Fact', COUNT(*), 50000 FROM customer_journey_fact
    UNION ALL SELECT 'network_qoe_fact', 'Analytics Fact', COUNT(*), 50000 FROM network_qoe_fact
    UNION ALL SELECT 'customer_propensity_scores', 'Analytics', COUNT(*), 25000 FROM customer_propensity_scores
    UNION ALL SELECT 'field_visit_fact', 'Analytics Fact', COUNT(*), 5000 FROM field_visit_fact
    UNION ALL SELECT 'market_share_fact', 'Analytics Fact', COUNT(*), 50 FROM market_share_fact
    UNION ALL SELECT 'social_mention_fact', 'Analytics Fact', COUNT(*), 5000 FROM social_mention_fact
    UNION ALL SELECT 'energy_consumption_fact', 'ESG Fact', COUNT(*), 500 FROM energy_consumption_fact
    UNION ALL SELECT 'sustainability_metrics', 'ESG', COUNT(*), 10 FROM sustainability_metrics
    
    -- FRAUD DETECTION
    UNION ALL SELECT 'fraud_type_dim', 'Fraud', COUNT(*), 3 FROM fraud_type_dim
    UNION ALL SELECT 'fraud_case_fact', 'Fraud Fact', COUNT(*), 2000 FROM fraud_case_fact
    
    -- B2B CONTRACTS
    UNION ALL SELECT 'b2b_contract_fact', 'B2B Fact', COUNT(*), 500 FROM b2b_contract_fact
    
    -- MVNO/WHOLESALE
    UNION ALL SELECT 'mvno_partner_dim', 'MVNO', COUNT(*), 3 FROM mvno_partner_dim
    UNION ALL SELECT 'mvno_traffic_fact', 'MVNO Fact', COUNT(*), 25000 FROM mvno_traffic_fact
    UNION ALL SELECT 'mvno_settlement_fact', 'MVNO Fact', COUNT(*), 50 FROM mvno_settlement_fact
    
    -- RETAIL
    UNION ALL SELECT 'retail_store_dim', 'Retail', COUNT(*), 25 FROM retail_store_dim
    UNION ALL SELECT 'retail_sales_fact', 'Retail Fact', COUNT(*), 25000 FROM retail_sales_fact
    UNION ALL SELECT 'retail_footfall_fact', 'Retail Fact', COUNT(*), 5000 FROM retail_footfall_fact
    
    -- HR ENHANCED
    UNION ALL SELECT 'employee_detail_dim', 'HR', COUNT(*), 250 FROM employee_detail_dim
    UNION ALL SELECT 'employee_survey_fact', 'HR Fact', COUNT(*), 500 FROM employee_survey_fact
    
    -- CORE FACT TABLES
    UNION ALL SELECT 'sales_fact', 'Fact', COUNT(*), 5000 FROM sales_fact
    UNION ALL SELECT 'finance_transactions', 'Fact', COUNT(*), 5000 FROM finance_transactions
    UNION ALL SELECT 'marketing_campaign_fact', 'Fact', COUNT(*), 500 FROM marketing_campaign_fact
    UNION ALL SELECT 'hr_employee_fact', 'Fact', COUNT(*), 50 FROM hr_employee_fact
    UNION ALL SELECT 'mobile_usage_fact', 'Fact', COUNT(*), 50000 FROM mobile_usage_fact
    UNION ALL SELECT 'mobile_churn_fact', 'Fact', COUNT(*), 500 FROM mobile_churn_fact
    UNION ALL SELECT 'number_port_fact', 'Fact', COUNT(*), 500 FROM number_port_fact
    UNION ALL SELECT 'partner_performance_fact', 'Fact', COUNT(*), 50 FROM partner_performance_fact
    UNION ALL SELECT 'order_line_fact', 'Fact', COUNT(*), 2000 FROM order_line_fact
    UNION ALL SELECT 'service_instance_fact', 'Fact', COUNT(*), 5000 FROM service_instance_fact
    UNION ALL SELECT 'invoice_fact', 'Fact', COUNT(*), 50000 FROM invoice_fact
    UNION ALL SELECT 'payment_fact', 'Fact', COUNT(*), 25000 FROM payment_fact
    UNION ALL SELECT 'inventory_fact', 'Fact', COUNT(*), 500 FROM inventory_fact
    UNION ALL SELECT 'purchase_order_fact', 'Fact', COUNT(*), 200 FROM purchase_order_fact
    UNION ALL SELECT 'purchase_order_line_fact', 'Fact', COUNT(*), 500 FROM purchase_order_line_fact
    UNION ALL SELECT 'network_alarm_fact', 'Fact', COUNT(*), 5000 FROM network_alarm_fact
    UNION ALL SELECT 'network_performance_fact', 'Fact', COUNT(*), 25000 FROM network_performance_fact
    UNION ALL SELECT 'sla_measurement_fact', 'Fact', COUNT(*), 2000 FROM sla_measurement_fact
    UNION ALL SELECT 'it_incident_fact', 'Fact', COUNT(*), 500 FROM it_incident_fact
    UNION ALL SELECT 'support_ticket_fact', 'Fact', COUNT(*), 5000 FROM support_ticket_fact
    UNION ALL SELECT 'complaint_fact', 'Fact', COUNT(*), 500 FROM complaint_fact
    UNION ALL SELECT 'legal_matter_fact', 'Fact', COUNT(*), 10 FROM legal_matter_fact
    UNION ALL SELECT 'contact_center_call_fact', 'Fact', COUNT(*), 50000 FROM contact_center_call_fact
    UNION ALL SELECT 'loyalty_transaction_fact', 'Fact', COUNT(*), 25000 FROM loyalty_transaction_fact
    UNION ALL SELECT 'iot_subscription_fact', 'Fact', COUNT(*), 2000 FROM iot_subscription_fact
    UNION ALL SELECT 'iot_usage_fact', 'Fact', COUNT(*), 25000 FROM iot_usage_fact
    UNION ALL SELECT 'roaming_usage_fact', 'Fact', COUNT(*), 5000 FROM roaming_usage_fact
    UNION ALL SELECT 'digital_interaction_fact', 'Fact', COUNT(*), 50000 FROM digital_interaction_fact
    
    -- SALESFORCE CRM
    UNION ALL SELECT 'sf_accounts', 'Salesforce', COUNT(*), 50 FROM sf_accounts
    UNION ALL SELECT 'sf_contacts', 'Salesforce', COUNT(*), 100 FROM sf_contacts
    UNION ALL SELECT 'sf_opportunities', 'Salesforce', COUNT(*), 200 FROM sf_opportunities
    UNION ALL SELECT 'sf_quotas', 'Salesforce', COUNT(*), 10 FROM sf_quotas
    UNION ALL SELECT 'sf_pipeline_snapshot', 'Salesforce', COUNT(*), 20 FROM sf_pipeline_snapshot
    
    -- REVENUE ASSURANCE
    UNION ALL SELECT 'credit_note_fact', 'Revenue Assurance', COUNT(*), 100 FROM credit_note_fact
    UNION ALL SELECT 'billing_adjustment_fact', 'Revenue Assurance', COUNT(*), 50 FROM billing_adjustment_fact
    UNION ALL SELECT 'unbilled_usage_fact', 'Revenue Assurance', COUNT(*), 500 FROM unbilled_usage_fact
    UNION ALL SELECT 'sim_activation_fact', 'Operations', COUNT(*), 5000 FROM sim_activation_fact
    UNION ALL SELECT 'dispute_fact', 'Billing', COUNT(*), 100 FROM dispute_fact
)
ORDER BY 
    CASE table_type 
        WHEN 'Dimension' THEN 1 
        WHEN 'RAN' THEN 2
        WHEN 'RAN Fact' THEN 3
        WHEN 'Analytics' THEN 4
        WHEN 'Analytics Fact' THEN 5
        WHEN 'ESG' THEN 6
        WHEN 'ESG Fact' THEN 7
        WHEN 'Fraud' THEN 8
        WHEN 'Fraud Fact' THEN 9
        WHEN 'B2B Fact' THEN 10
        WHEN 'MVNO' THEN 11
        WHEN 'MVNO Fact' THEN 12
        WHEN 'Retail' THEN 13
        WHEN 'Retail Fact' THEN 14
        WHEN 'HR' THEN 15
        WHEN 'HR Fact' THEN 16
        WHEN 'Fact' THEN 17
        WHEN 'Salesforce' THEN 18
        WHEN 'Revenue Assurance' THEN 19
        WHEN 'Operations' THEN 20
        WHEN 'Billing' THEN 21
        ELSE 99 
    END,
    table_name;
