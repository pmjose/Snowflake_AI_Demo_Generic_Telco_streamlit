-- =====================================================
-- SnowTelco V2 Demo User Creation Script
-- =====================================================
-- Run this script as ACCOUNTADMIN to create a new user
-- with full access to the SnowTelco V2 Executive Agent
-- =====================================================

USE ROLE ACCOUNTADMIN;

-- =====================================================
-- STEP 1: Create the User
-- =====================================================

CREATE USER IF NOT EXISTS PEDRO_JOSE
    LOGIN_NAME = 'PEDRO_JOSE'
    DISPLAY_NAME = 'Pedro Jose'
    FIRST_NAME = 'Pedro'
    LAST_NAME = 'Jose'
    EMAIL = 'pmjose@gmail.com'
    PASSWORD = 'snowflake2026'
    DEFAULT_ROLE = SNOWTELCO_V2_DEMO
    DEFAULT_WAREHOUSE = SNOWTELCO_V2_DEMO_WH
    MUST_CHANGE_PASSWORD = FALSE
    COMMENT = 'SnowTelco V2 Demo User - Pedro Jose';

-- =====================================================
-- STEP 2: Grant Demo Role to User
-- =====================================================

GRANT ROLE SNOWTELCO_V2_DEMO TO USER PEDRO_JOSE;

-- =====================================================
-- STEP 3: Ensure Role Has All Required Permissions
-- =====================================================

-- Warehouse access
GRANT USAGE ON WAREHOUSE SNOWTELCO_V2_DEMO_WH TO ROLE SNOWTELCO_V2_DEMO;

-- Database and Schema access
GRANT USAGE ON DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;
GRANT USAGE ON ALL SCHEMAS IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;

-- Table and View access
GRANT SELECT ON ALL TABLES IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;
GRANT SELECT ON ALL VIEWS IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;

-- Future grants
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;
GRANT SELECT ON FUTURE TABLES IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;
GRANT SELECT ON FUTURE VIEWS IN DATABASE SNOWTELCO_V2 TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 4: Semantic Views Access
-- =====================================================

GRANT SELECT ON ALL SEMANTIC VIEWS IN SCHEMA SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA TO ROLE SNOWTELCO_V2_DEMO;
GRANT SELECT ON FUTURE SEMANTIC VIEWS IN SCHEMA SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 5: Cortex Search Services Access
-- =====================================================

GRANT USAGE ON ALL CORTEX SEARCH SERVICES IN SCHEMA SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 6: Cortex AI Access
-- =====================================================

GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 7: Snowflake Intelligence Access (for Agents)
-- =====================================================

-- Grant access to the agent database/schema
GRANT USAGE ON DATABASE SNOWFLAKE_INTELLIGENCE TO ROLE SNOWTELCO_V2_DEMO;
GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE SNOWTELCO_V2_DEMO;

-- Grant usage on the SnowTelco V2 Executive Agent
GRANT USAGE ON AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.SNOWTELCO_V2_EXECUTIVE_AGENT TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 8: Set Default Agent for User
-- =====================================================

ALTER USER PEDRO_JOSE SET DEFAULT_SECONDARY_ROLES = ('ALL');

-- =====================================================
-- STEP 9: Stage Access (for document search)
-- =====================================================

GRANT READ ON STAGE SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA.INTERNAL_DATA_STAGE TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 10: Stored Procedures & Functions Access
-- =====================================================

GRANT USAGE ON ALL PROCEDURES IN SCHEMA SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA TO ROLE SNOWTELCO_V2_DEMO;
GRANT USAGE ON ALL FUNCTIONS IN SCHEMA SNOWTELCO_V2.SNOWTELCO_V2_SCHEMA TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- STEP 11: Bypass MFA (for demo purposes only)
-- =====================================================

-- Disable MFA requirement for this user
ALTER USER PEDRO_JOSE SET DISABLE_MFA = TRUE;

-- Allow MFA bypass for 24 hours (1440 minutes)
ALTER USER PEDRO_JOSE SET MINS_TO_BYPASS_MFA = 1440;

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Check user was created
DESCRIBE USER PEDRO_JOSE;

-- Check grants to user
SHOW GRANTS TO USER PEDRO_JOSE;

-- Check grants to role
SHOW GRANTS TO ROLE SNOWTELCO_V2_DEMO;

-- =====================================================
-- LOGIN INFORMATION
-- =====================================================
-- 
-- Login URL: https://app.snowflake.com
-- Username: PEDRO_JOSE
-- Password: snowflake2026
-- Default Agent: SnowTelco Executive Agent V2
-- 
-- To use the agent:
-- 1. Go to AI & ML > Snowflake Intelligence
-- 2. Select "SnowTelco Executive Agent V2"
-- 3. Ask questions like "What is our total revenue?"
-- =====================================================
