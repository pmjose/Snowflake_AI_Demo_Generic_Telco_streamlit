#!/usr/bin/env python3
"""
SnowTelco Enhanced Data Generator
=================================
Generates additional data tables for comprehensive telco analytics:
- Customer Journey Fact
- Network Quality of Experience (QoE) Fact  
- Customer Propensity Scores
- Field Visit Fact + Technician Dimension
- Market Share Fact + Competitor Pricing Dimension
- Social Mention Fact
- Energy Consumption Fact + Sustainability Metrics

Data covers 2025-2026 (Jan 28)

Usage:
    python scripts/generate_enhanced_data.py
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# Configuration
DEMO_DATA_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'demo_data')

# Random seed for reproducibility
np.random.seed(42)
random.seed(42)

# Date ranges
START_DATE = datetime(2025, 1, 1)
END_DATE = datetime(2026, 1, 28)
TOTAL_DAYS = (END_DATE - START_DATE).days

# Load existing data for consistency
def load_existing_data():
    """Load existing dimension data for foreign key references."""
    data = {}
    data['subscribers'] = pd.read_csv(os.path.join(DEMO_DATA_PATH, 'mobile_subscriber_dim.csv'))
    data['ran_sites'] = pd.read_csv(os.path.join(DEMO_DATA_PATH, 'ran_site_dim.csv'))
    data['ran_cells'] = pd.read_csv(os.path.join(DEMO_DATA_PATH, 'ran_cell_dim.csv'))
    data['products'] = pd.read_csv(os.path.join(DEMO_DATA_PATH, 'product_dim.csv'))
    data['regions'] = pd.read_csv(os.path.join(DEMO_DATA_PATH, 'region_dim.csv'))
    return data

# ============================================================================
# COMPETITOR DATA
# ============================================================================

UK_COMPETITORS = [
    {'name': 'Vodafone UK', 'market_share': 0.25, 'type': 'MNO'},
    {'name': 'EE', 'market_share': 0.28, 'type': 'MNO'},
    {'name': 'Three UK', 'market_share': 0.15, 'type': 'MNO'},
    {'name': 'O2 UK', 'market_share': 0.22, 'type': 'MNO'},
    {'name': 'SnowTelco', 'market_share': 0.05, 'type': 'MNO'},
    {'name': 'Tesco Mobile', 'market_share': 0.02, 'type': 'MVNO'},
    {'name': 'giffgaff', 'market_share': 0.015, 'type': 'MVNO'},
    {'name': 'Sky Mobile', 'market_share': 0.015, 'type': 'MVNO'},
]

def generate_competitor_dim():
    """Generate competitor dimension."""
    competitors = []
    for i, comp in enumerate(UK_COMPETITORS, 1):
        competitors.append({
            'competitor_id': i,
            'competitor_name': comp['name'],
            'competitor_type': comp['type'],
            'headquarters': 'London' if comp['type'] == 'MNO' else random.choice(['London', 'Manchester', 'Edinburgh']),
            'founded_year': random.randint(1985, 2010),
            'website': f"www.{comp['name'].lower().replace(' ', '')}.co.uk",
            'is_snowtelco': comp['name'] == 'SnowTelco',
        })
    return pd.DataFrame(competitors)

def generate_competitor_pricing_dim():
    """Generate competitor pricing dimension."""
    pricing = []
    price_id = 1
    
    plan_templates = [
        {'name': 'Basic 5GB', 'data_gb': 5, 'base_price': 10},
        {'name': 'Standard 15GB', 'data_gb': 15, 'base_price': 18},
        {'name': 'Plus 30GB', 'data_gb': 30, 'base_price': 25},
        {'name': 'Unlimited', 'data_gb': 999, 'base_price': 35},
        {'name': '5G Unlimited', 'data_gb': 999, 'base_price': 45},
    ]
    
    for comp in UK_COMPETITORS:
        for plan in plan_templates:
            # Price variation by competitor
            price_mult = random.uniform(0.9, 1.15)
            pricing.append({
                'pricing_id': price_id,
                'competitor_name': comp['name'],
                'plan_name': f"{comp['name'].split()[0]} {plan['name']}",
                'data_allowance_gb': plan['data_gb'],
                'monthly_price': round(plan['base_price'] * price_mult, 2),
                'includes_5g': '5G' in plan['name'],
                'contract_months': random.choice([0, 12, 24]),
                'includes_roaming': random.choice([True, False]),
                'effective_date': '2025-01-01',
            })
            price_id += 1
    
    return pd.DataFrame(pricing)

# ============================================================================
# TECHNICIAN DIMENSION
# ============================================================================

def generate_technician_dim(num_technicians=200):
    """Generate field technician dimension."""
    first_names = ['James', 'John', 'Robert', 'Michael', 'David', 'William', 'Richard', 'Joseph',
                   'Emma', 'Olivia', 'Sarah', 'Sophie', 'Emily', 'Grace', 'Chloe', 'Jessica']
    last_names = ['Smith', 'Jones', 'Williams', 'Taylor', 'Brown', 'Davies', 'Evans', 'Wilson',
                  'Thomas', 'Johnson', 'Roberts', 'Walker', 'Wright', 'Thompson', 'White', 'Hughes']
    
    specializations = ['Installation', 'Repair', 'Network', 'Fibre', 'Enterprise', 'RAN']
    skill_levels = ['Junior', 'Intermediate', 'Senior', 'Expert']
    regions = ['London', 'South East', 'South West', 'Midlands', 'North West', 'North East', 
               'Scotland', 'Wales', 'Northern Ireland']
    
    technicians = []
    for i in range(1, num_technicians + 1):
        hire_date = START_DATE - timedelta(days=random.randint(30, 3000))
        technicians.append({
            'technician_id': i,
            'technician_name': f"{random.choice(first_names)} {random.choice(last_names)}",
            'employee_id': f"EMP{10000 + i}",
            'specialization': random.choice(specializations),
            'skill_level': random.choices(skill_levels, weights=[0.2, 0.35, 0.30, 0.15])[0],
            'region': random.choice(regions),
            'hire_date': hire_date.strftime('%Y-%m-%d'),
            'certification_count': random.randint(1, 8),
            'avg_csat_score': round(random.uniform(3.5, 5.0), 2),
            'status': random.choices(['Active', 'On Leave', 'Training'], weights=[0.9, 0.05, 0.05])[0],
        })
    
    return pd.DataFrame(technicians)

# ============================================================================
# CUSTOMER JOURNEY FACT
# ============================================================================

def generate_customer_journey_fact(subscribers_df, num_records=500000):
    """Generate customer journey touchpoint data."""
    
    journey_stages = ['Awareness', 'Consideration', 'Purchase', 'Onboarding', 
                      'Usage', 'Support', 'Renewal', 'Advocacy']
    
    channels = ['Website', 'Mobile App', 'Retail Store', 'Call Center', 'Social Media',
                'Email', 'SMS', 'Chat', 'Partner', 'Self-Service Portal']
    
    interaction_types = {
        'Awareness': ['Ad View', 'Search', 'Social Post View', 'Referral'],
        'Consideration': ['Plan Comparison', 'Coverage Check', 'Price Quote', 'Reviews Read'],
        'Purchase': ['Order Placed', 'Contract Signed', 'Payment Made', 'Device Selected'],
        'Onboarding': ['SIM Activated', 'App Downloaded', 'Tutorial Completed', 'First Call'],
        'Usage': ['Data Used', 'Call Made', 'Top-up', 'Plan Change', 'Roaming'],
        'Support': ['Ticket Opened', 'Chat Started', 'FAQ Viewed', 'Complaint Filed'],
        'Renewal': ['Offer Viewed', 'Contract Extended', 'Upgrade Considered', 'Loyalty Reward'],
        'Advocacy': ['Review Written', 'Referral Made', 'Social Share', 'Survey Completed'],
    }
    
    journey_data = []
    subscriber_keys = subscribers_df['subscriber_key'].tolist()
    
    for i in range(1, num_records + 1):
        subscriber_key = random.choice(subscriber_keys)
        stage = random.choices(journey_stages, 
                               weights=[0.05, 0.08, 0.10, 0.12, 0.35, 0.20, 0.07, 0.03])[0]
        
        interaction_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        
        # Sentiment based on stage
        if stage in ['Purchase', 'Advocacy']:
            sentiment = random.choices([-1, 0, 1], weights=[0.05, 0.15, 0.80])[0]
        elif stage == 'Support':
            sentiment = random.choices([-1, 0, 1], weights=[0.25, 0.35, 0.40])[0]
        else:
            sentiment = random.choices([-1, 0, 1], weights=[0.10, 0.30, 0.60])[0]
        
        journey_data.append({
            'journey_id': i,
            'subscriber_key': subscriber_key,
            'journey_stage': stage,
            'channel': random.choice(channels),
            'interaction_type': random.choice(interaction_types[stage]),
            'interaction_timestamp': interaction_date.strftime('%Y-%m-%d %H:%M:%S'),
            'interaction_date': interaction_date.strftime('%Y-%m-%d'),
            'sentiment_score': sentiment,
            'effort_score': random.randint(1, 5),
            'resolution_achieved': random.choices([True, False], weights=[0.75, 0.25])[0],
            'session_duration_secs': random.randint(10, 1800),
            'page_views': random.randint(1, 20) if random.random() > 0.3 else None,
            'conversion_flag': random.choices([True, False], weights=[0.15, 0.85])[0],
        })
    
    return pd.DataFrame(journey_data)

# ============================================================================
# NETWORK QoE FACT
# ============================================================================

def generate_network_qoe_fact(subscribers_df, cells_df, num_records=600000):
    """Generate network quality of experience data."""
    
    apps = ['General Browsing', 'YouTube', 'Netflix', 'TikTok', 'Instagram', 
            'Microsoft Teams', 'Zoom', 'WhatsApp', 'Spotify', 'Gaming', 'Email']
    
    qoe_data = []
    subscriber_keys = subscribers_df['subscriber_key'].tolist()
    cell_ids = cells_df['cell_id'].tolist()
    
    # Get subscriber network generation
    sub_network = subscribers_df.set_index('subscriber_key')['network_generation'].to_dict()
    
    for i in range(1, num_records + 1):
        subscriber_key = random.choice(subscriber_keys)
        cell_id = random.choice(cell_ids)
        
        measurement_time = START_DATE + timedelta(
            days=random.randint(0, TOTAL_DAYS),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59)
        )
        
        # Speed based on network generation
        network_gen = sub_network.get(subscriber_key, '4G')
        if network_gen == '5G':
            download_speed = random.uniform(50, 500)
            upload_speed = random.uniform(10, 100)
            latency = random.uniform(5, 30)
        elif network_gen == '4G':
            download_speed = random.uniform(10, 100)
            upload_speed = random.uniform(5, 30)
            latency = random.uniform(20, 80)
        else:  # 3G
            download_speed = random.uniform(1, 20)
            upload_speed = random.uniform(0.5, 5)
            latency = random.uniform(50, 200)
        
        # Add some variation
        download_speed *= random.uniform(0.5, 1.2)
        
        # Video quality score (1-5)
        if download_speed > 25:
            video_quality = random.choices([3, 4, 5], weights=[0.1, 0.3, 0.6])[0]
        elif download_speed > 5:
            video_quality = random.choices([2, 3, 4], weights=[0.2, 0.5, 0.3])[0]
        else:
            video_quality = random.choices([1, 2, 3], weights=[0.3, 0.5, 0.2])[0]
        
        # Voice MOS score (1-5)
        if latency < 50:
            voice_mos = round(random.uniform(3.8, 4.5), 1)
        elif latency < 100:
            voice_mos = round(random.uniform(3.0, 4.0), 1)
        else:
            voice_mos = round(random.uniform(2.0, 3.5), 1)
        
        qoe_data.append({
            'qoe_id': i,
            'subscriber_key': subscriber_key,
            'cell_id': cell_id,
            'measurement_timestamp': measurement_time.strftime('%Y-%m-%d %H:%M:%S'),
            'measurement_date': measurement_time.strftime('%Y-%m-%d'),
            'measurement_hour': measurement_time.hour,
            'download_speed_mbps': round(download_speed, 2),
            'upload_speed_mbps': round(upload_speed, 2),
            'latency_ms': round(latency, 1),
            'jitter_ms': round(random.uniform(1, 20), 1),
            'packet_loss_pct': round(random.uniform(0, 2), 3),
            'video_quality_score': video_quality,
            'voice_mos_score': voice_mos,
            'app_category': random.choice(apps),
            'connection_type': network_gen,
            'signal_strength_dbm': random.randint(-110, -60),
        })
    
    return pd.DataFrame(qoe_data)

# ============================================================================
# CUSTOMER PROPENSITY SCORES
# ============================================================================

def generate_propensity_scores(subscribers_df):
    """Generate ML propensity scores for all subscribers."""
    
    propensity_data = []
    
    for _, sub in subscribers_df.iterrows():
        # Churn risk based on various factors
        base_churn_risk = 0.15
        
        # Adjust based on status
        if sub['status'] == 'Churned':
            churn_risk = 0.95
        else:
            # Adjust based on tenure
            try:
                activation = pd.to_datetime(sub['activation_date'])
                tenure_days = (END_DATE - activation).days
                if tenure_days < 180:
                    base_churn_risk += 0.15  # New customers higher risk
                elif tenure_days > 1095:  # 3 years
                    base_churn_risk -= 0.08  # Long tenure lower risk
            except:
                pass
            
            # Adjust based on segment
            if sub['customer_segment'] == 'VIP':
                base_churn_risk -= 0.05
            elif sub['customer_segment'] == 'Budget':
                base_churn_risk += 0.08
            
            churn_risk = min(0.95, max(0.02, base_churn_risk + random.uniform(-0.1, 0.1)))
        
        # Upsell propensity (higher for engaged, lower for at-risk)
        upsell_propensity = max(0.05, min(0.90, 0.50 - churn_risk + random.uniform(-0.15, 0.15)))
        
        # Cross-sell propensity
        cross_sell_propensity = random.uniform(0.10, 0.60)
        
        # Predicted CLV (Customer Lifetime Value)
        if sub['customer_type'] == 'Enterprise':
            base_clv = random.uniform(50000, 200000)
        elif sub['customer_type'] == 'SMB':
            base_clv = random.uniform(5000, 30000)
        else:
            base_clv = random.uniform(500, 5000)
        
        # Adjust CLV by churn risk
        predicted_clv = base_clv * (1 - churn_risk * 0.5)
        
        # Next best action
        if churn_risk > 0.6:
            nba = random.choice(['Retention Offer', 'Loyalty Reward', 'Service Recovery', 'Personal Call'])
        elif upsell_propensity > 0.5:
            nba = random.choice(['5G Upgrade', 'Plan Upgrade', 'Device Offer', 'Add-on Service'])
        else:
            nba = random.choice(['Engagement Campaign', 'App Promotion', 'Referral Program', 'Survey'])
        
        propensity_data.append({
            'subscriber_key': sub['subscriber_key'],
            'score_date': END_DATE.strftime('%Y-%m-%d'),
            'churn_risk_score': round(churn_risk, 4),
            'churn_risk_band': 'High' if churn_risk > 0.5 else 'Medium' if churn_risk > 0.25 else 'Low',
            'upsell_propensity': round(upsell_propensity, 4),
            'cross_sell_propensity': round(cross_sell_propensity, 4),
            'predicted_clv': round(predicted_clv, 2),
            'clv_segment': 'High' if predicted_clv > 10000 else 'Medium' if predicted_clv > 2000 else 'Low',
            'next_best_action': nba,
            'model_version': 'v2.3.1',
            'confidence_score': round(random.uniform(0.70, 0.95), 2),
        })
    
    return pd.DataFrame(propensity_data)

# ============================================================================
# FIELD VISIT FACT
# ============================================================================

def generate_field_visit_fact(subscribers_df, sites_df, technicians_df, num_records=100000):
    """Generate field service visit data."""
    
    visit_types = ['Installation', 'Repair', 'Maintenance', 'Upgrade', 'Inspection', 'Emergency']
    visit_type_weights = [0.25, 0.30, 0.20, 0.15, 0.05, 0.05]
    
    outcomes = ['Completed', 'Partial', 'Rescheduled', 'Customer Not Home', 'Parts Required']
    
    visit_data = []
    subscriber_keys = subscribers_df['subscriber_key'].tolist()
    site_ids = sites_df['site_id'].tolist()
    technician_ids = technicians_df['technician_id'].tolist()
    
    for i in range(1, num_records + 1):
        visit_type = random.choices(visit_types, weights=visit_type_weights)[0]
        visit_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        
        # Scheduled time (business hours)
        scheduled_hour = random.randint(8, 17)
        scheduled_time = visit_date.replace(hour=scheduled_hour, minute=random.choice([0, 30]))
        
        # Arrival time (may be late)
        delay_mins = random.choices([0, 15, 30, 60, 120], weights=[0.5, 0.25, 0.15, 0.07, 0.03])[0]
        arrival_time = scheduled_time + timedelta(minutes=delay_mins + random.randint(-5, 5))
        
        # Duration based on visit type
        duration_mins = {
            'Installation': random.randint(60, 180),
            'Repair': random.randint(30, 120),
            'Maintenance': random.randint(45, 90),
            'Upgrade': random.randint(30, 90),
            'Inspection': random.randint(20, 45),
            'Emergency': random.randint(60, 240),
        }[visit_type]
        
        completion_time = arrival_time + timedelta(minutes=duration_mins)
        
        # Outcome
        outcome = random.choices(outcomes, weights=[0.75, 0.10, 0.08, 0.05, 0.02])[0]
        first_time_fix = outcome == 'Completed' and random.random() > 0.15
        
        # Cost
        labor_cost = duration_mins * random.uniform(0.5, 1.2)  # £0.50-1.20 per minute
        parts_cost = random.choice([0, 0, 0, 25, 50, 100, 200, 500]) if visit_type != 'Inspection' else 0
        
        # Customer or site visit
        is_customer_visit = visit_type in ['Installation', 'Repair', 'Upgrade']
        
        visit_data.append({
            'visit_id': i,
            'technician_id': random.choice(technician_ids),
            'subscriber_key': random.choice(subscriber_keys) if is_customer_visit else None,
            'site_id': random.choice(site_ids) if not is_customer_visit else None,
            'visit_type': visit_type,
            'visit_date': visit_date.strftime('%Y-%m-%d'),
            'scheduled_time': scheduled_time.strftime('%Y-%m-%d %H:%M:%S'),
            'arrival_time': arrival_time.strftime('%Y-%m-%d %H:%M:%S'),
            'completion_time': completion_time.strftime('%Y-%m-%d %H:%M:%S'),
            'duration_mins': duration_mins,
            'delay_mins': max(0, delay_mins),
            'outcome': outcome,
            'first_time_fix': first_time_fix,
            'labor_cost': round(labor_cost, 2),
            'parts_cost': round(parts_cost, 2),
            'total_cost': round(labor_cost + parts_cost, 2),
            'csat_score': random.randint(1, 5) if outcome == 'Completed' else None,
            'sla_met': delay_mins <= 30 and outcome in ['Completed', 'Partial'],
        })
    
    return pd.DataFrame(visit_data)

# ============================================================================
# MARKET SHARE FACT
# ============================================================================

def generate_market_share_fact():
    """Generate monthly market share data."""
    
    market_data = []
    record_id = 1
    
    regions = ['UK Total', 'London', 'South East', 'South West', 'Midlands', 
               'North West', 'North East', 'Scotland', 'Wales', 'Northern Ireland']
    
    current_date = START_DATE
    while current_date <= END_DATE:
        for region in regions:
            for comp in UK_COMPETITORS:
                # Base market share with regional variation
                base_share = comp['market_share']
                if region != 'UK Total':
                    base_share *= random.uniform(0.7, 1.3)
                
                # Monthly variation
                share = base_share * random.uniform(0.97, 1.03)
                
                # Subscriber count (UK has ~90M mobile connections)
                if region == 'UK Total':
                    total_market = 90000000
                else:
                    total_market = random.randint(3000000, 15000000)
                
                subscriber_count = int(total_market * share)
                
                # Net adds
                net_adds = random.randint(-50000, 100000)
                if comp['name'] == 'SnowTelco':
                    net_adds = abs(net_adds)  # SnowTelco is growing
                
                # ARPU
                if comp['type'] == 'MNO':
                    arpu = random.uniform(18, 28)
                else:
                    arpu = random.uniform(12, 18)
                
                market_data.append({
                    'record_id': record_id,
                    'report_date': current_date.strftime('%Y-%m-%d'),
                    'report_month': current_date.strftime('%Y-%m'),
                    'region': region,
                    'competitor_name': comp['name'],
                    'competitor_type': comp['type'],
                    'subscriber_count': subscriber_count,
                    'market_share_pct': round(share * 100, 2),
                    'net_adds': net_adds,
                    'arpu': round(arpu, 2),
                    'churn_rate_pct': round(random.uniform(1.0, 2.5), 2),
                })
                record_id += 1
        
        # Move to next month
        if current_date.month == 12:
            current_date = current_date.replace(year=current_date.year + 1, month=1)
        else:
            current_date = current_date.replace(month=current_date.month + 1)
    
    return pd.DataFrame(market_data)

# ============================================================================
# SOCIAL MENTION FACT
# ============================================================================

def generate_social_mention_fact(num_records=50000):
    """Generate social media mention data."""
    
    platforms = ['Twitter/X', 'Facebook', 'Instagram', 'LinkedIn', 'Trustpilot', 
                 'Reddit', 'YouTube', 'TikTok', 'Google Reviews']
    
    topics = ['Network Quality', 'Customer Service', 'Pricing', 'Billing', '5G Coverage',
              'App Experience', 'Store Experience', 'Promotions', 'Device', 'General']
    
    # Sample mention templates
    positive_mentions = [
        "Great 5G speeds with @SnowTelco today!",
        "Finally got my issue resolved. Thanks SnowTelco support!",
        "Switched to SnowTelco last month, best decision ever",
        "Love the new SnowTelco app update",
        "SnowTelco customer service was amazing today",
    ]
    
    negative_mentions = [
        "No signal again @SnowTelco, this is ridiculous",
        "Been on hold with SnowTelco for 45 minutes",
        "SnowTelco billing is a nightmare",
        "Worst network coverage I've ever had",
        "Thinking of leaving SnowTelco after this experience",
    ]
    
    neutral_mentions = [
        "Anyone else use SnowTelco? Thoughts?",
        "Comparing SnowTelco vs EE plans today",
        "SnowTelco store in town looks busy",
        "Got a text from SnowTelco about new plans",
        "SnowTelco 5G now available in my area apparently",
    ]
    
    mention_data = []
    
    for i in range(1, num_records + 1):
        mention_date = START_DATE + timedelta(
            days=random.randint(0, TOTAL_DAYS),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59)
        )
        
        # Sentiment distribution (slightly more negative on social - people complain more)
        sentiment = random.choices(['positive', 'negative', 'neutral'], 
                                   weights=[0.35, 0.40, 0.25])[0]
        
        if sentiment == 'positive':
            content = random.choice(positive_mentions)
            sentiment_score = random.uniform(0.5, 1.0)
        elif sentiment == 'negative':
            content = random.choice(negative_mentions)
            sentiment_score = random.uniform(-1.0, -0.3)
        else:
            content = random.choice(neutral_mentions)
            sentiment_score = random.uniform(-0.3, 0.3)
        
        platform = random.choice(platforms)
        
        # Reach varies by platform
        if platform in ['Twitter/X', 'TikTok']:
            reach = random.randint(10, 100000)
        elif platform in ['YouTube', 'Reddit']:
            reach = random.randint(50, 50000)
        else:
            reach = random.randint(5, 5000)
        
        mention_data.append({
            'mention_id': i,
            'platform': platform,
            'mention_timestamp': mention_date.strftime('%Y-%m-%d %H:%M:%S'),
            'mention_date': mention_date.strftime('%Y-%m-%d'),
            'content_snippet': content,
            'sentiment': sentiment,
            'sentiment_score': round(sentiment_score, 3),
            'topic': random.choice(topics),
            'reach_count': reach,
            'engagement_count': int(reach * random.uniform(0.01, 0.15)),
            'is_influencer': reach > 10000,
            'requires_response': sentiment == 'negative' and random.random() > 0.3,
            'responded': random.choices([True, False], weights=[0.6, 0.4])[0] if sentiment == 'negative' else False,
            'response_time_mins': random.randint(5, 480) if sentiment == 'negative' else None,
        })
    
    return pd.DataFrame(mention_data)

# ============================================================================
# ENERGY & SUSTAINABILITY DATA
# ============================================================================

def generate_energy_consumption_fact(sites_df):
    """Generate energy consumption data for RAN sites."""
    
    energy_data = []
    record_id = 1
    
    current_date = START_DATE
    while current_date <= END_DATE:
        for _, site in sites_df.iterrows():
            # Base energy consumption by site type
            base_kwh = {
                'Macro': random.uniform(800, 1500),
                'Small': random.uniform(100, 300),
                'DAS': random.uniform(50, 150),
                'Rural': random.uniform(600, 1200),
                'Rooftop': random.uniform(200, 500),
            }.get(site['site_type'], 500)
            
            # Seasonal variation (higher in summer for cooling)
            month = current_date.month
            if month in [6, 7, 8]:
                seasonal_mult = 1.15
            elif month in [12, 1, 2]:
                seasonal_mult = 1.05
            else:
                seasonal_mult = 1.0
            
            daily_kwh = base_kwh * seasonal_mult * random.uniform(0.9, 1.1)
            
            # Renewable percentage (improving over time)
            days_from_start = (current_date - START_DATE).days
            renewable_pct = min(75, 40 + (days_from_start / TOTAL_DAYS) * 20 + random.uniform(-5, 5))
            
            # PUE (Power Usage Effectiveness) - lower is better
            pue = random.uniform(1.3, 1.8)
            
            # Carbon emissions (kg CO2)
            # UK grid: ~0.2 kg CO2 per kWh, renewable is near zero
            grid_kwh = daily_kwh * (1 - renewable_pct / 100)
            carbon_kg = grid_kwh * 0.2
            
            energy_data.append({
                'record_id': record_id,
                'site_id': site['site_id'],
                'measurement_date': current_date.strftime('%Y-%m-%d'),
                'energy_kwh': round(daily_kwh, 2),
                'renewable_kwh': round(daily_kwh * renewable_pct / 100, 2),
                'grid_kwh': round(grid_kwh, 2),
                'renewable_pct': round(renewable_pct, 1),
                'carbon_emissions_kg': round(carbon_kg, 2),
                'pue_ratio': round(pue, 2),
                'cooling_kwh': round(daily_kwh * random.uniform(0.2, 0.4), 2),
                'equipment_kwh': round(daily_kwh * random.uniform(0.5, 0.7), 2),
            })
            record_id += 1
        
        # Weekly data to keep size manageable
        current_date += timedelta(days=7)
    
    return pd.DataFrame(energy_data)

def generate_sustainability_metrics():
    """Generate company-level sustainability metrics."""
    
    metrics_data = []
    record_id = 1
    
    current_date = START_DATE
    while current_date <= END_DATE:
        # Monthly metrics
        days_from_start = (current_date - START_DATE).days
        progress_factor = days_from_start / TOTAL_DAYS
        
        metrics_data.append({
            'record_id': record_id,
            'metric_date': current_date.strftime('%Y-%m-%d'),
            'metric_month': current_date.strftime('%Y-%m'),
            'total_energy_mwh': round(random.uniform(15000, 20000) * (1 - progress_factor * 0.1), 0),
            'renewable_energy_pct': round(40 + progress_factor * 25 + random.uniform(-2, 2), 1),
            'total_carbon_tonnes': round(random.uniform(3000, 4000) * (1 - progress_factor * 0.15), 0),
            'carbon_intensity': round(random.uniform(0.15, 0.25) * (1 - progress_factor * 0.1), 3),
            'e_waste_recycled_tonnes': round(random.uniform(50, 150), 1),
            'e_waste_recycled_pct': round(85 + progress_factor * 10 + random.uniform(-2, 2), 1),
            'water_usage_m3': round(random.uniform(5000, 8000), 0),
            'green_tariff_subscribers': int(30000 * (0.1 + progress_factor * 0.15)),
            'sustainability_score': round(60 + progress_factor * 20 + random.uniform(-3, 3), 1),
            'net_zero_progress_pct': round(progress_factor * 30 + random.uniform(-2, 2), 1),
        })
        record_id += 1
        
        # Monthly
        if current_date.month == 12:
            current_date = current_date.replace(year=current_date.year + 1, month=1)
        else:
            current_date = current_date.replace(month=current_date.month + 1)
    
    return pd.DataFrame(metrics_data)

# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    """Main function to generate all enhanced data."""
    print("=" * 70)
    print("SnowTelco Enhanced Data Generator")
    print("=" * 70)
    
    # Ensure output directory exists
    os.makedirs(DEMO_DATA_PATH, exist_ok=True)
    
    # Load existing data
    print("\nLoading existing data for consistency...")
    existing = load_existing_data()
    
    # Generate dimension tables
    print("\n" + "-" * 50)
    print("GENERATING DIMENSION TABLES")
    print("-" * 50)
    
    # Competitor Dimension
    print("\n[1/10] Generating competitor_dim...")
    competitor_dim = generate_competitor_dim()
    competitor_dim.to_csv(os.path.join(DEMO_DATA_PATH, 'competitor_dim.csv'), index=False)
    print(f"        Created {len(competitor_dim)} competitors")
    
    # Competitor Pricing
    print("\n[2/10] Generating competitor_pricing_dim...")
    pricing_dim = generate_competitor_pricing_dim()
    pricing_dim.to_csv(os.path.join(DEMO_DATA_PATH, 'competitor_pricing_dim.csv'), index=False)
    print(f"        Created {len(pricing_dim)} pricing records")
    
    # Technician Dimension
    print("\n[3/10] Generating technician_dim...")
    technician_dim = generate_technician_dim(200)
    technician_dim.to_csv(os.path.join(DEMO_DATA_PATH, 'technician_dim.csv'), index=False)
    print(f"        Created {len(technician_dim)} technicians")
    
    # Generate fact tables
    print("\n" + "-" * 50)
    print("GENERATING FACT TABLES")
    print("-" * 50)
    
    # Customer Journey
    print("\n[4/10] Generating customer_journey_fact...")
    journey_fact = generate_customer_journey_fact(existing['subscribers'], 500000)
    journey_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'customer_journey_fact.csv'), index=False)
    print(f"        Created {len(journey_fact):,} journey records")
    
    # Network QoE
    print("\n[5/10] Generating network_qoe_fact...")
    qoe_fact = generate_network_qoe_fact(existing['subscribers'], existing['ran_cells'], 600000)
    qoe_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'network_qoe_fact.csv'), index=False)
    print(f"        Created {len(qoe_fact):,} QoE records")
    
    # Propensity Scores
    print("\n[6/10] Generating customer_propensity_scores...")
    propensity = generate_propensity_scores(existing['subscribers'])
    propensity.to_csv(os.path.join(DEMO_DATA_PATH, 'customer_propensity_scores.csv'), index=False)
    print(f"        Created {len(propensity):,} propensity records")
    
    # Field Visits
    print("\n[7/10] Generating field_visit_fact...")
    field_fact = generate_field_visit_fact(existing['subscribers'], existing['ran_sites'], technician_dim, 100000)
    field_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'field_visit_fact.csv'), index=False)
    print(f"        Created {len(field_fact):,} field visit records")
    
    # Market Share
    print("\n[8/10] Generating market_share_fact...")
    market_fact = generate_market_share_fact()
    market_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'market_share_fact.csv'), index=False)
    print(f"        Created {len(market_fact):,} market share records")
    
    # Social Mentions
    print("\n[9/10] Generating social_mention_fact...")
    social_fact = generate_social_mention_fact(50000)
    social_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'social_mention_fact.csv'), index=False)
    print(f"        Created {len(social_fact):,} social mention records")
    
    # Energy & Sustainability
    print("\n[10/10] Generating energy & sustainability data...")
    energy_fact = generate_energy_consumption_fact(existing['ran_sites'])
    energy_fact.to_csv(os.path.join(DEMO_DATA_PATH, 'energy_consumption_fact.csv'), index=False)
    print(f"         Created {len(energy_fact):,} energy records")
    
    sustainability = generate_sustainability_metrics()
    sustainability.to_csv(os.path.join(DEMO_DATA_PATH, 'sustainability_metrics.csv'), index=False)
    print(f"         Created {len(sustainability)} sustainability records")
    
    # Summary
    print("\n" + "=" * 70)
    print("ENHANCED DATA GENERATION COMPLETE!")
    print("=" * 70)
    print(f"\nNew files created in {DEMO_DATA_PATH}:")
    print(f"  Dimensions:")
    print(f"    - competitor_dim.csv            ({len(competitor_dim)} records)")
    print(f"    - competitor_pricing_dim.csv    ({len(pricing_dim)} records)")
    print(f"    - technician_dim.csv            ({len(technician_dim)} records)")
    print(f"  Facts:")
    print(f"    - customer_journey_fact.csv     ({len(journey_fact):,} records)")
    print(f"    - network_qoe_fact.csv          ({len(qoe_fact):,} records)")
    print(f"    - customer_propensity_scores.csv ({len(propensity):,} records)")
    print(f"    - field_visit_fact.csv          ({len(field_fact):,} records)")
    print(f"    - market_share_fact.csv         ({len(market_fact):,} records)")
    print(f"    - social_mention_fact.csv       ({len(social_fact):,} records)")
    print(f"    - energy_consumption_fact.csv   ({len(energy_fact):,} records)")
    print(f"    - sustainability_metrics.csv    ({len(sustainability)} records)")
    
    total_new = (len(competitor_dim) + len(pricing_dim) + len(technician_dim) + 
                 len(journey_fact) + len(qoe_fact) + len(propensity) + 
                 len(field_fact) + len(market_fact) + len(social_fact) + 
                 len(energy_fact) + len(sustainability))
    print(f"\n  TOTAL NEW RECORDS: {total_new:,}")


if __name__ == '__main__':
    main()
