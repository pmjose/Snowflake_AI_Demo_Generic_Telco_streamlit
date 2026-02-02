-- ========================================================================
-- SnowTelco Demo - Step 7: Cortex Search Services
-- Creates document parsing and search services for unstructured data
-- Run time: ~5 minutes (batched processing for reliability)
-- Prerequisites: Run 01-06 scripts first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== CREATING CORTEX SEARCH SERVICES ===' AS status;

-- ========================================================================
-- UNSTRUCTURED DATA - Parse all document types in BATCHES
-- Processing in smaller batches to avoid Cortex service timeouts
-- ========================================================================

SELECT '=== PARSING PDF/DOCX/PPTX DOCUMENTS ===' AS status;

-- Parse structured documents (PDF, DOCX, PPTX) using PARSE_DOCUMENT
CREATE OR REPLACE TABLE parsed_content_docs AS 
SELECT 
    relative_path, 
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/%.pdf'
   OR relative_path ilike 'unstructured_docs/%.docx'
   OR relative_path ilike 'unstructured_docs/%.pptx';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 1 - finance) ===' AS status;

-- Parse Markdown files in batches by folder to avoid timeouts
-- Batch 1: Finance folder
CREATE OR REPLACE TABLE parsed_content_md AS
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/finance/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 2 - hr) ===' AS status;

-- Batch 2: HR folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/hr/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 3 - sales) ===' AS status;

-- Batch 3: Sales folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/sales/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 4 - marketing) ===' AS status;

-- Batch 4: Marketing folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/marketing/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 5 - strategy) ===' AS status;

-- Batch 5: Strategy folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/strategy/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 6 - network) ===' AS status;

-- Batch 6: Network folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/network/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 7 - demo) ===' AS status;

-- Batch 7: Demo folder
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/demo/%.md';

SELECT '=== PARSING MARKDOWN DOCUMENTS (BATCH 8 - remaining folders) ===' AS status;

-- Batch 8: Any remaining markdown files not in the above folders
INSERT INTO parsed_content_md
SELECT 
    relative_path,
    BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path) as file_url,
    TO_FILE(BUILD_STAGE_FILE_URL('@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE', relative_path)) as file_object,
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE,
        relative_path,
        {'mode':'LAYOUT'}
    ):content::string as content
FROM directory(@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE) 
WHERE relative_path ilike 'unstructured_docs/%.md'
  AND relative_path NOT ilike 'unstructured_docs/finance/%.md'
  AND relative_path NOT ilike 'unstructured_docs/hr/%.md'
  AND relative_path NOT ilike 'unstructured_docs/sales/%.md'
  AND relative_path NOT ilike 'unstructured_docs/marketing/%.md'
  AND relative_path NOT ilike 'unstructured_docs/strategy/%.md'
  AND relative_path NOT ilike 'unstructured_docs/network/%.md'
  AND relative_path NOT ilike 'unstructured_docs/demo/%.md';

SELECT '=== COMBINING ALL PARSED DOCUMENTS ===' AS status;

-- Combine all document types into unified parsed_content table
CREATE OR REPLACE TABLE parsed_content AS
SELECT relative_path, file_url, file_object, content FROM parsed_content_docs
UNION ALL
SELECT relative_path, file_url, file_object, content FROM parsed_content_md;
    
    -- Verify document counts by type
    SELECT 
        CASE 
            WHEN relative_path ILIKE '%.pdf' THEN 'PDF'
            WHEN relative_path ILIKE '%.docx' THEN 'DOCX'
            WHEN relative_path ILIKE '%.pptx' THEN 'PPTX'
            WHEN relative_path ILIKE '%.md' THEN 'Markdown'
            ELSE 'Other'
        END as file_type,
        COUNT(*) as file_count
    FROM parsed_content
    GROUP BY file_type
    ORDER BY file_count DESC;

--select *, GET_PATH(PARSE_JSON(content), 'content')::string as extracted_content from parsed_content;


    -- Switch to admin role for remaining operations
    USE ROLE SnowTelco_V2_Demo;

    -- Create search service for finance documents
    -- This enables semantic search over finance-related content
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_finance_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title, -- Extract filename as title
                content
            FROM parsed_content
            WHERE relative_path ilike '%/finance/%'
        );
    
    -- Create search service for HR documents
    -- This enables semantic search over HR-related content
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_hr_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/hr/%'
        );

    -- Create search service for marketing documents
    -- This enables semantic search over marketing-related content
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_marketing_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/marketing/%'
        );

    -- Create search service for sales documents
    -- This enables semantic search over sales-related content
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_sales_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/sales/%'
        );

    -- Create search service for strategy documents
    -- This enables semantic search over CEO/strategy-related content (UK Telecom)
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_strategy_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/strategy/%'
        );

    -- Create search service for demo scripts
    -- This enables semantic search over demo presentation materials
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_demo_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/demo/%'
        );

    -- Create search service for network infrastructure documents
    -- This enables semantic search over data center, network capacity, and platform uptime content
    CREATE OR REPLACE CORTEX SEARCH SERVICE Search_network_docs
        ON content
        ATTRIBUTES relative_path, file_url, title
        WAREHOUSE = SnowTelco_V2_Demo_WH
        TARGET_LAG = '30 day'
        EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
        AS (
            SELECT
                relative_path,
                file_url,
                REGEXP_SUBSTR(relative_path, '[^/]+$') as title,
                content
            FROM parsed_content
            WHERE relative_path ilike '%/network/%'
        );


use role snowtelco_demo;



-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT '=== CORTEX SEARCH SETUP COMPLETE ===' AS status;

-- Check search services
SHOW CORTEX SEARCH SERVICES IN SnowTelco_V2.SnowTelco_V2_SCHEMA;

SELECT 'Next step: Run 08_create_agent.sql' AS next_step;
