-- ========================================================================
-- SnowTelco Demo - MASTER INSTALLATION SCRIPT
-- Runs all installation scripts directly from GitHub
-- Run time: ~20-30 minutes total
-- ========================================================================
-- 
-- INSTRUCTIONS:
-- 1. Run this script as ACCOUNTADMIN in Snowflake
-- 2. Scripts are fetched directly from GitHub (no file upload needed)
-- 3. Ensure your account has external network access enabled
--
-- REPOSITORY: https://github.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit
--
-- ========================================================================

USE ROLE ACCOUNTADMIN;

-- ========================================================================
-- SETUP: Network Access for GitHub
-- ========================================================================
SELECT '=== STEP 0: Setting up GitHub network access ===' AS status;

CREATE OR REPLACE NETWORK RULE github_install_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('raw.githubusercontent.com:443');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION github_install_integration
  ALLOWED_NETWORK_RULES = (github_install_rule)
  ENABLED = TRUE;

-- Set base URL variable for GitHub raw content
SET github_base = 'https://raw.githubusercontent.com/pmjose/Snowflake_AI_Demo_Generic_Telco_streamlit/main/sql_scripts';

SELECT '=== GitHub access configured successfully ===' AS status;

-- ========================================================================
-- CORE INSTALLATION (Required - Scripts 01-08)
-- ========================================================================
SELECT '=== STEP 1: Infrastructure Setup ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/01_infrastructure.sql';

SELECT '=== STEP 2: Downloading Data from GitHub ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/02_download_data.sql';

SELECT '=== STEP 3: Creating Tables ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/03_create_tables.sql';

SELECT '=== STEP 4: Loading Data ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/04_load_data.sql';

SELECT '=== STEP 5: Creating Semantic Views ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/05_semantic_views.sql';

SELECT '=== STEP 6: Creating Enhanced Semantic Views ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/06_enhanced_semantic_views.sql';

SELECT '=== STEP 7: Setting up Cortex Search ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/07_cortex_search.sql';

SELECT '=== STEP 8: Creating Intelligence Agent ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/08_create_agent.sql';

SELECT '=== CORE INSTALLATION COMPLETE ===' AS status;

-- ========================================================================
-- VALIDATION (Recommended - Script 09)
-- ========================================================================
SELECT '=== STEP 9: Validating Data Load ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/09_validate_data.sql';

-- ========================================================================
-- HISTORICAL DATA (Optional - Scripts 10-11, 13-14)
-- Adds 2024-2025 historical data for trend analysis
-- ========================================================================
SELECT '=== STEP 10: Loading 2025 Historical Data ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/10_load_2025_data.sql';

SELECT '=== STEP 11: Validating 2025 Data ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/11_validate_2025_data.sql';

SELECT '=== STEP 13: Loading 2024 Historical Data ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/13_load_2024_data.sql';

SELECT '=== STEP 14: Validating 2024 Data ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/14_validate_2024_data.sql';

-- ========================================================================
-- ENHANCEMENTS (Optional - Scripts 12, 15, 90)
-- ========================================================================
SELECT '=== STEP 12: Creating Demo User ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/12_create_demo_user.sql';

SELECT '=== STEP 15: Applying Data Enhancements ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/15_data_enhancements.sql';

SELECT '=== STEP 90: Adding Additional Semantic Views ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/90_semantic_views_additional.sql';

-- ========================================================================
-- TESTING (Optional - Script 91)
-- ========================================================================
SELECT '=== STEP 91: Testing Semantic Views ===' AS status;
EXECUTE IMMEDIATE FROM $github_base || '/91_test_semantic_views.sql';

-- ========================================================================
-- INSTALLATION COMPLETE
-- ========================================================================
SELECT '========================================' AS status;
SELECT '=== SNOWTELCO INSTALLATION COMPLETE ===' AS status;
SELECT '========================================' AS status;
SELECT 'Access Snowflake Intelligence to use the SnowTelco Executive Agent' AS next_step;
