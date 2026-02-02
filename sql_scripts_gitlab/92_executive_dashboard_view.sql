-- ========================================================================
-- Executive Dashboard Semantic View
-- Combines key metrics for CEO/CFO level questions
-- Run after 05 and 06 semantic view scripts
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- Create Executive Summary Table (materialized for performance)
-- ========================================================================

CREATE OR REPLACE TABLE executive_summary (
    summary_id INT DEFAULT 1,
    total_revenue_gbp DECIMAL(15,2),
    arpu_gbp DECIMAL(10,2),
    total_invoiced_gbp DECIMAL(15,2),
    total_active_subscribers INT,
    b2c_subscribers INT,
    b2b_subscribers INT,
    churned_subscribers INT,
    avg_network_throughput_gbps DECIMAL(10,4),
    avg_network_latency_ms DECIMAL(10,2),
    critical_alarms INT,
    avg_5g_throughput_mbps DECIMAL(10,2),
    avg_4g_throughput_mbps DECIMAL(10,2),
    total_ran_sites INT,
    avg_csat_score DECIMAL(5,2),
    avg_nps_score DECIMAL(5,2),
    open_tickets INT,
    avg_call_handle_time_secs DECIMAL(10,2),
    snowtelco_market_share_pct DECIMAL(6,2),
    market_arpu_gbp DECIMAL(8,2),
    last_updated TIMESTAMP
);

-- Populate the table
INSERT INTO executive_summary
SELECT
    1 AS summary_id,
    (SELECT SUM(bill_amount) FROM mobile_usage_fact),
    (SELECT AVG(bill_amount) FROM mobile_usage_fact),
    (SELECT SUM(total_amount) FROM invoice_fact),
    (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE status = 'Active'),
    (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE customer_type = 'Consumer'),
    (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE customer_type IN ('SMB', 'Enterprise')),
    (SELECT COUNT(*) FROM mobile_subscriber_dim WHERE churn_date IS NOT NULL),
    (SELECT AVG(throughput_gbps) FROM network_performance_fact),
    (SELECT AVG(latency_ms) FROM network_performance_fact),
    (SELECT COUNT(*) FROM network_alarm_fact WHERE severity = 'Critical'),
    (SELECT AVG(avg_throughput_mbps) FROM ran_performance_fact WHERE technology = '5G NR'),
    (SELECT AVG(avg_throughput_mbps) FROM ran_performance_fact WHERE technology = '4G LTE'),
    (SELECT COUNT(DISTINCT site_id) FROM ran_site_dim),
    (SELECT AVG(csat_score) FROM contact_center_call_fact),
    (SELECT AVG(nps_score) FROM mobile_usage_fact WHERE nps_score IS NOT NULL),
    (SELECT COUNT(*) FROM support_ticket_fact WHERE status = 'Open'),
    (SELECT AVG(handle_time_secs) FROM contact_center_call_fact),
    (SELECT AVG(market_share_pct) FROM market_share_fact WHERE competitor_name = 'SnowTelco'),
    (SELECT AVG(arpu) FROM market_share_fact WHERE competitor_name = 'SnowTelco'),
    CURRENT_TIMESTAMP();

-- ========================================================================
-- Executive Dashboard Semantic View (simplified)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.EXECUTIVE_DASHBOARD_SEMANTIC_VIEW
    tables (
        SUMMARY as EXECUTIVE_SUMMARY primary key (SUMMARY_ID) 
            with synonyms=('executive summary','dashboard','kpis','overview','ceo view','cfo view','board report') 
            comment='Executive dashboard with key business metrics'
    )
    facts (
        SUMMARY.total_revenue_gbp AS TOTAL_REVENUE with synonyms=('revenue','total revenue','sales') comment='Total revenue GBP',
        SUMMARY.arpu_gbp AS ARPU with synonyms=('average revenue per user','arpu') comment='ARPU in GBP',
        SUMMARY.total_invoiced_gbp AS TOTAL_INVOICED comment='Total invoiced GBP',
        SUMMARY.total_active_subscribers AS TOTAL_SUBSCRIBERS with synonyms=('subscribers','customer count') comment='Active subscribers',
        SUMMARY.b2c_subscribers AS B2C_SUBSCRIBERS with synonyms=('consumer','b2c') comment='B2C subscribers',
        SUMMARY.b2b_subscribers AS B2B_SUBSCRIBERS with synonyms=('business','b2b','enterprise') comment='B2B subscribers',
        SUMMARY.churned_subscribers AS CHURNED with synonyms=('churn','lost customers') comment='Churned subscribers',
        SUMMARY.avg_network_throughput_gbps AS THROUGHPUT with synonyms=('network speed','bandwidth') comment='Network throughput Gbps',
        SUMMARY.avg_network_latency_ms AS LATENCY with synonyms=('delay','ping') comment='Network latency ms',
        SUMMARY.critical_alarms AS ALARMS with synonyms=('critical alarms','network issues') comment='Critical alarms',
        SUMMARY.avg_5g_throughput_mbps AS THROUGHPUT_5G with synonyms=('5g speed','5g performance') comment='5G throughput Mbps',
        SUMMARY.avg_4g_throughput_mbps AS THROUGHPUT_4G with synonyms=('4g speed','lte','4g performance') comment='4G throughput Mbps',
        SUMMARY.total_ran_sites AS RAN_SITES with synonyms=('cell towers','sites') comment='Total RAN sites',
        SUMMARY.avg_csat_score AS CSAT with synonyms=('customer satisfaction','csat score') comment='Average CSAT',
        SUMMARY.avg_nps_score AS NPS with synonyms=('net promoter score','nps score') comment='Average NPS',
        SUMMARY.open_tickets AS TICKETS with synonyms=('support tickets','open issues') comment='Open tickets',
        SUMMARY.snowtelco_market_share_pct AS MARKET_SHARE with synonyms=('share','market position') comment='Market share %'
    )
    comment='Executive dashboard for CEO/CFO with revenue, ARPU, subscribers, network metrics, and market position';

-- ========================================================================
-- Verification
-- ========================================================================

SELECT * FROM executive_summary;
