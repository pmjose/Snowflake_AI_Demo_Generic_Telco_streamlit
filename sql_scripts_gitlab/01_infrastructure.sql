-- ========================================================================
-- SnowTelco Demo - Step 1: Infrastructure Setup
-- Creates warehouse, roles, and file formats
-- Run time: ~1 minute
-- Prerequisites: Run 00_git_setup.sql first
-- 
-- NOTE: Data loads directly from Git repository stage - no intermediate
-- copy step required! This is faster and avoids data duplication.
-- ========================================================================

-- Switch to accountadmin role
USE ROLE ACCOUNTADMIN;

-- Enable Snowflake Intelligence by creating the Config DB & Schema
CREATE DATABASE IF NOT EXISTS snowflake_intelligence;
CREATE SCHEMA IF NOT EXISTS snowflake_intelligence.agents;

-- Allow anyone to see the agents in this schema
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

-- Create demo role
CREATE OR REPLACE ROLE SnowTelco_V2_Demo;

SET current_user_name = CURRENT_USER();

-- Grant the role to current user
GRANT ROLE SnowTelco_V2_Demo TO USER IDENTIFIER($current_user_name);
GRANT CREATE DATABASE ON ACCOUNT TO ROLE SnowTelco_V2_Demo;

-- Create a dedicated warehouse for the demo with auto-suspend/resume
CREATE OR REPLACE WAREHOUSE SnowTelco_V2_Demo_WH 
    WITH WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;

-- Grant usage on warehouse to demo role
GRANT USAGE ON WAREHOUSE SnowTelco_V2_Demo_WH TO ROLE SnowTelco_V2_Demo;

-- Grant privileges on database and schema to demo role (created in 00_git_setup.sql)
GRANT USAGE, CREATE SCHEMA ON DATABASE SnowTelco_V2 TO ROLE SnowTelco_V2_Demo;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE SEMANTIC VIEW, CREATE STAGE, CREATE FILE FORMAT, CREATE FUNCTION, CREATE PROCEDURE, CREATE CORTEX SEARCH SERVICE, CREATE NETWORK RULE ON SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE SnowTelco_V2_Demo;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE SnowTelco_V2_Demo;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE SnowTelco_V2_Demo;
GRANT USAGE ON ALL SECRETS IN SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE SnowTelco_V2_Demo;

-- Grant usage on Git repository to demo role
GRANT USAGE ON GIT REPOSITORY SnowTelco_V2.SnowTelco_V2_SCHEMA.snowtelco_repo TO ROLE SnowTelco_V2_Demo;

-- Grant usage on API integration
GRANT USAGE ON INTEGRATION gitlab_api_integration TO ROLE SnowTelco_V2_Demo;

-- Alter current user's default role and warehouse to the ones used here
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_ROLE = SnowTelco_V2_Demo;
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_WAREHOUSE = SnowTelco_V2_Demo_WH;

-- Stay as ACCOUNTADMIN to create file format, then grant
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- Create file format for CSV files (used when loading from Git repo)
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    ESCAPE = 'NONE'
    ESCAPE_UNENCLOSED_FIELD = '\134'
    DATE_FORMAT = 'YYYY-MM-DD'
    TIMESTAMP_FORMAT = 'AUTO'
    NULL_IF = ('NULL', 'null', '', 'N/A', 'n/a');

-- Grant usage on file format to demo role
GRANT USAGE ON FILE FORMAT SnowTelco_V2.SnowTelco_V2_SCHEMA.CSV_FORMAT TO ROLE SnowTelco_V2_Demo;

-- Switch back to demo role
USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- ========================================================================
-- VERIFICATION - Combined into single result
-- ========================================================================

SELECT 
    'INFRASTRUCTURE SETUP COMPLETE' AS status,
    CURRENT_DATABASE() AS database_name,
    CURRENT_SCHEMA() AS schema_name,
    CURRENT_WAREHOUSE() AS warehouse_name,
    CURRENT_ROLE() AS current_role,
    'NEXT: Run 02_copy_data_from_git.sql' AS next_step;
