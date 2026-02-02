-- ========================================================================
-- SnowTelco Demo - Step 6: Enhanced Semantic Views for Cortex Analyst
-- Creates semantic views for new analytics capabilities:
-- - Customer Experience Analytics
-- - Network QoE Analytics  
-- - AI/ML Propensity Analytics
-- - Field Operations Analytics
-- - Market Intelligence
-- - Social Sentiment Analytics
-- - ESG/Sustainability Analytics
-- Run time: ~1 minute
-- Prerequisites: Run 01-05 scripts first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- CUSTOMER EXPERIENCE SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.CUSTOMER_EXPERIENCE_SEMANTIC_VIEW
    tables (
        JOURNEY as CUSTOMER_JOURNEY_FACT primary key (JOURNEY_ID) with synonyms=('customer journey','touchpoints','interactions') comment='Customer journey touchpoint data across all channels',
        SUBSCRIBERS as MOBILE_SUBSCRIBER_DIM primary key (SUBSCRIBER_KEY) with synonyms=('customers','subscribers','mobile customers') comment='Mobile subscriber information'
    )
    relationships ( 
        JOURNEY_TO_SUBSCRIBER as JOURNEY(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY)
    )
    facts (
        JOURNEY.sentiment_score AS SENTIMENT_SCORE comment='Sentiment score (-1 to 1)',
        JOURNEY.effort_score AS EFFORT_SCORE comment='Customer effort score (1-5)',
        JOURNEY.session_duration_secs AS SESSION_DURATION_SECS comment='Session duration in seconds',
        JOURNEY.page_views AS PAGE_VIEWS comment='Number of pages viewed'
    )
    dimensions (
        JOURNEY.interaction_date AS INTERACTION_DATE with synonyms=('date','interaction date') comment='Date of the interaction',
        JOURNEY.journey_stage AS JOURNEY_STAGE with synonyms=('stage','funnel stage','customer stage') comment='Customer journey stage (Awareness, Consideration, Purchase, etc.)',
        JOURNEY.channel AS CHANNEL with synonyms=('channel','touchpoint channel') comment='Channel of interaction (Website, App, Store, etc.)',
        JOURNEY.interaction_type AS INTERACTION_TYPE with synonyms=('type','action type') comment='Type of customer interaction',
        JOURNEY.resolution_achieved AS RESOLUTION_ACHIEVED with synonyms=('resolved','successful') comment='Whether the interaction achieved resolution',
        JOURNEY.conversion_flag AS CONVERSION_FLAG with synonyms=('conversion','converted') comment='Whether the interaction resulted in conversion',
        SUBSCRIBERS.customer_type AS CUSTOMER_TYPE with synonyms=('type','segment') comment='Customer type (Consumer, SMB, Enterprise)',
        SUBSCRIBERS.customer_segment AS CUSTOMER_SEGMENT with synonyms=('segment','tier') comment='Customer segment (Budget, Standard, Premium, VIP)',
        SUBSCRIBERS.city AS CITY comment='Customer city',
        SUBSCRIBERS.network_generation AS NETWORK_GENERATION with synonyms=('network','3G/4G/5G') comment='Network generation (3G, 4G, 5G)'
    )
    metrics (
        avg_sentiment as AVG(JOURNEY.SENTIMENT_SCORE) with synonyms=('average sentiment','sentiment score') comment='Average customer sentiment score (-1 to 1)',
        avg_effort_score as AVG(JOURNEY.EFFORT_SCORE) with synonyms=('effort score','customer effort') comment='Average customer effort score (1-5, lower is better)',
        total_page_views as SUM(JOURNEY.PAGE_VIEWS) comment='Total page views across all journeys',
        avg_session_duration as AVG(JOURNEY.SESSION_DURATION_SECS) with synonyms=('session time','duration') comment='Average session duration in seconds'
    )
    comment='Semantic view for customer experience and journey analytics - sentiment, effort, conversions, and engagement metrics';

-- ========================================================================
-- NETWORK QoE SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_QOE_SEMANTIC_VIEW
    tables (
        QOE as NETWORK_QOE_FACT primary key (QOE_ID) with synonyms=('quality of experience','network quality','qoe') comment='Network quality of experience measurements',
        SUBSCRIBERS as MOBILE_SUBSCRIBER_DIM primary key (SUBSCRIBER_KEY) with synonyms=('customers','subscribers') comment='Mobile subscriber information',
        CELLS as RAN_CELL_DIM primary key (CELL_ID) with synonyms=('cells','sectors') comment='RAN cell information',
        SITES as RAN_SITE_DIM primary key (SITE_ID) with synonyms=('sites','towers','base stations') comment='RAN site information'
    )
    relationships ( 
        QOE_TO_SUBSCRIBER as QOE(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY),
        QOE_TO_CELL as QOE(CELL_ID) references CELLS(CELL_ID),
        CELL_TO_SITE as CELLS(SITE_ID) references SITES(SITE_ID)
    )
    facts (
        QOE.download_speed_mbps AS DOWNLOAD_SPEED_MBPS comment='Download speed in Mbps',
        QOE.upload_speed_mbps AS UPLOAD_SPEED_MBPS comment='Upload speed in Mbps',
        QOE.latency_ms AS LATENCY_MS comment='Latency in milliseconds',
        QOE.jitter_ms AS JITTER_MS comment='Jitter in milliseconds',
        QOE.packet_loss_pct AS PACKET_LOSS_PCT comment='Packet loss percentage',
        QOE.video_quality_score AS VIDEO_QUALITY_SCORE comment='Video quality score (1-5)',
        QOE.voice_mos_score AS VOICE_MOS_SCORE comment='Voice MOS score',
        QOE.signal_strength_dbm AS SIGNAL_STRENGTH_DBM comment='Signal strength in dBm'
    )
    dimensions (
        QOE.measurement_date AS MEASUREMENT_DATE with synonyms=('date','measurement date') comment='Date of measurement',
        QOE.measurement_hour AS MEASUREMENT_HOUR with synonyms=('hour','time') comment='Hour of measurement',
        QOE.app_category AS APP_CATEGORY with synonyms=('app','application','service','app type','application type','streaming app','video app') comment='Application category (Netflix, YouTube, Zoom, Teams, TikTok, Gaming, Spotify, WhatsApp, Instagram)',
        QOE.connection_type AS CONNECTION_TYPE with synonyms=('network type','3G/4G/5G','5G','4G','3G','network generation','5G vs 4G','technology type') comment='Connection/network type for customer experience comparison (3G, 4G, 5G)',
        CELLS.cell_name AS CELL_NAME comment='Cell name',
        CELLS.technology AS TECHNOLOGY comment='Cell technology (4G LTE, 5G NR)',
        CELLS.frequency_band AS FREQUENCY_BAND comment='Frequency band',
        SITES.site_name AS SITE_NAME comment='Site name',
        SITES.city AS CITY comment='Site city',
        SITES.site_type AS SITE_TYPE with synonyms=('type') comment='Site type (Macro, Small, DAS, etc.)',
        SUBSCRIBERS.customer_type AS CUSTOMER_TYPE comment='Customer type'
    )
    metrics (
        avg_download_speed as AVG(QOE.DOWNLOAD_SPEED_MBPS) with synonyms=('average download speed','download speed','download','speed','network speed','data speed','mbps') comment='Average download speed in Mbps by network generation (3G/4G/5G)',
        avg_upload_speed as AVG(QOE.UPLOAD_SPEED_MBPS) with synonyms=('average upload speed','upload speed') comment='Average upload speed in Mbps',
        avg_latency as AVG(QOE.LATENCY_MS) with synonyms=('average latency','latency') comment='Average latency in ms',
        avg_video_quality as AVG(QOE.VIDEO_QUALITY_SCORE) with synonyms=('video streaming quality','video score','streaming quality') comment='Average video streaming quality score (1-5 scale)'
    )
    comment='Semantic view for network quality of experience (QoE) analytics - compare 5G vs 4G vs 3G customer experience metrics including video streaming quality scores, download/upload speeds, latency, jitter, packet loss, voice MOS scores by network generation and app category (Netflix, YouTube, Zoom, Teams, TikTok, Gaming, Spotify, WhatsApp, Instagram)';

