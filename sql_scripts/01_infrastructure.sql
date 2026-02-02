-- ========================================================================
-- SnowTelco Demo - Step 1: Infrastructure Setup
-- Creates database, schema, warehouse, roles, and network access
-- Run time: ~1 minute
-- ========================================================================

-- Switch to accountadmin role to create warehouse
USE ROLE accountadmin;

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

-- Grant usage on warehouse to admin role
GRANT USAGE ON WAREHOUSE SnowTelco_V2_Demo_WH TO ROLE SnowTelco_V2_Demo;

-- Alter current user's default role and warehouse to the ones used here
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_ROLE = SnowTelco_V2_Demo;
ALTER USER IDENTIFIER($current_user_name) SET DEFAULT_WAREHOUSE = SnowTelco_V2_Demo_WH;

-- Switch to SnowTelco_V2_Demo role to create demo objects
USE ROLE SnowTelco_V2_Demo;

-- Create database and schema
CREATE OR REPLACE DATABASE SnowTelco_V2;
USE DATABASE SnowTelco_V2;

CREATE SCHEMA IF NOT EXISTS SnowTelco_V2_SCHEMA;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- Create file format for CSV files
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

-- Create internal stage for data files
CREATE OR REPLACE STAGE INTERNAL_DATA_STAGE
    FILE_FORMAT = CSV_FORMAT
    COMMENT = 'Internal stage for demo data files'
    DIRECTORY = ( ENABLE = TRUE)
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- ========================================================================
-- GITHUB INTEGRATION - Network access for downloading data
-- ========================================================================

-- Switch to accountadmin for network rule and integration creation
USE ROLE ACCOUNTADMIN;

-- Grant accountadmin access to the database/schema for creating network rule
GRANT ALL PRIVILEGES ON DATABASE SnowTelco_V2 TO ROLE ACCOUNTADMIN;
GRANT ALL PRIVILEGES ON SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE ACCOUNTADMIN;

USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- Create network rule to allow GitHub access (in the schema)
CREATE OR REPLACE NETWORK RULE github_network_rule
    MODE = EGRESS
    TYPE = HOST_PORT
    VALUE_LIST = ('raw.githubusercontent.com:443');

-- Create external access integration for GitHub
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION github_access_integration
    ALLOWED_NETWORK_RULES = (SnowTelco_V2.SnowTelco_V2_SCHEMA.github_network_rule)
    ENABLED = TRUE
    COMMENT = 'Integration for downloading demo data from GitHub';

-- Grant usage on integration to demo role
GRANT USAGE ON INTEGRATION github_access_integration TO ROLE SnowTelco_V2_Demo;

-- Grant usage on network rule to demo role
GRANT USAGE ON NETWORK RULE SnowTelco_V2.SnowTelco_V2_SCHEMA.github_network_rule TO ROLE SnowTelco_V2_Demo;

-- Switch back to demo role
USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT '=== INFRASTRUCTURE SETUP COMPLETE ===' AS status;
SELECT 
    CURRENT_DATABASE() AS database_name,
    CURRENT_SCHEMA() AS schema_name,
    CURRENT_WAREHOUSE() AS warehouse_name,
    CURRENT_ROLE() AS current_role;

-- Test GitHub connectivity
CREATE OR REPLACE PROCEDURE test_github_connection()
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python', 'requests')
EXTERNAL_ACCESS_INTEGRATIONS = (github_access_integration)
HANDLER = 'test_connection'
AS
$$
import requests

def test_connection(session):
    test_url = "https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/README.md"
    try:
        response = requests.get(test_url, timeout=30)
        if response.status_code == 200:
            return f"SUCCESS: GitHub connection working. Status: {response.status_code}"
        else:
            return f"ERROR: GitHub returned status {response.status_code}"
    except Exception as e:
        return f"ERROR: {str(e)}"
$$;

SELECT '=== TESTING GITHUB CONNECTIVITY ===' AS status;
CALL test_github_connection();

SELECT '*** If GitHub test FAILED, check network rules before proceeding ***' AS warning;
SELECT 'Next step: Run 02_download_data.sql' AS next_step;
