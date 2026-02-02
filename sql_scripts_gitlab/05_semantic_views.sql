-- ========================================================================
-- SnowTelco Demo - Step 5: Semantic Views for Cortex Analyst
-- Creates business unit-specific semantic views for natural language queries
-- Based on: https://docs.snowflake.com/en/user-guide/views-semantic/sql
-- Run time: ~1 minute
-- Prerequisites: Run 01-04 scripts first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

-- ========================================================================
-- FINANCE SEMANTIC VIEW
-- ========================================================================

create or replace semantic view SnowTelco_V2.SnowTelco_V2_SCHEMA.FINANCE_SEMANTIC_VIEW
    tables (
        TRANSACTIONS as FINANCE_TRANSACTIONS primary key (TRANSACTION_ID) with synonyms=('finance transactions','financial data') comment='All financial transactions across departments',
        ACCOUNTS as ACCOUNT_DIM primary key (ACCOUNT_KEY) with synonyms=('chart of accounts','account types') comment='Account dimension for financial categorization',
        DEPARTMENTS as DEPARTMENT_DIM primary key (DEPARTMENT_KEY) with synonyms=('business units','departments') comment='Department dimension for cost center analysis',
        VENDORS as VENDOR_DIM primary key (VENDOR_KEY) with synonyms=('suppliers','vendors') comment='Vendor information for spend analysis',
        PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items') comment='Product dimension for transaction analysis',
        CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('clients','customers') comment='Customer dimension for revenue analysis'
    )
    relationships ( 
        TRANSACTIONS_TO_ACCOUNTS as TRANSACTIONS(ACCOUNT_KEY) references ACCOUNTS(ACCOUNT_KEY),
        TRANSACTIONS_TO_DEPARTMENTS as TRANSACTIONS(DEPARTMENT_KEY) references DEPARTMENTS(DEPARTMENT_KEY),
        TRANSACTIONS_TO_VENDORS as TRANSACTIONS(VENDOR_KEY) references VENDORS(VENDOR_KEY),
        TRANSACTIONS_TO_PRODUCTS as TRANSACTIONS(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
        TRANSACTIONS_TO_CUSTOMERS as TRANSACTIONS(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
    )
    facts (
        TRANSACTIONS.amount AS AMOUNT comment='Transaction amount in GBP',
        TRANSACTIONS.transaction_id AS TRANSACTION_ID comment='Transaction identifier for counting'
    )
    dimensions (
        TRANSACTIONS.date AS "DATE" with synonyms=('date','transaction date') comment='Date of the financial transaction',
        ACCOUNTS.account_name AS ACCOUNT_NAME with synonyms=('account','account type') comment='Name of the account',
        ACCOUNTS.account_type AS ACCOUNT_TYPE with synonyms=('type','category') comment='Type of account (Income/Expense)',
        DEPARTMENTS.department_name AS DEPARTMENT_NAME with synonyms=('department','business unit') comment='Name of the department',
        VENDORS.vendor_name AS VENDOR_NAME with synonyms=('vendor','supplier') comment='Name of the vendor',
        PRODUCTS.product_name AS PRODUCT_NAME with synonyms=('product','item') comment='Name of the product',
        CUSTOMERS.customer_name AS CUSTOMER_NAME with synonyms=('customer','client') comment='Name of the customer',
        CUSTOMERS.industry AS INDUSTRY with synonyms=('industry','customer industry','sector') comment='Customer industry sector',
        CUSTOMERS.vertical AS VERTICAL with synonyms=('vertical','segment','customer segment') comment='Customer vertical/segment (SMB/Enterprise/Public Sector/Partner)',
        TRANSACTIONS.approval_status AS APPROVAL_STATUS with synonyms=('approval','status','approval state') comment='Transaction approval status (Approved/Pending/Rejected)',
        TRANSACTIONS.procurement_method AS PROCUREMENT_METHOD with synonyms=('procurement','method','purchase method') comment='Method of procurement (RFP/Quotes/Emergency/Contract)',
        TRANSACTIONS.approver_id AS APPROVER_ID with synonyms=('approver','approver employee id') comment='Employee ID of the approver from HR',
        TRANSACTIONS.approval_date AS APPROVAL_DATE with synonyms=('approved date','date approved') comment='Date when transaction was approved',
        TRANSACTIONS.purchase_order_number AS PURCHASE_ORDER_NUMBER with synonyms=('PO number','PO','purchase order') comment='Purchase order number for tracking',
        TRANSACTIONS.contract_reference AS CONTRACT_REFERENCE with synonyms=('contract','contract number','contract ref') comment='Reference to related contract'
    )
    metrics (
        avg_amount as AVG(TRANSACTIONS.AMOUNT) comment='Average transaction amount',
        total_amount as SUM(TRANSACTIONS.AMOUNT) comment='Total transaction amount',
        transaction_count as COUNT(TRANSACTIONS.TRANSACTION_ID) comment='Total number of transactions'
    )
    comment='Semantic view for financial analysis and reporting';


-- ========================================================================
-- SALES SEMANTIC VIEW
-- ========================================================================

create or replace semantic view SnowTelco_V2.SnowTelco_V2_SCHEMA.SALES_SEMANTIC_VIEW
  tables (
    CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('clients','customers','accounts') comment='Customer information for sales analysis',
    PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items','SKUs') comment='Product catalog for sales analysis',
    PRODUCT_CATEGORY_DIM primary key (CATEGORY_KEY),
    REGIONS as REGION_DIM primary key (REGION_KEY) with synonyms=('territories','regions','areas') comment='Regional information for territory analysis',
    SALES as SALES_FACT primary key (SALE_ID) with synonyms=('sales transactions','sales data') comment='All sales transactions and deals',
    SALES_REPS as SALES_REP_DIM primary key (SALES_REP_KEY) with synonyms=('sales representatives','reps','salespeople') comment='Sales representative information',
    VENDORS as VENDOR_DIM primary key (VENDOR_KEY) with synonyms=('suppliers','vendors') comment='Vendor information for supply chain analysis'
  )
  relationships (
    PRODUCT_TO_CATEGORY as PRODUCTS(CATEGORY_KEY) references PRODUCT_CATEGORY_DIM(CATEGORY_KEY),
    SALES_TO_CUSTOMERS as SALES(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY),
    SALES_TO_PRODUCTS as SALES(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
    SALES_TO_REGIONS as SALES(REGION_KEY) references REGIONS(REGION_KEY),
    SALES_TO_REPS as SALES(SALES_REP_KEY) references SALES_REPS(SALES_REP_KEY),
    SALES_TO_VENDORS as SALES(VENDOR_KEY) references VENDORS(VENDOR_KEY)
  )
  facts (
    SALES.amount AS AMOUNT comment='Sale amount in GBP',
    SALES.units AS UNITS comment='Number of units sold',
    SALES.sale_id AS SALE_ID comment='Sale identifier for counting'
  )
  dimensions (
    CUSTOMERS.industry AS INDUSTRY with synonyms=('industry','customer type','customer industry') comment='Customer industry sector',
    CUSTOMERS.customer_name AS CUSTOMER_NAME with synonyms=('customer','client','account') comment='Name of the customer',
    PRODUCTS.product_name AS PRODUCT_NAME with synonyms=('product','item') comment='Name of the product',
    PRODUCT_CATEGORY_DIM.category_name AS CATEGORY_NAME with synonyms=('category_title','product_group','classification_name','category_label','product_category_description') comment='The category to which a product belongs, such as electronics, clothing, or software as a service.',
    PRODUCT_CATEGORY_DIM.vertical AS VERTICAL with synonyms=('industry','sector','market','category_group','business_area','domain') comment='The industry or sector in which a product is categorized, such as retail, technology, or manufacturing.',
    REGIONS.region_name AS REGION_NAME with synonyms=('region','territory','area') comment='Name of the region',
    SALES.date AS "DATE" with synonyms=('date','sale date','transaction date') comment='Date of the sale',
    SALES_REPS.rep_name AS REP_NAME with synonyms=('sales rep','representative','salesperson') comment='Name of the sales representative',
    VENDORS.vendor_name AS VENDOR_NAME with synonyms=('vendor','supplier','provider') comment='Name of the vendor'
  )
  metrics (
    avg_deal_size as AVG(SALES.AMOUNT) comment='Average deal size',
    avg_units_per_sale as AVG(SALES.UNITS) comment='Average units per sale',
    total_deals as COUNT(SALES.SALE_ID) comment='Total number of deals',
    total_revenue as SUM(SALES.AMOUNT) comment='Total sales revenue',
    total_units as SUM(SALES.UNITS) comment='Total units sold'
  )
  comment='Semantic view for SnowTelco UK B2B UCaaS/CCaaS sales analysis';


-- ========================================================================
-- MARKETING SEMANTIC VIEW
-- ========================================================================

create or replace semantic view SnowTelco_V2.SnowTelco_V2_SCHEMA.MARKETING_SEMANTIC_VIEW
  tables (
    ACCOUNTS as SF_ACCOUNTS primary key (ACCOUNT_ID) with synonyms=('customers','accounts','clients') comment='Customer account information for revenue analysis',
    CAMPAIGNS as MARKETING_CAMPAIGN_FACT primary key (CAMPAIGN_FACT_ID) with synonyms=('marketing campaigns','campaign data') comment='Marketing campaign performance data',
    CAMPAIGN_DETAILS as CAMPAIGN_DIM primary key (CAMPAIGN_KEY) with synonyms=('campaign info','campaign details') comment='Campaign dimension with objectives and names',
    CHANNELS as CHANNEL_DIM primary key (CHANNEL_KEY) with synonyms=('marketing channels','channels') comment='Marketing channel information',
    CONTACTS as SF_CONTACTS primary key (CONTACT_ID) with synonyms=('leads','contacts','prospects') comment='Contact records generated from marketing campaigns',
    OPPORTUNITIES as SF_OPPORTUNITIES primary key (OPPORTUNITY_ID) with synonyms=('deals','opportunities','sales pipeline') comment='Sales opportunities and revenue data',
    PRODUCTS as PRODUCT_DIM primary key (PRODUCT_KEY) with synonyms=('products','items') comment='Product dimension for campaign-specific analysis',
    REGIONS as REGION_DIM primary key (REGION_KEY) with synonyms=('territories','regions','markets') comment='Regional information for campaign analysis'
  )
  relationships (
    CAMPAIGNS_TO_CHANNELS as CAMPAIGNS(CHANNEL_KEY) references CHANNELS(CHANNEL_KEY),
    CAMPAIGNS_TO_DETAILS as CAMPAIGNS(CAMPAIGN_KEY) references CAMPAIGN_DETAILS(CAMPAIGN_KEY),
    CAMPAIGNS_TO_PRODUCTS as CAMPAIGNS(PRODUCT_KEY) references PRODUCTS(PRODUCT_KEY),
    CAMPAIGNS_TO_REGIONS as CAMPAIGNS(REGION_KEY) references REGIONS(REGION_KEY),
    CONTACTS_TO_ACCOUNTS as CONTACTS(ACCOUNT_ID) references ACCOUNTS(ACCOUNT_ID),
    OPPORTUNITIES_TO_ACCOUNTS as OPPORTUNITIES(ACCOUNT_ID) references ACCOUNTS(ACCOUNT_ID),
    OPPORTUNITIES_TO_CAMPAIGNS as OPPORTUNITIES(CAMPAIGN_ID) references CAMPAIGNS(CAMPAIGN_FACT_ID)
  )
  facts (
    CAMPAIGNS.spend AS SPEND comment='Marketing spend in GBP',
    CAMPAIGNS.impressions AS IMPRESSIONS comment='Number of impressions',
    CAMPAIGNS.leads_generated AS LEADS_GENERATED comment='Number of leads generated',
    CAMPAIGNS.campaign_fact_id AS CAMPAIGN_FACT_ID comment='Campaign identifier for counting',
    OPPORTUNITIES.amount AS AMOUNT comment='Opportunity revenue in GBP',
    OPPORTUNITIES.opportunity_id AS OPPORTUNITY_ID comment='Opportunity identifier for counting',
    CONTACTS.contact_id AS CONTACT_ID comment='Contact identifier for counting'
  )
  dimensions (
    ACCOUNTS.account_name AS ACCOUNT_NAME with synonyms=('customer name','client name','company') comment='Name of the customer account',
    ACCOUNTS.account_type AS ACCOUNT_TYPE with synonyms=('customer type','account category') comment='Type of customer account',
    ACCOUNTS.annual_revenue AS ANNUAL_REVENUE with synonyms=('customer revenue','company revenue') comment='Customer annual revenue',
    ACCOUNTS.employees AS EMPLOYEES with synonyms=('company size','employee count') comment='Number of employees at customer',
    ACCOUNTS.industry AS INDUSTRY with synonyms=('industry','sector') comment='Customer industry',
    CAMPAIGNS.date AS "DATE" with synonyms=('date','campaign date') comment='Date of the campaign activity',
    CAMPAIGN_DETAILS.campaign_name AS CAMPAIGN_NAME with synonyms=('campaign','campaign title') comment='Name of the marketing campaign',
    CAMPAIGN_DETAILS.objective AS OBJECTIVE with synonyms=('goal','purpose') comment='Campaign objective',
    CHANNELS.channel_name AS CHANNEL_NAME with synonyms=('channel','marketing channel') comment='Name of the marketing channel',
    CONTACTS.department AS DEPARTMENT with synonyms=('department','business unit') comment='Contact department',
    CONTACTS.email AS EMAIL with synonyms=('email','email address') comment='Contact email address',
    CONTACTS.first_name AS FIRST_NAME with synonyms=('first name','contact name') comment='Contact first name',
    CONTACTS.last_name AS LAST_NAME with synonyms=('last name','surname') comment='Contact last name',
    CONTACTS.title AS "TITLE" with synonyms=('job title','position') comment='Contact job title',
    OPPORTUNITIES.close_date AS CLOSE_DATE with synonyms=('close date','expected close') comment='Expected or actual close date',
    OPPORTUNITIES.lead_source AS LEAD_SOURCE with synonyms=('opportunity source','deal source') comment='Source of the opportunity',
    OPPORTUNITIES.opportunity_name AS OPPORTUNITY_NAME with synonyms=('deal name','opportunity title') comment='Name of the sales opportunity',
    OPPORTUNITIES.stage_name AS STAGE_NAME comment='Stage name of the opportunity. Closed Won indicates an actual sale with revenue',
    OPPORTUNITIES.opportunity_type AS "TYPE" with synonyms=('deal type') comment='Type of opportunity',
    PRODUCTS.product_name AS PRODUCT_NAME with synonyms=('product','item','product title') comment='Name of the product being promoted',
    REGIONS.region_name AS REGION_NAME with synonyms=('region','market','territory') comment='Name of the region'
  )
  metrics (
    avg_spend as AVG(CAMPAIGNS.SPEND) comment='Average campaign spend',
    total_campaigns as COUNT(CAMPAIGNS.CAMPAIGN_FACT_ID) comment='Total number of campaign activities',
    total_impressions as SUM(CAMPAIGNS.IMPRESSIONS) comment='Total impressions across campaigns',
    total_leads as SUM(CAMPAIGNS.LEADS_GENERATED) comment='Total leads generated from campaigns',
    total_spend as SUM(CAMPAIGNS.SPEND) comment='Total marketing spend',
    total_contacts as COUNT(CONTACTS.CONTACT_ID) comment='Total contacts generated from campaigns',
    avg_deal_size as AVG(OPPORTUNITIES.AMOUNT) comment='Average opportunity size from marketing',
    total_opportunities as COUNT(OPPORTUNITIES.OPPORTUNITY_ID) comment='Total opportunities from marketing',
    total_opportunity_revenue as SUM(OPPORTUNITIES.AMOUNT) comment='Total revenue from marketing-driven opportunities'
  )
  comment='Semantic view for marketing campaign analysis with revenue attribution and ROI tracking';


-- ========================================================================
-- HR SEMANTIC VIEW
-- ========================================================================

create or replace semantic view SnowTelco_V2.SnowTelco_V2_SCHEMA.HR_SEMANTIC_VIEW
  tables (
    DEPARTMENTS as DEPARTMENT_DIM primary key (DEPARTMENT_KEY) with synonyms=('departments','business units') comment='Department dimension for organizational analysis',
    EMPLOYEES as EMPLOYEE_DIM primary key (EMPLOYEE_KEY) with synonyms=('employees','staff','workforce') comment='Employee dimension with personal information',
    HR_RECORDS as HR_EMPLOYEE_FACT primary key (HR_FACT_ID) with synonyms=('hr data','employee records') comment='HR employee fact data for workforce analysis',
    JOBS as JOB_DIM primary key (JOB_KEY) with synonyms=('job titles','positions','roles') comment='Job dimension with titles and levels',
    LOCATIONS as LOCATION_DIM primary key (LOCATION_KEY) with synonyms=('locations','offices','sites') comment='Location dimension for geographic analysis'
  )
  relationships (
    HR_TO_DEPARTMENTS as HR_RECORDS(DEPARTMENT_KEY) references DEPARTMENTS(DEPARTMENT_KEY),
    HR_TO_EMPLOYEES as HR_RECORDS(EMPLOYEE_KEY) references EMPLOYEES(EMPLOYEE_KEY),
    HR_TO_JOBS as HR_RECORDS(JOB_KEY) references JOBS(JOB_KEY),
    HR_TO_LOCATIONS as HR_RECORDS(LOCATION_KEY) references LOCATIONS(LOCATION_KEY)
  )
  facts (
    HR_RECORDS.attrition_flag AS ATTRITION_FLAG with synonyms=('turnover_indicator','employee_departure_flag','separation_flag','employee_retention_status','churn_status','employee_exit_indicator') comment='Attrition flag. value is 0 if employee is currently active. 1 if employee quit & left the company. Always filter by 0 to show active employees unless specified otherwise',
    HR_RECORDS.salary AS SALARY comment='Employee salary in GBP',
    HR_RECORDS.hr_fact_id AS HR_FACT_ID comment='HR record identifier for counting'
  )
  dimensions (
    DEPARTMENTS.department_name AS DEPARTMENT_NAME with synonyms=('department','business unit','division') comment='Name of the department',
    EMPLOYEES.employee_name AS EMPLOYEE_NAME with synonyms=('employee','staff member','person','sales rep','manager','director','executive') comment='Name of the employee',
    EMPLOYEES.gender AS GENDER with synonyms=('gender','sex') comment='Employee gender',
    EMPLOYEES.hire_date AS HIRE_DATE with synonyms=('hire date','start date') comment='Date when employee was hired',
    HR_RECORDS.date AS "DATE" with synonyms=('date','record date') comment='Date of the HR record',
    JOBS.job_title AS JOB_TITLE with synonyms=('job title','position','role') comment='Employee job title',
    LOCATIONS.location_name AS LOCATION_NAME with synonyms=('location','office','site') comment='Work location'
  )
  metrics (
    attrition_count as SUM(HR_RECORDS.ATTRITION_FLAG) comment='Number of employees who left',
    avg_salary as AVG(HR_RECORDS.SALARY) comment='Average employee salary',
    total_employees as COUNT(HR_RECORDS.HR_FACT_ID) comment='Total number of employees',
    total_salary_cost as SUM(HR_RECORDS.SALARY) comment='Total salary cost'
  )
  comment='Semantic view for HR analytics and workforce management';


-- ========================================================================
-- MOBILE SEMANTIC VIEW
-- Note: Porting data is in separate PORTING_SEMANTIC_VIEW due to Snowflake limitations
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.MOBILE_SEMANTIC_VIEW
  tables (
    SUBSCRIBERS as MOBILE_SUBSCRIBER_DIM primary key (SUBSCRIBER_KEY) with synonyms=('mobile customers','subscribers','mobile users') comment='Mobile subscriber information with B2C/B2B classification',
    USAGE as MOBILE_USAGE_FACT primary key (USAGE_ID) with synonyms=('mobile usage','consumption','billing') comment='Monthly mobile usage records with NPS',
    CHURN as MOBILE_CHURN_FACT primary key (CHURN_ID) with synonyms=('churn','attrition','cancellations') comment='Customer churn records with reasons',
    PLANS as MOBILE_PLAN_DIM primary key (PLAN_KEY) with synonyms=('mobile plans','tariffs','packages') comment='Mobile plan details'
  )
  relationships (
    USAGE_TO_SUBSCRIBER as USAGE(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY),
    CHURN_TO_SUBSCRIBER as CHURN(SUBSCRIBER_KEY) references SUBSCRIBERS(SUBSCRIBER_KEY),
    SUBSCRIBER_TO_PLAN as SUBSCRIBERS(PLAN_KEY) references PLANS(PLAN_KEY)
  )
  facts (
    USAGE.data_used_gb AS DATA_USED_GB comment='Data consumed in GB',
    USAGE.data_allowance_gb AS DATA_ALLOWANCE_GB comment='Data allowance in GB',
    USAGE.minutes_used AS MINUTES_USED comment='Voice minutes used',
    USAGE.sms_sent AS SMS_SENT comment='SMS messages sent',
    USAGE.roaming_data_gb AS ROAMING_DATA_GB comment='Roaming data in GB',
    USAGE.roaming_minutes AS ROAMING_MINUTES comment='Roaming voice minutes',
    USAGE.bill_amount AS BILL_AMOUNT with synonyms=('revenue','arpu','monthly revenue') comment='Monthly bill in GBP - use for ARPU calculation',
    USAGE.nps_score AS NPS_SCORE with synonyms=('satisfaction score','customer satisfaction','CSAT') comment='Customer satisfaction score on 1-10 scale (not traditional NPS -100 to +100). Higher is better. 1-6=Detractor, 7-8=Passive, 9-10=Promoter.',
    CHURN.lifetime_value AS LIFETIME_VALUE comment='Customer lifetime value in GBP',
    CHURN.retention_attempts AS RETENTION_ATTEMPTS comment='Number of retention attempts made'
  )
  dimensions (
    SUBSCRIBERS.mobile_number AS MOBILE_NUMBER comment='Mobile phone number',
    SUBSCRIBERS.first_name AS FIRST_NAME comment='Subscriber first name',
    SUBSCRIBERS.last_name AS LAST_NAME comment='Subscriber last name',
    SUBSCRIBERS.city AS CITY comment='Subscriber city',
    SUBSCRIBERS.county AS COUNTY with synonyms=('region','area') comment='Subscriber county/region',
    SUBSCRIBERS.postcode AS POSTCODE comment='Subscriber postcode',
    SUBSCRIBERS.status AS STATUS comment='Active/Churned',
    SUBSCRIBERS.customer_type AS CUSTOMER_TYPE with synonyms=('B2B','B2C','business type','market segment') comment='Customer type: Consumer (B2C) / SMB (B2B) / Enterprise (B2B)',
    SUBSCRIBERS.customer_segment AS CUSTOMER_SEGMENT with synonyms=('tier','value tier') comment='Value segment: Budget/Standard/Premium/VIP',
    SUBSCRIBERS.company_name AS COMPANY_NAME with synonyms=('business name','employer') comment='Company name for B2B customers',
    SUBSCRIBERS.company_size AS COMPANY_SIZE with synonyms=('employee count','business size') comment='Company size: 1-10/11-50/51-200/201-500/501-1000/1000+',
    SUBSCRIBERS.activation_date AS ACTIVATION_DATE comment='Service activation date',
    SUBSCRIBERS.acquisition_channel AS ACQUISITION_CHANNEL with synonyms=('source','channel') comment='How customer was acquired',
    SUBSCRIBERS.credit_score AS CREDIT_SCORE comment='Credit rating: Excellent/Good/Fair/Poor',
    USAGE.usage_month AS USAGE_MONTH with synonyms=('month','period','billing month','year','fiscal year') comment='Usage month as text string in YYYY-MM format (e.g. 2024-01, 2025-12). Filter using string comparison like usage_month >= 2024-01. Use LEFT(usage_month,4) to extract year.',
    USAGE.payment_status AS PAYMENT_STATUS comment='Payment status: Paid/Pending/Overdue',
    CHURN.churn_date AS CHURN_DATE comment='Date customer churned',
    CHURN.churn_reason AS CHURN_REASON with synonyms=('cancellation reason','why left') comment='Primary reason for churn',
    CHURN.churn_reason_detail AS CHURN_REASON_DETAIL comment='Detailed churn reason',
    CHURN.competitor_name AS COMPETITOR_NAME with synonyms=('competitor','rival') comment='Competitor customer moved to (EE/Vodafone/Three/O2/Sky/etc)',
    CHURN.port_out AS PORT_OUT comment='Whether number was ported out (TRUE/FALSE)',
    PLANS.plan_name AS PLAN_NAME with synonyms=('tariff','package') comment='Mobile plan name',
    PLANS.plan_type AS PLAN_TYPE comment='Plan type: Pay Monthly/SIM Only/PAYG/Family/Business',
    PLANS.network_generation AS NETWORK_GENERATION with synonyms=('5G','4G','network type') comment='Network generation: 5G/4G/4G+/3G'
  )
  metrics (
    total_data as SUM(USAGE.DATA_USED_GB) comment='Total data consumed in GB',
    total_revenue as SUM(USAGE.BILL_AMOUNT) comment='Total revenue in GBP',
    avg_bill as AVG(USAGE.BILL_AMOUNT) with synonyms=('ARPU','average revenue per user') comment='Average monthly bill (ARPU) in GBP',
    avg_nps as AVG(USAGE.NPS_SCORE) comment='Average satisfaction score (1-10 scale)',
    total_lifetime_value as SUM(CHURN.LIFETIME_VALUE) comment='Total lifetime value lost to churn'
  )
  comment='Semantic view for mobile subscriber analytics including B2C/B2B segmentation, usage, churn, and NPS. For porting data, use PORTING_SEMANTIC_VIEW';


-- ========================================================================
-- PORTING SEMANTIC VIEW (Number Porting / MNP)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PORTING_SEMANTIC_VIEW
  tables (
    PORTS as NUMBER_PORT_FACT primary key (PORT_ID) with synonyms=('number porting','port requests','MNP','porting') comment='Number porting to/from competitors'
  )
  facts (
    PORTS.port_id AS PORT_ID comment='Port request identifier'
  )
  dimensions (
    PORTS.direction AS DIRECTION with synonyms=('port direction','port type') comment='Port In (gaining customer) or Port Out (losing customer)',
    PORTS.donor_carrier AS DONOR_CARRIER with synonyms=('from carrier','source carrier') comment='Carrier customer is porting FROM',
    PORTS.recipient_carrier AS RECIPIENT_CARRIER with synonyms=('to carrier','destination carrier') comment='Carrier customer is porting TO',
    PORTS.status AS STATUS comment='Completed/Pending/Failed/Rejected',
    PORTS.request_date AS REQUEST_DATE comment='Date port was requested'
  )
  comment='Semantic view for number porting (MNP) analysis - port-ins from competitors and port-outs to competitors';


-- ========================================================================
-- ORDER MANAGEMENT SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.ORDER_SEMANTIC_VIEW
  tables (
    ORDER_LINES as ORDER_LINE_FACT primary key (ORDER_LINE_ID) with synonyms=('order items','line items') comment='Order line details',
    ORDERS as ORDER_DIM primary key (ORDER_ID) with synonyms=('sales orders','orders') comment='Order header information'
  )
  relationships (
    LINE_TO_ORDER as ORDER_LINES(ORDER_ID) references ORDERS(ORDER_ID)
  )
  facts (
    ORDER_LINES.line_total AS LINE_TOTAL comment='Order line total value',
    ORDER_LINES.quantity AS QUANTITY comment='Quantity ordered',
    ORDER_LINES.unit_price AS UNIT_PRICE comment='Unit price'
  )
  dimensions (
    ORDERS.order_number AS ORDER_NUMBER comment='Order reference number',
    ORDERS.order_date AS ORDER_DATE comment='Date order was placed',
    ORDERS.order_type AS ORDER_TYPE comment='New/Upgrade/Renewal',
    ORDERS.channel AS CHANNEL comment='Sales channel',
    ORDERS.status AS STATUS comment='Order status'
  )
  metrics (
    sum_line_total as SUM(ORDER_LINES.LINE_TOTAL) comment='Total order value',
    sum_quantity as SUM(ORDER_LINES.QUANTITY) comment='Total quantity ordered',
    avg_unit_price as AVG(ORDER_LINES.UNIT_PRICE) comment='Average unit price'
  )
  comment='Semantic view for order management analytics';


-- ========================================================================
-- BILLING SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.BILLING_SEMANTIC_VIEW
  tables (
    INVOICES as INVOICE_FACT primary key (INVOICE_ID) with synonyms=('bills','invoices') comment='Invoice records',
    CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) with synonyms=('accounts','clients') comment='Customer information'
  )
  relationships (
    INVOICE_TO_CUSTOMER as INVOICES(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
  )
  facts (
    INVOICES.amount AS AMOUNT comment='Invoice amount before tax',
    INVOICES.tax_amount AS TAX_AMOUNT comment='Tax amount',
    INVOICES.total_amount AS TOTAL_AMOUNT comment='Invoice total with tax'
  )
  dimensions (
    INVOICES.invoice_number AS INVOICE_NUMBER comment='Invoice reference',
    INVOICES.invoice_date AS INVOICE_DATE comment='Date invoice issued',
    INVOICES.due_date AS DUE_DATE comment='Payment due date',
    INVOICES.status AS STATUS comment='Paid/Pending/Overdue',
    CUSTOMERS.customer_name AS CUSTOMER_NAME comment='Customer name'
  )
  metrics (
    total_invoiced as SUM(INVOICES.TOTAL_AMOUNT) comment='Total invoiced amount',
    avg_invoice as AVG(INVOICES.AMOUNT) comment='Average invoice amount'
  )
  comment='Semantic view for billing and revenue collection';


-- ========================================================================
-- PAYMENT SEMANTIC VIEW (Payment transactions analysis)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PAYMENT_SEMANTIC_VIEW
  tables (
    PAYMENTS as PAYMENT_FACT primary key (PAYMENT_ID) with synonyms=('payments','transactions') comment='Payment transactions'
  )
  facts (
    PAYMENTS.amount AS AMOUNT comment='Payment amount'
  )
  dimensions (
    PAYMENTS.payment_date AS PAYMENT_DATE comment='Date payment received',
    PAYMENTS.payment_reference AS PAYMENT_REFERENCE comment='Payment reference number'
  )
  metrics (
    total_collected as SUM(PAYMENTS.AMOUNT) comment='Total payments collected',
    avg_payment as AVG(PAYMENTS.AMOUNT) comment='Average payment amount'
  )
  comment='Semantic view for payment analysis';


-- ========================================================================
-- NETWORK OPERATIONS SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_OPS_SEMANTIC_VIEW
  tables (
    PERFORMANCE as NETWORK_PERFORMANCE_FACT primary key (PERF_ID) with synonyms=('metrics','KPIs') comment='Network performance metrics',
    ELEMENTS as NETWORK_ELEMENT_DIM primary key (ELEMENT_ID) with synonyms=('network equipment','nodes') comment='Network elements and equipment'
  )
  relationships (
    PERF_TO_ELEMENT as PERFORMANCE(ELEMENT_ID) references ELEMENTS(ELEMENT_ID)
  )
  facts (
    PERFORMANCE.throughput_gbps AS THROUGHPUT_GBPS comment='Network throughput in Gbps',
    PERFORMANCE.latency_ms AS LATENCY_MS comment='Network latency in milliseconds',
    PERFORMANCE.utilization_pct AS UTILIZATION_PCT comment='Capacity utilization percentage',
    PERFORMANCE.availability_pct AS AVAILABILITY_PCT comment='Availability percentage'
  )
  dimensions (
    ELEMENTS.element_name AS ELEMENT_NAME comment='Network element name',
    ELEMENTS.element_type AS ELEMENT_TYPE comment='Router/Switch/BTS/Core',
    ELEMENTS.category AS CATEGORY comment='Element category',
    ELEMENTS.city AS CITY comment='Element location city',
    ELEMENTS.status AS STATUS comment='Active/Maintenance/Decommissioned',
    ELEMENTS.criticality AS CRITICALITY comment='Critical/High/Medium/Low',
    PERFORMANCE.metric_date AS METRIC_DATE comment='Date of measurement'
  )
  metrics (
    avg_throughput as AVG(PERFORMANCE.THROUGHPUT_GBPS) comment='Average throughput',
    avg_latency as AVG(PERFORMANCE.LATENCY_MS) comment='Average latency',
    avg_availability as AVG(PERFORMANCE.AVAILABILITY_PCT) comment='Average availability'
  )
  comment='Semantic view for network operations and monitoring';


-- ========================================================================
-- SUPPORT SEMANTIC VIEW (Enhanced with FCR - Phase 3.2)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SUPPORT_SEMANTIC_VIEW
  tables (
    CALLS as CONTACT_CENTER_CALL_FACT primary key (CALL_ID) with synonyms=('phone calls','interactions') comment='Contact center calls with FCR tracking',
    AGENTS as CONTACT_CENTER_AGENT_DIM primary key (AGENT_KEY) with synonyms=('representatives','staff') comment='Contact center agents'
  )
  relationships (
    CALL_TO_AGENT as CALLS(AGENT_KEY) references AGENTS(AGENT_KEY)
  )
  facts (
    CALLS.handle_time_secs AS HANDLE_TIME_SECS comment='Call handle time in seconds',
    CALLS.wait_time_secs AS WAIT_TIME_SECS comment='Call wait time in seconds',
    CALLS.csat_score AS CSAT_SCORE comment='Customer satisfaction score',
    CALLS.transfer_count AS TRANSFER_COUNT comment='Number of transfers'
  )
  dimensions (
    CALLS.queue AS QUEUE comment='Call queue',
    CALLS.disposition AS DISPOSITION comment='Call disposition',
    CALLS.start_time AS START_TIME comment='Call start time',
    CALLS.customer_type AS CUSTOMER_TYPE with synonyms=('segment','B2B','B2C') comment='Customer type (Consumer, B2B)',
    CALLS.is_first_call_resolved AS IS_FIRST_CALL_RESOLVED with synonyms=('FCR','first call resolution','resolved first call','is_fcr') comment='Whether issue was resolved on first call',
    CALLS.callback_required AS CALLBACK_REQUIRED comment='Whether callback was needed',
    AGENTS.agent_name AS AGENT_NAME comment='Agent handling call',
    AGENTS.team AS TEAM comment='Agent team',
    AGENTS.skill_group AS SKILL_GROUP comment='Agent skill group'
  )
  metrics (
    avg_handle_time as AVG(CALLS.HANDLE_TIME_SECS) comment='Average handle time in seconds',
    avg_wait_time as AVG(CALLS.WAIT_TIME_SECS) comment='Average wait time in seconds',
    avg_csat as AVG(CALLS.CSAT_SCORE) comment='Average CSAT score'
  )
  comment='Semantic view for customer support analytics with First Call Resolution tracking';


-- ========================================================================
-- PARTNER SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PARTNER_SEMANTIC_VIEW
  tables (
    PERFORMANCE as PARTNER_PERFORMANCE_FACT primary key (PERF_ID) with synonyms=('results','KPIs') comment='Partner performance metrics',
    PARTNERS as PARTNER_DIM primary key (PARTNER_KEY) with synonyms=('dealers','resellers','channels') comment='Partner information'
  )
  relationships (
    PERF_TO_PARTNER as PERFORMANCE(PARTNER_KEY) references PARTNERS(PARTNER_KEY)
  )
  facts (
    PERFORMANCE.orders_count AS ORDERS_COUNT comment='Number of orders',
    PERFORMANCE.order_value AS ORDER_VALUE comment='Total order value',
    PERFORMANCE.revenue AS REVENUE comment='Revenue generated',
    PERFORMANCE.new_customers AS NEW_CUSTOMERS comment='New customers acquired',
    PERFORMANCE.commission_earned AS COMMISSION_EARNED comment='Commission earned',
    PERFORMANCE.nps_score AS NPS_SCORE comment='Partner NPS score',
    PERFORMANCE.churn_rate AS CHURN_RATE with synonyms=('attrition','turnover rate') comment='Partner customer churn rate',
    PERFORMANCE.support_tickets AS SUPPORT_TICKETS comment='Support tickets raised by partner',
    PERFORMANCE.training_completed AS TRAINING_COMPLETED with synonyms=('certifications','training') comment='Training modules completed'
  )
  dimensions (
    PARTNERS.partner_name AS PARTNER_NAME comment='Partner company name',
    PARTNERS.partner_type AS PARTNER_TYPE comment='Dealer/Reseller/Distributor',
    PARTNERS.tier AS TIER comment='Gold/Silver/Bronze',
    PARTNERS.city AS CITY comment='Partner city',
    PARTNERS.status AS STATUS comment='Active/Suspended',
    PARTNERS.onboard_date AS ONBOARD_DATE with synonyms=('joined','partner since') comment='Date partner was onboarded',
    PARTNERS.account_manager AS ACCOUNT_MANAGER comment='Partner account manager',
    PARTNERS.commission_rate AS COMMISSION_RATE comment='Partner commission rate percentage',
    PERFORMANCE.month AS MONTH comment='Performance month'
  )
  metrics (
    total_orders as SUM(PERFORMANCE.ORDERS_COUNT) comment='Total orders',
    total_revenue as SUM(PERFORMANCE.REVENUE) comment='Total revenue',
    total_commission as SUM(PERFORMANCE.COMMISSION_EARNED) comment='Total commission',
    avg_order_value as AVG(PERFORMANCE.ORDER_VALUE) comment='Average order value',
    avg_churn_rate as AVG(PERFORMANCE.CHURN_RATE) comment='Average partner churn rate',
    total_new_customers as SUM(PERFORMANCE.NEW_CUSTOMERS) comment='Total new customers acquired'
  )
  comment='Semantic view for partner/channel management - performance, recruitment, and health tracking';


-- ========================================================================
-- ASSET MANAGEMENT SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.ASSET_SEMANTIC_VIEW
  tables (
    INVENTORY as INVENTORY_FACT primary key (INVENTORY_ID) with synonyms=('stock','warehouse stock') comment='Inventory levels',
    WAREHOUSES as WAREHOUSE_DIM primary key (WAREHOUSE_KEY) with synonyms=('locations','depots') comment='Warehouse locations'
  )
  relationships (
    INVENTORY_TO_WAREHOUSE as INVENTORY(WAREHOUSE_KEY) references WAREHOUSES(WAREHOUSE_KEY)
  )
  facts (
    INVENTORY.quantity_on_hand AS QUANTITY_ON_HAND comment='Stock quantity available',
    INVENTORY.quantity_reserved AS QUANTITY_RESERVED comment='Stock reserved for orders',
    INVENTORY.unit_cost AS UNIT_COST comment='Unit cost of inventory'
  )
  dimensions (
    WAREHOUSES.warehouse_name AS WAREHOUSE_NAME comment='Warehouse name',
    WAREHOUSES.city AS CITY comment='Warehouse city',
    INVENTORY.status AS STATUS comment='In Stock/Low/Out',
    INVENTORY.snapshot_date AS SNAPSHOT_DATE comment='Stock count date'
  )
  metrics (
    total_stock as SUM(INVENTORY.QUANTITY_ON_HAND) comment='Total stock quantity',
    total_reserved as SUM(INVENTORY.QUANTITY_RESERVED) comment='Total reserved quantity',
    avg_unit_cost as AVG(INVENTORY.UNIT_COST) comment='Average unit cost'
  )
  comment='Semantic view for asset and inventory management';


-- ========================================================================
-- IT OPERATIONS SEMANTIC VIEW (Enhanced with SLA Tracking - Phase 4)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.IT_OPS_SEMANTIC_VIEW
  tables (
    INCIDENTS as IT_INCIDENT_FACT primary key (INCIDENT_ID) with synonyms=('issues','problems') comment='IT incidents with SLA tracking',
    APPLICATIONS as IT_APPLICATION_DIM primary key (APP_ID) with synonyms=('systems','software') comment='IT applications'
  )
  relationships (
    INCIDENT_TO_APP as INCIDENTS(APP_ID) references APPLICATIONS(APP_ID)
  )
  facts (
    INCIDENTS.resolution_mins AS RESOLUTION_MINS comment='Time to resolve in minutes',
    INCIDENTS.sla_target_mins AS SLA_TARGET_MINS comment='SLA target time in minutes'
  )
  dimensions (
    APPLICATIONS.app_name AS APP_NAME comment='Application name',
    APPLICATIONS.criticality AS CRITICALITY comment='Business criticality',
    INCIDENTS.incident_number AS INCIDENT_NUMBER comment='Incident reference',
    INCIDENTS.category AS CATEGORY comment='Incident category',
    INCIDENTS.severity AS SEVERITY with synonyms=('priority','P1','P2','P3','P4') comment='Priority: P1/P2/P3/P4 (P1=4hr SLA, P2=8hr, P3=24hr, P4=72hr)',
    INCIDENTS.status AS STATUS comment='Open/Resolved/Closed',
    INCIDENTS.root_cause AS ROOT_CAUSE comment='Root cause analysis',
    INCIDENTS.created_timestamp AS CREATED_TIMESTAMP comment='When incident was created',
    INCIDENTS.assigned_timestamp AS ASSIGNED_TIMESTAMP comment='When incident was assigned',
    INCIDENTS.resolved_timestamp AS RESOLVED_TIMESTAMP comment='When incident was resolved',
    INCIDENTS.sla_met AS SLA_MET with synonyms=('within SLA','SLA compliant') comment='Whether SLA target was met'
  )
  metrics (
    avg_resolution as AVG(INCIDENTS.RESOLUTION_MINS) comment='Average resolution time in minutes'
  )
  comment='Semantic view for IT operations and service management with SLA tracking';


-- ========================================================================
-- SLA SEMANTIC VIEW
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SLA_SEMANTIC_VIEW
  tables (
    MEASUREMENTS as SLA_MEASUREMENT_FACT primary key (MEASUREMENT_ID) with synonyms=('results','performance') comment='SLA measurements',
    SLAS as SLA_DIM primary key (SLA_KEY) with synonyms=('service levels','agreements') comment='SLA definitions'
  )
  relationships (
    MEASUREMENT_TO_SLA as MEASUREMENTS(SLA_KEY) references SLAS(SLA_KEY)
  )
  facts (
    MEASUREMENTS.actual_value AS ACTUAL_VALUE comment='Measured value',
    MEASUREMENTS.target_value AS TARGET_VALUE comment='Target value',
    MEASUREMENTS.breach_minutes AS BREACH_MINUTES comment='Minutes in breach'
  )
  dimensions (
    SLAS.sla_name AS SLA_NAME comment='SLA name',
    SLAS.sla_category AS SLA_CATEGORY comment='Availability/Performance/Support',
    SLAS.unit AS UNIT comment='Measurement unit',
    MEASUREMENTS.measurement_date AS MEASUREMENT_DATE comment='Date of measurement',
    MEASUREMENTS.met AS MET comment='Whether SLA was met',
    MEASUREMENTS.credit_applicable AS CREDIT_APPLICABLE comment='Whether credit is due'
  )
  metrics (
    avg_actual as AVG(MEASUREMENTS.ACTUAL_VALUE) comment='Average actual value',
    total_breach_mins as SUM(MEASUREMENTS.BREACH_MINUTES) comment='Total breach minutes'
  )
  comment='Semantic view for SLA monitoring and compliance';


-- ========================================================================
-- NETWORK ALARM SEMANTIC VIEW (NEW - Phase 3.4)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_ALARM_SEMANTIC_VIEW
  tables (
    ALARMS as NETWORK_ALARM_FACT primary key (ALARM_ID) with synonyms=('alerts','faults','issues') comment='Network alarms and alerts',
    ELEMENTS as NETWORK_ELEMENT_DIM primary key (ELEMENT_ID) with synonyms=('equipment','nodes','devices') comment='Network elements'
  )
  relationships (
    ALARM_TO_ELEMENT as ALARMS(ELEMENT_ID) references ELEMENTS(ELEMENT_ID)
  )
  facts (
    ALARMS.alarm_id AS ALARM_ID comment='Alarm identifier for counting',
    ALARMS.mttr_minutes AS MTTR_MINUTES with synonyms=('mean time to repair','repair time') comment='Mean time to repair in minutes',
    ALARMS.alarm_duration_minutes AS ALARM_DURATION_MINUTES with synonyms=('duration','outage time') comment='Alarm duration in minutes'
  )
  dimensions (
    ALARMS.raised_time AS RAISED_TIME with synonyms=('alarm time','start time') comment='When alarm was raised',
    ALARMS.cleared_time AS CLEARED_TIME comment='When alarm was cleared',
    ALARMS.alarm_type AS ALARM_TYPE with synonyms=('fault type','alert type') comment='Type of alarm: Link Down/High CPU/Memory/etc',
    ALARMS.severity AS SEVERITY with synonyms=('priority','criticality','impact') comment='Alarm severity: Critical/Major/Minor/Warning',
    ALARMS.acknowledged AS ACKNOWLEDGED comment='Whether alarm was acknowledged',
    ALARMS.acknowledged_by AS ACKNOWLEDGED_BY comment='Person who acknowledged',
    ALARMS.root_cause AS ROOT_CAUSE comment='Root cause of alarm',
    ALARMS.impact AS IMPACT with synonyms=('effect','consequence') comment='Business impact: Service Affecting/Customer Impacting',
    ELEMENTS.element_name AS ELEMENT_NAME comment='Name of network element',
    ELEMENTS.element_type AS ELEMENT_TYPE comment='Type of equipment',
    ELEMENTS.city AS CITY with synonyms=('location','site') comment='Element location',
    ELEMENTS.criticality AS CRITICALITY comment='Element business criticality'
  )
  metrics (
    alarm_count as COUNT(ALARMS.ALARM_ID) comment='Number of alarms',
    avg_mttr as AVG(ALARMS.MTTR_MINUTES) comment='Average mean time to repair',
    avg_duration as AVG(ALARMS.ALARM_DURATION_MINUTES) comment='Average alarm duration'
  )
  comment='Semantic view for network alarm analysis and NOC monitoring';


-- ========================================================================
-- REVENUE ASSURANCE SEMANTIC VIEW (NEW - Phase 2.3)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.REVENUE_ASSURANCE_SEMANTIC_VIEW
  tables (
    CREDIT_NOTES as CREDIT_NOTE_FACT primary key (CREDIT_NOTE_ID) with synonyms=('credits','refunds') comment='Credit notes issued to customers',
    ADJUSTMENTS as BILLING_ADJUSTMENT_FACT primary key (ADJUSTMENT_ID) with synonyms=('billing corrections') comment='Billing adjustments',
    UNBILLED as UNBILLED_USAGE_FACT primary key (UNBILLED_ID) with synonyms=('revenue leakage','missed billing') comment='Unbilled usage (revenue leakage)',
    CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) comment='Customer information'
  )
  relationships (
    CREDIT_TO_CUSTOMER as CREDIT_NOTES(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY),
    ADJUSTMENT_TO_CUSTOMER as ADJUSTMENTS(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
  )
  facts (
    CREDIT_NOTES.credit_amount AS CREDIT_AMOUNT comment='Amount credited in GBP',
    ADJUSTMENTS.original_amount AS ORIGINAL_AMOUNT comment='Original billing amount',
    ADJUSTMENTS.adjusted_amount AS ADJUSTED_AMOUNT comment='Adjusted billing amount',
    UNBILLED.estimated_revenue AS ESTIMATED_REVENUE with synonyms=('leakage','missed revenue','unbilled_revenue') comment='Estimated unbilled revenue (leakage)'
  )
  dimensions (
    CREDIT_NOTES.credit_date AS CREDIT_DATE comment='Date credit was issued',
    CREDIT_NOTES.credit_reason AS CREDIT_REASON with synonyms=('reason','cause') comment='Reason for credit: Billing Error/Outage/Goodwill/etc',
    CREDIT_NOTES.approval_status AS APPROVAL_STATUS comment='Approved/Pending',
    CREDIT_NOTES.approved_by AS APPROVED_BY comment='Who approved the credit',
    ADJUSTMENTS.adjustment_date AS ADJUSTMENT_DATE comment='Date of adjustment',
    ADJUSTMENTS.adjustment_type AS ADJUSTMENT_TYPE comment='Type: Rate Correction/Usage Rebate/Promotional/Dispute',
    UNBILLED.usage_date AS USAGE_DATE comment='Date of unbilled usage',
    UNBILLED.usage_type AS USAGE_TYPE comment='Type: Data Overage/Roaming/Premium Services/etc',
    UNBILLED.reason_unbilled AS REASON_UNBILLED comment='Why not billed: Mediation Delay/Rating Error/etc',
    CUSTOMERS.customer_name AS CUSTOMER_NAME comment='Customer name'
  )
  metrics (
    total_credits as SUM(CREDIT_NOTES.CREDIT_AMOUNT) comment='Total credits issued in GBP',
    total_adjustments as SUM(ADJUSTMENTS.ADJUSTED_AMOUNT) comment='Total adjusted amounts',
    total_unbilled as SUM(UNBILLED.ESTIMATED_REVENUE) comment='Total unbilled revenue (leakage)'
  )
  comment='Semantic view for revenue assurance - credits, adjustments, and leakage analysis';


-- ========================================================================
-- SIM ACTIVATION SEMANTIC VIEW (NEW - Phase 3.3)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.ACTIVATION_SEMANTIC_VIEW
  tables (
    ACTIVATIONS as SIM_ACTIVATION_FACT primary key (ACTIVATION_ID) with synonyms=('sim activations','provisioning') comment='SIM activation tracking'
  )
  facts (
    ACTIVATIONS.time_to_activate_hours AS TIME_TO_ACTIVATE_HOURS with synonyms=('activation time','provisioning time','activation_hours') comment='Hours from order to activation'
  )
  dimensions (
    ACTIVATIONS.order_timestamp AS ORDER_TIMESTAMP comment='When order was placed',
    ACTIVATIONS.activation_timestamp AS ACTIVATION_TIMESTAMP comment='When SIM was activated',
    ACTIVATIONS.activation_channel AS ACTIVATION_CHANNEL with synonyms=('sales channel','source','channel') comment='Retail Store/Online/Telesales/Partner',
    ACTIVATIONS.activation_status AS ACTIVATION_STATUS comment='Completed/Pending',
    ACTIVATIONS.activation_type AS ACTIVATION_TYPE comment='New Activation/SIM Swap/Replacement'
  )
  metrics (
    avg_activation_time as AVG(ACTIVATIONS.TIME_TO_ACTIVATE_HOURS) comment='Average activation time in hours'
  )
  comment='Semantic view for SIM activation tracking and operations efficiency';


-- ========================================================================
-- DISPUTE SEMANTIC VIEW (NEW - Phase 4)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.DISPUTE_SEMANTIC_VIEW
  tables (
    DISPUTES as DISPUTE_FACT primary key (DISPUTE_ID) with synonyms=('billing disputes','complaints') comment='Customer billing disputes',
    CUSTOMERS as CUSTOMER_DIM primary key (CUSTOMER_KEY) comment='Customer information'
  )
  relationships (
    DISPUTE_TO_CUSTOMER as DISPUTES(CUSTOMER_KEY) references CUSTOMERS(CUSTOMER_KEY)
  )
  facts (
    DISPUTES.disputed_amount AS DISPUTED_AMOUNT comment='Amount in dispute GBP',
    DISPUTES.final_amount AS FINAL_AMOUNT comment='Final settlement amount',
    DISPUTES.days_to_resolve AS DAYS_TO_RESOLVE comment='Days to resolve dispute'
  )
  dimensions (
    DISPUTES.dispute_date AS DISPUTE_DATE comment='Date dispute was raised',
    DISPUTES.dispute_type AS DISPUTE_TYPE with synonyms=('reason','category') comment='Type: Incorrect Charge/Service Not Received/Rate Dispute/etc',
    DISPUTES.status AS STATUS comment='Resolved/In Progress/Escalated',
    DISPUTES.assigned_to AS ASSIGNED_TO comment='Team handling dispute',
    DISPUTES.response_date AS RESPONSE_DATE comment='First response date',
    DISPUTES.resolution_date AS RESOLUTION_DATE comment='Date resolved',
    DISPUTES.resolution_type AS RESOLUTION_TYPE comment='Full Credit/Partial Credit/No Action/Goodwill',
    DISPUTES.sla_met AS SLA_MET comment='Whether resolution SLA was met',
    CUSTOMERS.customer_name AS CUSTOMER_NAME comment='Customer name'
  )
  metrics (
    total_disputed as SUM(DISPUTES.DISPUTED_AMOUNT) comment='Total disputed amount',
    avg_resolution_days as AVG(DISPUTES.DAYS_TO_RESOLVE) comment='Average days to resolve'
  )
  comment='Semantic view for billing dispute management and resolution tracking';


-- ========================================================================
-- SALES PIPELINE SEMANTIC VIEW (CRM/Salesforce data for CCO)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.SALES_PIPELINE_SEMANTIC_VIEW
  tables (
    OPPORTUNITIES as SF_OPPORTUNITIES primary key (OPPORTUNITY_ID) with synonyms=('deals','pipeline','opps') comment='Sales opportunities/deals',
    ACCOUNTS as SF_ACCOUNTS primary key (ACCOUNT_ID) with synonyms=('customers','clients') comment='Customer accounts',
    QUOTAS as SF_QUOTAS primary key (QUOTA_ID) with synonyms=('targets','goals') comment='Sales quotas and targets',
    SNAPSHOTS as SF_PIPELINE_SNAPSHOT primary key (SNAPSHOT_ID) with synonyms=('pipeline history','trends') comment='Weekly pipeline snapshots'
  )
  relationships (
    OPPORTUNITIES (ACCOUNT_ID) references ACCOUNTS (ACCOUNT_ID)
  )
  facts (
    OPPORTUNITIES.amount AS AMOUNT comment='Deal amount in GBP',
    OPPORTUNITIES.opp_id AS OPPORTUNITY_ID comment='Opportunity identifier for counting',
    QUOTAS.quota_amount AS QUOTA_AMOUNT comment='Quota target amount'
  )
  dimensions (
    -- Opportunity dimensions
    OPPORTUNITIES.opportunity_name AS OPPORTUNITY_NAME comment='Deal/opportunity name',
    OPPORTUNITIES.stage_name AS STAGE_NAME with synonyms=('stage','pipeline stage','sales stage')
      comment='Salesforce stage: Prospecting, Qualification, Needs Analysis, Value Proposition, Proposal/Price Quote, Negotiation/Review, Id. Decision Makers, Perception Analysis, Closed Won, Closed Lost',
    OPPORTUNITIES.close_date AS CLOSE_DATE with synonyms=('expected close','close by') comment='Expected or actual close date',
    OPPORTUNITIES.created_date AS CREATED_DATE comment='Date opportunity was created',
    OPPORTUNITIES.lead_source AS LEAD_SOURCE with synonyms=('source','how acquired')
      comment='Web, Phone Inquiry, Partner Referral, Purchased List, Other, Campaign',
    
    -- Account dimensions
    ACCOUNTS.account_id AS ACCOUNT_ID comment='Unique account identifier',
    ACCOUNTS.account_name AS ACCOUNT_NAME with synonyms=('company','customer name') comment='Company/account name',
    ACCOUNTS.industry AS INDUSTRY comment='Industry vertical',
    ACCOUNTS.vertical AS VERTICAL with synonyms=('segment','market segment') comment='SMB, Enterprise, Public Sector',
    ACCOUNTS.account_type AS ACCOUNT_TYPE comment='Customer, Prospect, Partner',
    
    -- Quota dimensions
    QUOTAS.quota_id AS QUOTA_ID comment='Unique quota identifier',
    QUOTAS.rep_name AS REP_NAME with synonyms=('sales rep','account executive') comment='Sales representative name',
    QUOTAS.team AS TEAM with synonyms=('sales team','department') comment='Enterprise, SMB, Consumer, Partners',
    QUOTAS.territory AS TERRITORY with synonyms=('region','geo') comment='London, South East, Midlands, North, Scotland, Wales',
    QUOTAS.quota_type AS QUOTA_TYPE comment='Revenue, New Business, Renewals, Upsell',
    QUOTAS.fiscal_year AS FISCAL_YEAR comment='Fiscal year (2024, 2025, 2026)',
    QUOTAS.fiscal_quarter AS FISCAL_QUARTER comment='Fiscal quarter (1-4)',
    QUOTAS.period_start AS PERIOD_START comment='Quota period start date',
    QUOTAS.period_end AS PERIOD_END comment='Quota period end date',
    
    -- Snapshot dimensions
    SNAPSHOTS.snapshot_id AS SNAPSHOT_ID comment='Unique snapshot identifier',
    SNAPSHOTS.snapshot_date AS SNAPSHOT_DATE comment='Date of pipeline snapshot'
  )
  metrics (
    -- Pipeline metrics
    total_pipeline as SUM(OPPORTUNITIES.AMOUNT) comment='Total pipeline value (all stages)',
    opp_count as COUNT(OPPORTUNITIES.OPP_ID) comment='Number of opportunities',
    avg_deal_size as AVG(OPPORTUNITIES.AMOUNT) comment='Average deal size in GBP'
  )
  comment='Semantic view for CRM pipeline analysis, sales quotas, and forecast tracking. Use for CCO queries about win rates, quota attainment, and pipeline trends.';


-- ========================================================================
-- VERIFICATION - Shows all semantic views created
-- ========================================================================

SHOW SEMANTIC VIEWS IN SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA;

SELECT 
    ROW_NUMBER() OVER (ORDER BY "name") AS num,
    "name" AS semantic_view_name,
    "created_on",
    'Total: ' || COUNT(*) OVER () || ' semantic views | NEXT: Run 06_enhanced_semantic_views.sql' AS summary
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
ORDER BY "name";