-- ========================================================================
-- AI/ML PROPENSITY SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PROPENSITY_SEMANTIC_VIEW
    tables (
        PROPENSITY as CUSTOMER_PROPENSITY_SCORES primary key (SUBSCRIBER_KEY) with synonyms=('propensity scores','ml scores','predictions') comment='Customer propensity and ML prediction scores',
        SUBSCRIBERS as MOBILE_SUBSCRIBER_DIM primary key (SUBSCRIBER_KEY) with synonyms=('customers','subscribers') comment='Mobile subscriber information'
    )
    relationships ( 
        PROPENSITY_TO_SUBSCRIBER as PROPENSITY(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY)
    )
    facts (
        PROPENSITY.churn_risk_score AS CHURN_RISK_SCORE comment='Churn risk score (0-1)',
        PROPENSITY.upsell_propensity AS UPSELL_PROPENSITY comment='Upsell propensity score (0-1)',
        PROPENSITY.cross_sell_propensity AS CROSS_SELL_PROPENSITY comment='Cross-sell propensity score (0-1)',
        PROPENSITY.predicted_clv AS PREDICTED_CLV comment='Predicted customer lifetime value',
        PROPENSITY.confidence_score AS CONFIDENCE_SCORE comment='Model confidence score'
    )
    dimensions (
        PROPENSITY.score_date AS SCORE_DATE with synonyms=('date') comment='Date scores were calculated',
        PROPENSITY.churn_risk_band AS CHURN_RISK_BAND with synonyms=('risk level','churn band') comment='Churn risk band (High, Medium, Low)',
        PROPENSITY.clv_segment AS CLV_SEGMENT with synonyms=('value segment','clv band') comment='CLV segment (High, Medium, Low)',
        PROPENSITY.next_best_action AS NEXT_BEST_ACTION with synonyms=('NBA','recommendation','action') comment='Recommended next best action',
        PROPENSITY.model_version AS MODEL_VERSION comment='ML model version',
        SUBSCRIBERS.customer_type AS CUSTOMER_TYPE comment='Customer type',
        SUBSCRIBERS.customer_segment AS CUSTOMER_SEGMENT comment='Customer segment',
        SUBSCRIBERS.network_generation AS NETWORK_GENERATION comment='Network generation',
        SUBSCRIBERS.status AS STATUS comment='Customer status (Active, Churned)',
        SUBSCRIBERS.city AS CITY comment='Customer city'
    )
    metrics (
        avg_churn_risk as AVG(PROPENSITY.CHURN_RISK_SCORE) with synonyms=('average churn risk') comment='Average churn risk score',
        total_churn_risk as SUM(PROPENSITY.CHURN_RISK_SCORE) comment='Total churn risk score',
        avg_predicted_clv as AVG(PROPENSITY.PREDICTED_CLV) with synonyms=('average CLV','mean CLV') comment='Average predicted customer lifetime value',
        total_predicted_clv as SUM(PROPENSITY.PREDICTED_CLV) comment='Total predicted CLV',
        avg_upsell_propensity as AVG(PROPENSITY.UPSELL_PROPENSITY) comment='Average upsell propensity score',
        total_upsell_propensity as SUM(PROPENSITY.UPSELL_PROPENSITY) comment='Total upsell propensity'
    )
    comment='Semantic view for AI/ML propensity and prediction analytics';

-- ========================================================================
-- FIELD OPERATIONS SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.FIELD_OPERATIONS_SEMANTIC_VIEW
    tables (
        VISITS as FIELD_VISIT_FACT primary key (VISIT_ID) with synonyms=('field visits','service calls','technician visits') comment='Field service visit data',
        TECHNICIANS as TECHNICIAN_DIM primary key (TECHNICIAN_ID) with synonyms=('field technicians','engineers','service techs') comment='Field technician information',
        SUBSCRIBERS as MOBILE_SUBSCRIBER_DIM primary key (SUBSCRIBER_KEY) with synonyms=('customers') comment='Mobile subscriber information',
        SITES as RAN_SITE_DIM primary key (SITE_ID) with synonyms=('network sites','towers') comment='RAN site information'
    )
    relationships ( 
        VISITS_TO_TECHNICIAN as VISITS(TECHNICIAN_ID) references TECHNICIANS(TECHNICIAN_ID),
        VISITS_TO_SUBSCRIBER as VISITS(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY),
        VISITS_TO_SITE as VISITS(SITE_ID) references SITES(SITE_ID)
    )
    facts (
        VISITS.duration_mins AS DURATION_MINS comment='Visit duration in minutes',
        VISITS.delay_mins AS DELAY_MINS comment='Arrival delay in minutes',
        VISITS.labor_cost AS LABOR_COST comment='Labor cost',
        VISITS.parts_cost AS PARTS_COST comment='Parts cost',
        VISITS.total_cost AS TOTAL_COST comment='Total visit cost',
        VISITS.csat_score AS CSAT_SCORE comment='Customer satisfaction score (1-5)'
    )
    dimensions (
        VISITS.visit_date AS VISIT_DATE with synonyms=('date','visit date') comment='Date of visit',
        VISITS.visit_type AS VISIT_TYPE with synonyms=('type','job type') comment='Type of visit (Installation, Repair, etc.)',
        VISITS.outcome AS OUTCOME with synonyms=('result','status') comment='Visit outcome',
        VISITS.first_time_fix AS FIRST_TIME_FIX with synonyms=('FTF','resolved first visit') comment='Whether issue was fixed on first visit',
        VISITS.sla_met AS SLA_MET with synonyms=('on time','SLA compliance') comment='Whether SLA was met',
        TECHNICIANS.technician_name AS TECHNICIAN_NAME with synonyms=('technician','engineer') comment='Technician name',
        TECHNICIANS.skill_level AS SKILL_LEVEL with synonyms=('experience','level') comment='Technician skill level',
        TECHNICIANS.specialization AS SPECIALIZATION with synonyms=('specialty') comment='Technician specialization',
        TECHNICIANS.region AS REGION with synonyms=('area','territory') comment='Technician region'
    )
    metrics (
        total_duration as SUM(VISITS.DURATION_MINS) comment='Total visit duration',
        sum_total_cost as SUM(VISITS.TOTAL_COST) comment='Total visit cost',
        total_csat as SUM(VISITS.CSAT_SCORE) comment='Total CSAT score'
    )
    comment='Semantic view for field operations and workforce analytics';

