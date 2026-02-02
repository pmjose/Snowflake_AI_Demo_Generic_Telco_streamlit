#!/usr/bin/env python3
"""
Generate additional demo data for SnowTelco:
1. Fraud Detection Data - Security use case
2. B2B Contract Renewals - Enterprise sales use case  
3. Wholesale/MVNO Data - SnowTelco as MNO with MVNO customers

Author: Demo Generator
Date: January 2026
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# Set random seed for reproducibility
np.random.seed(42)
random.seed(42)

# Output directory
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'demo_data')

# Date range
START_DATE = datetime(2025, 1, 1)
END_DATE = datetime(2026, 2, 28)
TOTAL_DAYS = (END_DATE - START_DATE).days

# ============================================================================
# 1. FRAUD DETECTION DATA
# ============================================================================

def generate_fraud_type_dim():
    """Generate fraud type dimension table."""
    fraud_types = [
        {'fraud_type_id': 1, 'fraud_type': 'SIM Swap Fraud', 'category': 'Identity', 'severity': 'Critical', 'description': 'Unauthorized SIM swap to take over account'},
        {'fraud_type_id': 2, 'fraud_type': 'Subscription Fraud', 'category': 'Identity', 'severity': 'High', 'description': 'Fake identity used to open accounts'},
        {'fraud_type_id': 3, 'fraud_type': 'International Revenue Share Fraud', 'category': 'Traffic', 'severity': 'Critical', 'description': 'Artificially inflated calls to premium numbers'},
        {'fraud_type_id': 4, 'fraud_type': 'Wangiri Fraud', 'category': 'Traffic', 'severity': 'Medium', 'description': 'One-ring scam to premium numbers'},
        {'fraud_type_id': 5, 'fraud_type': 'Roaming Fraud', 'category': 'Traffic', 'severity': 'High', 'description': 'Unauthorized roaming usage'},
        {'fraud_type_id': 6, 'fraud_type': 'Device Fraud', 'category': 'Device', 'severity': 'Medium', 'description': 'Stolen or cloned devices'},
        {'fraud_type_id': 7, 'fraud_type': 'Internal Fraud', 'category': 'Internal', 'severity': 'Critical', 'description': 'Employee-assisted fraud'},
        {'fraud_type_id': 8, 'fraud_type': 'PBX Hacking', 'category': 'Traffic', 'severity': 'High', 'description': 'Compromised business phone systems'},
        {'fraud_type_id': 9, 'fraud_type': 'Dealer Fraud', 'category': 'Channel', 'severity': 'High', 'description': 'Fraudulent dealer activations'},
        {'fraud_type_id': 10, 'fraud_type': 'Credit Muling', 'category': 'Identity', 'severity': 'Medium', 'description': 'Third party opens accounts for fraudsters'},
        {'fraud_type_id': 11, 'fraud_type': 'Account Takeover', 'category': 'Identity', 'severity': 'Critical', 'description': 'Unauthorized access to customer accounts'},
        {'fraud_type_id': 12, 'fraud_type': 'Bypass Fraud', 'category': 'Traffic', 'severity': 'High', 'description': 'SIM boxes routing international calls as local'},
    ]
    return pd.DataFrame(fraud_types)


def generate_fraud_case_fact(num_cases=15000):
    """Generate fraud detection fact table."""
    
    detection_methods = ['ML Model', 'Rule Engine', 'Customer Report', 'Partner Alert', 'Manual Review', 'Real-time Monitor']
    detection_weights = [0.35, 0.25, 0.15, 0.10, 0.08, 0.07]
    
    statuses = ['Detected', 'Investigating', 'Confirmed', 'Resolved', 'False Positive', 'Escalated']
    status_weights = [0.10, 0.12, 0.25, 0.35, 0.13, 0.05]
    
    resolution_types = ['Account Blocked', 'Refund Issued', 'Law Enforcement', 'Customer Warned', 'No Action', 'Write-off']
    
    uk_cities = ['London', 'Manchester', 'Birmingham', 'Leeds', 'Glasgow', 'Liverpool', 'Bristol', 'Sheffield', 
                 'Edinburgh', 'Cardiff', 'Belfast', 'Newcastle', 'Nottingham', 'Southampton', 'Leicester']
    
    fraud_data = []
    
    for i in range(1, num_cases + 1):
        fraud_type_id = random.choices(range(1, 13), weights=[0.15, 0.12, 0.10, 0.08, 0.08, 0.10, 0.03, 0.07, 0.08, 0.06, 0.08, 0.05])[0]
        detection_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        
        # Amount varies by fraud type
        if fraud_type_id in [3, 5, 8]:  # Traffic fraud - higher amounts
            amount = round(random.uniform(500, 50000), 2)
        elif fraud_type_id in [1, 2, 11]:  # Identity fraud - medium amounts
            amount = round(random.uniform(100, 5000), 2)
        else:
            amount = round(random.uniform(50, 2000), 2)
        
        status = random.choices(statuses, weights=status_weights)[0]
        
        # Resolution only if resolved
        resolution = random.choice(resolution_types) if status in ['Resolved', 'Confirmed'] else None
        resolution_date = (detection_date + timedelta(days=random.randint(1, 30))).strftime('%Y-%m-%d') if status == 'Resolved' else None
        
        # ML confidence score
        detection_method = random.choices(detection_methods, weights=detection_weights)[0]
        ml_confidence = round(random.uniform(0.65, 0.99), 2) if detection_method == 'ML Model' else None
        
        # Prevented vs actual loss
        prevented = status in ['Detected', 'Resolved', 'Confirmed']
        actual_loss = 0 if prevented else round(amount * random.uniform(0.3, 0.8), 2)
        prevented_loss = amount if prevented else round(amount * random.uniform(0.2, 0.5), 2)
        
        fraud_data.append({
            'fraud_case_id': i,
            'fraud_type_id': fraud_type_id,
            'detection_date': detection_date.strftime('%Y-%m-%d'),
            'detection_timestamp': (detection_date + timedelta(hours=random.randint(0, 23), minutes=random.randint(0, 59))).strftime('%Y-%m-%d %H:%M:%S'),
            'detection_method': detection_method,
            'ml_confidence_score': ml_confidence,
            'subscriber_key': random.randint(1, 30000),
            'msisdn': f'447{random.randint(100000000, 999999999)}',
            'suspected_amount': amount,
            'actual_loss': actual_loss,
            'prevented_loss': prevented_loss,
            'status': status,
            'resolution_type': resolution,
            'resolution_date': resolution_date,
            'investigating_team': random.choice(['Fraud Ops', 'Revenue Assurance', 'Security', 'External Partner']),
            'city': random.choice(uk_cities),
            'risk_score': random.randint(60, 100),
            'is_repeat_offender': random.choices([True, False], weights=[0.15, 0.85])[0],
        })
    
    return pd.DataFrame(fraud_data)


# ============================================================================
# 2. B2B CONTRACT RENEWALS
# ============================================================================

def generate_b2b_contract_fact(num_contracts=5000):
    """Generate B2B contract renewals fact table."""
    
    contract_types = ['UCaaS', 'CCaaS', 'SIP Trunking', 'SD-WAN', 'Managed Security', 'Business Mobile', 'IoT Connectivity', 'Business Broadband']
    contract_weights = [0.20, 0.15, 0.15, 0.12, 0.10, 0.12, 0.08, 0.08]
    
    renewal_statuses = ['Active', 'Pending Renewal', 'In Negotiation', 'Renewed', 'Churned', 'Upgraded', 'Downgraded']
    
    industries = ['Financial Services', 'Healthcare', 'Retail', 'Manufacturing', 'Technology', 'Professional Services', 
                  'Education', 'Government', 'Hospitality', 'Transport']
    
    uk_regions = ['London', 'South East', 'North West', 'West Midlands', 'Yorkshire', 'Scotland', 'East', 'South West', 'Wales', 'Northern Ireland']
    
    contract_data = []
    
    for i in range(1, num_contracts + 1):
        contract_type = random.choices(contract_types, weights=contract_weights)[0]
        
        # Contract value based on type
        if contract_type in ['UCaaS', 'CCaaS']:
            annual_value = round(random.uniform(10000, 500000), 2)
        elif contract_type in ['SD-WAN', 'Managed Security']:
            annual_value = round(random.uniform(20000, 300000), 2)
        else:
            annual_value = round(random.uniform(5000, 100000), 2)
        
        contract_start = START_DATE - timedelta(days=random.randint(0, 730))  # Up to 2 years ago
        contract_term_months = random.choice([12, 24, 36, 60])
        contract_end = contract_start + timedelta(days=contract_term_months * 30)
        
        # Renewal window
        days_to_renewal = (contract_end - datetime.now()).days
        
        if days_to_renewal < -90:
            status = random.choices(['Churned', 'Renewed'], weights=[0.15, 0.85])[0]
        elif days_to_renewal < 0:
            status = random.choices(['Renewed', 'Churned', 'In Negotiation'], weights=[0.70, 0.15, 0.15])[0]
        elif days_to_renewal < 90:
            status = random.choices(['Pending Renewal', 'In Negotiation', 'Renewed'], weights=[0.40, 0.35, 0.25])[0]
        else:
            status = 'Active'
        
        # Renewal probability based on various factors
        base_renewal_prob = 0.85
        if contract_term_months >= 36:
            base_renewal_prob += 0.05
        renewal_probability = round(min(0.99, base_renewal_prob + random.uniform(-0.15, 0.10)), 2)
        
        # Competitor threat
        competitor_threat = random.choices(['None', 'Low', 'Medium', 'High'], weights=[0.40, 0.30, 0.20, 0.10])[0]
        if competitor_threat == 'High':
            renewal_probability = round(renewal_probability * 0.7, 2)
        elif competitor_threat == 'Medium':
            renewal_probability = round(renewal_probability * 0.85, 2)
        
        # Proposed changes
        if status in ['In Negotiation', 'Pending Renewal']:
            proposed_change = random.choices(['Same', 'Upgrade', 'Downgrade', 'Add Services'], weights=[0.40, 0.30, 0.15, 0.15])[0]
            proposed_value_change = {
                'Same': 0,
                'Upgrade': round(annual_value * random.uniform(0.10, 0.40), 2),
                'Downgrade': round(-annual_value * random.uniform(0.10, 0.30), 2),
                'Add Services': round(annual_value * random.uniform(0.15, 0.50), 2)
            }[proposed_change]
        else:
            proposed_change = None
            proposed_value_change = None
        
        contract_data.append({
            'contract_id': f'CON{i:06d}',
            'customer_key': random.randint(1, 5000),
            'account_name': f'Enterprise Customer {i}',
            'industry': random.choice(industries),
            'region': random.choice(uk_regions),
            'contract_type': contract_type,
            'contract_start_date': contract_start.strftime('%Y-%m-%d'),
            'contract_end_date': contract_end.strftime('%Y-%m-%d'),
            'contract_term_months': contract_term_months,
            'annual_contract_value': annual_value,
            'total_contract_value': round(annual_value * (contract_term_months / 12), 2),
            'renewal_status': status,
            'renewal_probability': renewal_probability,
            'days_to_renewal': max(0, days_to_renewal),
            'competitor_threat': competitor_threat,
            'competitor_name': random.choice(['BT', 'Vodafone', 'Virgin Media O2', 'Three', 'TalkTalk']) if competitor_threat != 'None' else None,
            'proposed_change': proposed_change,
            'proposed_value_change': proposed_value_change,
            'account_manager': f'AM{random.randint(1, 50):03d}',
            'nps_score': random.randint(1, 10),
            'support_tickets_ytd': random.randint(0, 50),
            'last_engagement_date': (datetime.now() - timedelta(days=random.randint(1, 90))).strftime('%Y-%m-%d'),
        })
    
    return pd.DataFrame(contract_data)


# ============================================================================
# 3. WHOLESALE / MVNO DATA
# ============================================================================

def generate_mvno_partner_dim():
    """Generate MVNO partner dimension - virtual operators using SnowTelco's network."""
    
    mvno_partners = [
        {'mvno_id': 1, 'mvno_name': 'Giffgaff Mobile', 'mvno_type': 'Full MVNO', 'parent_company': 'Telefonica UK', 'launch_date': '2019-03-15', 'target_segment': 'Youth/Value', 'subscriber_count': 85000, 'status': 'Active'},
        {'mvno_id': 2, 'mvno_name': 'Lebara UK', 'mvno_type': 'Light MVNO', 'parent_company': 'Lebara Group', 'launch_date': '2020-06-01', 'target_segment': 'International Calling', 'subscriber_count': 120000, 'status': 'Active'},
        {'mvno_id': 3, 'mvno_name': 'Lycamobile', 'mvno_type': 'Full MVNO', 'parent_company': 'Lyca Group', 'launch_date': '2018-09-10', 'target_segment': 'Ethnic/International', 'subscriber_count': 95000, 'status': 'Active'},
        {'mvno_id': 4, 'mvno_name': 'SMARTY', 'mvno_type': 'Light MVNO', 'parent_company': 'Three UK', 'launch_date': '2021-01-20', 'target_segment': 'Value Seekers', 'subscriber_count': 45000, 'status': 'Active'},
        {'mvno_id': 5, 'mvno_name': 'Voxi', 'mvno_type': 'Light MVNO', 'parent_company': 'Vodafone UK', 'launch_date': '2020-11-05', 'target_segment': 'Youth/Social Media', 'subscriber_count': 62000, 'status': 'Active'},
        {'mvno_id': 6, 'mvno_name': 'iD Mobile', 'mvno_type': 'Full MVNO', 'parent_company': 'Dixons Carphone', 'launch_date': '2019-07-22', 'target_segment': 'Retail Customers', 'subscriber_count': 78000, 'status': 'Active'},
        {'mvno_id': 7, 'mvno_name': 'Tesco Mobile', 'mvno_type': 'Full MVNO', 'parent_company': 'Tesco PLC', 'launch_date': '2017-04-01', 'target_segment': 'Family/Value', 'subscriber_count': 150000, 'status': 'Active'},
        {'mvno_id': 8, 'mvno_name': 'Asda Mobile', 'mvno_type': 'Light MVNO', 'parent_company': 'Asda Stores', 'launch_date': '2022-02-15', 'target_segment': 'Budget Conscious', 'subscriber_count': 28000, 'status': 'Active'},
        {'mvno_id': 9, 'mvno_name': 'FreedomPop UK', 'mvno_type': 'Light MVNO', 'parent_company': 'FreedomPop Inc', 'launch_date': '2021-08-30', 'target_segment': 'Free/Freemium', 'subscriber_count': 15000, 'status': 'Active'},
        {'mvno_id': 10, 'mvno_name': 'Utility Warehouse', 'mvno_type': 'Full MVNO', 'parent_company': 'Telecom Plus', 'launch_date': '2018-11-12', 'target_segment': 'Bundle Customers', 'subscriber_count': 55000, 'status': 'Active'},
        {'mvno_id': 11, 'mvno_name': 'Ecotalk', 'mvno_type': 'Light MVNO', 'parent_company': 'The Phone Co-op', 'launch_date': '2023-03-01', 'target_segment': 'Eco-Conscious', 'subscriber_count': 8000, 'status': 'Active'},
        {'mvno_id': 12, 'mvno_name': 'TrueConnect', 'mvno_type': 'Light MVNO', 'parent_company': 'Startup Ventures', 'launch_date': '2024-06-15', 'target_segment': 'Digital Natives', 'subscriber_count': 5000, 'status': 'Pilot'},
    ]
    
    # Add more details
    for mvno in mvno_partners:
        mvno['contract_type'] = 'National Roaming' if mvno['mvno_type'] == 'Light MVNO' else 'Full MVNO Agreement'
        mvno['contract_start_date'] = mvno['launch_date']
        mvno['contract_end_date'] = (datetime.strptime(mvno['launch_date'], '%Y-%m-%d') + timedelta(days=365*3)).strftime('%Y-%m-%d')
        mvno['wholesale_rate_voice'] = round(random.uniform(0.008, 0.015), 4)  # Per minute
        mvno['wholesale_rate_sms'] = round(random.uniform(0.005, 0.01), 4)  # Per SMS
        mvno['wholesale_rate_data'] = round(random.uniform(0.50, 1.50), 2)  # Per GB
        mvno['minimum_commitment_gbp'] = random.choice([50000, 100000, 150000, 200000, 250000])
        mvno['account_manager'] = f'WAM{random.randint(1, 10):02d}'
    
    return pd.DataFrame(mvno_partners)


