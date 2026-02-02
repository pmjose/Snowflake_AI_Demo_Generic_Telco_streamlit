-- ========================================================================
-- SEMANTIC VIEW VALIDATION TESTS (V2)
-- Run in Snowflake to verify all semantic views have data
-- Returns ONE result set showing all test status
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- CONSOLIDATED TEST - ALL SEMANTIC VIEWS IN ONE QUERY
-- ========================================================================

SELECT 
    test_num,
    test_name,
    row_count,
    sample_value,
    CASE 
        WHEN row_count > 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM (
    -- Core Business Views
    SELECT 1 AS test_num, 'FINANCE_SEMANTIC_VIEW' AS test_name, 
           COUNT(*) AS row_count, 
           TO_VARCHAR(ROUND(SUM(amount), 0)) AS sample_value
    FROM FINANCE_TRANSACTIONS
    
    UNION ALL
    SELECT 2, 'SALES_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(DISTINCT customer_key))
    FROM SALES_FACT
    
    UNION ALL
    SELECT 3, 'MARKETING_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(SUM(leads_generated))
    FROM MARKETING_CAMPAIGN_FACT
    
    UNION ALL
    SELECT 4, 'HR_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(DISTINCT employee_key))
    FROM HR_EMPLOYEE_FACT
    
    UNION ALL
    SELECT 5, 'MOBILE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' subscribers'
    FROM MOBILE_SUBSCRIBER_DIM
    
    UNION ALL
    SELECT 6, 'PORTING_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' port requests'
    FROM NUMBER_PORT_FACT
    
    UNION ALL
    SELECT 7, 'ORDER_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' orders'
    FROM ORDER_DIM
    
    UNION ALL
    SELECT 8, 'BILLING_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(total_amount), 0)) || ' GBP'
    FROM INVOICE_FACT
    
    UNION ALL
    SELECT 9, 'PAYMENT_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(amount), 0)) || ' GBP'
    FROM PAYMENT_FACT
    
    UNION ALL
    SELECT 10, 'NETWORK_OPS_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(AVG(availability_pct), 1)) || '% avg'
    FROM NETWORK_PERFORMANCE_FACT
    
    UNION ALL
    SELECT 11, 'SUPPORT_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' tickets'
    FROM SUPPORT_TICKET_FACT
    
    UNION ALL
    SELECT 12, 'PARTNER_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(DISTINCT partner_key)) || ' partners'
    FROM PARTNER_PERFORMANCE_FACT
    
    UNION ALL
    SELECT 13, 'ASSET_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' assets'
    FROM FIXED_ASSET_DIM
    
    UNION ALL
    SELECT 14, 'IT_OPS_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' incidents'
    FROM IT_INCIDENT_FACT
    
    UNION ALL
    SELECT 15, 'SLA_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' measurements'
    FROM SLA_MEASUREMENT_FACT
    
    UNION ALL
    SELECT 16, 'NETWORK_ALARM_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' alarms'
    FROM NETWORK_ALARM_FACT
    
    UNION ALL
    SELECT 17, 'REVENUE_ASSURANCE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(credit_amount), 0)) || ' GBP credits'
    FROM CREDIT_NOTE_FACT
    
    UNION ALL
    SELECT 18, 'ACTIVATION_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' activations'
    FROM SIM_ACTIVATION_FACT
    
    UNION ALL
    SELECT 19, 'DISPUTE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(disputed_amount), 0)) || ' GBP disputed'
    FROM DISPUTE_FACT
    
    UNION ALL
    SELECT 20, 'SALES_PIPELINE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' opportunities'
    FROM SF_OPPORTUNITIES
    
    -- Enhanced Analytics Views
    UNION ALL
    SELECT 21, 'CUSTOMER_EXPERIENCE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(AVG(sentiment_score), 2)) || ' avg sentiment'
    FROM CUSTOMER_JOURNEY_FACT
    
    UNION ALL
    SELECT 22, 'NETWORK_QOE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(AVG(download_speed_mbps), 1)) || ' Mbps avg'
    FROM NETWORK_QOE_FACT
    
    UNION ALL
    SELECT 23, 'PROPENSITY_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(AVG(churn_risk_score), 2)) || ' avg churn risk'
    FROM CUSTOMER_PROPENSITY_SCORES
    
    UNION ALL
    SELECT 24, 'FIELD_OPERATIONS_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' field visits'
    FROM FIELD_VISIT_FACT
    
    UNION ALL
    SELECT 25, 'MARKET_INTELLIGENCE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(DISTINCT competitor_name)) || ' competitors tracked'
    FROM MARKET_SHARE_FACT
    
    UNION ALL
    SELECT 26, 'SOCIAL_SENTIMENT_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' social mentions'
    FROM SOCIAL_MENTION_FACT
    
    UNION ALL
    SELECT 27, 'SUSTAINABILITY_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(energy_kwh), 0)) || ' kWh total'
    FROM ENERGY_CONSUMPTION_FACT
    
    UNION ALL
    SELECT 28, 'FRAUD_DETECTION_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(actual_loss), 0)) || ' GBP fraud loss'
    FROM FRAUD_CASE_FACT
    
    UNION ALL
    SELECT 29, 'B2B_CONTRACT_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(total_contract_value), 0)) || ' GBP contracts'
    FROM B2B_CONTRACT_FACT
    
    UNION ALL
    SELECT 30, 'WHOLESALE_MVNO_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(DISTINCT mvno_id)) || ' MVNO partners'
    FROM MVNO_TRAFFIC_FACT
    
    UNION ALL
    SELECT 31, 'RETAIL_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(SUM(total_amount), 0)) || ' GBP retail sales'
    FROM RETAIL_SALES_FACT
    
    UNION ALL
    SELECT 32, 'WORKFORCE_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(COUNT(*)) || ' employees'
    FROM EMPLOYEE_DETAIL_DIM
    
    UNION ALL
    SELECT 33, 'RAN_SEMANTIC_VIEW', COUNT(*), TO_VARCHAR(ROUND(AVG(avg_throughput_mbps), 1)) || ' Mbps avg'
    FROM RAN_PERFORMANCE_FACT
)
ORDER BY test_num;