-- ========================================================================
-- MARKET INTELLIGENCE SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.MARKET_INTELLIGENCE_SEMANTIC_VIEW
    tables (
        MARKET as MARKET_SHARE_FACT primary key (RECORD_ID) with synonyms=('market share','competitive data','market data') comment='Market share and competitive intelligence data',
        PRICING as COMPETITOR_PRICING_DIM primary key (PRICING_ID) with synonyms=('competitor pricing','pricing') comment='Competitor pricing information'
    )
    facts (
        MARKET.subscriber_count AS SUBSCRIBER_COUNT comment='Number of subscribers',
        MARKET.market_share_pct AS MARKET_SHARE_PCT comment='Market share percentage',
        MARKET.net_adds AS NET_ADDS comment='Net subscriber additions',
        MARKET.arpu AS ARPU comment='Average revenue per user',
        MARKET.churn_rate_pct AS CHURN_RATE_PCT comment='Churn rate percentage',
        PRICING.monthly_price AS MONTHLY_PRICE comment='Monthly plan price'
    )
    dimensions (
        MARKET.report_date AS REPORT_DATE with synonyms=('date','report date') comment='Report date',
        MARKET.report_month AS REPORT_MONTH with synonyms=('month') comment='Report month',
        MARKET.region AS REGION with synonyms=('area','territory') comment='Geographic region',
        MARKET.competitor_name AS COMPETITOR_NAME with synonyms=('competitor','company') comment='Competitor name',
        MARKET.competitor_type AS COMPETITOR_TYPE with synonyms=('type','MNO/MVNO') comment='Competitor type (MNO, MVNO)',
        PRICING.plan_name AS PLAN_NAME comment='Plan name',
        PRICING.data_allowance_gb AS DATA_ALLOWANCE_GB comment='Data allowance in GB',
        PRICING.includes_5g AS INCLUDES_5G comment='Whether plan includes 5G'
    )
    metrics (
        total_subscribers as SUM(MARKET.SUBSCRIBER_COUNT) comment='Total market size',
        total_arpu as SUM(MARKET.ARPU) comment='Total ARPU',
        total_churn_rate as SUM(MARKET.CHURN_RATE_PCT) comment='Total churn rate'
    )
    comment='Semantic view for market intelligence and competitive analytics';

-- ========================================================================
-- SOCIAL SENTIMENT SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SOCIAL_SENTIMENT_SEMANTIC_VIEW
    tables (
        MENTIONS as SOCIAL_MENTION_FACT primary key (MENTION_ID) with synonyms=('social mentions','social media','posts') comment='Social media mention and sentiment data'
    )
    facts (
        MENTIONS.sentiment_score AS SENTIMENT_SCORE comment='Sentiment score (-1 to 1)',
        MENTIONS.reach_count AS REACH_COUNT comment='Reach/impressions count',
        MENTIONS.engagement_count AS ENGAGEMENT_COUNT comment='Engagement count',
        MENTIONS.response_time_mins AS RESPONSE_TIME_MINS comment='Response time in minutes'
    )
    dimensions (
        MENTIONS.mention_date AS MENTION_DATE with synonyms=('date','post date') comment='Date of mention',
        MENTIONS.platform AS PLATFORM with synonyms=('social platform','channel') comment='Social media platform',
        MENTIONS.sentiment AS SENTIMENT with synonyms=('sentiment category') comment='Sentiment category (positive, negative, neutral)',
        MENTIONS.topic AS TOPIC with synonyms=('subject','category') comment='Topic/subject of mention',
        MENTIONS.is_influencer AS IS_INFLUENCER with synonyms=('influencer','high reach') comment='Whether from an influencer',
        MENTIONS.requires_response AS REQUIRES_RESPONSE comment='Whether mention requires response',
        MENTIONS.responded AS RESPONDED comment='Whether we responded',
        MENTIONS.content_snippet AS CONTENT_SNIPPET with synonyms=('text','message') comment='Content snippet'
    )
    metrics (
        avg_sentiment as AVG(MENTIONS.SENTIMENT_SCORE) with synonyms=('average sentiment','overall sentiment','sentiment score') comment='Average sentiment score (-1 to 1)',
        total_reach as SUM(MENTIONS.REACH_COUNT) comment='Total reach/impressions',
        total_engagement as SUM(MENTIONS.ENGAGEMENT_COUNT) comment='Total engagements',
        avg_response_time as AVG(MENTIONS.RESPONSE_TIME_MINS) comment='Average response time in minutes'
    )
    comment='Semantic view for social media sentiment analytics - tracks mentions, sentiment, and engagement across platforms';

