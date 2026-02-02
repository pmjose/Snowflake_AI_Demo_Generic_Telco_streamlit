-- ========================================================================
-- ADDITIONAL SEMANTIC VIEWS FOR PORTING AND PLANS
-- Simplified versions to avoid Snowflake semantic view limitations
-- ========================================================================

USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- ========================================================================
-- PORTING SEMANTIC VIEW (Simplified)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PORTING_SEMANTIC_VIEW
  tables (
    PORTS as NUMBER_PORT_FACT primary key (PORT_ID) comment='Number porting transactions'
  )
  facts (
    PORTS.port_id AS PORT_ID comment='Port ID'
  )
  dimensions (
    PORTS.direction AS DIRECTION comment='Port In or Port Out',
    PORTS.donor_carrier AS DONOR_CARRIER comment='From carrier',
    PORTS.recipient_carrier AS RECIPIENT_CARRIER comment='To carrier',
    PORTS.status AS STATUS comment='Port status',
    PORTS.request_date AS REQUEST_DATE comment='Request date'
  )
  metrics (
    port_count as COUNT(PORTS.PORT_ID) comment='Port count'
  )
  comment='Porting analysis';


-- ========================================================================
-- MOBILE PLAN SEMANTIC VIEW (Simplified)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.PLAN_SEMANTIC_VIEW
  tables (
    PLANS as MOBILE_PLAN_DIM primary key (PLAN_KEY) comment='Mobile plans'
  )
  facts (
    PLANS.monthly_price AS MONTHLY_PRICE comment='Monthly price GBP'
  )
  dimensions (
    PLANS.plan_name AS PLAN_NAME comment='Plan name',
    PLANS.plan_type AS PLAN_TYPE comment='Plan type',
    PLANS.roaming_included AS ROAMING_INCLUDED comment='Roaming included'
  )
  comment='Plan analysis';


-- ========================================================================
-- LEGAL MATTER SEMANTIC VIEW (for VP Legal persona)
-- ========================================================================

CREATE OR REPLACE SEMANTIC VIEW SnowTelco_V2.SnowTelco_V2_SCHEMA.LEGAL_MATTER_SEMANTIC_VIEW
  tables (
    MATTERS as LEGAL_MATTER_FACT primary key (MATTER_ID) with synonyms=('legal matters','disputes','litigation','cases') comment='Legal matters and disputes tracking'
  )
  facts (
    MATTERS.potential_exposure AS POTENTIAL_EXPOSURE with synonyms=('exposure','liability','risk amount') comment='Potential financial exposure in GBP',
    MATTERS.reserved_amount AS RESERVED_AMOUNT with synonyms=('reserve','provision') comment='Reserved amount for matter',
    MATTERS.actual_cost AS ACTUAL_COST with synonyms=('cost','spend','legal fees') comment='Actual costs incurred',
    MATTERS.matter_id AS MATTER_ID comment='Matter identifier for counting'
  )
  dimensions (
    MATTERS.matter_type AS MATTER_TYPE with synonyms=('type','category') comment='Type: Customer Dispute, Employment, Regulatory, Contract, IP/Patent',
    MATTERS.matter_title AS MATTER_TITLE with synonyms=('title','name','description') comment='Matter title',
    MATTERS.status AS STATUS with synonyms=('state') comment='Status: Open, Under Review, Settled, Closed',
    MATTERS.priority AS PRIORITY comment='Priority: High, Medium, Low',
    MATTERS.open_date AS OPEN_DATE comment='Date matter opened',
    MATTERS.close_date AS CLOSE_DATE comment='Date matter closed',
    MATTERS.opposing_party AS OPPOSING_PARTY with synonyms=('party','claimant','plaintiff') comment='Opposing party name',
    MATTERS.assigned_counsel AS ASSIGNED_COUNSEL with synonyms=('counsel','lawyer') comment='Assigned counsel (Internal/External)',
    MATTERS.business_unit AS BUSINESS_UNIT with synonyms=('department','unit') comment='Related business unit',
    MATTERS.region AS REGION comment='Geographic region'
  )
  metrics (
    matter_count as COUNT(MATTERS.MATTER_ID) comment='Number of legal matters',
    total_exposure as SUM(MATTERS.POTENTIAL_EXPOSURE) comment='Total potential exposure',
    total_reserved as SUM(MATTERS.RESERVED_AMOUNT) comment='Total reserved amount',
    total_actual_cost as SUM(MATTERS.ACTUAL_COST) comment='Total actual costs'
  )
  comment='Semantic view for legal matter and dispute tracking - litigation, regulatory, employment, contract disputes';


-- ========================================================================
-- FALLBACK: Standard SQL Views (these always work)
-- ========================================================================

CREATE OR REPLACE VIEW V_PORTING_SUMMARY AS
SELECT 
    direction,
    donor_carrier,
    recipient_carrier,
    status,
    COUNT(*) as port_count
FROM NUMBER_PORT_FACT
GROUP BY direction, donor_carrier, recipient_carrier, status;

CREATE OR REPLACE VIEW V_PLAN_SUMMARY AS
SELECT 
    plan_key, plan_name, plan_type, monthly_price,
    data_allowance_gb, "5g_included" as five_g_included, roaming_included
FROM MOBILE_PLAN_DIM
ORDER BY plan_type, monthly_price;
