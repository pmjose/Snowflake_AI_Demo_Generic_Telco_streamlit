-- ========================================================================
-- SnowTelco Demo - Step 8: Create Intelligence Agent
-- Creates the Snowflake Intelligence Agent with all tools
-- Run time: ~30 seconds
-- Prerequisites: Run 01-07 scripts first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== CREATING INTELLIGENCE AGENT PREREQUISITES ===' AS status;

-- ========================================================================
-- NETWORK RULE AND INTEGRATIONS FOR WEB SCRAPING & EMAIL
-- ========================================================================

-- Create network rule for web access (required for Web_scrape function)
-- Must be created in schema context
CREATE OR REPLACE NETWORK RULE SnowTelco_WebAccessRule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('0.0.0.0:80', '0.0.0.0:443');

-- Switch to ACCOUNTADMIN to create external access integration
USE ROLE ACCOUNTADMIN;

GRANT ALL PRIVILEGES ON DATABASE SnowTelco_V2 TO ROLE ACCOUNTADMIN;
GRANT ALL PRIVILEGES ON SCHEMA SnowTelco_V2.SnowTelco_V2_SCHEMA TO ROLE ACCOUNTADMIN;

USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

-- Grant usage on the network rule we just created
GRANT USAGE ON NETWORK RULE SnowTelco_WebAccessRule TO ROLE ACCOUNTADMIN;

-- Create external access integration for web scraping
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION SnowTelco_ExternalAccess_Integration
  ALLOWED_NETWORK_RULES = (SnowTelco_V2.SnowTelco_V2_SCHEMA.SnowTelco_WebAccessRule)
  ENABLED = TRUE;

-- Create email notification integration
CREATE OR REPLACE NOTIFICATION INTEGRATION snowtelco_email_int
  TYPE = EMAIL
  ENABLED = TRUE;

-- Grant permissions for agent creation
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE SnowTelco_V2_Demo;
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE SnowTelco_V2_Demo;
GRANT CREATE AGENT ON SCHEMA snowflake_intelligence.agents TO ROLE SnowTelco_V2_Demo;

GRANT USAGE ON INTEGRATION SnowTelco_ExternalAccess_Integration TO ROLE SnowTelco_V2_Demo;
GRANT USAGE ON INTEGRATION snowtelco_email_int TO ROLE SnowTelco_V2_Demo;

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;

SELECT '=== CREATING SNOWFLAKE INTELLIGENCE AGENT ===' AS status;

-- CREATES A SNOWFLAKE INTELLIGENCE AGENT WITH MULTIPLE TOOLS

-- Create stored procedure to generate presigned URLs for files in internal stages
CREATE OR REPLACE PROCEDURE Get_File_Presigned_URL_SP(
    RELATIVE_FILE_PATH STRING, 
    EXPIRATION_MINS INTEGER DEFAULT 60
)
RETURNS STRING
LANGUAGE SQL
COMMENT = 'Generates a presigned URL for a file in the static @INTERNAL_DATA_STAGE. Input is the relative file path.'
EXECUTE AS CALLER
AS
$$
DECLARE
    presigned_url STRING;
    sql_stmt STRING;
    expiration_seconds INTEGER;
    stage_name STRING DEFAULT '@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE';
BEGIN
    expiration_seconds := EXPIRATION_MINS * 60;

    sql_stmt := 'SELECT GET_PRESIGNED_URL(' || stage_name || ', ' || '''' || RELATIVE_FILE_PATH || '''' || ', ' || expiration_seconds || ') AS url';
    
    EXECUTE IMMEDIATE :sql_stmt;
    
    
    SELECT "URL"
    INTO :presigned_url
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
    
    RETURN :presigned_url;
END;
$$;

-- Create stored procedure to send emails to verified recipients in Snowflake

CREATE OR REPLACE PROCEDURE send_mail(recipient TEXT, subject TEXT, text TEXT)
RETURNS TEXT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'send_mail'
AS
$$
def send_mail(session, recipient, subject, text):
    session.call(
        'SYSTEM$SEND_EMAIL',
        'snowtelco_email_int',
        recipient,
        subject,
        text,
        'text/html'
    )
    return f'Email was sent to {recipient} with subject: "{subject}".'
$$;