-- ========================================================================
-- ESG/SUSTAINABILITY SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SUSTAINABILITY_SEMANTIC_VIEW
    tables (
        ENERGY as ENERGY_CONSUMPTION_FACT primary key (RECORD_ID) with synonyms=('energy consumption','power usage') comment='Site-level energy consumption data',
        SUSTAINABILITY as SUSTAINABILITY_METRICS primary key (RECORD_ID) with synonyms=('ESG metrics','sustainability KPIs') comment='Company-level sustainability metrics',
        SITES as RAN_SITE_DIM primary key (SITE_ID) with synonyms=('network sites','towers') comment='RAN site information'
    )
    relationships ( 
        ENERGY_TO_SITE as ENERGY(SITE_ID) references SITES(SITE_ID)
    )
    facts (
        ENERGY.energy_kwh AS ENERGY_KWH comment='Total energy consumption in kWh',
        ENERGY.renewable_kwh AS RENEWABLE_KWH comment='Renewable energy in kWh',
        ENERGY.grid_kwh AS GRID_KWH comment='Grid energy in kWh',
        ENERGY.renewable_pct AS RENEWABLE_PCT comment='Renewable energy percentage',
        ENERGY.carbon_emissions_kg AS CARBON_EMISSIONS_KG comment='Carbon emissions in kg',
        ENERGY.pue_ratio AS PUE_RATIO comment='Power Usage Effectiveness ratio',
        SUSTAINABILITY.total_energy_mwh AS TOTAL_ENERGY_MWH comment='Total energy in MWh',
        SUSTAINABILITY.total_carbon_tonnes AS TOTAL_CARBON_TONNES comment='Total carbon in tonnes',
        SUSTAINABILITY.carbon_intensity AS CARBON_INTENSITY with synonyms=('carbon per unit') comment='Carbon intensity (tonnes CO2 per unit)',
        SUSTAINABILITY.e_waste_recycled_tonnes AS E_WASTE_RECYCLED_TONNES comment='E-waste recycled in tonnes',
        SUSTAINABILITY.e_waste_recycled_pct AS E_WASTE_RECYCLED_PCT with synonyms=('recycling rate') comment='E-waste recycling percentage',
        SUSTAINABILITY.green_tariff_subscribers AS GREEN_TARIFF_SUBSCRIBERS with synonyms=('green customers') comment='Number of subscribers on green tariffs',
        SUSTAINABILITY.sustainability_score AS SUSTAINABILITY_SCORE comment='Overall sustainability score',
        SUSTAINABILITY.net_zero_progress_pct AS NET_ZERO_PROGRESS_PCT comment='Net zero progress percentage'
    )
    dimensions (
        ENERGY.measurement_date AS MEASUREMENT_DATE with synonyms=('date') comment='Measurement date',
        SUSTAINABILITY.metric_month AS METRIC_MONTH comment='Metric month',
        SITES.site_name AS SITE_NAME comment='Site name',
        SITES.city AS CITY comment='Site city',
        SITES.site_type AS SITE_TYPE comment='Site type'
    )
    metrics (
        total_energy as SUM(ENERGY.ENERGY_KWH) with synonyms=('total consumption','energy usage') comment='Total energy consumption in kWh',
        total_renewable as SUM(ENERGY.RENEWABLE_KWH) comment='Total renewable energy in kWh',
        total_carbon as SUM(ENERGY.CARBON_EMISSIONS_KG) with synonyms=('carbon footprint','emissions') comment='Total carbon emissions in kg',
        avg_renewable_pct as AVG(ENERGY.RENEWABLE_PCT) with synonyms=('renewable percentage','green energy') comment='Average renewable energy percentage',
        avg_pue as AVG(ENERGY.PUE_RATIO) with synonyms=('power efficiency','PUE') comment='Average Power Usage Effectiveness ratio'
    )
    comment='Semantic view for ESG and sustainability analytics - energy consumption, carbon emissions, and efficiency metrics';

-- ========================================================================
-- FRAUD DETECTION SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.FRAUD_DETECTION_SEMANTIC_VIEW
    tables (
        FRAUD as FRAUD_CASE_FACT primary key (FRAUD_CASE_ID) with synonyms=('fraud cases','fraud detection','security') comment='Fraud detection and prevention data',
        FRAUD_TYPES as FRAUD_TYPE_DIM primary key (FRAUD_TYPE_ID) with synonyms=('fraud types','fraud categories') comment='Fraud type reference data'
    )
    relationships ( 
        FRAUD_TO_TYPE as FRAUD(FRAUD_TYPE_ID) references FRAUD_TYPES(FRAUD_TYPE_ID)
    )
    facts (
        FRAUD.suspected_amount AS SUSPECTED_AMOUNT comment='Suspected fraud amount in GBP',
        FRAUD.actual_loss AS ACTUAL_LOSS comment='Actual financial loss in GBP',
        FRAUD.prevented_loss AS PREVENTED_LOSS comment='Loss prevented by detection in GBP',
        FRAUD.ml_confidence_score AS ML_CONFIDENCE_SCORE comment='ML model confidence score',
        FRAUD.risk_score AS RISK_SCORE comment='Risk score (0-100)'
    )
    dimensions (
        FRAUD.detection_date AS DETECTION_DATE with synonyms=('date','detection date') comment='Date fraud was detected',
        FRAUD.detection_method AS DETECTION_METHOD with synonyms=('method','how detected') comment='Method of detection (ML Model, Rule Engine, etc.)',
        FRAUD.status AS STATUS with synonyms=('case status') comment='Case status (Detected, Investigating, Resolved, etc.)',
        FRAUD.resolution_type AS RESOLUTION_TYPE with synonyms=('resolution','outcome') comment='Resolution type (Account Blocked, Refund, etc.)',
        FRAUD.investigating_team AS INVESTIGATING_TEAM comment='Team handling investigation',
        FRAUD.city AS CITY comment='Location of fraud',
        FRAUD.is_repeat_offender AS IS_REPEAT_OFFENDER comment='Whether this is a repeat offender',
        FRAUD_TYPES.fraud_type AS FRAUD_TYPE with synonyms=('type','fraud category') comment='Type of fraud',
        FRAUD_TYPES.category AS CATEGORY comment='Fraud category (Identity, Traffic, Device, etc.)',
        FRAUD_TYPES.severity AS SEVERITY comment='Severity level (Critical, High, Medium)'
    )
    metrics (
        total_suspected as SUM(FRAUD.SUSPECTED_AMOUNT) comment='Total suspected fraud amount',
        total_loss as SUM(FRAUD.ACTUAL_LOSS) comment='Total actual loss',
        total_prevented as SUM(FRAUD.PREVENTED_LOSS) comment='Total loss prevented'
    )
    comment='Semantic view for fraud detection and security analytics';