def generate_mvno_traffic_fact(num_records=100000):
    """Generate MVNO traffic/usage fact table."""
    
    traffic_data = []
    
    for i in range(1, num_records + 1):
        mvno_id = random.choices(range(1, 13), weights=[0.12, 0.15, 0.12, 0.08, 0.10, 0.10, 0.15, 0.05, 0.03, 0.06, 0.02, 0.02])[0]
        traffic_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        
        # Traffic varies by MVNO size
        size_multiplier = {1: 1.0, 2: 1.4, 3: 1.1, 4: 0.5, 5: 0.7, 6: 0.9, 7: 1.8, 8: 0.3, 9: 0.2, 10: 0.6, 11: 0.1, 12: 0.05}
        
        voice_minutes = int(random.uniform(5000, 50000) * size_multiplier.get(mvno_id, 1))
        sms_count = int(random.uniform(2000, 20000) * size_multiplier.get(mvno_id, 1))
        data_gb = round(random.uniform(100, 2000) * size_multiplier.get(mvno_id, 1), 2)
        
        # Calculate wholesale revenue
        voice_revenue = round(voice_minutes * random.uniform(0.008, 0.015), 2)
        sms_revenue = round(sms_count * random.uniform(0.005, 0.01), 2)
        data_revenue = round(data_gb * random.uniform(0.50, 1.50), 2)
        
        traffic_data.append({
            'traffic_id': i,
            'mvno_id': mvno_id,
            'traffic_date': traffic_date.strftime('%Y-%m-%d'),
            'traffic_month': traffic_date.strftime('%Y-%m'),
            'voice_minutes': voice_minutes,
            'sms_count': sms_count,
            'data_gb': data_gb,
            'voice_revenue': voice_revenue,
            'sms_revenue': sms_revenue,
            'data_revenue': data_revenue,
            'total_revenue': round(voice_revenue + sms_revenue + data_revenue, 2),
            'active_subscribers': int(random.uniform(1000, 50000) * size_multiplier.get(mvno_id, 1)),
            'network_type': random.choices(['4G', '5G', '3G'], weights=[0.55, 0.35, 0.10])[0],
            'peak_hour_traffic_pct': round(random.uniform(0.25, 0.45), 2),
        })
    
    return pd.DataFrame(traffic_data)


