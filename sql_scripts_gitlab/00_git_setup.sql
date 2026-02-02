-- ========================================================================
-- SnowTelco Demo - Step 0: GitLab Repository Setup
-- Sets up Snowflake Git Integration to access demo files directly from GitLab
-- Run time: ~1 minute
-- Prerequisites: GitLab Personal Access Token (PAT) with read_repository scope
-- ========================================================================

USE ROLE ACCOUNTADMIN;

-- ========================================================================
-- STEP 1: CREATE DATABASE AND SCHEMA
-- ========================================================================

CREATE DATABASE IF NOT EXISTS SnowTelco_V2;
CREATE SCHEMA IF NOT EXISTS SnowTelco_V2.SnowTelco_V2_SCHEMA;

USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- ========================================================================
-- STEP 2: CREATE GITLAB CREDENTIALS SECRET
-- ========================================================================
-- To get a Personal Access Token (PAT):
-- 1. Go to: https://snow.gitlab-dedicated.com/-/user_settings/personal_access_tokens
-- 2. Click "Add new token"
-- 3. Name: "Snowflake Git Access", Scopes: check "read_repository"
-- 4. Click "Create personal access token" and copy the token
-- 5. Replace <YOUR_GITLAB_USERNAME> and <YOUR_PERSONAL_ACCESS_TOKEN> below

CREATE OR REPLACE SECRET SnowTelco_V2.SnowTelco_V2_SCHEMA.gitlab_secret
  TYPE = password
  USERNAME = 'pedro.jose'  -- Replace with your GitLab username
  PASSWORD = 'glpat-Ce0sgCRusXBmi25EUmMxlG86MQp1OjRscwk.01.0z0h86jj6';  -- Replace with your PAT

-- ========================================================================
-- STEP 3: CREATE API INTEGRATION FOR GITLAB
-- ========================================================================

CREATE OR REPLACE API INTEGRATION gitlab_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://snow.gitlab-dedicated.com/')
  ALLOWED_AUTHENTICATION_SECRETS = (SnowTelco_V2.SnowTelco_V2_SCHEMA.gitlab_secret)
  ENABLED = TRUE
  COMMENT = 'API Integration for Snowflake GitLab access';

-- ========================================================================
-- STEP 4: CREATE GIT REPOSITORY CLONE
-- ========================================================================

CREATE OR REPLACE GIT REPOSITORY SnowTelco_V2.SnowTelco_V2_SCHEMA.snowtelco_repo
  API_INTEGRATION = gitlab_api_integration
  GIT_CREDENTIALS = SnowTelco_V2.SnowTelco_V2_SCHEMA.gitlab_secret
  ORIGIN = 'https://snow.gitlab-dedicated.com/snowflakecorp/SE/sales-engineering/pj-customer_demos.git'
  COMMENT = 'SnowTelco Demo repository from GitLab';

-- ========================================================================
-- STEP 5: FETCH LATEST FROM REMOTE
-- ========================================================================

ALTER GIT REPOSITORY SnowTelco_V2.SnowTelco_V2_SCHEMA.snowtelco_repo FETCH;

-- ========================================================================
-- VERIFICATION - Combined into single result
-- ========================================================================

SELECT 
    'GIT REPOSITORY SETUP COMPLETE' AS status,
    'snowtelco_repo' AS repository,
    'NEXT: Run 01_infrastructure.sql' AS next_step
UNION ALL
SELECT 'Files available:', 'sql_scripts_gitlab/', 'Use: LS @snowtelco_repo/branches/main/...';