-- ========================================================================
-- B2B CONTRACT RENEWALS SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.B2B_CONTRACT_SEMANTIC_VIEW
    tables (
        CONTRACTS as B2B_CONTRACT_FACT primary key (CONTRACT_ID) with synonyms=('b2b contracts','enterprise contracts','renewals') comment='B2B contract and renewal data'
    )
    facts (
        CONTRACTS.annual_contract_value AS ANNUAL_CONTRACT_VALUE with synonyms=('ACV','annual value') comment='Annual contract value in GBP',
        CONTRACTS.total_contract_value AS TOTAL_CONTRACT_VALUE with synonyms=('TCV','total value') comment='Total contract value in GBP',
        CONTRACTS.renewal_probability AS RENEWAL_PROBABILITY comment='Renewal probability (0-1)',
        CONTRACTS.days_to_renewal AS DAYS_TO_RENEWAL comment='Days until contract renewal',
        CONTRACTS.proposed_value_change AS PROPOSED_VALUE_CHANGE comment='Proposed value change in GBP',
        CONTRACTS.nps_score AS NPS_SCORE comment='Customer NPS score',
        CONTRACTS.support_tickets_ytd AS SUPPORT_TICKETS_YTD comment='Support tickets year to date'
    )
    dimensions (
        CONTRACTS.contract_start_date AS CONTRACT_START_DATE comment='Contract start date',
        CONTRACTS.contract_end_date AS CONTRACT_END_DATE with synonyms=('renewal date','expiry') comment='Contract end/renewal date',
        CONTRACTS.renewal_status AS RENEWAL_STATUS with synonyms=('status') comment='Renewal status (Active, Pending, In Negotiation, etc.)',
        CONTRACTS.contract_type AS CONTRACT_TYPE with synonyms=('product','service type') comment='Contract type (UCaaS, CCaaS, SD-WAN, etc.)',
        CONTRACTS.industry AS INDUSTRY comment='Customer industry',
        CONTRACTS.region AS REGION comment='Customer region',
        CONTRACTS.account_name AS ACCOUNT_NAME with synonyms=('customer','company') comment='Account name',
        CONTRACTS.competitor_threat AS COMPETITOR_THREAT comment='Competitor threat level (None, Low, Medium, High)',
        CONTRACTS.competitor_name AS COMPETITOR_NAME comment='Threatening competitor name',
        CONTRACTS.proposed_change AS PROPOSED_CHANGE comment='Proposed contract change (Same, Upgrade, Downgrade)',
        CONTRACTS.account_manager AS ACCOUNT_MANAGER comment='Account manager ID',
        CONTRACTS.contract_term_months AS CONTRACT_TERM_MONTHS comment='Contract term in months'
    )
    metrics (
        total_acv as SUM(CONTRACTS.ANNUAL_CONTRACT_VALUE) comment='Total annual contract value',
        total_tcv as SUM(CONTRACTS.TOTAL_CONTRACT_VALUE) comment='Total contract value',
        total_renewal_prob as SUM(CONTRACTS.RENEWAL_PROBABILITY) comment='Total renewal probability'
    )
    comment='Semantic view for B2B contract and renewal analytics';

-- ========================================================================
-- WHOLESALE / MVNO SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.WHOLESALE_MVNO_SEMANTIC_VIEW
    tables (
        TRAFFIC as MVNO_TRAFFIC_FACT primary key (TRAFFIC_ID) with synonyms=('mvno traffic','wholesale traffic','mvno usage') comment='MVNO network traffic and usage data',
        SETTLEMENTS as MVNO_SETTLEMENT_FACT primary key (SETTLEMENT_ID) with synonyms=('settlements','invoices','billing') comment='MVNO financial settlements',
        MVNOS as MVNO_PARTNER_DIM primary key (MVNO_ID) with synonyms=('mvno partners','virtual operators','wholesale customers') comment='MVNO partner information'
    )
    relationships ( 
        TRAFFIC_TO_MVNO as TRAFFIC(MVNO_ID) references MVNOS(MVNO_ID),
        SETTLEMENT_TO_MVNO as SETTLEMENTS(MVNO_ID) references MVNOS(MVNO_ID)
    )
    facts (
        TRAFFIC.voice_minutes AS VOICE_MINUTES comment='Voice traffic in minutes',
        TRAFFIC.sms_count AS SMS_COUNT comment='SMS message count',
        TRAFFIC.data_gb AS DATA_GB comment='Data traffic in GB',
        TRAFFIC.voice_revenue AS VOICE_REVENUE comment='Voice wholesale revenue',
        TRAFFIC.sms_revenue AS SMS_REVENUE comment='SMS wholesale revenue',
        TRAFFIC.data_revenue AS DATA_REVENUE comment='Data wholesale revenue',
        TRAFFIC.total_revenue AS TOTAL_REVENUE comment='Total traffic revenue',
        TRAFFIC.active_subscribers AS ACTIVE_SUBSCRIBERS comment='Active MVNO subscribers',
        SETTLEMENTS.total_charges AS TOTAL_CHARGES with synonyms=('settlement amount','settlement_amount') comment='Settlement total charges',
        SETTLEMENTS.shortfall_charge AS SHORTFALL_CHARGE comment='Minimum commitment shortfall',
        SETTLEMENTS.days_overdue AS DAYS_OVERDUE comment='Number of days overdue (populated by 15_data_enhancements.sql)'
    )
    dimensions (
        TRAFFIC.traffic_date AS TRAFFIC_DATE comment='Traffic date',
        TRAFFIC.traffic_month AS TRAFFIC_MONTH comment='Traffic month',
        TRAFFIC.network_type AS NETWORK_TYPE with synonyms=('3G/4G/5G') comment='Network type used',
        SETTLEMENTS.settlement_month AS SETTLEMENT_MONTH comment='Settlement month',
        SETTLEMENTS.payment_status AS PAYMENT_STATUS with synonyms=('overdue','late','paid') comment='Settlement payment status',
        SETTLEMENTS.is_overdue AS IS_OVERDUE with synonyms=('past due') comment='Whether settlement is overdue (populated by 15_data_enhancements.sql)',
        SETTLEMENTS.settlement_date AS SETTLEMENT_DATE comment='Settlement date',
        MVNOS.mvno_name AS MVNO_NAME with synonyms=('partner','virtual operator') comment='MVNO partner name',
        MVNOS.mvno_type AS MVNO_TYPE comment='MVNO type (Full MVNO, Light MVNO)',
        MVNOS.target_segment AS TARGET_SEGMENT comment='MVNO target market segment',
        MVNOS.parent_company AS PARENT_COMPANY comment='MVNO parent company',
        MVNOS.status AS STATUS comment='Partner status'
    )
    metrics (
        total_voice as SUM(TRAFFIC.VOICE_MINUTES) comment='Total voice minutes',
        total_sms as SUM(TRAFFIC.SMS_COUNT) comment='Total SMS count',
        total_data as SUM(TRAFFIC.DATA_GB) comment='Total data in GB'
    )
    comment='Semantic view for wholesale and MVNO partner analytics';