def generate_mvno_settlement_fact(num_records=500):
    """Generate MVNO financial settlement fact table - monthly settlements."""
    
    settlement_data = []
    
    # Generate monthly settlements for each MVNO
    settlement_id = 1
    for mvno_id in range(1, 13):
        size_multiplier = {1: 1.0, 2: 1.4, 3: 1.1, 4: 0.5, 5: 0.7, 6: 0.9, 7: 1.8, 8: 0.3, 9: 0.2, 10: 0.6, 11: 0.1, 12: 0.05}
        
        current_date = START_DATE
        while current_date < END_DATE:
            month_end = (current_date.replace(day=28) + timedelta(days=4)).replace(day=1) - timedelta(days=1)
            
            base_amount = random.uniform(80000, 400000) * size_multiplier.get(mvno_id, 1)
            
            voice_charges = round(base_amount * 0.25, 2)
            sms_charges = round(base_amount * 0.10, 2)
            data_charges = round(base_amount * 0.55, 2)
            interconnect_charges = round(base_amount * 0.08, 2)
            other_charges = round(base_amount * 0.02, 2)
            
            total_charges = round(voice_charges + sms_charges + data_charges + interconnect_charges + other_charges, 2)
            
            # Payment status
            days_since_month_end = (datetime.now() - month_end).days
            if days_since_month_end > 45:
                payment_status = random.choices(['Paid', 'Overdue'], weights=[0.92, 0.08])[0]
            elif days_since_month_end > 30:
                payment_status = random.choices(['Paid', 'Pending'], weights=[0.75, 0.25])[0]
            else:
                payment_status = 'Pending'
            
            settlement_data.append({
                'settlement_id': settlement_id,
                'mvno_id': mvno_id,
                'settlement_month': current_date.strftime('%Y-%m'),
                'settlement_date': month_end.strftime('%Y-%m-%d'),
                'voice_charges': voice_charges,
                'sms_charges': sms_charges,
                'data_charges': data_charges,
                'interconnect_charges': interconnect_charges,
                'other_charges': other_charges,
                'total_charges': total_charges,
                'minimum_commitment': random.choice([50000, 100000, 150000, 200000]),
                'shortfall_charge': max(0, random.choice([50000, 100000, 150000]) - total_charges) if total_charges < 100000 else 0,
                'payment_status': payment_status,
                'payment_date': (month_end + timedelta(days=random.randint(25, 40))).strftime('%Y-%m-%d') if payment_status == 'Paid' else None,
                'invoice_number': f'INV-MVNO-{mvno_id:02d}-{current_date.strftime("%Y%m")}',
            })
            
            settlement_id += 1
            current_date = (current_date.replace(day=28) + timedelta(days=4)).replace(day=1)
    
    return pd.DataFrame(settlement_data)


# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    print("=" * 60)
    print("Generating Additional SnowTelco Demo Data")
    print("=" * 60)
    
    # 1. Fraud Detection Data
    print("\n1. Generating Fraud Detection Data...")
    
    fraud_type_df = generate_fraud_type_dim()
    fraud_type_df.to_csv(os.path.join(OUTPUT_DIR, 'fraud_type_dim.csv'), index=False)
    print(f"   - fraud_type_dim.csv: {len(fraud_type_df)} records")
    
    fraud_case_df = generate_fraud_case_fact()
    fraud_case_df.to_csv(os.path.join(OUTPUT_DIR, 'fraud_case_fact.csv'), index=False)
    print(f"   - fraud_case_fact.csv: {len(fraud_case_df)} records")
    
    # 2. B2B Contract Renewals
    print("\n2. Generating B2B Contract Renewals Data...")
    
    b2b_contract_df = generate_b2b_contract_fact()
    b2b_contract_df.to_csv(os.path.join(OUTPUT_DIR, 'b2b_contract_fact.csv'), index=False)
    print(f"   - b2b_contract_fact.csv: {len(b2b_contract_df)} records")
    
    # 3. Wholesale/MVNO Data
    print("\n3. Generating Wholesale/MVNO Data...")
    
    mvno_partner_df = generate_mvno_partner_dim()
    mvno_partner_df.to_csv(os.path.join(OUTPUT_DIR, 'mvno_partner_dim.csv'), index=False)
    print(f"   - mvno_partner_dim.csv: {len(mvno_partner_df)} records")
    
    mvno_traffic_df = generate_mvno_traffic_fact()
    mvno_traffic_df.to_csv(os.path.join(OUTPUT_DIR, 'mvno_traffic_fact.csv'), index=False)
    print(f"   - mvno_traffic_fact.csv: {len(mvno_traffic_df)} records")
    
    mvno_settlement_df = generate_mvno_settlement_fact()
    mvno_settlement_df.to_csv(os.path.join(OUTPUT_DIR, 'mvno_settlement_fact.csv'), index=False)
    print(f"   - mvno_settlement_fact.csv: {len(mvno_settlement_df)} records")
    
    # Summary
    print("\n" + "=" * 60)
    print("GENERATION COMPLETE")
    print("=" * 60)
    
    total_records = (len(fraud_type_df) + len(fraud_case_df) + 
                    len(b2b_contract_df) + 
                    len(mvno_partner_df) + len(mvno_traffic_df) + len(mvno_settlement_df))
    
    print(f"\nTotal new records: {total_records:,}")
    print(f"Files created: 6")
    print(f"Output directory: {OUTPUT_DIR}")


if __name__ == '__main__':
    main()
