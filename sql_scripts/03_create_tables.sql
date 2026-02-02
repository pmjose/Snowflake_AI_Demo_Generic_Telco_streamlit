-- ========================================================================
-- SnowTelco Demo - Step 3: Create Tables
-- Creates all dimension and fact tables (~100 tables)
-- Run time: ~30 seconds
-- Prerequisites: Run 01_infrastructure.sql and 02_download_data.sql first
-- ========================================================================

USE ROLE SnowTelco_V2_Demo;
USE DATABASE SnowTelco_V2;
USE SCHEMA SnowTelco_V2_SCHEMA;
USE WAREHOUSE SnowTelco_V2_Demo_WH;

SELECT '=== CREATING TABLES ===' AS status;

    -- DIMENSION TABLES
    -- ========================================================================

    -- Product Category Dimension
    CREATE OR REPLACE TABLE product_category_dim (
        category_key INT PRIMARY KEY,
        category_name VARCHAR(100) NOT NULL,
        vertical VARCHAR(50) NOT NULL
    );

    -- Product Dimension
    CREATE OR REPLACE TABLE product_dim (
        product_key INT PRIMARY KEY,
        product_name VARCHAR(200) NOT NULL,
        category_key INT NOT NULL,
        category_name VARCHAR(100),
        vertical VARCHAR(50)
    );

    -- Vendor Dimension
    CREATE OR REPLACE TABLE vendor_dim (
        vendor_key INT PRIMARY KEY,
        vendor_name VARCHAR(200) NOT NULL,
        vertical VARCHAR(50) NOT NULL,
        address VARCHAR(200),
        city VARCHAR(100),
        county VARCHAR(50),
        postcode VARCHAR(20)
    );

    -- Customer Dimension
    CREATE OR REPLACE TABLE customer_dim (
        customer_key INT PRIMARY KEY,
        customer_name VARCHAR(200) NOT NULL,
        industry VARCHAR(100),
        vertical VARCHAR(50),
        address VARCHAR(200),
        city VARCHAR(100),
        county VARCHAR(50),
        postcode VARCHAR(20)
    );

    -- Account Dimension (Finance)
    CREATE OR REPLACE TABLE account_dim (
        account_key INT PRIMARY KEY,
        account_name VARCHAR(100) NOT NULL,
        account_type VARCHAR(50)
    );

    -- Department Dimension
    CREATE OR REPLACE TABLE department_dim (
        department_key INT PRIMARY KEY,
        department_name VARCHAR(100) NOT NULL
    );

    -- Region Dimension
    CREATE OR REPLACE TABLE region_dim (
        region_key INT PRIMARY KEY,
        region_name VARCHAR(100) NOT NULL
    );

    -- Sales Rep Dimension
    CREATE OR REPLACE TABLE sales_rep_dim (
        sales_rep_key INT PRIMARY KEY,
        rep_name VARCHAR(200) NOT NULL,
        role VARCHAR(100),
        hire_date DATE
    );

    -- Campaign Dimension (Marketing)
    CREATE OR REPLACE TABLE campaign_dim (
        campaign_key INT PRIMARY KEY,
        campaign_name VARCHAR(300) NOT NULL,
        objective VARCHAR(100)
    );

    -- Channel Dimension (Marketing)
    CREATE OR REPLACE TABLE channel_dim (
        channel_key INT PRIMARY KEY,
        channel_name VARCHAR(100) NOT NULL
    );

    -- Employee Dimension (HR)
    CREATE OR REPLACE TABLE employee_dim (
        employee_key INT PRIMARY KEY,
        employee_name VARCHAR(200) NOT NULL,
        gender VARCHAR(1),
        hire_date DATE
    );

    -- Job Dimension (HR)
    CREATE OR REPLACE TABLE job_dim (
        job_key INT PRIMARY KEY,
        job_title VARCHAR(100) NOT NULL
    );

    -- Location Dimension (HR)
    CREATE OR REPLACE TABLE location_dim (
        location_key INT PRIMARY KEY,
        location_name VARCHAR(200) NOT NULL
    );

    -- ========================================================================
    -- MOBILE TELCO DIMENSION TABLES
    -- ========================================================================

    -- Mobile Plan Dimension (Enhanced with network generation)
    CREATE OR REPLACE TABLE mobile_plan_dim (
        plan_key INT PRIMARY KEY,
        plan_name VARCHAR(100) NOT NULL,
        plan_type VARCHAR(50),
        monthly_price DECIMAL(10,2),
        data_allowance_gb INT,
        minutes_allowance INT,
        sms_allowance INT,
        contract_length_months INT,
        "5g_included" BOOLEAN,
        roaming_included BOOLEAN,
        family_eligible BOOLEAN,
        launch_date DATE,
        network_generation VARCHAR(10)
    );

    -- Mobile Device Dimension
    CREATE OR REPLACE TABLE mobile_device_dim (
        device_key INT PRIMARY KEY,
        device_name VARCHAR(200) NOT NULL,
        manufacturer VARCHAR(100),
        device_type VARCHAR(50),
        release_date DATE,
        rrp_price DECIMAL(10,2),
        storage_gb INT,
        "5g_capable" BOOLEAN,
        screen_size_inches DECIMAL(4,2),
        os VARCHAR(50),
        os_version VARCHAR(50)
    );

    -- Mobile Network Site Dimension
    CREATE OR REPLACE TABLE mobile_network_dim (
        network_site_key INT PRIMARY KEY,
        site_name VARCHAR(200) NOT NULL,
        site_type VARCHAR(50),
        address VARCHAR(200),
        city VARCHAR(100),
        county VARCHAR(50),
        postcode VARCHAR(20),
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        technology VARCHAR(50),
        capacity_mbps INT,
        coverage_radius_km DECIMAL(6,2),
        status VARCHAR(50),
        install_date DATE
    );

    -- Mobile Subscriber Dimension
    CREATE OR REPLACE TABLE mobile_subscriber_dim (
        subscriber_key INT PRIMARY KEY,
        mobile_number VARCHAR(20) NOT NULL,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        email VARCHAR(200),
        date_of_birth DATE,
        address VARCHAR(200),
        city VARCHAR(100),
        county VARCHAR(50),
        postcode VARCHAR(20),
        plan_key INT,
        device_key INT,
        activation_date DATE,
        status VARCHAR(50),
        churn_date DATE,
        credit_score VARCHAR(50),
        marketing_opt_in BOOLEAN,
        acquisition_channel VARCHAR(100),
        customer_type VARCHAR(50),
        customer_segment VARCHAR(50),
        company_name VARCHAR(200),
        company_size VARCHAR(50),
        network_generation VARCHAR(10)
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 1 DIMENSION TABLES
    -- ========================================================================

    -- Service Dimension
    CREATE OR REPLACE TABLE service_dim (
        service_key INT PRIMARY KEY,
        service_name VARCHAR(200) NOT NULL,
        service_type VARCHAR(100),
        category VARCHAR(100),
        monthly_price DECIMAL(10,2),
        setup_fee DECIMAL(10,2),
        billing_frequency VARCHAR(50),
        status VARCHAR(50)
    );

    -- Support Category Dimension
    CREATE OR REPLACE TABLE support_category_dim (
        category_key INT PRIMARY KEY,
        category_name VARCHAR(100) NOT NULL,
        department VARCHAR(100),
        category_type VARCHAR(50),
        sla_hours INT
    );

    -- Order Dimension
    CREATE OR REPLACE TABLE order_dim (
        order_id INT PRIMARY KEY,
        order_number VARCHAR(50) NOT NULL,
        customer_key INT,
        customer_type VARCHAR(50),
        partner_key INT,
        order_date DATE,
        order_type VARCHAR(50),
        channel VARCHAR(50),
        status VARCHAR(50),
        completion_date DATE,
        total_mrr DECIMAL(12,2),
        total_nrr DECIMAL(12,2),
        sales_rep_key INT,
        region_key INT
    );

    -- Network Element Dimension
    CREATE OR REPLACE TABLE network_element_dim (
        element_id INT PRIMARY KEY,
        element_name VARCHAR(200) NOT NULL,
        element_type VARCHAR(100),
        category VARCHAR(100),
        site_key INT,
        vendor VARCHAR(100),
        model VARCHAR(100),
        serial_number VARCHAR(100),
        ip_address VARCHAR(50),
        city VARCHAR(100),
        county VARCHAR(50),
        status VARCHAR(50),
        install_date DATE,
        last_maintenance DATE,
        capacity_gbps DECIMAL(10,2),
        criticality VARCHAR(50)
    );

    -- ========================================================================
    -- RAN (RADIO ACCESS NETWORK) TABLES
    -- ========================================================================

    -- RAN Site Dimension (Cell tower sites)
    CREATE OR REPLACE TABLE ran_site_dim (
        site_id INT PRIMARY KEY,
        site_code VARCHAR(50) NOT NULL,
        site_name VARCHAR(200) NOT NULL,
        site_type VARCHAR(50),
        site_type_desc VARCHAR(100),
        address VARCHAR(200),
        city VARCHAR(100),
        county VARCHAR(100),
        postcode VARCHAR(20),
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        area_type VARCHAR(50),
        technology VARCHAR(50),
        primary_vendor VARCHAR(100),
        tower_height_m INT,
        coverage_radius_km DECIMAL(6,2),
        num_sectors INT,
        backhaul_type VARCHAR(50),
        power_source VARCHAR(100),
        status VARCHAR(50),
        install_date DATE,
        last_maintenance DATE
    );

    -- RAN Equipment Dimension (gNodeB, eNodeB, BBU, RRU, Antennas)
    CREATE OR REPLACE TABLE ran_equipment_dim (
        equipment_id INT PRIMARY KEY,
        site_id INT,
        equipment_type VARCHAR(50) NOT NULL,
        equipment_name VARCHAR(100) NOT NULL,
        vendor VARCHAR(100),
        model VARCHAR(200),
        serial_number VARCHAR(100),
        technology VARCHAR(50),
        frequency_band VARCHAR(20),
        power_watts INT,
        status VARCHAR(50),
        install_date DATE,
        firmware_version VARCHAR(50)
    );

    -- RAN Cell Dimension (Sectors/Cells per site)
    CREATE OR REPLACE TABLE ran_cell_dim (
        cell_id INT PRIMARY KEY,
        site_id INT,
        cell_name VARCHAR(100) NOT NULL,
        cell_type VARCHAR(20),
        technology VARCHAR(50),
        frequency_band VARCHAR(20),
        frequency_mhz INT,
        bandwidth_mhz INT,
        sector INT,
        azimuth_degrees INT,
        electrical_tilt INT,
        mechanical_tilt INT,
        antenna_height_m INT,
        tx_power_dbm INT,
        max_throughput_mbps INT,
        max_connected_users INT,
        pci INT,
        tac INT,
        vendor VARCHAR(100),
        status VARCHAR(50)
    );

    -- RAN Performance Fact (KPIs)
    CREATE OR REPLACE TABLE ran_performance_fact (
        perf_id INT PRIMARY KEY,
        cell_id INT,
        site_id INT,
        metric_date DATE,
        metric_hour INT,
        technology VARCHAR(50),
        frequency_band VARCHAR(20),
        avg_throughput_mbps DECIMAL(10,2),
        max_throughput_mbps DECIMAL(10,2),
        prb_utilization_pct DECIMAL(6,2),
        connected_users INT,
        max_connected_users INT,
        avg_latency_ms DECIMAL(8,2),
        rsrp_dbm DECIMAL(6,2),
        rsrq_db DECIMAL(6,2),
        sinr_db DECIMAL(6,2),
        handover_success_pct DECIMAL(6,2),
        call_drop_rate_pct DECIMAL(6,3),
        rrc_setup_success_pct DECIMAL(6,2),
        erab_setup_success_pct DECIMAL(6,2),
        availability_pct DECIMAL(6,2)
    );

    -- RAN Alarm Fact (RAN-specific alarms)
    CREATE OR REPLACE TABLE ran_alarm_fact (
        alarm_id INT PRIMARY KEY,
        site_id INT,
        target_type VARCHAR(50),
        target_id INT,
        target_name VARCHAR(100),
        alarm_type VARCHAR(100),
        severity VARCHAR(50),
        impact VARCHAR(100),
        raised_time TIMESTAMP,
        cleared_time TIMESTAMP,
        duration_minutes INT,
        acknowledged BOOLEAN,
        acknowledged_by VARCHAR(100),
        root_cause VARCHAR(100),
        ticket_id VARCHAR(50)
    );

    -- ========================================================================
    -- ENHANCED ANALYTICS TABLES
    -- ========================================================================

    -- Competitor Dimension
    CREATE OR REPLACE TABLE competitor_dim (
        competitor_id INT PRIMARY KEY,
        competitor_name VARCHAR(100) NOT NULL,
        competitor_type VARCHAR(50),
        headquarters VARCHAR(100),
        founded_year INT,
        website VARCHAR(200),
        is_snowtelco BOOLEAN
    );

    -- Competitor Pricing Dimension
    CREATE OR REPLACE TABLE competitor_pricing_dim (
        pricing_id INT PRIMARY KEY,
        competitor_name VARCHAR(100),
        plan_name VARCHAR(200),
        data_allowance_gb INT,
        monthly_price DECIMAL(10,2),
        includes_5g BOOLEAN,
        contract_months INT,
        includes_roaming BOOLEAN,
        effective_date DATE
    );

    -- Technician Dimension (Field Operations)
    CREATE OR REPLACE TABLE technician_dim (
        technician_id INT PRIMARY KEY,
        technician_name VARCHAR(200) NOT NULL,
        employee_id VARCHAR(50),
        specialization VARCHAR(100),
        skill_level VARCHAR(50),
        region VARCHAR(100),
        hire_date DATE,
        certification_count INT,
        avg_csat_score DECIMAL(4,2),
        status VARCHAR(50)
    );

    -- Customer Journey Fact
    CREATE OR REPLACE TABLE customer_journey_fact (
        journey_id INT PRIMARY KEY,
        subscriber_key INT,
        journey_stage VARCHAR(50),
        channel VARCHAR(50),
        interaction_type VARCHAR(100),
        interaction_timestamp TIMESTAMP,
        interaction_date DATE,
        sentiment_score INT,
        effort_score INT,
        resolution_achieved BOOLEAN,
        session_duration_secs INT,
        page_views INT,
        conversion_flag BOOLEAN
    );

    -- Network Quality of Experience Fact
    CREATE OR REPLACE TABLE network_qoe_fact (
        qoe_id INT PRIMARY KEY,
        subscriber_key INT,
        cell_id INT,
        measurement_timestamp TIMESTAMP,
        measurement_date DATE,
        measurement_hour INT,
        download_speed_mbps DECIMAL(10,2),
        upload_speed_mbps DECIMAL(10,2),
        latency_ms DECIMAL(8,2),
        jitter_ms DECIMAL(8,2),
        packet_loss_pct DECIMAL(6,3),
        video_quality_score INT,
        voice_mos_score DECIMAL(4,2),
        app_category VARCHAR(100),
        connection_type VARCHAR(20),
        signal_strength_dbm INT
    );

    -- Customer Propensity Scores (ML/AI)
    CREATE OR REPLACE TABLE customer_propensity_scores (
        subscriber_key INT PRIMARY KEY,
        score_date DATE,
        churn_risk_score DECIMAL(6,4),
        churn_risk_band VARCHAR(20),
        upsell_propensity DECIMAL(6,4),
        cross_sell_propensity DECIMAL(6,4),
        predicted_clv DECIMAL(12,2),
        clv_segment VARCHAR(20),
        next_best_action VARCHAR(100),
        model_version VARCHAR(20),
        confidence_score DECIMAL(4,2)
    );

    -- Field Visit Fact
    CREATE OR REPLACE TABLE field_visit_fact (
        visit_id INT PRIMARY KEY,
        technician_id INT,
        subscriber_key INT,
        site_id INT,
        visit_type VARCHAR(50),
        visit_date DATE,
        scheduled_time TIMESTAMP,
        arrival_time TIMESTAMP,
        completion_time TIMESTAMP,
        duration_mins INT,
        delay_mins INT,
        outcome VARCHAR(50),
        first_time_fix BOOLEAN,
        labor_cost DECIMAL(10,2),
        parts_cost DECIMAL(10,2),
        total_cost DECIMAL(10,2),
        csat_score INT,
        sla_met BOOLEAN
    );

    -- Market Share Fact
    CREATE OR REPLACE TABLE market_share_fact (
        record_id INT PRIMARY KEY,
        report_date DATE,
        report_month VARCHAR(10),
        region VARCHAR(100),
        competitor_name VARCHAR(100),
        competitor_type VARCHAR(50),
        subscriber_count INT,
        market_share_pct DECIMAL(6,2),
        net_adds INT,
        arpu DECIMAL(8,2),
        churn_rate_pct DECIMAL(6,2)
    );

    -- Social Mention Fact
    CREATE OR REPLACE TABLE social_mention_fact (
        mention_id INT PRIMARY KEY,
        platform VARCHAR(50),
        mention_timestamp TIMESTAMP,
        mention_date DATE,
        content_snippet VARCHAR(500),
        sentiment VARCHAR(20),
        sentiment_score DECIMAL(5,3),
        topic VARCHAR(100),
        reach_count INT,
        engagement_count INT,
        is_influencer BOOLEAN,
        requires_response BOOLEAN,
        responded BOOLEAN,
        response_time_mins INT
    );

    -- Energy Consumption Fact (ESG)
    CREATE OR REPLACE TABLE energy_consumption_fact (
        record_id INT PRIMARY KEY,
        site_id INT,
        measurement_date DATE,
        energy_kwh DECIMAL(10,2),
        renewable_kwh DECIMAL(10,2),
        grid_kwh DECIMAL(10,2),
        renewable_pct DECIMAL(5,1),
        carbon_emissions_kg DECIMAL(10,2),
        pue_ratio DECIMAL(4,2),
        cooling_kwh DECIMAL(10,2),
        equipment_kwh DECIMAL(10,2)
    );

    -- Sustainability Metrics
    CREATE OR REPLACE TABLE sustainability_metrics (
        record_id INT PRIMARY KEY,
        metric_date DATE,
        metric_month VARCHAR(10),
        total_energy_mwh DECIMAL(12,0),
        renewable_energy_pct DECIMAL(5,1),
        total_carbon_tonnes DECIMAL(10,0),
        carbon_intensity DECIMAL(6,3),
        e_waste_recycled_tonnes DECIMAL(8,1),
        e_waste_recycled_pct DECIMAL(5,1),
        water_usage_m3 DECIMAL(10,0),
        green_tariff_subscribers INT,
        sustainability_score DECIMAL(5,1),
        net_zero_progress_pct DECIMAL(5,1)
    );

    -- ========================================================================
    -- FRAUD DETECTION TABLES
    -- ========================================================================

    -- Fraud Type Dimension
    CREATE OR REPLACE TABLE fraud_type_dim (
        fraud_type_id INT PRIMARY KEY,
        fraud_type VARCHAR(100) NOT NULL,
        category VARCHAR(50),
        severity VARCHAR(20),
        description VARCHAR(500)
    );

    -- Fraud Case Fact
    CREATE OR REPLACE TABLE fraud_case_fact (
        fraud_case_id INT PRIMARY KEY,
        fraud_type_id INT,
        detection_date DATE,
        detection_timestamp TIMESTAMP,
        detection_method VARCHAR(50),
        ml_confidence_score DECIMAL(4,2),
        subscriber_key INT,
        msisdn VARCHAR(20),
        suspected_amount DECIMAL(12,2),
        actual_loss DECIMAL(12,2),
        prevented_loss DECIMAL(12,2),
        status VARCHAR(50),
        resolution_type VARCHAR(50),
        resolution_date DATE,
        investigating_team VARCHAR(50),
        city VARCHAR(100),
        risk_score INT,
        is_repeat_offender BOOLEAN
    );

    -- ========================================================================
    -- B2B CONTRACT RENEWALS TABLE
    -- ========================================================================

    -- B2B Contract Fact
    CREATE OR REPLACE TABLE b2b_contract_fact (
        contract_id VARCHAR(20) PRIMARY KEY,
        customer_key INT,
        account_name VARCHAR(200),
        industry VARCHAR(100),
        region VARCHAR(50),
        contract_type VARCHAR(50),
        contract_start_date DATE,
        contract_end_date DATE,
        contract_term_months INT,
        annual_contract_value DECIMAL(15,2),
        total_contract_value DECIMAL(15,2),
        renewal_status VARCHAR(50),
        renewal_probability DECIMAL(4,2),
        days_to_renewal INT,
        competitor_threat VARCHAR(20),
        competitor_name VARCHAR(100),
        proposed_change VARCHAR(50),
        proposed_value_change DECIMAL(15,2),
        account_manager VARCHAR(20),
        nps_score INT,
        support_tickets_ytd INT,
        last_engagement_date DATE
    );

    -- ========================================================================
    -- WHOLESALE / MVNO TABLES
    -- ========================================================================

    -- MVNO Partner Dimension
    CREATE OR REPLACE TABLE mvno_partner_dim (
        mvno_id INT PRIMARY KEY,
        mvno_name VARCHAR(100) NOT NULL,
        mvno_type VARCHAR(50),
        parent_company VARCHAR(100),
        launch_date DATE,
        target_segment VARCHAR(100),
        subscriber_count INT,
        status VARCHAR(20),
        contract_type VARCHAR(50),
        contract_start_date DATE,
        contract_end_date DATE,
        wholesale_rate_voice DECIMAL(6,4),
        wholesale_rate_sms DECIMAL(6,4),
        wholesale_rate_data DECIMAL(6,2),
        minimum_commitment_gbp DECIMAL(12,2),
        account_manager VARCHAR(20)
    );

    -- MVNO Traffic Fact
    CREATE OR REPLACE TABLE mvno_traffic_fact (
        traffic_id INT PRIMARY KEY,
        mvno_id INT,
        traffic_date DATE,
        traffic_month VARCHAR(10),
        voice_minutes INT,
        sms_count INT,
        data_gb DECIMAL(12,2),
        voice_revenue DECIMAL(12,2),
        sms_revenue DECIMAL(12,2),
        data_revenue DECIMAL(12,2),
        total_revenue DECIMAL(12,2),
        active_subscribers INT,
        network_type VARCHAR(10),
        peak_hour_traffic_pct DECIMAL(4,2)
    );

    -- MVNO Settlement Fact
    CREATE OR REPLACE TABLE mvno_settlement_fact (
        settlement_id INT PRIMARY KEY,
        mvno_id INT,
        settlement_month VARCHAR(10),
        settlement_date DATE,
        due_date DATE,
        voice_charges DECIMAL(12,2),
        sms_charges DECIMAL(12,2),
        data_charges DECIMAL(12,2),
        interconnect_charges DECIMAL(12,2),
        other_charges DECIMAL(12,2),
        total_charges DECIMAL(12,2),
        minimum_commitment DECIMAL(12,2),
        shortfall_charge DECIMAL(12,2),
        payment_status VARCHAR(20),
        payment_date DATE,
        invoice_number VARCHAR(50),
        is_overdue BOOLEAN DEFAULT FALSE,
        days_overdue INT DEFAULT 0
    );

    -- ========================================================================
    -- RETAIL STORE TABLES
    -- ========================================================================

    -- Retail Store Dimension
    CREATE OR REPLACE TABLE retail_store_dim (
        store_id INT PRIMARY KEY,
        store_name VARCHAR(200) NOT NULL,
        store_code VARCHAR(20),
        store_type VARCHAR(50),
        store_format VARCHAR(50),
        city VARCHAR(100),
        region VARCHAR(50),
        postcode VARCHAR(20),
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        opening_date DATE,
        store_sqft INT,
        staff_count INT,
        manager_name VARCHAR(200),
        status VARCHAR(20),
        has_repair_centre BOOLEAN,
        has_business_area BOOLEAN
    );

    -- Retail Sales Fact
    CREATE OR REPLACE TABLE retail_sales_fact (
        sale_id INT PRIMARY KEY,
        store_id INT,
        sale_date DATE,
        sale_timestamp TIMESTAMP,
        sale_month VARCHAR(10),
        product_category VARCHAR(50),
        product_name VARCHAR(200),
        quantity INT,
        unit_price DECIMAL(12,2),
        total_amount DECIMAL(12,2),
        payment_type VARCHAR(50),
        contract_length_months INT,
        customer_type VARCHAR(50),
        staff_id VARCHAR(20),
        commission_amount DECIMAL(10,2),
        is_weekend BOOLEAN,
        channel VARCHAR(50)
    );

    -- Retail Footfall Fact
    CREATE OR REPLACE TABLE retail_footfall_fact (
        footfall_id INT PRIMARY KEY,
        store_id INT,
        footfall_date DATE,
        footfall_month VARCHAR(10),
        day_of_week VARCHAR(20),
        visitor_count INT,
        transaction_count INT,
        conversion_rate DECIMAL(5,3),
        avg_dwell_time_mins INT,
        peak_hour VARCHAR(10),
        weather VARCHAR(20)
    );

    -- ========================================================================
    -- ENHANCED HR TABLES
    -- ========================================================================

    -- Employee Detail Dimension
    CREATE OR REPLACE TABLE employee_detail_dim (
        employee_id VARCHAR(20) PRIMARY KEY,
        employee_name VARCHAR(200) NOT NULL,
        email VARCHAR(200),
        department VARCHAR(100),
        job_title VARCHAR(200),
        job_level VARCHAR(50),
        employment_type VARCHAR(50),
        hire_date DATE,
        tenure_years DECIMAL(4,1),
        work_location VARCHAR(200),
        work_city VARCHAR(100),
        work_type VARCHAR(20),
        salary DECIMAL(12,2),
        manager_id VARCHAR(20),
        cost_centre VARCHAR(20),
        status VARCHAR(20),
        gender VARCHAR(10),
        age_band VARCHAR(20),
        performance_rating INT,
        last_promotion_date DATE,
        training_hours_ytd INT
    );

    -- Employee Survey Fact
    CREATE OR REPLACE TABLE employee_survey_fact (
        survey_id INT PRIMARY KEY,
        employee_id VARCHAR(20),
        department VARCHAR(100),
        work_location VARCHAR(200),
        survey_date DATE,
        survey_month VARCHAR(10),
        survey_type VARCHAR(50),
        engagement_score INT,
        satisfaction_score INT,
        manager_rating INT,
        career_growth_score INT,
        work_life_balance INT,
        compensation_satisfaction INT,
        would_recommend BOOLEAN,
        enps_score INT,
        comments_provided BOOLEAN
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 2 DIMENSION TABLES
    -- ========================================================================

    -- Partner Dimension
    CREATE OR REPLACE TABLE partner_dim (
        partner_key INT PRIMARY KEY,
        partner_name VARCHAR(200) NOT NULL,
        partner_type VARCHAR(100),
        tier VARCHAR(50),
        city VARCHAR(100),
        county VARCHAR(50),
        region_key INT,
        status VARCHAR(50),
        onboard_date DATE,
        account_manager VARCHAR(200),
        commission_rate DECIMAL(5,2),
        credit_limit DECIMAL(15,2)
    );

    -- Contact Center Agent Dimension
    CREATE OR REPLACE TABLE contact_center_agent_dim (
        agent_key INT PRIMARY KEY,
        agent_id VARCHAR(50) NOT NULL,
        agent_name VARCHAR(200),
        team VARCHAR(100),
        skill_group VARCHAR(100),
        hire_date DATE,
        status VARCHAR(50),
        supervisor VARCHAR(200),
        location VARCHAR(100),
        languages VARCHAR(200)
    );

    -- Payment Method Dimension
    CREATE OR REPLACE TABLE payment_method_dim (
        method_key INT PRIMARY KEY,
        method_name VARCHAR(100) NOT NULL,
        method_type VARCHAR(50),
        is_recurring BOOLEAN
    );

    -- Warehouse Dimension
    CREATE OR REPLACE TABLE warehouse_dim (
        warehouse_key INT PRIMARY KEY,
        warehouse_name VARCHAR(200) NOT NULL,
        city VARCHAR(100),
        warehouse_type VARCHAR(50),
        is_active BOOLEAN
    );

    -- Fixed Asset Dimension
    CREATE OR REPLACE TABLE fixed_asset_dim (
        asset_id INT PRIMARY KEY,
        asset_tag VARCHAR(50) NOT NULL,
        asset_name VARCHAR(200),
        category VARCHAR(100),
        location VARCHAR(200),
        department_key INT,
        purchase_date DATE,
        purchase_value DECIMAL(15,2),
        current_value DECIMAL(15,2),
        useful_life_years INT,
        depreciation_method VARCHAR(50),
        status VARCHAR(50),
        vendor_key INT,
        warranty_end DATE,
        last_inspection DATE
    );

    -- Contract Dimension
    CREATE OR REPLACE TABLE contract_dim (
        contract_id INT PRIMARY KEY,
        contract_number VARCHAR(50) NOT NULL,
        customer_key INT,
        contract_type VARCHAR(100),
        start_date DATE,
        end_date DATE,
        term_months INT,
        total_value DECIMAL(15,2),
        annual_value DECIMAL(15,2),
        status VARCHAR(50),
        auto_renew BOOLEAN,
        notice_period_days INT,
        payment_terms VARCHAR(100),
        signed_date DATE,
        account_manager VARCHAR(200)
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 3 DIMENSION TABLES
    -- ========================================================================

    -- SLA Dimension
    CREATE OR REPLACE TABLE sla_dim (
        sla_key INT PRIMARY KEY,
        sla_name VARCHAR(200) NOT NULL,
        sla_category VARCHAR(100),
        target_value DECIMAL(10,4),
        unit VARCHAR(50),
        measurement_period VARCHAR(50),
        penalty_applicable BOOLEAN,
        status VARCHAR(50)
    );

    -- Roaming Partner Dimension
    CREATE OR REPLACE TABLE roaming_partner_dim (
        roaming_partner_key INT PRIMARY KEY,
        partner_name VARCHAR(200) NOT NULL,
        country VARCHAR(100),
        region VARCHAR(100),
        agreement_type VARCHAR(100),
        effective_date DATE,
        data_rate_per_mb DECIMAL(10,4),
        voice_rate_per_min DECIMAL(10,4),
        status VARCHAR(50)
    );

    -- Number Range Dimension
    CREATE OR REPLACE TABLE number_range_dim (
        range_id INT PRIMARY KEY,
        prefix VARCHAR(20) NOT NULL,
        range_start VARCHAR(20),
        range_end VARCHAR(20),
        block_size INT,
        number_type VARCHAR(50),
        status VARCHAR(50),
        allocated_date DATE,
        utilization_pct DECIMAL(5,2)
    );

    -- IT Application Dimension
    CREATE OR REPLACE TABLE it_application_dim (
        app_id INT PRIMARY KEY,
        app_name VARCHAR(200) NOT NULL,
        category VARCHAR(100),
        vendor VARCHAR(200),
        version VARCHAR(50),
        criticality VARCHAR(50),
        owner VARCHAR(200),
        support_team VARCHAR(100),
        go_live_date DATE,
        status VARCHAR(50),
        users_count INT,
        monthly_cost DECIMAL(12,2)
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 4 DIMENSION TABLES
    -- ========================================================================

    -- Loyalty Program Dimension
    CREATE OR REPLACE TABLE loyalty_program_dim (
        program_key INT PRIMARY KEY,
        tier_name VARCHAR(100) NOT NULL,
        points_threshold INT,
        benefits VARCHAR(500),
        earn_rate DECIMAL(5,2),
        status VARCHAR(50)
    );

    -- IoT Device Type Dimension
    CREATE OR REPLACE TABLE iot_device_type_dim (
        device_type_key INT PRIMARY KEY,
        device_name VARCHAR(200) NOT NULL,
        category VARCHAR(100),
        industry VARCHAR(100),
        connectivity VARCHAR(100),
        data_frequency VARCHAR(100),
        avg_data_mb_month DECIMAL(10,2),
        power_mode VARCHAR(50),
        certification VARCHAR(200)
    );

    -- ========================================================================
    -- FACT TABLES
    -- ========================================================================

    -- Sales Fact Table
    CREATE OR REPLACE TABLE sales_fact (
        sale_id INT PRIMARY KEY,
        date DATE NOT NULL,
        customer_key INT NOT NULL,
        product_key INT NOT NULL,
        sales_rep_key INT NOT NULL,
        region_key INT NOT NULL,
        vendor_key INT NOT NULL,
        amount DECIMAL(10,2) NOT NULL,
        units INT NOT NULL
    );

    -- Finance Transactions Fact Table
    CREATE OR REPLACE TABLE finance_transactions (
        transaction_id INT PRIMARY KEY,
        date DATE NOT NULL,
        account_key INT NOT NULL,
        department_key INT NOT NULL,
        vendor_key INT NOT NULL,
        product_key INT NOT NULL,
        customer_key INT NOT NULL,
        amount DECIMAL(12,2) NOT NULL,
        approval_status VARCHAR(20) DEFAULT 'Pending',
        procurement_method VARCHAR(50),
        approver_id INT,
        approval_date DATE,
        purchase_order_number VARCHAR(50),
        contract_reference VARCHAR(100),
        CONSTRAINT fk_approver FOREIGN KEY (approver_id) REFERENCES employee_dim(employee_key)
    ) COMMENT = 'Financial transactions with compliance tracking. approval_status should be Approved/Pending/Rejected. procurement_method should be RFP/Quotes/Emergency/Contract';

    -- Marketing Campaign Fact Table
    CREATE OR REPLACE TABLE marketing_campaign_fact (
        campaign_fact_id INT PRIMARY KEY,
        date DATE NOT NULL,
        campaign_key INT NOT NULL,
        product_key INT NOT NULL,
        channel_key INT NOT NULL,
        region_key INT NOT NULL,
        spend DECIMAL(10,2) NOT NULL,
        leads_generated INT NOT NULL,
        impressions INT NOT NULL
    );

    -- HR Employee Fact Table
    CREATE OR REPLACE TABLE hr_employee_fact (
        hr_fact_id INT PRIMARY KEY,
        date DATE NOT NULL,
        employee_key INT NOT NULL,
        department_key INT NOT NULL,
        job_key INT NOT NULL,
        location_key INT NOT NULL,
        salary DECIMAL(10,2) NOT NULL,
        attrition_flag INT NOT NULL
    );

    -- ========================================================================
    -- MOBILE TELCO FACT TABLES
    -- ========================================================================

    -- Mobile Usage Fact
    CREATE OR REPLACE TABLE mobile_usage_fact (
        usage_id INT PRIMARY KEY,
        subscriber_key INT NOT NULL,
        usage_month VARCHAR(10) NOT NULL,
        data_used_gb DECIMAL(10,2),
        data_allowance_gb INT,
        minutes_used INT,
        sms_sent INT,
        roaming_data_gb DECIMAL(10,2),
        roaming_minutes INT,
        international_minutes INT,
        bill_amount DECIMAL(10,2),
        payment_status VARCHAR(50),
        nps_score INT
    );

    -- Mobile Churn Fact
    CREATE OR REPLACE TABLE mobile_churn_fact (
        churn_id INT PRIMARY KEY,
        subscriber_key INT NOT NULL,
        churn_date DATE NOT NULL,
        churn_reason VARCHAR(100),
        churn_reason_detail VARCHAR(500),
        competitor_name VARCHAR(100),
        tenure_months INT,
        lifetime_value DECIMAL(12,2),
        retention_attempts INT,
        retention_offer_made BOOLEAN,
        retention_offer_accepted BOOLEAN,
        final_bill_status VARCHAR(50),
        port_out BOOLEAN,
        win_back_eligible BOOLEAN
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 1 FACT TABLES
    -- ========================================================================

    -- Order Line Fact
    CREATE OR REPLACE TABLE order_line_fact (
        order_line_id INT PRIMARY KEY,
        order_id INT NOT NULL,
        service_key INT,
        product_key INT,
        quantity INT,
        unit_price DECIMAL(10,2),
        line_total DECIMAL(12,2),
        discount_percent DECIMAL(5,2),
        status VARCHAR(50),
        provisioning_date DATE
    );

    -- Invoice Fact
    CREATE OR REPLACE TABLE invoice_fact (
        invoice_id INT PRIMARY KEY,
        invoice_number VARCHAR(50) NOT NULL,
        customer_key INT NOT NULL,
        customer_type VARCHAR(50),
        invoice_date DATE NOT NULL,
        due_date DATE,
        amount DECIMAL(12,2),
        tax_amount DECIMAL(10,2),
        total_amount DECIMAL(12,2),
        status VARCHAR(50),
        paid_date DATE,
        payment_method VARCHAR(100),
        billing_period_start DATE,
        billing_period_end DATE
    );

    -- Service Instance Fact
    CREATE OR REPLACE TABLE service_instance_fact (
        service_instance_id INT PRIMARY KEY,
        service_instance_number VARCHAR(50) NOT NULL,
        customer_key INT NOT NULL,
        customer_type VARCHAR(50),
        service_key INT NOT NULL,
        order_id INT,
        quantity INT,
        status VARCHAR(50),
        start_date DATE,
        end_date DATE,
        mrr DECIMAL(12,2),
        contract_term_months INT,
        auto_renew BOOLEAN
    );

    -- Support Ticket Fact
    CREATE OR REPLACE TABLE support_ticket_fact (
        ticket_id INT PRIMARY KEY,
        ticket_number VARCHAR(50) NOT NULL,
        customer_key INT NOT NULL,
        customer_type VARCHAR(50),
        service_instance_id INT,
        category_key INT,
        priority VARCHAR(50),
        status VARCHAR(50),
        channel VARCHAR(50),
        created_date TIMESTAMP,
        resolved_date TIMESTAMP,
        first_response_mins INT,
        resolution_mins INT,
        csat_score INT,
        agent_key INT,
        escalated BOOLEAN
    );

    -- Network Alarm Fact
    CREATE OR REPLACE TABLE network_alarm_fact (
        alarm_id INT PRIMARY KEY,
        element_id INT NOT NULL,
        alarm_type VARCHAR(100),
        severity VARCHAR(50),
        raised_time TIMESTAMP,
        cleared_time TIMESTAMP,
        acknowledged BOOLEAN,
        acknowledged_by VARCHAR(200),
        ticket_id INT,
        root_cause VARCHAR(200),
        impact VARCHAR(200),
        alarm_duration_minutes INT,
        mttr_minutes INT
    );

    -- Network Performance Fact
    CREATE OR REPLACE TABLE network_performance_fact (
        perf_id INT PRIMARY KEY,
        element_id INT NOT NULL,
        metric_datetime TIMESTAMP NOT NULL,
        metric_date DATE,
        metric_hour INT,
        throughput_gbps DECIMAL(10,4),
        latency_ms DECIMAL(10,2),
        utilization_pct DECIMAL(5,2),
        packet_loss_pct DECIMAL(5,4),
        error_count INT,
        availability_pct DECIMAL(5,2)
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 2 FACT TABLES
    -- ========================================================================

    -- Partner Performance Fact
    CREATE OR REPLACE TABLE partner_performance_fact (
        perf_id INT PRIMARY KEY,
        partner_key INT NOT NULL,
        month VARCHAR(10) NOT NULL,
        orders_count INT,
        order_value DECIMAL(15,2),
        revenue DECIMAL(15,2),
        new_customers INT,
        churn_rate DECIMAL(5,2),
        nps_score INT,
        support_tickets INT,
        training_completed BOOLEAN,
        commission_earned DECIMAL(12,2)
    );

    -- Contact Center Call Fact (Enhanced with FCR tracking)
    CREATE OR REPLACE TABLE contact_center_call_fact (
        call_id INT PRIMARY KEY,
        customer_key INT,
        customer_type VARCHAR(50),
        agent_key INT NOT NULL,
        queue VARCHAR(100),
        start_time TIMESTAMP NOT NULL,
        end_time TIMESTAMP,
        wait_time_secs INT,
        handle_time_secs INT,
        disposition VARCHAR(100),
        ticket_id INT,
        transfer_count INT,
        csat_score INT,
        call_recording_url VARCHAR(500),
        is_first_call_resolved BOOLEAN,
        callback_required BOOLEAN
    );

    -- Payment Fact (Enhanced with payment method tracking)
    CREATE OR REPLACE TABLE payment_fact (
        payment_id INT PRIMARY KEY,
        payment_reference VARCHAR(50) NOT NULL,
        invoice_id INT,
        customer_key INT NOT NULL,
        payment_date DATE NOT NULL,
        amount DECIMAL(12,2),
        method_key INT,
        status VARCHAR(50),
        card_last_four VARCHAR(4),
        transaction_id VARCHAR(100),
        payment_method_key INT
    );

    -- Inventory Fact
    CREATE OR REPLACE TABLE inventory_fact (
        inventory_id INT PRIMARY KEY,
        product_key INT NOT NULL,
        warehouse_key INT NOT NULL,
        snapshot_date DATE NOT NULL,
        quantity_on_hand INT,
        quantity_reserved INT,
        quantity_on_order INT,
        reorder_point INT,
        status VARCHAR(50),
        last_count_date DATE,
        unit_cost DECIMAL(10,2)
    );

    -- Purchase Order Fact
    CREATE OR REPLACE TABLE purchase_order_fact (
        po_id INT PRIMARY KEY,
        po_number VARCHAR(50) NOT NULL,
        vendor_key INT NOT NULL,
        po_date DATE NOT NULL,
        expected_date DATE,
        total_amount DECIMAL(15,2),
        status VARCHAR(50),
        received_date DATE,
        payment_terms VARCHAR(100),
        buyer VARCHAR(200),
        department_key INT
    );

    -- Purchase Order Line Fact
    CREATE OR REPLACE TABLE purchase_order_line_fact (
        po_line_id INT PRIMARY KEY,
        po_id INT NOT NULL,
        product_key INT,
        description VARCHAR(500),
        quantity_ordered INT,
        quantity_received INT,
        unit_cost DECIMAL(10,2),
        line_total DECIMAL(12,2)
    );

    -- ========================================================================
    -- TM FORUM ODA - PHASE 3 FACT TABLES
    -- ========================================================================

    -- SLA Measurement Fact
    CREATE OR REPLACE TABLE sla_measurement_fact (
        measurement_id INT PRIMARY KEY,
        sla_key INT NOT NULL,
        service_instance_id INT,
        measurement_date DATE NOT NULL,
        actual_value DECIMAL(10,4),
        target_value DECIMAL(10,4),
        met BOOLEAN,
        breach_minutes INT,
        credit_applicable BOOLEAN
    );

    -- Roaming Usage Fact
    CREATE OR REPLACE TABLE roaming_usage_fact (
        roaming_usage_id INT PRIMARY KEY,
        subscriber_key INT NOT NULL,
        roaming_partner_key INT NOT NULL,
        usage_date DATE NOT NULL,
        direction VARCHAR(50),
        data_mb DECIMAL(10,2),
        voice_minutes DECIMAL(10,2),
        sms_count INT,
        wholesale_cost DECIMAL(10,2),
        retail_charge DECIMAL(10,2),
        imsi VARCHAR(50)
    );

    -- Number Port Fact
    CREATE OR REPLACE TABLE number_port_fact (
        port_id INT PRIMARY KEY,
        number VARCHAR(20) NOT NULL,
        direction VARCHAR(50),
        donor_carrier VARCHAR(100),
        recipient_carrier VARCHAR(100),
        request_date DATE,
        scheduled_date DATE,
        completed_date DATE,
        status VARCHAR(50),
        subscriber_key INT,
        rejection_reason VARCHAR(200)
    );

    -- IT Incident Fact (Enhanced with SLA tracking)
    CREATE OR REPLACE TABLE it_incident_fact (
        incident_id INT PRIMARY KEY,
        incident_number VARCHAR(50) NOT NULL,
        app_id INT NOT NULL,
        category VARCHAR(100),
        severity VARCHAR(50),
        status VARCHAR(50),
        created_date TIMESTAMP,
        resolved_date TIMESTAMP,
        assignee VARCHAR(200),
        resolution_mins INT,
        root_cause VARCHAR(500),
        business_impact VARCHAR(500),
        sla_target_mins INT,
        created_timestamp TIMESTAMP,
        assigned_timestamp TIMESTAMP,
        resolved_timestamp TIMESTAMP,
        sla_met BOOLEAN
    );

    -- Complaint Fact
    CREATE OR REPLACE TABLE complaint_fact (
        complaint_id INT PRIMARY KEY,
        complaint_reference VARCHAR(50) NOT NULL,
        customer_key INT NOT NULL,
        customer_type VARCHAR(50),
        category VARCHAR(100),
        channel VARCHAR(50),
        received_date DATE NOT NULL,
        acknowledged_date DATE,
        resolved_date DATE,
        outcome VARCHAR(100),
        compensation_amount DECIMAL(10,2),
        escalated_to_ombudsman BOOLEAN,
        root_cause VARCHAR(500)
    );

    -- Legal Matter Fact (for VP Legal persona)
    CREATE OR REPLACE TABLE legal_matter_fact (
        matter_id VARCHAR(20) PRIMARY KEY,
        matter_type VARCHAR(50) NOT NULL,
        matter_title VARCHAR(200) NOT NULL,
        status VARCHAR(50) NOT NULL,
        priority VARCHAR(20),
        open_date DATE NOT NULL,
        close_date DATE,
        opposing_party VARCHAR(200),
        description VARCHAR(1000),
        potential_exposure DECIMAL(12,2),
        reserved_amount DECIMAL(12,2),
        actual_cost DECIMAL(12,2),
        assigned_counsel VARCHAR(50),
        business_unit VARCHAR(100),
        related_contract_id VARCHAR(50),
        region VARCHAR(100)
    ) COMMENT = 'Legal matters, disputes, and litigation tracking. status: Open/Under Review/Settled/Closed. matter_type: Customer Dispute/Employment/Regulatory/Contract/IP-Patent';

    -- ========================================================================
    -- TM FORUM ODA - PHASE 4 FACT TABLES
    -- ========================================================================

    -- Loyalty Transaction Fact
    CREATE OR REPLACE TABLE loyalty_transaction_fact (
        transaction_id INT PRIMARY KEY,
        subscriber_key INT NOT NULL,
        program_key INT NOT NULL,
        transaction_date DATE NOT NULL,
        transaction_type VARCHAR(50),
        points INT,
        description VARCHAR(500),
        reference VARCHAR(100),
        balance_after INT
    );

    -- IoT Subscription Fact
    CREATE OR REPLACE TABLE iot_subscription_fact (
        subscription_id INT PRIMARY KEY,
        iccid VARCHAR(50) NOT NULL,
        device_type_key INT NOT NULL,
        customer_key INT NOT NULL,
        data_plan VARCHAR(100),
        activation_date DATE,
        status VARCHAR(50),
        monthly_fee DECIMAL(10,2),
        contract_term_months INT,
        last_communication DATE
    );

    -- IoT Usage Fact
    CREATE OR REPLACE TABLE iot_usage_fact (
        usage_id INT PRIMARY KEY,
        subscription_id INT NOT NULL,
        usage_date DATE NOT NULL,
        data_mb DECIMAL(10,2),
        messages_sent INT,
        messages_received INT,
        sessions INT,
        location_updates INT
    );

    -- Digital Interaction Fact
    CREATE OR REPLACE TABLE digital_interaction_fact (
        interaction_id INT PRIMARY KEY,
        customer_key INT,
        customer_type VARCHAR(50),
        channel VARCHAR(50) NOT NULL,
        event_type VARCHAR(100),
        timestamp TIMESTAMP NOT NULL,
        session_id VARCHAR(100),
        page_url VARCHAR(500),
        duration_secs INT,
        device_type VARCHAR(50),
        success BOOLEAN
    );

    -- ========================================================================
    -- NEW TABLES - PHASE 2-4 ENHANCEMENTS
    -- ========================================================================

    -- Credit Note Fact (Revenue Assurance)
    CREATE OR REPLACE TABLE credit_note_fact (
        credit_note_id VARCHAR(36) PRIMARY KEY,
        customer_key INT,
        invoice_id INT,
        credit_date DATE NOT NULL,
        credit_amount DECIMAL(12,2),
        credit_reason VARCHAR(100),
        approval_status VARCHAR(20),
        approved_by VARCHAR(100),
        created_date TIMESTAMP
    );

    -- Billing Adjustment Fact (Revenue Assurance)
    CREATE OR REPLACE TABLE billing_adjustment_fact (
        adjustment_id VARCHAR(36) PRIMARY KEY,
        customer_key INT,
        adjustment_date DATE NOT NULL,
        adjustment_type VARCHAR(50),
        original_amount DECIMAL(12,2),
        adjusted_amount DECIMAL(12,2),
        adjustment_reason VARCHAR(200),
        created_date TIMESTAMP
    );

    -- Unbilled Usage Fact (Revenue Leakage)
    CREATE OR REPLACE TABLE unbilled_usage_fact (
        unbilled_id VARCHAR(36) PRIMARY KEY,
        subscriber_key INT,
        usage_date DATE NOT NULL,
        usage_type VARCHAR(50),
        usage_quantity DECIMAL(12,2),
        estimated_revenue DECIMAL(12,2),
        reason_unbilled VARCHAR(100),
        created_date TIMESTAMP
    );

    -- SIM Activation Fact (Operations)
    CREATE OR REPLACE TABLE sim_activation_fact (
        activation_id VARCHAR(36) PRIMARY KEY,
        order_id VARCHAR(50),
        subscriber_key INT,
        sim_iccid VARCHAR(25),
        order_timestamp TIMESTAMP,
        activation_timestamp TIMESTAMP,
        activation_channel VARCHAR(50),
        time_to_activate_hours DECIMAL(10,2),
        activation_status VARCHAR(20),
        activation_type VARCHAR(50)
    );

    -- Dispute Fact (Billing)
    CREATE OR REPLACE TABLE dispute_fact (
        dispute_id VARCHAR(36) PRIMARY KEY,
        customer_key INT,
        invoice_id INT,
        dispute_date DATE NOT NULL,
        dispute_type VARCHAR(50),
        disputed_amount DECIMAL(12,2),
        status VARCHAR(30),
        assigned_to VARCHAR(100),
        response_date DATE,
        resolution_date DATE,
        resolution_type VARCHAR(50),
        final_amount DECIMAL(12,2),
        days_to_resolve INT,
        sla_met BOOLEAN,
        created_date TIMESTAMP
    );

    -- ========================================================================
    -- SALESFORCE CRM TABLES
    -- ========================================================================

    -- Salesforce Accounts Table
    CREATE OR REPLACE TABLE sf_accounts (
        account_id VARCHAR(20) PRIMARY KEY,
        account_name VARCHAR(200) NOT NULL,
        customer_key INT NOT NULL,
        industry VARCHAR(100),
        vertical VARCHAR(50),
        billing_street VARCHAR(200),
        billing_city VARCHAR(100),
        billing_state VARCHAR(10),
        billing_postal_code VARCHAR(20),
        account_type VARCHAR(50),
        annual_revenue DECIMAL(15,2),
        employees INT,
        created_date DATE
    );

    -- Salesforce Opportunities Table
    CREATE OR REPLACE TABLE sf_opportunities (
        opportunity_id VARCHAR(20) PRIMARY KEY,
        sale_id INT,
        account_id VARCHAR(20) NOT NULL,
        opportunity_name VARCHAR(200) NOT NULL,
        stage_name VARCHAR(100) NOT NULL,
        amount DECIMAL(15,2) NOT NULL,
        probability DECIMAL(5,2),
        close_date DATE,
        created_date DATE,
        lead_source VARCHAR(100),
        type VARCHAR(100),
        campaign_id INT
    );

    -- Salesforce Contacts Table
    CREATE OR REPLACE TABLE sf_contacts (
        contact_id VARCHAR(20) PRIMARY KEY,
        account_id VARCHAR(20) NOT NULL,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        email VARCHAR(200),
        phone VARCHAR(50),
        title VARCHAR(100),
        department VARCHAR(100),
        created_date DATE
    );

    -- Salesforce Quotas Table (Sales Targets)
    CREATE OR REPLACE TABLE sf_quotas (
        quota_id VARCHAR(20) PRIMARY KEY,
        user_id VARCHAR(20) NOT NULL,
        rep_name VARCHAR(200) NOT NULL,
        team VARCHAR(100),
        period_start DATE NOT NULL,
        period_end DATE NOT NULL,
        quota_amount DECIMAL(15,2) NOT NULL,
        quota_type VARCHAR(50),
        territory VARCHAR(100),
        fiscal_year INT,
        fiscal_quarter INT
    );

    -- Salesforce Pipeline Snapshot Table (Weekly snapshots for trend analysis)
    CREATE OR REPLACE TABLE sf_pipeline_snapshot (
        snapshot_id VARCHAR(20) PRIMARY KEY,
        snapshot_date DATE NOT NULL,
        stage_name VARCHAR(100) NOT NULL,
        opportunity_count INT,
        total_amount DECIMAL(15,2),
        weighted_amount DECIMAL(15,2),
        avg_days_in_stage INT
    );

    -- ========================================================================

-- ========================================================================
-- VERIFICATION
-- ========================================================================

SELECT '=== TABLE CREATION COMPLETE ===' AS status;
SELECT COUNT(*) AS tables_created 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'SNOWTELCO_SCHEMA';

SELECT 'Next step: Run 04_load_data.sql' AS next_step;