-- ========================================================================
-- RETAIL STORE SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.RETAIL_SEMANTIC_VIEW
    tables (
        SALES as RETAIL_SALES_FACT primary key (SALE_ID) with synonyms=('retail sales','store sales','transactions') comment='Retail store sales transactions',
        FOOTFALL as RETAIL_FOOTFALL_FACT primary key (FOOTFALL_ID) with synonyms=('footfall','visitors','traffic') comment='Store visitor footfall data',
        STORES as RETAIL_STORE_DIM primary key (STORE_ID) with synonyms=('stores','retail stores','shops') comment='Retail store information'
    )
    relationships ( 
        SALES_TO_STORE as SALES(STORE_ID) references STORES(STORE_ID),
        FOOTFALL_TO_STORE as FOOTFALL(STORE_ID) references STORES(STORE_ID)
    )
    facts (
        SALES.total_amount AS TOTAL_AMOUNT comment='Sale total amount in GBP',
        SALES.quantity AS QUANTITY comment='Quantity sold',
        SALES.unit_price AS UNIT_PRICE comment='Unit price',
        SALES.commission_amount AS COMMISSION_AMOUNT comment='Staff commission amount',
        FOOTFALL.visitor_count AS VISITOR_COUNT comment='Number of store visitors',
        FOOTFALL.transaction_count AS TRANSACTION_COUNT comment='Number of transactions',
        FOOTFALL.conversion_rate AS CONVERSION_RATE comment='Visitor to transaction conversion rate',
        FOOTFALL.avg_dwell_time_mins AS AVG_DWELL_TIME_MINS comment='Average time spent in store',
        STORES.store_sqft AS STORE_SQFT with synonyms=('square footage','floor space','size') comment='Store size in square feet',
        STORES.staff_count AS STAFF_COUNT comment='Number of staff in store'
    )
    dimensions (
        SALES.sale_date AS SALE_DATE with synonyms=('date','sale date') comment='Sale date',
        SALES.sale_month AS SALE_MONTH comment='Sale month',
        SALES.product_category AS PRODUCT_CATEGORY with synonyms=('product','type') comment='Product category (Handset, SIM, Accessories, etc.)',
        SALES.payment_type AS PAYMENT_TYPE comment='Payment type (Contract, PAYG, One-time)',
        SALES.customer_type AS CUSTOMER_TYPE with synonyms=('new','upgrade') comment='Customer type (New, Upgrade, Add Line)',
        SALES.is_weekend AS IS_WEEKEND comment='Whether sale was on weekend',
        SALES.staff_id AS STAFF_ID with synonyms=('employee','salesperson') comment='Staff member ID who made sale',
        FOOTFALL.day_of_week AS DAY_OF_WEEK comment='Day of the week',
        FOOTFALL.weather AS WEATHER comment='Weather conditions',
        STORES.store_name AS STORE_NAME with synonyms=('store','location') comment='Store name',
        STORES.store_type AS STORE_TYPE comment='Store type (Flagship, Standard, Express, Kiosk)',
        STORES.store_format AS STORE_FORMAT comment='Store format (High Street, Shopping Centre, etc.)',
        STORES.city AS CITY comment='Store city',
        STORES.region AS REGION comment='Store region',
        STORES.status AS STATUS comment='Store status'
    )
    metrics (
        total_revenue as SUM(SALES.TOTAL_AMOUNT) comment='Total retail revenue',
        total_quantity as SUM(SALES.QUANTITY) comment='Total quantity sold',
        total_visitors as SUM(FOOTFALL.VISITOR_COUNT) comment='Total visitors'
    )
    comment='Semantic view for retail store analytics - sales, footfall, staff performance, and store efficiency';

-- ========================================================================
-- HR / WORKFORCE SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.WORKFORCE_SEMANTIC_VIEW
    tables (
        EMPLOYEES as EMPLOYEE_DETAIL_DIM primary key (EMPLOYEE_ID) with synonyms=('employees','staff','workforce','people') comment='Employee workforce data',
        SURVEYS as EMPLOYEE_SURVEY_FACT primary key (SURVEY_ID) with synonyms=('surveys','engagement','feedback') comment='Employee engagement surveys'
    )
    relationships ( 
        SURVEY_TO_EMPLOYEE as SURVEYS(EMPLOYEE_ID) references EMPLOYEES(EMPLOYEE_ID)
    )
    facts (
        EMPLOYEES.salary AS SALARY comment='Employee salary in GBP',
        EMPLOYEES.tenure_years AS TENURE_YEARS comment='Years of employment',
        EMPLOYEES.training_hours_ytd AS TRAINING_HOURS_YTD comment='Training hours this year',
        EMPLOYEES.performance_rating AS PERFORMANCE_RATING comment='Performance rating (1-5)',
        SURVEYS.engagement_score AS ENGAGEMENT_SCORE comment='Employee engagement score (1-5)',
        SURVEYS.satisfaction_score AS SATISFACTION_SCORE comment='Job satisfaction score (1-5)',
        SURVEYS.manager_rating AS MANAGER_RATING comment='Manager effectiveness rating',
        SURVEYS.enps_score AS ENPS_SCORE comment='Employee Net Promoter Score',
        SURVEYS.career_growth_score AS CAREER_GROWTH_SCORE with synonyms=('career growth','growth perception') comment='Career growth perception score (1-5)',
        SURVEYS.work_life_balance AS WORK_LIFE_BALANCE comment='Work-life balance score (1-5)',
        SURVEYS.compensation_satisfaction AS COMPENSATION_SATISFACTION comment='Compensation satisfaction score (1-5)'
    )
    dimensions (
        EMPLOYEES.department AS DEPARTMENT with synonyms=('dept','team') comment='Employee department',
        EMPLOYEES.job_title AS JOB_TITLE with synonyms=('role','position') comment='Job title',
        EMPLOYEES.job_level AS JOB_LEVEL with synonyms=('level','grade') comment='Job level (Entry, Junior, Senior, Manager, etc.)',
        EMPLOYEES.employment_type AS EMPLOYMENT_TYPE comment='Employment type (Full-time, Part-time, Contract)',
        EMPLOYEES.work_location AS WORK_LOCATION with synonyms=('location','office','store') comment='Work location',
        EMPLOYEES.work_city AS WORK_CITY comment='Work city',
        EMPLOYEES.work_type AS WORK_TYPE comment='Work arrangement (On-site, Hybrid, Remote)',
        EMPLOYEES.status AS STATUS comment='Employee status',
        EMPLOYEES.gender AS GENDER comment='Employee gender',
        EMPLOYEES.age_band AS AGE_BAND comment='Age band',
        SURVEYS.survey_type AS SURVEY_TYPE comment='Survey type',
        SURVEYS.survey_date AS SURVEY_DATE comment='Survey date',
        SURVEYS.would_recommend AS WOULD_RECOMMEND comment='Would recommend as employer'
    )
    metrics (
        avg_salary as AVG(EMPLOYEES.SALARY) with synonyms=('average salary','mean salary') comment='Average employee salary in GBP',
        avg_tenure as AVG(EMPLOYEES.TENURE_YEARS) with synonyms=('average tenure','mean tenure') comment='Average years of employment',
        avg_engagement as AVG(SURVEYS.ENGAGEMENT_SCORE) with synonyms=('engagement score','average engagement') comment='Average employee engagement score (1-5)',
        avg_satisfaction as AVG(SURVEYS.SATISFACTION_SCORE) with synonyms=('satisfaction score') comment='Average job satisfaction score (1-5)',
        avg_enps as AVG(SURVEYS.ENPS_SCORE) with synonyms=('employee NPS','eNPS') comment='Average employee Net Promoter Score',
        avg_career_growth as AVG(SURVEYS.CAREER_GROWTH_SCORE) with synonyms=('career growth score') comment='Average career growth perception score',
        total_training_hours as SUM(EMPLOYEES.TRAINING_HOURS_YTD) comment='Total training hours invested',
        avg_performance as AVG(EMPLOYEES.PERFORMANCE_RATING) comment='Average performance rating'
    )
    comment='Semantic view for HR and workforce analytics - headcount, engagement, tenure, and performance metrics';

