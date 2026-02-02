-- ========================================================================
-- SnowTelco Demo - Step 2: Copy Data from Git to Internal Stage
-- Copies all data files from Git repository to internal stage
-- Run time: ~2-3 minutes
-- Prerequisites: Run 00_git_setup.sql and 01_infrastructure.sql first
-- 
-- NOTE: Snowflake doesn't support COPY INTO directly from Git repositories,
-- so we first copy files to an internal stage, then load from there.
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== COPYING DATA FILES FROM GIT TO INTERNAL STAGE ===' AS status;
SELECT '    This may take 2-3 minutes...' AS note;

-- ========================================================================
-- COPY CSV DATA FILES
-- ========================================================================

-- Copy main demo data CSV files
COPY FILES
  INTO @INTERNAL_DATA_STAGE/demo_data/
  FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/
  PATTERN = '.*\.csv';

-- ========================================================================
-- COPY ADDITIONAL DATA (2024, 2025 historical data)
-- ========================================================================

-- Copy 2025 additional data
COPY FILES
  INTO @INTERNAL_DATA_STAGE/additional_data/2025/
  FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/additional_data/2025/
  PATTERN = '.*\.csv';

-- Copy 2024 additional data
COPY FILES
  INTO @INTERNAL_DATA_STAGE/additional_data/2024/
  FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/demo_data/additional_data/2024/
  PATTERN = '.*\.csv';

-- ========================================================================
-- COPY UNSTRUCTURED DOCUMENTS (for RAG/Document AI)
-- ========================================================================

-- Copy markdown documents
COPY FILES
  INTO @INTERNAL_DATA_STAGE/unstructured_docs/
  FROM @snowtelco_repo/branches/main/Snowflake_AI_Demo_Generic_Telco/unstructured_docs/
  PATTERN = '.*\.md';

-- ========================================================================
-- VERIFICATION - Combined into single result
-- ========================================================================

-- Refresh directory metadata
ALTER STAGE INTERNAL_DATA_STAGE REFRESH;

-- Show file counts by folder with next step
SELECT 
    COALESCE(SPLIT_PART(RELATIVE_PATH, '/', 1), 'TOTAL') AS folder,
    COUNT(*) AS file_count,
    ROUND(SUM(SIZE)/1024/1024, 2) AS size_mb,
    'NEXT: Run 03_create_tables.sql' AS next_step
FROM DIRECTORY(@INTERNAL_DATA_STAGE)
GROUP BY ROLLUP(SPLIT_PART(RELATIVE_PATH, '/', 1))
ORDER BY file_count DESC;