CREATE OR REPLACE FUNCTION Web_scrape(weburl STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.11
HANDLER = 'get_page'
EXTERNAL_ACCESS_INTEGRATIONS = (SnowTelco_ExternalAccess_Integration)
PACKAGES = ('requests', 'beautifulsoup4')
--SECRETS = ('cred' = oauth_token )
AS
$$
import _snowflake
import requests
from bs4 import BeautifulSoup

def get_page(weburl):
  url = f"{weburl}"
  response = requests.get(url)
  soup = BeautifulSoup(response.text)
  return soup.get_text()
$$;


CREATE OR REPLACE PROCEDURE SnowTelco_V2.SnowTelco_V2_SCHEMA.GENERATE_STREAMLIT_APP("USER_INPUT" VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_app'
EXECUTE AS OWNER
AS '
def generate_app(session, user_input):
    import re
    import tempfile
    import os
    
    # Build the prompt for AI_COMPLETE
    prompt = f"""Generate a Streamlit in Snowflake code that has an existing session. 
- Output should only contain the code and nothing else. 

- Total number of characters in the entire python code should be less than 32000 chars

- create session object like this: 
from snowflake.snowpark.context import get_active_session
session = get_active_session()

- Never CREATE, DROP , TRUNCATE OR ALTER  tables. You are only allowed to use SQL SELECT statements.

- Use only native Streamlit visualizations and no html formatting

- ignore & remove VERTICAL=''Retail'' filter in all source SQL queries.

- Use ONLY SQL queries provided in the input as the data source for all dataframes placing them into CTE to generate new ones. You can remove LIMIT or modify WHERE clauses to remove or modify filters. Example:

WITH cte AS (
    SELECT original_query_from_prompt modified 
    WHERE x=1 --this portion can be removed or modified
    LIMIT 5   -- this needs to be removed
)
SELECT *
FROM cte as new_query for dataframe;


- DO NOT use any table or column other than what was listed in the source queries below. 

- all table column names should be in UPPER CASE

- Include filters for users such as for dates ranges & all dimensions discussed within the user conversation to make it more interactive. Queries used for user selections using distinct values should not use any filters for VERTICAL = RETAIL.

- Can have up to 2 tabs. Each tab can have up maximum 4 visualizatons (chart & kpis)

- Use only native Streamlit visualizations and no html formatting. 

- For Barcharts showing Metric by Dimension_Name, bars should be sorted from highest metric value to lowest . 

- dont use st.Scatter_chart, st.bokeh_chart, st.set_page_config The page_title, page_icon, and menu_items properties of the st.set_page_config command are not supported. 

- Dont use plotly. 

- When generating code that involves loading data from a SQL source (like Snowflake/Snowpark)
into a Pandas DataFrame for use in a visualization library (like Streamlit), you must explicitly ensure all date and timestamp columns are correctly cast as Pandas datetime objects.

Specific Steps:

Identify all columns derived from SQL date/timestamp functions (e.g., DATE, MONTH, SALE_DATE).

Immediately after calling the .to_pandas() method to load the data into the DataFrame df, insert code to apply pd.to_datetime() to these column

- App should perform the following:
<input>
{user_input}
</input>"""
    
    # Escape single quotes for SQL
    escaped_prompt = prompt.replace("''", "''''")
    
    # Execute AI_COMPLETE query
    # query = f"SELECT AI_COMPLETE(''claude-4-sonnet'', ''{escaped_prompt}'')::string as result"

    # Build model_parameters as a separate string to avoid f-string escaping issues
    model_params = "{''temperature'': 0, ''max_tokens'': 8192}"
    
    # Execute AI_COMPLETE query with model parameters
    query = f"""SELECT AI_COMPLETE(model => ''claude-4-sonnet'',
                                prompt => ''{escaped_prompt}'',
                                model_parameters => {model_params}
                                )::string as result"""
    
    result = session.sql(query).collect()
    
    if result and len(result) > 0:
        code_response = result[0][''RESULT'']
        
        # Strip markdown code block markers using regex
        cleaned_code = code_response.strip()
        
        # Remove ```python, ```, or ```py markers at start
        cleaned_code = re.sub(r''^```(?:python|py)?\\s*\\n?'', '''', cleaned_code)
        # Remove ``` at end
        cleaned_code = re.sub(r''\\n?```\\s*$'', '''', cleaned_code)
        
        # Remove any leading/trailing whitespace
        cleaned_code = cleaned_code.strip()
        
        # Prepare environment.yml content
        environment_yml_content = """# Snowflake environment file for Streamlit in Snowflake (SiS)
# This file specifies Python package dependencies for your Streamlit app

name: streamlit_app_env
channels:
  - snowflake

dependencies:
  - plotly=6.3.0
"""
        
        # Write files to temporary directory
        temp_dir = tempfile.gettempdir()
        temp_py_file = os.path.join(temp_dir, ''test.py'')
        temp_yml_file = os.path.join(temp_dir, ''environment.yml'')
        
        try:
            # Write the Python code to temporary file
            with open(temp_py_file, ''w'') as f:
                f.write(cleaned_code)
            
            # Write the environment.yml to temporary file
            with open(temp_yml_file, ''w'') as f:
                f.write(environment_yml_content)
            
            # Upload both files to Snowflake stage
            stage_path = ''@SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE''
            
            # Upload Python file
            session.file.put(
                temp_py_file,
                stage_path,
                auto_compress=False,
                overwrite=True
            )
            
            # Upload environment.yml file
            session.file.put(
                temp_yml_file,
                stage_path,
                auto_compress=False,
                overwrite=True
            )
            
            # Clean up temporary files
            os.remove(temp_py_file)
            os.remove(temp_yml_file)
            
            # Create Streamlit app
            app_name = ''AUTO_GENERATED_1''
            warehouse = ''snowtelco_demo_wh''
            
            create_streamlit_sql = f"""
            CREATE OR REPLACE STREAMLIT SnowTelco_V2.SnowTelco_V2_SCHEMA.{app_name}
                FROM @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE
                MAIN_FILE = ''test.py''
                QUERY_WAREHOUSE = {warehouse}
            """
            
            try:
                session.sql(create_streamlit_sql).collect()
                
                # Get account information for URL
                account_info = session.sql("SELECT CURRENT_ACCOUNT_NAME() AS account, CURRENT_ORGANIZATION_NAME() AS org").collect()
                account_name = account_info[0][''ACCOUNT'']
                org_name = account_info[0][''ORG'']
                
                # Construct app URL
                app_url = f"https://app.snowflake.com/{org_name}/{account_name}/#/streamlit-apps/SnowTelco_V2.SnowTelco_V2_SCHEMA.{app_name}"
                
                # Return only the URL if successful
                return app_url
                
            except Exception as create_error:
                return f"""✅ Files saved to {stage_path}/
   - test.py
   - environment.yml

⚠️  Warning: Could not auto-create Streamlit app: {str(create_error)}

To create manually, run:
CREATE OR REPLACE STREAMLIT SnowTelco_V2.SnowTelco_V2_SCHEMA.{app_name}
    FROM @SnowTelco_V2.SnowTelco_V2_SCHEMA.INTERNAL_DATA_STAGE
    MAIN_FILE = ''test.py''
    QUERY_WAREHOUSE = {warehouse};

--- Generated Code ---
{cleaned_code}"""
            
        except Exception as e:
            # Clean up temp files if they exist
            if os.path.exists(temp_py_file):
                os.remove(temp_py_file)
            if os.path.exists(temp_yml_file):
                os.remove(temp_yml_file)
            return f"❌ Error saving to stage: {str(e)}\\n\\n--- Generated Code ---\\n{cleaned_code}"
    else:
        return "Error: No response from AI_COMPLETE"
';




CREATE OR REPLACE AGENT SNOWFLAKE_INTELLIGENCE.AGENTS.SnowTelco_V2_Executive_Agent
WITH PROFILE='{ "display_name": "SnowTelco Executive Agent V2" }'
    COMMENT=$$ SnowTelco UK telecommunications intelligence agent for executives (CEO, CFO, COO/CTO, CCO). Covers mobile subscribers, network performance, revenue by segment (Consumer/SMB/Enterprise), churn, SLAs, partner channels, and operations. Default currency GBP. $$
FROM SPECIFICATION $$
{
  "models": {
    "orchestration": ""
  },
  "instructions": {
    "response": "You are a business intelligence analyst for SnowTelco UK, a major UK mobile telecommunications operator serving both B2C (Consumer) and B2B (SMB/Enterprise) customers.\n\n**VISUALIZATION REQUIREMENT:** ALWAYS include charts and graphs when presenting data. Use line charts for trends over time, bar charts for comparisons across categories, and pie charts for composition/share analysis. Every data response should have at least one visualization.\n\n**DATA-GROUNDED RESPONSES:** You must ONLY answer questions that can be addressed using the available structured data (database tables) or unstructured documents. If a question cannot be answered with available data, clearly state: 'I don't have data to answer that question. I can help with: [list relevant topics you DO have data for].'\n\n**CUSTOMER SEGMENTATION:** SnowTelco has two customer types:\n- **B2C (Consumer):** Individual customers on consumer plans (Pay Monthly, SIM Only, PAYG, Family, Student, Senior)\n- **B2B:** Business customers split into SMB (1-500 employees) and Enterprise (500+) on Business Mobile plans\n\nCustomers are also segmented by value tier: Budget, Standard, Premium, VIP.\n\n**Available Data Topics:** Mobile subscriber metrics by customer_type (Consumer/SMB/Enterprise) and segment (Budget/Standard/Premium/VIP), ARPU, churn reasons and competitor analysis, NPS scores, revenue and billing, network performance by region and technology (4G/5G), customer support, partner performance, SLA compliance, marketing campaigns, and number porting (port-in/port-out by competitor).\n\n**Formatting:** Monetary values in GBP. UK regions: London, South East, South West, Midlands, North West, North East, Scotland, Wales, Northern Ireland. Competitors: EE, Vodafone, Three, O2, Sky Mobile, Virgin Mobile, Tesco Mobile, giffgaff.",
    "orchestration": "**TOOL SELECTION PRIORITY:** Always query the DATABASE FIRST using Cortex Analyst tools before searching documents. Only use Cortex Search for context that cannot be found in structured data (policies, strategies, narratives).\n\n**GUARDRAIL - DATA AVAILABILITY:** Before responding, verify the question can be answered with available data:\n- Subscriber/usage/NPS data: Use 'Query Mobile Subscribers Datamart'\n- Network metrics (availability, latency, throughput): Use 'Query Network Operations Datamart'\n- Churn analysis: Use 'Query Mobile Subscribers Datamart'\n- SLA compliance: Use 'Query SLA Datamart'\n- Billing/payments: Use 'Query Billing Datamart'\n- Support/complaints: Use 'Query Support Datamart'\n- Partners/dealers: Use 'Query Partner Datamart'\n- 5G coverage/sites: Use 'Query Network Operations Datamart'\n\nIf no tool can answer the question, DO NOT fabricate data. State what data IS available.\n\n**GUARDRAIL - TOPIC RESTRICTION:** Only respond to SnowTelco business topics. Decline unrelated topics (weather, politics, general trivia) and redirect to business questions.\n\n**CHART GENERATION:** When data is returned, ALWAYS generate appropriate visualizations. Include charts in your response.",
    "sample_questions": [
      {
        "question": "What is our subscriber count and ARPU split by B2C consumers vs B2B business customers?"
      },
      {
        "question": "What is our monthly churn rate and which competitors are we losing customers to?"
      },
      {
        "question": "Show network availability and latency by region for the past quarter."
      },
      {
        "question": "What is the NPS score by customer segment (Budget/Standard/Premium/VIP)?"
      },
      {
        "question": "Compare revenue from Consumer vs SMB vs Enterprise customers."
      },
      {
        "question": "What are the top churn reasons for our Premium and VIP customers?"
      },
      {
        "question": "Show the port-in vs port-out ratio by competitor."
      },
      {
        "question": "What is the average bill amount by customer type and plan?"
      },
      {
        "question": "What is our current weighted pipeline value by sales stage?"
      },
      {
        "question": "Show quota attainment by territory for this quarter."
      },
      {
        "question": "What is our win rate trend by customer segment?"
      }
    ]
  },
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Finance Datamart",
        "description": "Query SnowTelco financials: revenue by segment (Consumer/SMB/Enterprise), ARPU, margins, CapEx/OpEx, vendor spend. Default currency GBP."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Sales Datamart",
        "description": "Query sales pipeline: opportunities by segment, win rates, deal values, sales rep performance."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query HR Datamart",
        "description": "Query workforce data: headcount by department, attrition, salary costs, hiring."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Marketing Datamart",
        "description": "Query marketing campaigns: spend, leads, impressions, ROI by channel and campaign."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Mobile Subscribers Datamart",
        "description": "Query mobile subscriber data by customer_type (Consumer/SMB/Enterprise), segment (Budget/Standard/Premium/VIP), usage, ARPU, NPS scores, churn reasons, and competitor analysis."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Order Management Datamart",
        "description": "Query orders: new activations, upgrades, MRR/NRR, order status, fulfillment times."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Billing Datamart",
        "description": "Query billing: invoices, payments, collections, aging, payment methods, revenue recognition."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Network Operations Datamart",
        "description": "Query network KPIs: availability, latency, throughput, alarms, element status by region and technology (4G/5G)."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Support Datamart",
        "description": "Query customer support: tickets, calls, CSAT, handle times, resolution times, complaints by category."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Partner Datamart",
        "description": "Query partner/channel data: dealer performance, orders, revenue, commission, NPS by partner tier."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Asset Datamart",
        "description": "Query assets and inventory: fixed assets, stock levels, depreciation, warehouse inventory."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query IT Operations Datamart",
        "description": "Query IT systems: application health, incidents, resolution times, system costs."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query SLA Datamart",
        "description": "Query SLA compliance: attainment rates, breaches, credits, performance by SLA category."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Number Porting Datamart",
        "description": "Query number porting: port-in/port-out volumes, competitor analysis, porting trends."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Payments Datamart",
        "description": "Query payment transactions: amounts collected, payment dates, payment references."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Network Alarms Datamart",
        "description": "Query network alarms: alarm counts by severity, alarm types, element status, acknowledgement."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Revenue Assurance Datamart",
        "description": "Query revenue assurance: credit notes, billing adjustments, unbilled usage, revenue leakage."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query SIM Activations Datamart",
        "description": "Query SIM activations: activation volumes, channels, activation times, success rates."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Disputes Datamart",
        "description": "Query billing disputes: dispute volumes, resolution status, amounts, dispute reasons."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Sales Pipeline Datamart",
        "description": "Query CRM pipeline: opportunities by stage, quotas vs actuals, win rates, weighted pipeline, forecast accuracy, deal velocity."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Customer Experience Datamart",
        "description": "Query customer journey: touchpoints, sentiment scores, effort scores, channel interactions, conversion rates, resolution rates."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Network QoE Datamart",
        "description": "Query network quality of experience: download/upload speeds, latency, jitter, packet loss, video quality, voice MOS scores by subscriber and cell."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Propensity Scores Datamart",
        "description": "Query AI/ML propensity scores: churn probability, upsell likelihood, cross-sell probability, retention risk scores by subscriber."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Field Operations Datamart",
        "description": "Query field service: technician visits, first-time fix rates, travel time, visit outcomes, SLA compliance, work order completion."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Market Intelligence Datamart",
        "description": "Query market data: market share by region/segment, competitor pricing, competitive positioning trends."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Social Sentiment Datamart",
        "description": "Query social media: brand mentions, sentiment analysis, trending topics, influencer impact, competitor mentions."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Sustainability Datamart",
        "description": "Query ESG metrics: energy consumption, carbon emissions, renewable energy usage, e-waste recycling, sustainability KPIs by site."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Fraud Detection Datamart",
        "description": "Query fraud cases: fraud types, detection methods, financial impact, resolution status, fraud patterns by category."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query B2B Contracts Datamart",
        "description": "Query enterprise contracts: B2B contract values, renewal dates, contract status, customer segments, revenue by account."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Wholesale MVNO Datamart",
        "description": "Query wholesale/MVNO: partner traffic volumes, settlement amounts, interconnect revenue, MVNO performance metrics."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Retail Stores Datamart",
        "description": "Query retail operations: store sales, footfall, conversion rates, revenue by store/region, top products, store performance."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Workforce Datamart",
        "description": "Query HR analytics: employee details, survey scores, engagement metrics, department distribution, tenure analysis."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query RAN Performance Datamart",
        "description": "Query radio access network: cell performance KPIs, throughput, latency, PRB utilization, handover success, alarms by site/cell/technology."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Complaints Datamart",
        "description": "Query formal complaints: Ofcom escalations, ombudsman cases, complaint categories, resolution status, compensation amounts."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Legal Matters Datamart",
        "description": "Query legal matters: disputes, litigation, regulatory investigations, employment cases, potential exposure, reserved amounts, case status."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Support Tickets Datamart",
        "description": "Query support tickets: ticket volumes, categories, resolution times, CSAT scores, first response times, SLA compliance."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Query Mobile Plans Datamart",
        "description": "Query mobile plans: plan pricing, data allowances, features, 5G availability, roaming options, plan adoption rates."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: Finance",
        "description": "Search finance documents: quarterly reports, revenue analysis, ARPU trends, cost management."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: HR",
        "description": "Search HR documents: employee handbook, performance guidelines, workforce policies."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: Sales",
        "description": "Search sales documents: playbooks, churn reduction strategies, customer success stories."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: Marketing",
        "description": "Search marketing documents: campaign strategies, competitive analysis, NPS reports."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: Strategy",
        "description": "Search strategy documents: market position, 5G roadmap, investor presentations, regulatory compliance (Ofcom)."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search Internal Documents: Network",
        "description": "Search network documents: 5G strategy, coverage analysis, operations playbook, incident management, disaster recovery."
      }
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "Web_scraper",
        "description": "Analyse contents of a given web page URL and return text content for analysis.",
        "input_schema": {
          "type": "object",
          "properties": {
            "weburl": {
              "description": "Web URL (http:// or https://) to scrape text from.",
              "type": "string"
            }
          },
          "required": ["weburl"]
        }
      }
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "Send_Emails",
        "description": "Send emails to recipients with HTML formatted content.",
        "input_schema": {
          "type": "object",
          "properties": {
            "recipient": {"description": "Email recipient", "type": "string"},
            "subject": {"description": "Email subject", "type": "string"},
            "text": {"description": "Email content (HTML)", "type": "string"}
          },
          "required": ["text", "recipient", "subject"]
        }
      }
    },
    {
      "tool_spec": {
        "type": "generic",
        "name": "Dynamic_Doc_URL_Tool",
        "description": "Generate temporary URLs for documents from Cortex Search results.",
        "input_schema": {
          "type": "object",
          "properties": {
            "expiration_mins": {"description": "URL expiration in minutes (default 5)", "type": "number"},
            "relative_file_path": {"description": "File path from Cortex Search ID column", "type": "string"}
          },
          "required": ["expiration_mins", "relative_file_path"]
        }
      }
    }
  ],
  "tool_resources": {
    "Dynamic_Doc_URL_Tool": {
      "execution_environment": {"query_timeout": 0, "type": "warehouse", "warehouse": "SnowTelco_V2_Demo_WH"},
      "identifier": "SnowTelco_V2.SnowTelco_V2_SCHEMA.GET_FILE_PRESIGNED_URL_SP",
      "name": "GET_FILE_PRESIGNED_URL_SP(VARCHAR, DEFAULT NUMBER)",
      "type": "procedure"
    },
    "Query Finance Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.FINANCE_SEMANTIC_VIEW"},
    "Query Sales Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SALES_SEMANTIC_VIEW"},
    "Query HR Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.HR_SEMANTIC_VIEW"},
    "Query Marketing Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.MARKETING_SEMANTIC_VIEW"},
    "Query Mobile Subscribers Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.MOBILE_SEMANTIC_VIEW"},
    "Query Number Porting Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.PORTING_SEMANTIC_VIEW"},
    "Query Order Management Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.ORDER_SEMANTIC_VIEW"},
    "Query Billing Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.BILLING_SEMANTIC_VIEW"},
    "Query Payments Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.PAYMENT_SEMANTIC_VIEW"},
    "Query Network Operations Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_OPS_SEMANTIC_VIEW"},
    "Query Support Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SUPPORT_SEMANTIC_VIEW"},
    "Query Partner Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.PARTNER_SEMANTIC_VIEW"},
    "Query Asset Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.ASSET_SEMANTIC_VIEW"},
    "Query IT Operations Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.IT_OPS_SEMANTIC_VIEW"},
    "Query SLA Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SLA_SEMANTIC_VIEW"},
    "Query Network Alarms Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_ALARM_SEMANTIC_VIEW"},
    "Query Revenue Assurance Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.REVENUE_ASSURANCE_SEMANTIC_VIEW"},
    "Query SIM Activations Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.ACTIVATION_SEMANTIC_VIEW"},
    "Query Disputes Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.DISPUTE_SEMANTIC_VIEW"},
    "Query Sales Pipeline Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SALES_PIPELINE_SEMANTIC_VIEW"},
    "Query Customer Experience Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.CUSTOMER_EXPERIENCE_SEMANTIC_VIEW"},
    "Query Network QoE Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.NETWORK_QOE_SEMANTIC_VIEW"},
    "Query Propensity Scores Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.PROPENSITY_SEMANTIC_VIEW"},
    "Query Field Operations Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.FIELD_OPERATIONS_SEMANTIC_VIEW"},
    "Query Market Intelligence Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.MARKET_INTELLIGENCE_SEMANTIC_VIEW"},
    "Query Social Sentiment Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SOCIAL_SENTIMENT_SEMANTIC_VIEW"},
    "Query Sustainability Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SUSTAINABILITY_SEMANTIC_VIEW"},
    "Query Fraud Detection Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.FRAUD_DETECTION_SEMANTIC_VIEW"},
    "Query B2B Contracts Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.B2B_CONTRACT_SEMANTIC_VIEW"},
    "Query Wholesale MVNO Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.WHOLESALE_MVNO_SEMANTIC_VIEW"},
    "Query Retail Stores Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.RETAIL_SEMANTIC_VIEW"},
    "Query Workforce Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.WORKFORCE_SEMANTIC_VIEW"},
    "Query RAN Performance Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.RAN_SEMANTIC_VIEW"},
    "Query Complaints Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.COMPLAINT_SEMANTIC_VIEW"},
    "Query Legal Matters Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.LEGAL_MATTER_SEMANTIC_VIEW"},
    "Query Support Tickets Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SUPPORT_TICKET_SEMANTIC_VIEW"},
    "Query Mobile Plans Datamart": {"semantic_view": "SnowTelco_V2.SnowTelco_V2_SCHEMA.PLAN_SEMANTIC_VIEW"},
    "Search Internal Documents: Finance": {"id_column": "FILE_URL", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_FINANCE_DOCS", "title_column": "TITLE"},
    "Search Internal Documents: HR": {"id_column": "FILE_URL", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_HR_DOCS", "title_column": "TITLE"},
    "Search Internal Documents: Sales": {"id_column": "FILE_URL", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_SALES_DOCS", "title_column": "TITLE"},
    "Search Internal Documents: Marketing": {"id_column": "RELATIVE_PATH", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_MARKETING_DOCS", "title_column": "TITLE"},
    "Search Internal Documents: Strategy": {"id_column": "RELATIVE_PATH", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_STRATEGY_DOCS", "title_column": "TITLE"},
    "Search Internal Documents: Network": {"id_column": "RELATIVE_PATH", "max_results": 5, "name": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEARCH_NETWORK_DOCS", "title_column": "TITLE"},
    "Send_Emails": {
      "execution_environment": {"query_timeout": 0, "type": "warehouse", "warehouse": "SnowTelco_V2_Demo_WH"},
      "identifier": "SnowTelco_V2.SnowTelco_V2_SCHEMA.SEND_MAIL",
      "name": "SEND_MAIL(VARCHAR, VARCHAR, VARCHAR)",
      "type": "procedure"
    },
    "Web_scraper": {
      "execution_environment": {"query_timeout": 0, "type": "warehouse", "warehouse": "SnowTelco_V2_Demo_WH"},
      "identifier": "SnowTelco_V2.SnowTelco_V2_SCHEMA.WEB_SCRAPE",
      "name": "WEB_SCRAPE(VARCHAR)",
      "type": "function"
    }
  }
}
$$;

-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT '=== AGENT CREATION COMPLETE ===' AS status;

-- Verify agent exists
SHOW AGENTS;

SELECT '*** SETUP COMPLETE! ***' AS status;
SELECT 'Go to AI & ML > Snowflake Intelligence > SnowTelco_V2_Executive_Agent' AS instructions;
SELECT 'Try: "What is our total subscriber count?"' AS test_question;