-- ========================================================================
-- RAN (RADIO ACCESS NETWORK) SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.RAN_SEMANTIC_VIEW
    tables (
        PERFORMANCE as RAN_PERFORMANCE_FACT primary key (PERF_ID) with synonyms=('ran performance','network performance','cell performance') comment='RAN performance metrics and KPIs',
        ALARMS as RAN_ALARM_FACT primary key (ALARM_ID) with synonyms=('ran alarms','network alarms','cell alarms') comment='RAN alarm events',
        CELLS as RAN_CELL_DIM primary key (CELL_ID) with synonyms=('cells','sectors','cell sectors') comment='Cell/sector information',
        SITES as RAN_SITE_DIM primary key (SITE_ID) with synonyms=('sites','towers','base stations','cell towers') comment='Cell tower site information',
        EQUIPMENT as RAN_EQUIPMENT_DIM primary key (EQUIPMENT_ID) with synonyms=('equipment','gnodeb','enodeb','bbu','rru') comment='RAN equipment details'
    )
    relationships (
        PERFORMANCE_TO_CELL as PERFORMANCE(CELL_ID) references CELLS(CELL_ID),
        PERFORMANCE_TO_SITE as PERFORMANCE(SITE_ID) references SITES(SITE_ID),
        ALARMS_TO_SITE as ALARMS(SITE_ID) references SITES(SITE_ID),
        CELLS_TO_SITE as CELLS(SITE_ID) references SITES(SITE_ID),
        EQUIPMENT_TO_SITE as EQUIPMENT(SITE_ID) references SITES(SITE_ID)
    )
    facts (
        PERFORMANCE.avg_throughput_mbps AS AVG_THROUGHPUT_MBPS comment='Average throughput in Mbps',
        PERFORMANCE.max_throughput_mbps AS MAX_THROUGHPUT_MBPS comment='Maximum throughput in Mbps',
        PERFORMANCE.prb_utilization_pct AS PRB_UTILIZATION_PCT comment='Physical Resource Block utilization percentage',
        PERFORMANCE.connected_users AS CONNECTED_USERS comment='Number of connected users',
        PERFORMANCE.max_connected_users AS MAX_CONNECTED_USERS comment='Maximum connected users',
        PERFORMANCE.avg_latency_ms AS AVG_LATENCY_MS comment='Average latency in milliseconds',
        PERFORMANCE.rsrp_dbm AS RSRP_DBM comment='Reference Signal Received Power in dBm',
        PERFORMANCE.rsrq_db AS RSRQ_DB comment='Reference Signal Received Quality in dB',
        PERFORMANCE.sinr_db AS SINR_DB comment='Signal to Interference plus Noise Ratio in dB',
        PERFORMANCE.handover_success_pct AS HANDOVER_SUCCESS_PCT comment='Handover success rate percentage',
        PERFORMANCE.call_drop_rate_pct AS CALL_DROP_RATE_PCT comment='Call drop rate percentage',
        PERFORMANCE.rrc_setup_success_pct AS RRC_SETUP_SUCCESS_PCT comment='RRC setup success rate',
        PERFORMANCE.erab_setup_success_pct AS ERAB_SETUP_SUCCESS_PCT comment='E-RAB setup success rate'
    )
    dimensions (
        PERFORMANCE.metric_date AS METRIC_DATE with synonyms=('date','measurement date') comment='Date of performance measurement',
        PERFORMANCE.metric_hour AS METRIC_HOUR with synonyms=('hour','time') comment='Hour of measurement (0-23)',
        PERFORMANCE.technology AS TECHNOLOGY with synonyms=('tech','network technology') comment='Technology (4G LTE, 5G NR)',
        PERFORMANCE.frequency_band AS FREQUENCY_BAND with synonyms=('band','spectrum','frequency') comment='Frequency band',
        ALARMS.severity AS SEVERITY with synonyms=('priority','alarm severity') comment='Alarm severity (Critical, Major, Minor, Warning)',
        ALARMS.alarm_type AS ALARM_TYPE with synonyms=('type','alarm category') comment='Type of alarm',
        ALARMS.acknowledged AS ACKNOWLEDGED comment='Whether alarm was acknowledged',
        ALARMS.root_cause AS ROOT_CAUSE comment='Root cause of alarm',
        CELLS.cell_name AS CELL_NAME comment='Cell/sector name',
        CELLS.sector AS SECTOR comment='Sector identifier',
        CELLS.azimuth_degrees AS AZIMUTH_DEGREES comment='Antenna azimuth direction',
        SITES.site_name AS SITE_NAME with synonyms=('tower','location') comment='Site name',
        SITES.site_type AS SITE_TYPE comment='Site type (Macro, Micro, Small Cell)',
        SITES.city AS CITY comment='City location',
        SITES.county AS COUNTY comment='County',
        SITES.latitude AS LATITUDE comment='Site latitude',
        SITES.longitude AS LONGITUDE comment='Site longitude',
        EQUIPMENT.equipment_name AS EQUIPMENT_NAME comment='Equipment name',
        EQUIPMENT.equipment_type AS EQUIPMENT_TYPE comment='Equipment type (gNodeB, eNodeB, BBU, RRU, Antenna)',
        EQUIPMENT.vendor AS VENDOR comment='Equipment vendor',
        EQUIPMENT.model AS MODEL comment='Equipment model'
    )
    metrics (
        total_throughput as SUM(PERFORMANCE.AVG_THROUGHPUT_MBPS) comment='Total throughput',
        total_users as SUM(PERFORMANCE.CONNECTED_USERS) comment='Total connected users',
        total_latency as SUM(PERFORMANCE.AVG_LATENCY_MS) comment='Total latency'
    )
    comment='Semantic view for Radio Access Network (RAN) analysis - cell performance, alarms, and infrastructure';

-- ========================================================================
-- COMPLAINT SEMANTIC VIEW (for Regulatory Compliance, VP Customer Service)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.COMPLAINT_SEMANTIC_VIEW
    tables (
        COMPLAINTS as COMPLAINT_FACT primary key (COMPLAINT_ID) with synonyms=('complaints','grievances','formal complaints') comment='Customer formal complaints and regulatory tracking',
        CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('customers','clients') comment='Customer information'
    )
    relationships ( 
        COMPLAINT_TO_CUSTOMER as COMPLAINTS(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
    )
    facts (
        COMPLAINTS.compensation_amount AS COMPENSATION_AMOUNT comment='Compensation paid in GBP'
    )
    dimensions (
        COMPLAINTS.complaint_reference AS COMPLAINT_REFERENCE comment='Unique complaint reference number',
        COMPLAINTS.category AS CATEGORY with synonyms=('complaint type','reason') comment='Complaint category (Network Coverage, Pricing, Sales Practice, Contract Terms, Privacy, Customer Service)',
        COMPLAINTS.channel AS CHANNEL with synonyms=('source','how received') comment='How complaint was received (Phone, Letter, Ombudsman, Social Media, Regulator)',
        COMPLAINTS.received_date AS RECEIVED_DATE with synonyms=('date','complaint date') comment='Date complaint was received',
        COMPLAINTS.acknowledged_date AS ACKNOWLEDGED_DATE comment='Date complaint was acknowledged',
        COMPLAINTS.resolved_date AS RESOLVED_DATE comment='Date complaint was resolved',
        COMPLAINTS.outcome AS OUTCOME with synonyms=('result','resolution') comment='Complaint outcome (Upheld, Not Upheld, Partially Upheld, Withdrawn, Pending)',
        COMPLAINTS.escalated_to_ombudsman AS ESCALATED_TO_OMBUDSMAN with synonyms=('ombudsman','ADR','escalated') comment='Whether escalated to Ombudsman/ADR',
        COMPLAINTS.root_cause AS ROOT_CAUSE comment='Root cause of complaint',
        COMPLAINTS.customer_type AS CUSTOMER_TYPE comment='Customer type (Consumer, B2B)',
        CUSTOMERS.customer_name AS CUSTOMER_NAME comment='Customer name'
    )
    metrics (
        total_compensation as SUM(COMPLAINTS.COMPENSATION_AMOUNT) comment='Total compensation paid in GBP',
        avg_compensation as AVG(COMPLAINTS.COMPENSATION_AMOUNT) comment='Average compensation per complaint'
    )
    comment='Semantic view for complaint management and regulatory compliance - Ofcom reporting, ombudsman escalations, resolution tracking';

-- ========================================================================
-- SUPPORT TICKET SEMANTIC VIEW (for VP Customer Service)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SUPPORT_TICKET_SEMANTIC_VIEW
    tables (
        TICKETS as SUPPORT_TICKET_FACT primary key (TICKET_ID) with synonyms=('support tickets','service requests','cases') comment='Customer support ticket data',
        CATEGORIES as SUPPORT_CATEGORY_DIM primary key (CATEGORY_KEY) with synonyms=('ticket categories','issue types') comment='Support ticket categories'
    )
    relationships ( 
        TICKET_TO_CATEGORY as TICKETS(CATEGORY_KEY) references CATEGORIES(CATEGORY_KEY)
    )
    facts (
        TICKETS.first_response_mins AS FIRST_RESPONSE_MINS comment='Time to first response in minutes',
        TICKETS.resolution_mins AS RESOLUTION_MINS comment='Time to resolution in minutes',
        TICKETS.csat_score AS CSAT_SCORE comment='Customer satisfaction score (1-5)'
    )
    dimensions (
        TICKETS.ticket_number AS TICKET_NUMBER comment='Ticket reference number',
        TICKETS.customer_type AS CUSTOMER_TYPE with synonyms=('type','segment') comment='Customer type (Consumer, B2B)',
        TICKETS.priority AS PRIORITY with synonyms=('severity','P1/P2/P3/P4') comment='Ticket priority (P1, P2, P3, P4)',
        TICKETS.status AS STATUS comment='Ticket status (Open, In Progress, Resolved, Closed)',
        TICKETS.channel AS CHANNEL with synonyms=('source','contact method') comment='Channel (Phone, Email, Chat, Portal, Partner)',
        TICKETS.created_date AS CREATED_DATE with synonyms=('date','opened') comment='Date ticket was created',
        TICKETS.resolved_date AS RESOLVED_DATE comment='Date ticket was resolved',
        TICKETS.escalated AS ESCALATED comment='Whether ticket was escalated',
        CATEGORIES.category_name AS CATEGORY_NAME with synonyms=('category','issue type') comment='Support category name'
    )
    metrics (
        avg_first_response as AVG(TICKETS.FIRST_RESPONSE_MINS) with synonyms=('response time') comment='Average first response time in minutes',
        avg_resolution_time as AVG(TICKETS.RESOLUTION_MINS) with synonyms=('resolution time','MTTR') comment='Average resolution time in minutes',
        avg_csat as AVG(TICKETS.CSAT_SCORE) comment='Average CSAT score'
    )
    comment='Semantic view for support ticket analytics - volumes, response times, resolution, and customer satisfaction';

-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT 'Enhanced semantic views created successfully' as status;

-- List all semantic views
SELECT 
    table_schema,
    table_name,
    comment
FROM information_schema.views
WHERE table_name LIKE '%SEMANTIC_VIEW%'
ORDER BY table_name;
