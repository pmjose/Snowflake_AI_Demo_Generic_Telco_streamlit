#!/usr/bin/env python3
"""
SnowTelco Demo Data Regeneration Script
Updates all CSV data files to extend through February 2026
Maintains data patterns, distributions, and referential integrity

Target date: February 28, 2026

ENHANCEMENTS (from FINAL_RECOMMENDATIONS.md):
- Phase 1: Fix date ranges (2020/2023 -> 2026)
- Phase 2.1: Enhance port-in data with UK carrier distribution
- Phase 2.2: Add payment_method_key to payment_fact
- Phase 2.3: Create revenue assurance tables
- Phase 3.1: Add network_generation to mobile_plan_dim
- Phase 3.2: Add FCR columns to contact_center_call_fact
- Phase 3.3: Create sim_activation_fact
- Phase 3.4: Enhance network_alarm_fact severity distribution
- Phase 4: Add incident timestamps, dispute tracking
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os
import uuid
from pathlib import Path

# Set random seed for reproducibility
np.random.seed(42)
random.seed(42)

# Configuration
DATA_DIR = Path(__file__).parent.parent / "demo_data"
TARGET_END_DATE = datetime(2026, 2, 28)
TARGET_START_DATE = datetime(2026, 1, 1)
TARGET_END_MONTH = "2026-02"
TARGET_START_MONTH = "2026-01"

# UK Mobile Carriers for porting data
UK_CARRIERS = ['EE', 'Vodafone', 'Three', 'O2', 'Sky Mobile', 'Tesco Mobile', 
               'Virgin Mobile', 'BT Mobile', 'giffgaff', 'iD Mobile', 'Lebara']
# Distribution weights for port-in source carriers
CARRIER_WEIGHTS = [0.25, 0.22, 0.20, 0.18, 0.05, 0.03, 0.03, 0.02, 0.01, 0.005, 0.005]

print(f"Data directory: {DATA_DIR}")
print(f"Target date range: {TARGET_START_DATE.date()} to {TARGET_END_DATE.date()}")
print("=" * 60)

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def shift_dates_to_2026(df, date_col, target_start=None, target_end=None):
    """
    Shift all dates in a dataframe to 2026, preserving the day-of-year distribution.
    This is for files that have old dates (2020, 2023) that need to be moved to 2026.
    """
    if target_start is None:
        target_start = TARGET_START_DATE
    if target_end is None:
        target_end = TARGET_END_DATE
    
    df[date_col] = pd.to_datetime(df[date_col])
    old_min = df[date_col].min()
    old_max = df[date_col].max()
    old_range = (old_max - old_min).days
    target_range = (target_end - target_start).days
    
    if old_range == 0:
        old_range = 1  # Avoid division by zero
    
    # Scale dates proportionally to fit in target range
    df[date_col] = df[date_col].apply(
        lambda x: target_start + timedelta(days=int((x - old_min).days * target_range / old_range))
    )
    
    print(f"  Shifted dates from {old_min.date()}-{old_max.date()} to {target_start.date()}-{target_end.date()}")
    return df


def shift_datetime_to_2026(df, datetime_col, target_start=None, target_end=None):
    """
    Shift all datetimes in a dataframe to 2026, preserving time of day.
    """
    if target_start is None:
        target_start = TARGET_START_DATE
    if target_end is None:
        target_end = TARGET_END_DATE
    
    df[datetime_col] = pd.to_datetime(df[datetime_col])
    old_min = df[datetime_col].min()
    old_max = df[datetime_col].max()
    old_range = (old_max - old_min).total_seconds()
    target_range = (target_end - target_start).total_seconds()
    
    if old_range == 0:
        old_range = 1
    
    def shift_dt(x):
        offset_ratio = (x - old_min).total_seconds() / old_range
        new_dt = target_start + timedelta(seconds=offset_ratio * target_range)
        # Preserve original time of day
        return new_dt.replace(hour=x.hour, minute=x.minute, second=x.second)
    
    df[datetime_col] = df[datetime_col].apply(shift_dt)
    print(f"  Shifted datetimes from {old_min.date()} to {target_start.date()}-{target_end.date()}")
    return df


def extend_date_data(df, date_col, end_date, id_col=None, start_id=None, 
                     preserve_existing=True, daily_records=None):
    """
    Extend a dataframe by adding new records up to end_date.
    """
    df[date_col] = pd.to_datetime(df[date_col])
    current_end = df[date_col].max()
    
    if current_end >= end_date:
        print(f"  Already up to date (ends {current_end.date()})")
        return df
    
    print(f"  Extending from {current_end.date()} to {end_date.date()}")
    
    # Get date range to add
    new_dates = pd.date_range(start=current_end + timedelta(days=1), end=end_date, freq='D')
    
    if len(new_dates) == 0:
        return df
    
    # Calculate records per day based on existing data
    if daily_records is None:
        total_days = (current_end - df[date_col].min()).days + 1
        daily_records = max(1, len(df) // total_days)
    
    # Sample existing records to use as templates
    new_records = []
    next_id = df[id_col].max() + 1 if id_col else None
    
    for date in new_dates:
        # Sample template records
        n_records = max(1, int(daily_records * np.random.uniform(0.8, 1.2)))
        templates = df.sample(n=min(n_records, len(df)), replace=True)
        
        for _, template in templates.iterrows():
            record = template.copy()
            record[date_col] = date
            if id_col:
                record[id_col] = next_id
                next_id += 1
            new_records.append(record)
    
    new_df = pd.DataFrame(new_records)
    result = pd.concat([df, new_df], ignore_index=True)
    result = result.sort_values(date_col).reset_index(drop=True)
    
    print(f"  Added {len(new_records)} records, total now {len(result)}")
    return result


def extend_month_data(df, month_col, end_month, id_col=None, subscriber_col=None):
    """
    Extend monthly data (YYYY-MM format) to end_month.
    """
    # Parse month format
    df_months = pd.to_datetime(df[month_col], format='%Y-%m')
    current_end = df_months.max()
    target_end = pd.to_datetime(end_month, format='%Y-%m')
    
    if current_end >= target_end:
        print(f"  Already up to date (ends {current_end.strftime('%Y-%m')})")
        return df
    
    print(f"  Extending from {current_end.strftime('%Y-%m')} to {target_end.strftime('%Y-%m')}")
    
    # Generate new months
    new_months = pd.date_range(start=current_end + pd.offsets.MonthBegin(1), 
                                end=target_end, freq='MS')
    
    if len(new_months) == 0:
        return df
    
    # Get unique subscribers
    subscribers = df[subscriber_col].unique() if subscriber_col else [None]
    
    new_records = []
    next_id = df[id_col].max() + 1 if id_col else None
    
    for month in new_months:
        month_str = month.strftime('%Y-%m')
        # Sample some subscribers for this month
        n_subs = int(len(subscribers) * np.random.uniform(0.7, 0.9))
        selected_subs = np.random.choice(subscribers, size=n_subs, replace=False)
        
        for sub in selected_subs:
            # Get a template for this subscriber
            if subscriber_col:
                sub_data = df[df[subscriber_col] == sub]
                if len(sub_data) == 0:
                    continue
                template = sub_data.sample(1).iloc[0].copy()
            else:
                template = df.sample(1).iloc[0].copy()
            
            template[month_col] = month_str
            if id_col:
                template[id_col] = next_id
                next_id += 1
            
            # Slight variations in numeric columns
            for col in template.index:
                if col not in [id_col, month_col, subscriber_col] and pd.api.types.is_numeric_dtype(type(template[col])):
                    if not pd.isna(template[col]):
                        template[col] = template[col] * np.random.uniform(0.9, 1.1)
            
            new_records.append(template)
    
    new_df = pd.DataFrame(new_records)
    result = pd.concat([df, new_df], ignore_index=True)
    print(f"  Added {len(new_records)} records, total now {len(result)}")
    return result


def extend_datetime_data(df, datetime_col, end_date, id_col=None, daily_records=None):
    """
    Extend datetime data to end_date.
    """
    df[datetime_col] = pd.to_datetime(df[datetime_col])
    current_end = df[datetime_col].max()
    
    if current_end.date() >= end_date.date():
        print(f"  Already up to date (ends {current_end.date()})")
        return df
    
    print(f"  Extending from {current_end.date()} to {end_date.date()}")
    
    new_dates = pd.date_range(start=current_end.date() + timedelta(days=1), 
                               end=end_date, freq='D')
    
    if len(new_dates) == 0:
        return df
    
    if daily_records is None:
        total_days = (current_end.date() - df[datetime_col].min().date()).days + 1
        daily_records = max(1, len(df) // total_days)
    
    new_records = []
    next_id = df[id_col].max() + 1 if id_col else None
    
    for date in new_dates:
        n_records = max(1, int(daily_records * np.random.uniform(0.8, 1.2)))
        templates = df.sample(n=min(n_records, len(df)), replace=True)
        
        for _, template in templates.iterrows():
            record = template.copy()
            # Generate random time
            hour = np.random.randint(0, 24)
            minute = np.random.randint(0, 60)
            second = np.random.randint(0, 60)
            record[datetime_col] = datetime.combine(date.date(), 
                                                     datetime.min.time().replace(hour=hour, minute=minute, second=second))
            if id_col:
                record[id_col] = next_id
                next_id += 1
            new_records.append(record)
    
    new_df = pd.DataFrame(new_records)
    result = pd.concat([df, new_df], ignore_index=True)
    result = result.sort_values(datetime_col).reset_index(drop=True)
    
    print(f"  Added {len(new_records)} records, total now {len(result)}")
    return result


# ============================================================================
# CRITICAL FIX: mobile_subscriber_dim.csv (Add B2C/B2B customer types)
# ============================================================================

def regenerate_mobile_subscribers():
    """
    Regenerate mobile_subscriber_dim with clear B2C (Consumer) and B2B classification.
    Creates realistic consumer and business customer profiles.
    """
    print("\n" + "=" * 60)
    print("REGENERATING mobile_subscriber_dim.csv (B2C/B2B Split)")
    print("=" * 60)
    
    file_path = DATA_DIR / "mobile_subscriber_dim.csv"
    
    # UK First Names
    first_names_male = ['Oliver', 'George', 'Harry', 'Noah', 'Jack', 'Leo', 'Arthur', 
                        'Muhammad', 'Oscar', 'Charlie', 'Jacob', 'Henry', 'Thomas', 
                        'William', 'James', 'Alfie', 'Theodore', 'Archie', 'Joshua', 
                        'Alexander', 'Ethan', 'Lucas', 'Daniel', 'Matthew', 'Samuel',
                        'David', 'Joseph', 'Benjamin', 'Edward', 'Max', 'Luke', 'Adam',
                        'Ryan', 'Nathan', 'Connor', 'Dylan', 'Liam', 'Jake', 'Caleb']
    
    first_names_female = ['Olivia', 'Amelia', 'Isla', 'Ava', 'Mia', 'Ivy', 'Lily', 
                          'Isabella', 'Sophia', 'Grace', 'Emily', 'Poppy', 'Ella', 
                          'Evie', 'Charlotte', 'Jessica', 'Freya', 'Sophie', 'Alice',
                          'Daisy', 'Millie', 'Lucy', 'Phoebe', 'Ruby', 'Rosie', 'Emma',
                          'Florence', 'Willow', 'Sienna', 'Maisie', 'Harper', 'Evelyn',
                          'Eleanor', 'Chloe', 'Hannah', 'Sarah', 'Katie', 'Amy', 'Zoe']
    
    last_names = ['Smith', 'Jones', 'Williams', 'Taylor', 'Brown', 'Davies', 'Evans',
                  'Wilson', 'Thomas', 'Roberts', 'Johnson', 'Lewis', 'Walker', 'Robinson',
                  'Wood', 'Thompson', 'White', 'Watson', 'Jackson', 'Wright', 'Green',
                  'Harris', 'Cooper', 'King', 'Lee', 'Martin', 'Clarke', 'James', 'Morgan',
                  'Hughes', 'Edwards', 'Hill', 'Moore', 'Clark', 'Harrison', 'Scott',
                  'Young', 'Morris', 'Hall', 'Ward', 'Turner', 'Carter', 'Phillips',
                  'Mitchell', 'Patel', 'Singh', 'Khan', 'Ali', 'Ahmed', 'Shah']
    
    # UK Cities by region with postcodes
    uk_locations = [
        # London & South East
        ('London', 'Greater London', ['E', 'N', 'NW', 'SE', 'SW', 'W', 'WC', 'EC']),
        ('Brighton', 'East Sussex', ['BN']),
        ('Reading', 'Berkshire', ['RG']),
        ('Oxford', 'Oxfordshire', ['OX']),
        ('Cambridge', 'Cambridgeshire', ['CB']),
        ('Southampton', 'Hampshire', ['SO']),
        ('Portsmouth', 'Hampshire', ['PO']),
        ('Guildford', 'Surrey', ['GU']),
        ('Milton Keynes', 'Buckinghamshire', ['MK']),
        # Midlands
        ('Birmingham', 'West Midlands', ['B']),
        ('Coventry', 'West Midlands', ['CV']),
        ('Leicester', 'Leicestershire', ['LE']),
        ('Nottingham', 'Nottinghamshire', ['NG']),
        ('Derby', 'Derbyshire', ['DE']),
        ('Wolverhampton', 'West Midlands', ['WV']),
        # North West
        ('Manchester', 'Greater Manchester', ['M']),
        ('Liverpool', 'Merseyside', ['L']),
        ('Preston', 'Lancashire', ['PR']),
        ('Blackpool', 'Lancashire', ['FY']),
        ('Chester', 'Cheshire', ['CH']),
        # North East
        ('Leeds', 'West Yorkshire', ['LS']),
        ('Sheffield', 'South Yorkshire', ['S']),
        ('Newcastle', 'Tyne and Wear', ['NE']),
        ('Bradford', 'West Yorkshire', ['BD']),
        ('Hull', 'East Yorkshire', ['HU']),
        ('York', 'North Yorkshire', ['YO']),
        # Scotland
        ('Edinburgh', 'Scotland', ['EH']),
        ('Glasgow', 'Scotland', ['G']),
        ('Aberdeen', 'Scotland', ['AB']),
        ('Dundee', 'Scotland', ['DD']),
        # Wales
        ('Cardiff', 'Wales', ['CF']),
        ('Swansea', 'Wales', ['SA']),
        ('Newport', 'Wales', ['NP']),
        # Northern Ireland
        ('Belfast', 'Northern Ireland', ['BT']),
        # South West
        ('Bristol', 'Avon', ['BS']),
        ('Plymouth', 'Devon', ['PL']),
        ('Exeter', 'Devon', ['EX']),
        ('Bath', 'Somerset', ['BA']),
    ]
    
    street_types = ['High Street', 'Main Street', 'Church Road', 'Park Road', 'Station Road',
                    'Mill Lane', 'School Lane', 'The Avenue', 'Kings Road', 'Queens Road',
                    'Victoria Road', 'Green Lane', 'North Street', 'South Street', 'West Street',
                    'East Road', 'New Road', 'Hill Road', 'Grove Road', 'Manor Road']
    
    # B2B Company names (for business customers)
    company_prefixes = ['Apex', 'Summit', 'Prime', 'Global', 'United', 'First', 'Pro', 
                        'Elite', 'Metro', 'City', 'Coastal', 'Northern', 'Southern', 'Central',
                        'Phoenix', 'Atlas', 'Vertex', 'Nexus', 'Quantum', 'Dynamic']
    company_suffixes = ['Solutions', 'Services', 'Consulting', 'Group', 'Partners', 'Associates',
                        'Industries', 'Systems', 'Technologies', 'Enterprises', 'Holdings', 
                        'Corporation', 'Ltd', 'UK', 'International']
    company_types = ['IT', 'Legal', 'Financial', 'Engineering', 'Marketing', 'Healthcare',
                     'Logistics', 'Manufacturing', 'Retail', 'Construction', 'Property',
                     'Hospitality', 'Education', 'Media', 'Insurance']
    
    # Email domains
    consumer_domains = ['gmail.com', 'hotmail.co.uk', 'yahoo.co.uk', 'outlook.com', 
                        'icloud.com', 'btinternet.com', 'sky.com', 'virginmedia.com']
    business_domains = ['company.co.uk', 'business.com', 'corp.co.uk', 'enterprise.com']
    
    # Plan mappings by customer type
    consumer_plans = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 27]
    business_plans = [24, 25, 26]  # Business Mobile Starter/Pro/Enterprise
    
    # Customer segment mappings
    consumer_segments = {
        'Budget': [1, 10, 14, 15, 22],  # Cheap plans
        'Standard': [2, 3, 11, 16, 20, 23],  # Mid-tier
        'Premium': [4, 5, 7, 8, 12, 17, 18, 21],  # Higher tier
        'VIP': [6, 9, 13, 19]  # Top tier
    }
    
    # Acquisition channels by customer type
    consumer_channels = ['Online', 'Retail Store', 'App', 'Referral', 'Telesales', 
                         'Social Media', 'Comparison Site', 'Partner']
    business_channels = ['Direct Sales', 'Partner', 'Telesales', 'Trade Show', 
                         'Referral', 'LinkedIn', 'Website']
    
    # Target: 70% B2C, 30% B2B
    total_subscribers = 30000
    b2c_count = int(total_subscribers * 0.70)  # 21,000 consumers
    b2b_count = total_subscribers - b2c_count   # 9,000 business
    
    print(f"  Generating {b2c_count} B2C + {b2b_count} B2B = {total_subscribers} subscribers")
    
    records = []
    subscriber_key = 1
    
    # Generate B2C (Consumer) subscribers
    print("    Generating B2C consumers...")
    for i in range(b2c_count):
        is_male = random.random() < 0.5
        first_name = random.choice(first_names_male if is_male else first_names_female)
        last_name = random.choice(last_names)
        
        # Age distribution (18-80)
        age_group = np.random.choice([0, 1, 2, 3, 4], p=[0.20, 0.35, 0.25, 0.15, 0.05])
        age_ranges = [(18, 25), (25, 40), (40, 55), (55, 70), (70, 85)]
        age = random.randint(*age_ranges[age_group])
        dob = datetime.now() - timedelta(days=age*365 + random.randint(0, 365))
        
        # Location
        city, county, postcodes = random.choice(uk_locations)
        postcode_prefix = random.choice(postcodes)
        postcode = f"{postcode_prefix}{random.randint(1,99)} {random.randint(1,9)}{random.choice('ABCDEFGHJKLMNPRSTUVWXYZ')}{random.choice('ABCDEFGHJKLMNPRSTUVWXYZ')}"
        
        # Email
        email_style = random.choice(['first.last', 'firstlast', 'first_last', 'flast'])
        if email_style == 'first.last':
            email_user = f"{first_name.lower()}.{last_name.lower()}"
        elif email_style == 'firstlast':
            email_user = f"{first_name.lower()}{last_name.lower()}{random.randint(1,999)}"
        elif email_style == 'first_last':
            email_user = f"{first_name.lower()}_{last_name.lower()}"
        else:
            email_user = f"{first_name[0].lower()}{last_name.lower()}{random.randint(1,99)}"
        email = f"{email_user}@{random.choice(consumer_domains)}"
        
        # Plan selection based on age
        if age < 25:
            plan_choices = [20, 21, 10, 11, 7, 8]  # Student/SIM Only/5G
        elif age > 65:
            plan_choices = [22, 23, 1, 10, 14, 15]  # Senior/Basic
        elif random.random() < 0.3:  # Family plan eligible (has kids)
            plan_choices = [17, 18, 19, 5, 6]  # Family/Unlimited
        else:
            plan_choices = consumer_plans
        plan_key = random.choice(plan_choices)
        
        # Determine segment based on plan
        segment = 'Standard'
        for seg, plans in consumer_segments.items():
            if plan_key in plans:
                segment = seg
                break
        
        # Status (92% active, 8% churned)
        is_churned = random.random() < 0.08
        status = 'Churned' if is_churned else 'Active'
        
        # Activation date (2020-2026)
        activation_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 2200))
        churn_date = None
        if is_churned:
            churn_date = activation_date + timedelta(days=random.randint(90, 1500))
            if churn_date > TARGET_END_DATE:
                churn_date = TARGET_END_DATE - timedelta(days=random.randint(1, 180))
        
        # Determine network_generation based on plan (5G plans, 4G plans, 3G plans)
        if plan_key in [5, 6, 7, 8, 9, 13, 17, 18, 19, 21, 25, 26, 29, 30]:
            network_gen = '5G'
        elif plan_key in [2, 3, 4, 12, 16, 24]:
            network_gen = '4G'
        else:
            network_gen = '3G'
        
        records.append({
            'subscriber_key': subscriber_key,
            'mobile_number': f"7{random.randint(100, 999)}{random.randint(100000, 999999)}",
            'first_name': first_name,
            'last_name': last_name,
            'email': email,
            'date_of_birth': dob.strftime('%Y-%m-%d'),
            'address': f"{random.randint(1, 200)} {random.choice(street_types)}",
            'city': city,
            'county': county,
            'postcode': postcode,
            'plan_key': plan_key,
            'device_key': random.randint(1, 50),
            'activation_date': activation_date.strftime('%Y-%m-%d'),
            'status': status,
            'churn_date': churn_date.strftime('%Y-%m-%d') if churn_date else '',
            'credit_score': random.choice(['Excellent', 'Good', 'Good', 'Good', 'Fair', 'Fair', 'Poor']),
            'marketing_opt_in': random.choice(['TRUE', 'TRUE', 'TRUE', 'FALSE']),
            'acquisition_channel': random.choice(consumer_channels),
            'customer_type': 'Consumer',
            'customer_segment': segment,
            'company_name': '',
            'company_size': '',
            'network_generation': network_gen
        })
        subscriber_key += 1
    
    # Generate B2B (Business) subscribers
    print("    Generating B2B business customers...")
    company_sizes = ['1-10', '11-50', '51-200', '201-500', '501-1000', '1000+']
    
    for i in range(b2b_count):
        is_male = random.random() < 0.55
        first_name = random.choice(first_names_male if is_male else first_names_female)
        last_name = random.choice(last_names)
        
        # Business contacts are typically 25-60
        age = random.randint(25, 60)
        dob = datetime.now() - timedelta(days=age*365 + random.randint(0, 365))
        
        # Location
        city, county, postcodes = random.choice(uk_locations)
        postcode_prefix = random.choice(postcodes)
        postcode = f"{postcode_prefix}{random.randint(1,99)} {random.randint(1,9)}{random.choice('ABCDEFGHJKLMNPRSTUVWXYZ')}{random.choice('ABCDEFGHJKLMNPRSTUVWXYZ')}"
        
        # Company info
        company_name = f"{random.choice(company_prefixes)} {random.choice(company_types)} {random.choice(company_suffixes)}"
        company_domain = company_name.split()[0].lower() + random.choice(['.co.uk', '.com', '.uk'])
        email = f"{first_name.lower()}.{last_name.lower()}@{company_domain}"
        
        # Company size determines segment
        company_size = random.choices(company_sizes, weights=[0.30, 0.25, 0.20, 0.12, 0.08, 0.05])[0]
        
        # Determine segment and plan based on company size
        if company_size in ['1-10', '11-50']:
            customer_type = 'SMB'
            segment = random.choice(['Standard', 'Premium'])
            plan_key = random.choice([24, 25])  # Starter or Pro
        elif company_size in ['51-200', '201-500']:
            customer_type = 'SMB'
            segment = random.choice(['Premium', 'VIP'])
            plan_key = random.choice([25, 26])  # Pro or Enterprise
        else:
            customer_type = 'Enterprise'
            segment = 'VIP'
            plan_key = 26  # Enterprise
        
        # Status (95% active for business)
        is_churned = random.random() < 0.05
        status = 'Churned' if is_churned else 'Active'
        
        activation_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 2200))
        churn_date = None
        if is_churned:
            churn_date = activation_date + timedelta(days=random.randint(180, 1500))
            if churn_date > TARGET_END_DATE:
                churn_date = TARGET_END_DATE - timedelta(days=random.randint(1, 180))
        
        # B2B plans are typically 5G (Enterprise) or 4G (SMB Starter)
        if plan_key == 26:  # Enterprise
            network_gen = '5G'
        elif plan_key == 25:  # Pro
            network_gen = '5G'
        else:  # Starter (24)
            network_gen = '4G'
        
        records.append({
            'subscriber_key': subscriber_key,
            'mobile_number': f"7{random.randint(100, 999)}{random.randint(100000, 999999)}",
            'first_name': first_name,
            'last_name': last_name,
            'email': email,
            'date_of_birth': dob.strftime('%Y-%m-%d'),
            'address': f"{random.randint(1, 200)} {random.choice(street_types)}",
            'city': city,
            'county': county,
            'postcode': postcode,
            'plan_key': plan_key,
            'device_key': random.randint(1, 50),
            'activation_date': activation_date.strftime('%Y-%m-%d'),
            'status': status,
            'churn_date': churn_date.strftime('%Y-%m-%d') if churn_date else '',
            'credit_score': random.choice(['Excellent', 'Good', 'Good', 'Good', 'Fair']),
            'marketing_opt_in': random.choice(['TRUE', 'FALSE']),
            'acquisition_channel': random.choice(business_channels),
            'customer_type': customer_type,
            'customer_segment': segment,
            'company_name': company_name,
            'company_size': company_size,
            'network_generation': network_gen
        })
        subscriber_key += 1
    
    # Shuffle to mix B2C and B2B
    random.shuffle(records)
    # Reassign subscriber_keys after shuffle
    for i, record in enumerate(records):
        record['subscriber_key'] = i + 1
    
    result_df = pd.DataFrame(records)
    result_df.to_csv(file_path, index=False)
    
    # Print summary
    print(f"  Saved {len(result_df)} subscribers to {file_path.name}")
    type_counts = result_df['customer_type'].value_counts()
    print(f"  Customer mix: {dict(type_counts)}")
    segment_counts = result_df['customer_segment'].value_counts()
    print(f"  Segments: {dict(segment_counts)}")
    
    return result_df


# ============================================================================
# CRITICAL FIX: network_performance_fact.csv (only 23 days of data!)
# ============================================================================

def regenerate_network_performance():
    """Completely regenerate network_performance_fact with 2+ years of data."""
    print("\n" + "=" * 60)
    print("REGENERATING network_performance_fact.csv (CRITICAL)")
    print("=" * 60)
    
    file_path = DATA_DIR / "network_performance_fact.csv"
    df = pd.read_csv(file_path, nrows=50000)  # Sample for templates
    
    # Get unique element IDs from network_element_dim
    elements_df = pd.read_csv(DATA_DIR / "network_element_dim.csv")
    element_ids = elements_df['element_id'].tolist()
    
    # Generate 2+ years of data: Jan 2024 to Feb 2026
    start_date = datetime(2024, 1, 1)
    end_date = TARGET_END_DATE
    all_dates = pd.date_range(start=start_date, end=end_date, freq='D')
    
    print(f"  Generating data from {start_date.date()} to {end_date.date()}")
    print(f"  {len(all_dates)} days x ~500 elements = ~{len(all_dates) * 500} records")
    
    # Sample subset of elements per day for reasonable file size
    records = []
    perf_id = 1
    
    for date in all_dates:
        # Sample 400-600 elements per day
        n_elements = np.random.randint(400, 600)
        selected_elements = np.random.choice(element_ids, size=min(n_elements, len(element_ids)), replace=False)
        
        for element_id in selected_elements:
            # Generate realistic metrics
            records.append({
                'perf_id': perf_id,
                'element_id': element_id,
                'metric_datetime': date.strftime('%Y-%m-%d') + f' {np.random.randint(0,24):02d}:00:00',
                'metric_date': date.strftime('%Y-%m-%d'),
                'metric_hour': np.random.randint(0, 24),
                'throughput_gbps': round(np.random.uniform(50, 700), 2),
                'latency_ms': round(np.random.uniform(5, 15), 2),
                'utilization_pct': round(np.random.uniform(10, 70), 1),
                'packet_loss_pct': round(np.random.uniform(0.0001, 0.012), 4),
                'error_count': np.random.choice([0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 5, 7, 10]),
                'availability_pct': round(np.random.uniform(99.5, 99.999), 3)
            })
            perf_id += 1
        
        if date.day == 1:
            print(f"    Progress: {date.strftime('%Y-%m')}...")
    
    result_df = pd.DataFrame(records)
    result_df.to_csv(file_path, index=False)
    print(f"  Saved {len(result_df)} records to {file_path.name}")
    return result_df


# ============================================================================
# CRITICAL FIX: mobile_usage_fact.csv (schema mismatch + missing NPS)
# ============================================================================

def regenerate_mobile_usage():
    """
    Completely regenerate mobile_usage_fact with correct schema including NPS.
    Schema: usage_id, subscriber_key, usage_month, data_used_gb, data_allowance_gb,
            minutes_used, sms_sent, roaming_data_gb, roaming_minutes, 
            international_minutes, bill_amount, payment_status, nps_score
    """
    print("\n" + "=" * 60)
    print("REGENERATING mobile_usage_fact.csv (CRITICAL - Schema Fix + NPS)")
    print("=" * 60)
    
    file_path = DATA_DIR / "mobile_usage_fact.csv"
    
    # Load subscribers to get subscriber_keys, segments, and customer types
    subscribers_df = pd.read_csv(DATA_DIR / "mobile_subscriber_dim.csv")
    subscriber_keys = subscribers_df['subscriber_key'].tolist()
    
    # Create mappings
    segment_map = dict(zip(subscribers_df['subscriber_key'], subscribers_df['customer_segment']))
    customer_type_map = dict(zip(subscribers_df['subscriber_key'], subscribers_df['customer_type']))
    
    # NPS distributions by segment and customer type
    # Full 0-10 scale: Detractors (0-6), Passives (7-8), Promoters (9-10)
    # Higher value segments have better NPS, but ALL segments have some detractors
    nps_distributions_consumer = {
        # VIP: 15% detractors, 25% passives, 60% promoters
        'VIP': [2, 4, 5, 6, 7, 7, 8, 8, 9, 9, 9, 9, 10, 10, 10],
        # Premium: 20% detractors, 35% passives, 45% promoters
        'Premium': [1, 3, 4, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 10],
        # Standard: 30% detractors, 40% passives, 30% promoters
        'Standard': [0, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9],
        # Budget: 40% detractors, 35% passives, 25% promoters
        'Budget': [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9]
    }
    nps_distributions_business = {
        # B2B VIP (Enterprise): Very high satisfaction - 10% detractors, 25% passives, 65% promoters
        'VIP': [3, 5, 6, 7, 7, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10],
        # B2B Premium: 15% detractors, 30% passives, 55% promoters
        'Premium': [2, 4, 5, 6, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10],
        # B2B Standard: 25% detractors, 35% passives, 40% promoters
        'Standard': [1, 3, 4, 5, 6, 6, 7, 7, 8, 8, 8, 9, 9, 9, 10],
        # B2B Budget (small SMB): 30% detractors, 35% passives, 35% promoters
        'Budget': [2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8, 8, 9, 9, 10]
    }
    
    # Payment statuses
    payment_statuses = ['Paid', 'Paid', 'Paid', 'Paid', 'Paid', 'Paid', 'Paid', 
                        'Pending', 'Pending', 'Overdue']
    
    # Load plans for data allowance lookup
    plans_df = pd.read_csv(DATA_DIR / "mobile_plan_dim.csv")
    plan_allowances = dict(zip(plans_df['plan_key'], plans_df['data_allowance_gb']))
    subscriber_plans = dict(zip(subscribers_df['subscriber_key'], subscribers_df['plan_key']))
    
    # Generate months from Jan 2024 to Feb 2026
    months = pd.date_range(start='2024-01-01', end=TARGET_END_DATE, freq='MS')
    
    print(f"  Generating {len(months)} months x ~{len(subscriber_keys)} subscribers")
    
    records = []
    usage_id = 1
    
    for month in months:
        month_str = month.strftime('%Y-%m')
        
        # Sample 70-90% of subscribers for each month
        n_subs = int(len(subscriber_keys) * np.random.uniform(0.7, 0.9))
        selected_subs = np.random.choice(subscriber_keys, size=n_subs, replace=False)
        
        for sub_key in selected_subs:
            segment = segment_map.get(sub_key, 'Standard')
            plan_key = subscriber_plans.get(sub_key, 10)
            data_allowance = plan_allowances.get(plan_key, 30)
            if data_allowance == 'Unlimited':
                data_allowance = 999  # Unlimited represented as 999
            else:
                data_allowance = int(data_allowance) if pd.notna(data_allowance) else 30
            
            # Generate usage data
            data_used = round(np.random.uniform(1, min(data_allowance * 1.2, 50)), 2)
            minutes_used = np.random.randint(20, 300)
            sms_sent = np.random.randint(5, 100)
            
            # Roaming usage (10% of subscribers per month)
            has_roaming = np.random.random() < 0.1
            roaming_data = round(np.random.uniform(0.1, 2.0), 2) if has_roaming else 0.0
            roaming_minutes = np.random.randint(5, 60) if has_roaming else 0
            international_minutes = np.random.randint(0, 30) if np.random.random() < 0.15 else 0
            
            # Get customer type for this subscriber
            customer_type = customer_type_map.get(sub_key, 'Consumer')
            
            # Bill amount based on customer type and segment
            # B2B customers have higher bills
            if customer_type == 'Enterprise':
                base_bill = {'VIP': 150, 'Premium': 120, 'Standard': 80, 'Budget': 60}.get(segment, 100)
            elif customer_type == 'SMB':
                base_bill = {'VIP': 80, 'Premium': 60, 'Standard': 45, 'Budget': 35}.get(segment, 50)
            else:  # Consumer
                base_bill = {'VIP': 55, 'Premium': 40, 'Standard': 25, 'Budget': 15}.get(segment, 25)
            bill_amount = round(base_bill * np.random.uniform(0.8, 1.4), 2)
            
            # Payment status (weighted)
            payment_status = random.choice(payment_statuses)
            
            # NPS score (some months have NPS, simulating survey responses)
            # B2B customers respond more often to surveys (~40%) vs consumers (~30%)
            nps_response_rate = 0.40 if customer_type in ['SMB', 'Enterprise'] else 0.30
            
            if np.random.random() < nps_response_rate:
                if customer_type in ['SMB', 'Enterprise']:
                    nps_dist = nps_distributions_business.get(segment, nps_distributions_business.get('Standard', [7, 8]))
                else:
                    nps_dist = nps_distributions_consumer.get(segment, nps_distributions_consumer.get('Standard', [7, 8]))
                nps_score = random.choice(nps_dist)
            else:
                nps_score = None
            
            records.append({
                'usage_id': usage_id,
                'subscriber_key': sub_key,
                'usage_month': month_str,
                'data_used_gb': data_used,
                'data_allowance_gb': data_allowance,
                'minutes_used': minutes_used,
                'sms_sent': sms_sent,
                'roaming_data_gb': roaming_data,
                'roaming_minutes': roaming_minutes,
                'international_minutes': international_minutes,
                'bill_amount': bill_amount,
                'payment_status': payment_status,
                'nps_score': nps_score
            })
            usage_id += 1
        
        if month.month == 1 or month.month == 7:
            print(f"    Progress: {month_str}...")
    
    result_df = pd.DataFrame(records)
    result_df.to_csv(file_path, index=False)
    print(f"  Saved {len(result_df)} records to {file_path.name}")
    print(f"  NPS coverage: {result_df['nps_score'].notna().sum() / len(result_df) * 100:.1f}%")
    return result_df


# ============================================================================
# FACT TABLE EXTENSIONS
# ============================================================================

def extend_sales_fact():
    """Extend sales_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending sales_fact.csv")
    
    file_path = DATA_DIR / "sales_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'date', TARGET_END_DATE, id_col='sale_id')
    result.to_csv(file_path, index=False)
    return result


def extend_finance_transactions():
    """Extend finance_transactions to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending finance_transactions.csv")
    
    file_path = DATA_DIR / "finance_transactions.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'date', TARGET_END_DATE, id_col='transaction_id')
    # Update approval_date for new records
    mask = pd.to_datetime(result['date']) > datetime(2025, 12, 31)
    result.loc[mask & (result['approval_status'] == 'Approved'), 'approval_date'] = \
        pd.to_datetime(result.loc[mask & (result['approval_status'] == 'Approved'), 'date']) + timedelta(days=np.random.randint(1, 5))
    
    result.to_csv(file_path, index=False)
    return result


def extend_marketing_campaign_fact():
    """Extend marketing_campaign_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending marketing_campaign_fact.csv")
    
    file_path = DATA_DIR / "marketing_campaign_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'date', TARGET_END_DATE, id_col='campaign_fact_id')
    result.to_csv(file_path, index=False)
    return result


def extend_hr_employee_fact():
    """Extend hr_employee_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending hr_employee_fact.csv")
    
    file_path = DATA_DIR / "hr_employee_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'date', TARGET_END_DATE, id_col='hr_fact_id')
    result.to_csv(file_path, index=False)
    return result


def extend_support_ticket_fact():
    """Extend support_ticket_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending support_ticket_fact.csv")
    
    file_path = DATA_DIR / "support_ticket_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_datetime_data(df, 'created_date', TARGET_END_DATE, id_col='ticket_id')
    # Update resolved_date for resolved tickets
    mask = (result['status'] == 'Resolved') & pd.isna(result['resolved_date'])
    if mask.any():
        result.loc[mask, 'resolved_date'] = pd.to_datetime(result.loc[mask, 'created_date']) + timedelta(days=np.random.randint(1, 5))
    
    # Update ticket numbers for new records
    max_ticket = df['ticket_number'].str.extract(r'(\d+)').astype(int).max()[0]
    new_records_mask = result['ticket_id'] > df['ticket_id'].max()
    new_count = new_records_mask.sum()
    if new_count > 0:
        result.loc[new_records_mask, 'ticket_number'] = [f'TKT{i:08d}' for i in range(max_ticket + 1, max_ticket + 1 + new_count)]
    
    result.to_csv(file_path, index=False)
    return result


def extend_contact_center_calls():
    """Extend contact_center_call_fact files to Feb 2026."""
    for file_num in [1, 2]:
        print("\n" + "-" * 40)
        print(f"Extending contact_center_call_fact_{file_num}.csv")
        
        file_path = DATA_DIR / f"contact_center_call_fact_{file_num}.csv"
        df = pd.read_csv(file_path)
        
        result = extend_datetime_data(df, 'start_time', TARGET_END_DATE, id_col='call_id', daily_records=500)
        
        # Update end_time
        result['end_time'] = pd.to_datetime(result['start_time']) + pd.to_timedelta(result['handle_time_secs'], unit='s')
        
        # Update recording URLs for new records
        max_id = df['call_id'].max()
        new_records_mask = result['call_id'] > max_id
        if new_records_mask.any():
            new_times = pd.to_datetime(result.loc[new_records_mask, 'start_time'])
            result.loc[new_records_mask, 'call_recording_url'] = new_times.apply(
                lambda x: f"s3://recordings/{x.year}/{x.month:02d}/{x.day:02d}/{np.random.randint(100000, 999999)}.wav"
            )
        
        result.to_csv(file_path, index=False)


def extend_invoice_fact():
    """Extend invoice_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending invoice_fact.csv")
    
    file_path = DATA_DIR / "invoice_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'invoice_date', TARGET_END_DATE, id_col='invoice_id')
    
    # Update related dates
    max_id = df['invoice_id'].max()
    new_mask = result['invoice_id'] > max_id
    if new_mask.any():
        result.loc[new_mask, 'due_date'] = pd.to_datetime(result.loc[new_mask, 'invoice_date']) + timedelta(days=30)
        result.loc[new_mask, 'billing_period_start'] = pd.to_datetime(result.loc[new_mask, 'invoice_date']) - timedelta(days=30)
        result.loc[new_mask, 'billing_period_end'] = pd.to_datetime(result.loc[new_mask, 'invoice_date']) - timedelta(days=1)
        
        # Update invoice numbers
        max_inv_num = df['invoice_number'].str.extract(r'(\d+)').astype(int).max()[0]
        new_count = new_mask.sum()
        result.loc[new_mask, 'invoice_number'] = [f'INV{i:08d}' for i in range(max_inv_num + 1, max_inv_num + 1 + new_count)]
    
    result.to_csv(file_path, index=False)
    return result


def extend_payment_fact():
    """Extend payment_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending payment_fact.csv")
    
    file_path = DATA_DIR / "payment_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'payment_date', TARGET_END_DATE, id_col='payment_id')
    
    # Update payment references
    max_id = df['payment_id'].max()
    new_mask = result['payment_id'] > max_id
    if new_mask.any():
        new_count = new_mask.sum()
        result.loc[new_mask, 'payment_reference'] = [f'PAY{np.random.randint(100000, 999999)}' for _ in range(new_count)]
    
    result.to_csv(file_path, index=False)
    return result


def extend_digital_interaction_fact():
    """Extend digital_interaction_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending digital_interaction_fact.csv")
    
    file_path = DATA_DIR / "digital_interaction_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_datetime_data(df, 'timestamp', TARGET_END_DATE, id_col='interaction_id', daily_records=1000)
    result.to_csv(file_path, index=False)
    return result


def extend_network_alarm_fact():
    """Extend network_alarm_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending network_alarm_fact.csv")
    
    file_path = DATA_DIR / "network_alarm_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_datetime_data(df, 'raised_time', TARGET_END_DATE, id_col='alarm_id', daily_records=150)
    
    # Update cleared_time for cleared alarms
    max_id = df['alarm_id'].max()
    new_mask = result['alarm_id'] > max_id
    cleared_mask = new_mask & result['acknowledged']
    if cleared_mask.any():
        result.loc[cleared_mask, 'cleared_time'] = pd.to_datetime(result.loc[cleared_mask, 'raised_time']) + \
                                                   pd.to_timedelta(np.random.randint(30, 480, size=cleared_mask.sum()), unit='m')
    
    result.to_csv(file_path, index=False)
    return result


def extend_it_incident_fact():
    """Extend it_incident_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending it_incident_fact.csv")
    
    file_path = DATA_DIR / "it_incident_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_datetime_data(df, 'created_date', TARGET_END_DATE, id_col='incident_id', daily_records=50)
    
    # Update incident numbers and resolved dates
    max_id = df['incident_id'].max()
    new_mask = result['incident_id'] > max_id
    if new_mask.any():
        max_inc_num = df['incident_number'].str.extract(r'(\d+)').astype(int).max()[0]
        new_count = new_mask.sum()
        result.loc[new_mask, 'incident_number'] = [f'INC{i:05d}' for i in range(max_inc_num + 1, max_inc_num + 1 + new_count)]
        
        # Update resolved_date for resolved incidents
        resolved_mask = new_mask & (result['status'] == 'Closed')
        if resolved_mask.any():
            result.loc[resolved_mask, 'resolved_date'] = pd.to_datetime(result.loc[resolved_mask, 'created_date']) + \
                                                         pd.to_timedelta(result.loc[resolved_mask, 'resolution_mins'], unit='m')
    
    result.to_csv(file_path, index=False)
    return result


def extend_mobile_churn_fact():
    """Extend mobile_churn_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending mobile_churn_fact.csv")
    
    file_path = DATA_DIR / "mobile_churn_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'churn_date', TARGET_END_DATE, id_col='churn_id', daily_records=5)
    result.to_csv(file_path, index=False)
    return result


def extend_partner_performance_fact():
    """Extend partner_performance_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending partner_performance_fact.csv")
    
    file_path = DATA_DIR / "partner_performance_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_month_data(df, 'month', TARGET_END_MONTH, 
                               id_col='perf_id', subscriber_col='partner_key')
    result.to_csv(file_path, index=False)
    return result


def add_2025_2026_partners():
    """
    Add new partners with 2025 and 2026 onboard dates to partner_dim.csv
    Adds ~50 partners per year (matching historical pattern)
    """
    print("\n" + "=" * 60)
    print("Adding 2025-2026 partners to partner_dim.csv")
    print("=" * 60)
    
    file_path = DATA_DIR / "partner_dim.csv"
    df = pd.read_csv(file_path)
    
    # Get max partner_key
    max_key = df['partner_key'].max()
    
    # Partner name components
    name_prefixes = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Apex', 'Summit', 'Prime', 
                     'Nova', 'Stellar', 'Quantum', 'Nexus', 'Vertex', 'Zenith', 
                     'Phoenix', 'Atlas', 'Titan', 'Orion', 'Eclipse', 'Horizon']
    name_types = ['Tech', 'Networks', 'IT', 'Solutions', 'Systems', 'Telecom', 
                  'Communications', 'Digital', 'Connect', 'Cloud']
    name_suffixes = ['Ltd', 'Ltd', 'Ltd', 'Group', 'Partners', 'UK']
    
    partner_types = ['Reseller', 'Agent', 'MSP', 'IT Provider', 'Wholesale', 
                     'Referral', 'Telecom Reseller']
    tiers = ['Bronze', 'Bronze', 'Standard', 'Standard', 'Silver', 'Gold', 'Platinum']
    
    uk_locations = [
        ('London', 'Greater London', 401), ('Birmingham', 'West Midlands', 402),
        ('Manchester', 'Greater Manchester', 403), ('Leeds', 'West Yorkshire', 404),
        ('Glasgow', 'Scotland', 405), ('Liverpool', 'Merseyside', 406),
        ('Bristol', 'Avon', 407), ('Sheffield', 'South Yorkshire', 408),
        ('Edinburgh', 'Scotland', 409), ('Newcastle', 'Tyne and Wear', 410),
        ('Cardiff', 'Wales', 411), ('Nottingham', 'Nottinghamshire', 412)
    ]
    
    account_managers = ['Emma Wilson', 'James Taylor', 'Sophie Brown', 'Oliver Davis',
                        'Charlotte Evans', 'Harry Thompson', 'Amelia Roberts', 
                        'George Clark', 'Isabella Harris', 'William Moore']
    
    new_partners = []
    partner_key = max_key + 1
    
    # Add 2025 partners (45-55 partners)
    n_2025_partners = random.randint(45, 55)
    print(f"  Adding {n_2025_partners} partners for 2025...")
    
    for i in range(n_2025_partners):
        city, county, region_key = random.choice(uk_locations)
        name = f"{random.choice(name_prefixes)} {random.choice(name_types)} {random.choice(name_suffixes)}"
        
        # 2025 onboard date
        onboard_date = datetime(2025, 1, 1) + timedelta(days=random.randint(0, 364))
        
        new_partners.append({
            'partner_key': partner_key,
            'partner_name': name,
            'partner_type': random.choice(partner_types),
            'tier': random.choice(tiers),
            'city': city,
            'county': county,
            'region_key': region_key,
            'status': random.choices(['Active', 'Inactive'], weights=[95, 5])[0],
            'onboard_date': onboard_date.strftime('%Y-%m-%d'),
            'account_manager': random.choice(account_managers),
            'commission_rate': round(random.uniform(5, 25), 1),
            'credit_limit': random.choice([10000, 25000, 50000, 100000, 250000])
        })
        partner_key += 1
    
    # Add 2026 partners (35-45 partners through Feb)
    n_2026_partners = random.randint(35, 45)
    print(f"  Adding {n_2026_partners} partners for 2026 (Jan-Feb)...")
    
    for i in range(n_2026_partners):
        city, county, region_key = random.choice(uk_locations)
        name = f"{random.choice(name_prefixes)} {random.choice(name_types)} {random.choice(name_suffixes)}"
        
        # 2026 onboard date (Jan-Feb only)
        onboard_date = datetime(2026, 1, 1) + timedelta(days=random.randint(0, 58))
        
        new_partners.append({
            'partner_key': partner_key,
            'partner_name': name,
            'partner_type': random.choice(partner_types),
            'tier': random.choice(tiers),
            'city': city,
            'county': county,
            'region_key': region_key,
            'status': 'Active',  # New partners all active
            'onboard_date': onboard_date.strftime('%Y-%m-%d'),
            'account_manager': random.choice(account_managers),
            'commission_rate': round(random.uniform(5, 25), 1),
            'credit_limit': random.choice([10000, 25000, 50000, 100000, 250000])
        })
        partner_key += 1
    
    # Combine and save
    new_df = pd.DataFrame(new_partners)
    result_df = pd.concat([df, new_df], ignore_index=True)
    result_df.to_csv(file_path, index=False)
    
    # Print summary
    result_df['onboard_year'] = pd.to_datetime(result_df['onboard_date']).dt.year
    year_counts = result_df['onboard_year'].value_counts().sort_index()
    print(f"  Partner onboarding by year: {year_counts.to_dict()}")
    print(f"  Total partners: {len(result_df)}")
    
    return result_df


def extend_sla_measurement_fact():
    """Extend sla_measurement_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending sla_measurement_fact.csv")
    
    file_path = DATA_DIR / "sla_measurement_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'measurement_date', TARGET_END_DATE, id_col='measurement_id', daily_records=500)
    result.to_csv(file_path, index=False)
    return result


def extend_roaming_usage_fact():
    """Extend roaming_usage_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending roaming_usage_fact.csv")
    
    file_path = DATA_DIR / "roaming_usage_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'usage_date', TARGET_END_DATE, id_col='roaming_usage_id', daily_records=300)
    result.to_csv(file_path, index=False)
    return result


def extend_iot_usage_fact():
    """Extend iot_usage_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending iot_usage_fact.csv")
    
    file_path = DATA_DIR / "iot_usage_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'usage_date', TARGET_END_DATE, id_col='usage_id', daily_records=500)
    result.to_csv(file_path, index=False)
    return result


def extend_loyalty_transaction_fact():
    """Extend loyalty_transaction_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending loyalty_transaction_fact.csv")
    
    file_path = DATA_DIR / "loyalty_transaction_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'transaction_date', TARGET_END_DATE, id_col='transaction_id', daily_records=200)
    result.to_csv(file_path, index=False)
    return result


def extend_complaint_fact():
    """Extend complaint_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending complaint_fact.csv")
    
    file_path = DATA_DIR / "complaint_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'received_date', TARGET_END_DATE, id_col='complaint_id', daily_records=20)
    
    # Update complaint references and related dates
    max_id = df['complaint_id'].max()
    new_mask = result['complaint_id'] > max_id
    if new_mask.any():
        new_count = new_mask.sum()
        new_indices = result.index[new_mask]
        result.loc[new_mask, 'complaint_reference'] = [f'CMP{np.random.randint(10000, 99999)}' for _ in range(new_count)]
        result.loc[new_mask, 'acknowledged_date'] = pd.to_datetime(result.loc[new_mask, 'received_date']) + timedelta(days=1)
        
        # Some resolved - use proper indexing
        random_resolved = np.random.random(new_count) > 0.3
        resolved_indices = new_indices[random_resolved]
        if len(resolved_indices) > 0:
            result.loc[resolved_indices, 'resolved_date'] = pd.to_datetime(result.loc[resolved_indices, 'received_date']) + \
                                                           pd.to_timedelta(np.random.randint(3, 30, size=len(resolved_indices)), unit='D')
    
    result.to_csv(file_path, index=False)
    return result


def extend_number_port_fact():
    """Extend number_port_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending number_port_fact.csv")
    
    file_path = DATA_DIR / "number_port_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'request_date', TARGET_END_DATE, id_col='port_id', daily_records=10)
    
    # Update related dates
    max_id = df['port_id'].max()
    new_mask = result['port_id'] > max_id
    if new_mask.any():
        result.loc[new_mask, 'scheduled_date'] = pd.to_datetime(result.loc[new_mask, 'request_date']) + timedelta(days=5)
        completed_mask = new_mask & (result['status'] == 'Completed')
        if completed_mask.any():
            result.loc[completed_mask, 'completed_date'] = pd.to_datetime(result.loc[completed_mask, 'scheduled_date'])
    
    result.to_csv(file_path, index=False)
    return result


def extend_inventory_fact():
    """Extend inventory_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending inventory_fact.csv")
    
    file_path = DATA_DIR / "inventory_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'snapshot_date', TARGET_END_DATE, id_col='inventory_id', daily_records=100)
    result.to_csv(file_path, index=False)
    return result


def extend_purchase_order_fact():
    """Extend purchase_order_fact to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending purchase_order_fact.csv")
    
    file_path = DATA_DIR / "purchase_order_fact.csv"
    df = pd.read_csv(file_path)
    
    result = extend_date_data(df, 'po_date', TARGET_END_DATE, id_col='po_id', daily_records=30)
    
    # Update related dates and PO numbers
    max_id = df['po_id'].max()
    new_mask = result['po_id'] > max_id
    if new_mask.any():
        new_count = new_mask.sum()
        result.loc[new_mask, 'po_number'] = [f'PO-{np.random.randint(100000, 999999)}' for _ in range(new_count)]
        result.loc[new_mask, 'expected_date'] = pd.to_datetime(result.loc[new_mask, 'po_date']) + timedelta(days=14)
        
        # Some received
        received_mask = new_mask & (result['status'] == 'Received')
        if received_mask.any():
            result.loc[received_mask, 'received_date'] = pd.to_datetime(result.loc[received_mask, 'expected_date']) + \
                                                         pd.to_timedelta(np.random.randint(-3, 5, size=received_mask.sum()), unit='D')
    
    result.to_csv(file_path, index=False)
    return result


def extend_sf_opportunities():
    """Extend sf_opportunities to Feb 2026."""
    print("\n" + "-" * 40)
    print("Extending sf_opportunities.csv")
    
    file_path = DATA_DIR / "sf_opportunities.csv"
    df = pd.read_csv(file_path)
    
    # Use close_date as the main date field
    result = extend_date_data(df, 'close_date', TARGET_END_DATE, id_col=None, daily_records=20)
    
    # Update opportunity IDs
    max_id_num = int(df['opportunity_id'].str.replace('OPP', '').max())
    new_mask = pd.to_datetime(result['close_date']) > pd.to_datetime(df['close_date']).max()
    if new_mask.any():
        new_count = new_mask.sum()
        result.loc[new_mask, 'opportunity_id'] = [f'OPP{i:015d}' for i in range(max_id_num + 1, max_id_num + 1 + new_count)]
        result.loc[new_mask, 'created_date'] = pd.to_datetime(result.loc[new_mask, 'close_date']) - timedelta(days=np.random.randint(30, 90))
    
    result.to_csv(file_path, index=False)
    return result


# ============================================================================
# PHASE 1: DATE FIXES - Shift old dates (2020/2023) to 2026
# ============================================================================

def fix_number_port_fact_dates():
    """
    Fix number_port_fact.csv - shift dates from 2020 to 2026.
    Also enhances port-in data with proper UK carrier distribution.
    """
    print("\n" + "=" * 60)
    print("PHASE 1: Fixing number_port_fact.csv dates (2020 -> 2026)")
    print("=" * 60)
    
    file_path = DATA_DIR / "number_port_fact.csv"
    df = pd.read_csv(file_path)
    
    # Shift request_date to 2026
    df = shift_dates_to_2026(df, 'request_date', TARGET_START_DATE, TARGET_END_DATE)
    
    # Also shift scheduled_date and completed_date
    df['scheduled_date'] = pd.to_datetime(df['request_date']) + pd.to_timedelta(
        np.random.randint(5, 15, size=len(df)), unit='D'
    )
    
    # Update completed_date for completed ports
    completed_mask = df['status'] == 'Completed'
    df.loc[completed_mask, 'completed_date'] = df.loc[completed_mask, 'scheduled_date'] + \
        pd.to_timedelta(np.random.randint(0, 3, size=completed_mask.sum()), unit='D')
    df.loc[~completed_mask, 'completed_date'] = None
    
    # Update UK carrier distribution for port-in
    port_in_mask = df['direction'] == 'Port In'
    port_in_count = port_in_mask.sum()
    df.loc[port_in_mask, 'donor_carrier'] = np.random.choice(
        UK_CARRIERS, size=port_in_count, p=CARRIER_WEIGHTS
    )
    df.loc[port_in_mask, 'recipient_carrier'] = 'SnowTelco'
    
    # Update UK carrier distribution for port-out  
    port_out_mask = df['direction'] == 'Port Out'
    port_out_count = port_out_mask.sum()
    df.loc[port_out_mask, 'donor_carrier'] = 'SnowTelco'
    df.loc[port_out_mask, 'recipient_carrier'] = np.random.choice(
        UK_CARRIERS, size=port_out_count, p=CARRIER_WEIGHTS
    )
    
    # Verify port-in volume is ~2500-3500 per month
    df['request_month'] = pd.to_datetime(df['request_date']).dt.to_period('M')
    port_in_by_month = df[df['direction'] == 'Port In'].groupby('request_month').size()
    print(f"  Port-In by month: min={port_in_by_month.min()}, max={port_in_by_month.max()}, avg={port_in_by_month.mean():.0f}")
    df = df.drop('request_month', axis=1)
    
    df.to_csv(file_path, index=False)
    print(f"  Saved {len(df)} records to {file_path.name}")
    print(f"  Port-In: {port_in_count}, Port-Out: {port_out_count}")
    return df


def fix_contact_center_dates():
    """
    Fix contact_center_call_fact files - shift dates from 2023 to 2026.
    Also adds FCR (First Call Resolution) columns.
    """
    for file_num in [1, 2]:
        print("\n" + "=" * 60)
        print(f"PHASE 1: Fixing contact_center_call_fact_{file_num}.csv dates (2023 -> 2026)")
        print("=" * 60)
        
        file_path = DATA_DIR / f"contact_center_call_fact_{file_num}.csv"
        df = pd.read_csv(file_path)
        
        # Shift start_time to 2026
        df = shift_datetime_to_2026(df, 'start_time', TARGET_START_DATE, TARGET_END_DATE)
        
        # Update end_time based on handle_time
        df['end_time'] = pd.to_datetime(df['start_time']) + pd.to_timedelta(df['handle_time_secs'], unit='s')
        
        # Update call recording URLs
        df['call_recording_url'] = df.apply(
            lambda x: f"s3://recordings/{pd.to_datetime(x['start_time']).year}/{pd.to_datetime(x['start_time']).month:02d}/{pd.to_datetime(x['start_time']).day:02d}/{x['call_id']}.wav",
            axis=1
        )
        
        # Add FCR columns (Phase 3.2)
        # 72% FCR rate target
        resolved_dispositions = ['Resolved', 'Completed', 'Issue Fixed', 'Query Answered']
        escalated_dispositions = ['Escalated', 'Callback', 'Transfer', 'Voicemail']
        
        # FCR based on disposition and transfer count
        df['is_first_call_resolved'] = df.apply(
            lambda x: True if x['disposition'] in resolved_dispositions and x['transfer_count'] == 0
                      else (False if x['disposition'] in escalated_dispositions or x['transfer_count'] > 1
                            else np.random.random() < 0.72),
            axis=1
        )
        
        df['callback_required'] = df['disposition'].isin(['Callback', 'Callback Scheduled', 'Follow-up Required'])
        
        # Print FCR stats
        fcr_rate = df['is_first_call_resolved'].mean() * 100
        print(f"  FCR Rate: {fcr_rate:.1f}%")
        
        df.to_csv(file_path, index=False)
        print(f"  Saved {len(df)} records with FCR columns")


def fix_network_alarm_dates():
    """
    Fix network_alarm_fact.csv - shift dates from 2023 to 2026.
    Also ensures proper severity distribution.
    """
    print("\n" + "=" * 60)
    print("PHASE 1: Fixing network_alarm_fact.csv dates (2023 -> 2026)")
    print("=" * 60)
    
    file_path = DATA_DIR / "network_alarm_fact.csv"
    df = pd.read_csv(file_path)
    
    # Shift raised_time to 2026
    df = shift_datetime_to_2026(df, 'raised_time', TARGET_START_DATE, TARGET_END_DATE)
    
    # Update cleared_time for acknowledged alarms
    ack_mask = df['acknowledged'] == True
    df.loc[ack_mask, 'cleared_time'] = pd.to_datetime(df.loc[ack_mask, 'raised_time']) + \
        pd.to_timedelta(np.random.randint(30, 480, size=ack_mask.sum()), unit='m')
    
    # Ensure proper severity distribution: Critical 5%, Major 15%, Minor 40%, Warning 40%
    severity_dist = ['Critical'] * 5 + ['Major'] * 15 + ['Minor'] * 40 + ['Warning'] * 40
    df['severity'] = np.random.choice(severity_dist, size=len(df))
    
    # Print severity distribution
    sev_counts = df['severity'].value_counts(normalize=True) * 100
    print(f"  Severity distribution: {sev_counts.to_dict()}")
    
    df.to_csv(file_path, index=False)
    print(f"  Saved {len(df)} records")
    return df


# ============================================================================
# PHASE 2.2: Payment Method Connection
# ============================================================================

def add_payment_method_to_payment_fact():
    """
    Add payment_method_key column to payment_fact.csv.
    Distribution: Direct Debit 65%, Card 25%, Manual 10%
    """
    print("\n" + "=" * 60)
    print("PHASE 2.2: Adding payment_method_key to payment_fact.csv")
    print("=" * 60)
    
    file_path = DATA_DIR / "payment_fact.csv"
    df = pd.read_csv(file_path)
    
    # Payment method distribution (matches payment_method_dim.csv)
    # 1=Direct Debit, 2=Credit Card, 3=Debit Card, 4=Bank Transfer
    payment_methods = [1] * 65 + [2] * 15 + [3] * 10 + [4] * 10
    
    df['payment_method_key'] = np.random.choice(payment_methods, size=len(df))
    
    # Print distribution
    method_dist = df['payment_method_key'].value_counts(normalize=True) * 100
    print(f"  Payment method distribution: {method_dist.to_dict()}")
    
    df.to_csv(file_path, index=False)
    print(f"  Added payment_method_key to {len(df)} records")
    return df


# ============================================================================
# PHASE 2.3: Revenue Assurance Tables
# ============================================================================

def create_credit_note_fact():
    """
    Create credit_note_fact.csv - Credit notes (~8% of invoices)
    """
    print("\n" + "=" * 60)
    print("PHASE 2.3: Creating credit_note_fact.csv")
    print("=" * 60)
    
    # Load invoice data for reference - ONLY 2026 invoices
    invoices_df = pd.read_csv(DATA_DIR / "invoice_fact.csv")
    invoices_df['invoice_date'] = pd.to_datetime(invoices_df['invoice_date'])
    invoices_2026 = invoices_df[invoices_df['invoice_date'].dt.year == 2026]
    
    if len(invoices_2026) == 0:
        # If no 2026 invoices, create synthetic dates
        print("  No 2026 invoices found, using synthetic dates")
        invoices_2026 = invoices_df.sample(n=min(5000, len(invoices_df)))
        invoices_2026['invoice_date'] = pd.date_range(start=TARGET_START_DATE, periods=len(invoices_2026), freq='H')
    
    customers_df = pd.read_csv(DATA_DIR / "customer_dim.csv")
    
    # Sample ~8% of 2026 invoices for credit notes
    sample_size = max(1000, int(len(invoices_2026) * 0.08))
    sampled_invoices = invoices_2026.sample(n=min(sample_size, len(invoices_2026)))
    
    credit_reasons = ['Billing Error', 'Service Outage Compensation', 'Goodwill Gesture', 
                      'Contract Dispute Resolution', 'Rate Plan Correction', 'Overcharge Refund']
    
    records = []
    for idx, (_, inv) in enumerate(sampled_invoices.iterrows()):
        credit_date = pd.to_datetime(inv['invoice_date']) + timedelta(days=random.randint(3, 14))
        credit_amount = round(float(inv['total_amount']) * random.uniform(0.05, 0.25), 2)
        
        records.append({
            'credit_note_id': str(uuid.uuid4()),
            'customer_key': inv['customer_key'],
            'invoice_id': inv['invoice_id'],
            'credit_date': credit_date.strftime('%Y-%m-%d'),
            'credit_amount': credit_amount,
            'credit_reason': random.choice(credit_reasons),
            'approval_status': random.choices(['Approved', 'Pending'], weights=[85, 15])[0],
            'approved_by': random.choice(['Finance Manager', 'Customer Service Lead', 'Revenue Assurance Team']),
            'created_date': credit_date.strftime('%Y-%m-%d %H:%M:%S')
        })
    
    df = pd.DataFrame(records)
    file_path = DATA_DIR / "credit_note_fact.csv"
    df.to_csv(file_path, index=False)
    print(f"  Created {len(df)} credit notes ({len(df)/len(invoices_df)*100:.1f}% of invoices)")
    return df


def create_billing_adjustment_fact():
    """
    Create billing_adjustment_fact.csv - Adjustments (~5% of customers)
    """
    print("\n" + "=" * 60)
    print("PHASE 2.3: Creating billing_adjustment_fact.csv")
    print("=" * 60)
    
    customers_df = pd.read_csv(DATA_DIR / "customer_dim.csv")
    
    # Sample ~5% of customers
    sample_size = int(len(customers_df) * 0.05)
    sampled_customers = customers_df.sample(n=sample_size)
    
    adjustment_types = ['Rate Correction', 'Usage Rebate', 'Promotional Credit', 
                        'Dispute Settlement', 'Loyalty Adjustment', 'Bundle Discount']
    
    records = []
    for idx, (_, cust) in enumerate(sampled_customers.iterrows()):
        adjustment_date = TARGET_START_DATE + timedelta(days=random.randint(0, 58))
        original_amount = round(random.uniform(30, 250), 2)
        adjusted_amount = round(original_amount * random.uniform(0.5, 0.9), 2)
        
        records.append({
            'adjustment_id': str(uuid.uuid4()),
            'customer_key': cust['customer_key'],
            'adjustment_date': adjustment_date.strftime('%Y-%m-%d'),
            'adjustment_type': random.choice(adjustment_types),
            'original_amount': original_amount,
            'adjusted_amount': adjusted_amount,
            'adjustment_reason': 'Adjustment applied per customer request',
            'created_date': adjustment_date.strftime('%Y-%m-%d %H:%M:%S')
        })
    
    df = pd.DataFrame(records)
    file_path = DATA_DIR / "billing_adjustment_fact.csv"
    df.to_csv(file_path, index=False)
    print(f"  Created {len(df)} billing adjustments ({len(df)/len(customers_df)*100:.1f}% of customers)")
    return df


def create_unbilled_usage_fact():
    """
    Create unbilled_usage_fact.csv - Revenue leakage (~2% of active subscribers)
    """
    print("\n" + "=" * 60)
    print("PHASE 2.3: Creating unbilled_usage_fact.csv")
    print("=" * 60)
    
    subscribers_df = pd.read_csv(DATA_DIR / "mobile_subscriber_dim.csv")
    active_subs = subscribers_df[subscribers_df['status'] == 'Active']
    
    # Sample ~2% of active subscribers
    sample_size = int(len(active_subs) * 0.02)
    sampled_subs = active_subs.sample(n=sample_size)
    
    usage_types = ['Data Overage', 'Roaming Charges', 'Premium Services', 
                   'International Calls', 'MMS Messages', 'Value Added Services']
    unbilled_reasons = ['Mediation Delay', 'Rating Error', 'Integration Lag', 
                        'CDR Processing Delay', 'System Timeout']
    
    records = []
    for idx, (_, sub) in enumerate(sampled_subs.iterrows()):
        usage_date = TARGET_END_DATE - timedelta(days=random.randint(1, 30))
        
        records.append({
            'unbilled_id': str(uuid.uuid4()),
            'subscriber_key': sub['subscriber_key'],
            'usage_date': usage_date.strftime('%Y-%m-%d'),
            'usage_type': random.choice(usage_types),
            'usage_quantity': round(random.uniform(1, 50), 2),
            'estimated_revenue': round(random.uniform(5, 100), 2),
            'reason_unbilled': random.choice(unbilled_reasons),
            'created_date': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        })
    
    df = pd.DataFrame(records)
    file_path = DATA_DIR / "unbilled_usage_fact.csv"
    df.to_csv(file_path, index=False)
    print(f"  Created {len(df)} unbilled usage records ({len(df)/len(active_subs)*100:.1f}% revenue leakage)")
    return df


# ============================================================================
# PHASE 3.1: Add network_generation to mobile_plan_dim
# ============================================================================

def add_network_generation_to_plans():
    """
    Add network_generation column to mobile_plan_dim.csv
    Distribution: 5G 40%, 4G 45%, 4G+ 10%, 3G 5%
    """
    print("\n" + "=" * 60)
    print("PHASE 3.1: Adding network_generation to mobile_plan_dim.csv")
    print("=" * 60)
    
    file_path = DATA_DIR / "mobile_plan_dim.csv"
    df = pd.read_csv(file_path)
    
    # Determine network generation based on 5g_included and price
    def get_network_gen(row):
        if row.get('5g_included', False) == True or str(row.get('5g_included', '')).lower() == 'true':
            return '5G'
        price = float(row.get('monthly_price', 0)) if pd.notna(row.get('monthly_price', 0)) else 0
        if price >= 35:
            return '4G+'
        elif price >= 15:
            return '4G'
        else:
            return '3G'
    
    df['network_generation'] = df.apply(get_network_gen, axis=1)
    
    # Print distribution
    gen_dist = df['network_generation'].value_counts(normalize=True) * 100
    print(f"  Network generation distribution: {gen_dist.to_dict()}")
    
    df.to_csv(file_path, index=False)
    print(f"  Added network_generation to {len(df)} plans")
    return df


# ============================================================================
# PHASE 3.3: Create SIM Activation Fact
# ============================================================================

def create_sim_activation_fact():
    """
    Create sim_activation_fact.csv - SIM activation tracking
    """
    print("\n" + "=" * 60)
    print("PHASE 3.3: Creating sim_activation_fact.csv")
    print("=" * 60)
    
    # Load order and subscriber data
    orders_df = pd.read_csv(DATA_DIR / "order_dim.csv")
    subscribers_df = pd.read_csv(DATA_DIR / "mobile_subscriber_dim.csv")
    
    # Filter orders for 2026 and relevant types
    orders_df['order_date'] = pd.to_datetime(orders_df['order_date'])
    orders_2026 = orders_df[orders_df['order_date'].dt.year == 2026]
    
    if len(orders_2026) == 0:
        # Create sample activations based on subscribers
        sample_size = min(5000, len(subscribers_df))
        sampled_subs = subscribers_df.sample(n=sample_size)
        
        records = []
        channels = ['Retail Store', 'Online', 'Telesales', 'Partner']
        channel_weights = [0.30, 0.40, 0.15, 0.15]
        
        for idx, (_, sub) in enumerate(sampled_subs.iterrows()):
            channel = random.choices(channels, weights=channel_weights)[0]
            
            # Activation time by channel
            if channel == 'Retail Store':
                hours_to_activate = random.uniform(0.5, 4)
            elif channel == 'Online':
                hours_to_activate = random.uniform(12, 48)
            elif channel == 'Telesales':
                hours_to_activate = random.uniform(24, 72)
            else:
                hours_to_activate = random.uniform(6, 24)
            
            order_time = TARGET_START_DATE + timedelta(days=random.randint(0, 58), 
                                                        hours=random.randint(8, 18))
            activation_time = order_time + timedelta(hours=hours_to_activate)
            
            records.append({
                'activation_id': str(uuid.uuid4()),
                'order_id': f'ORD{idx+100000}',
                'subscriber_key': sub['subscriber_key'],
                'sim_iccid': f'89440{random.randint(10000000000, 99999999999)}',
                'order_timestamp': order_time.strftime('%Y-%m-%d %H:%M:%S'),
                'activation_timestamp': activation_time.strftime('%Y-%m-%d %H:%M:%S'),
                'activation_channel': channel,
                'time_to_activate_hours': round(hours_to_activate, 2),
                'activation_status': random.choices(['Completed', 'Pending'], weights=[95, 5])[0],
                'activation_type': random.choice(['New Activation', 'SIM Swap', 'Replacement'])
            })
        
        df = pd.DataFrame(records)
    else:
        # Use actual orders
        records = []
        channels = ['Retail Store', 'Online', 'Telesales', 'Partner']
        
        for idx, (_, order) in enumerate(orders_2026.iterrows()):
            channel = order.get('channel', random.choice(channels))
            
            if channel == 'Retail Store':
                hours_to_activate = random.uniform(0.5, 4)
            elif channel == 'Online':
                hours_to_activate = random.uniform(12, 48)
            elif channel == 'Telesales':
                hours_to_activate = random.uniform(24, 72)
            else:
                hours_to_activate = random.uniform(6, 24)
            
            order_time = pd.to_datetime(order['order_date'])
            activation_time = order_time + timedelta(hours=hours_to_activate)
            
            records.append({
                'activation_id': str(uuid.uuid4()),
                'order_id': order['order_id'],
                'subscriber_key': random.randint(1, len(subscribers_df)),
                'sim_iccid': f'89440{random.randint(10000000000, 99999999999)}',
                'order_timestamp': order_time.strftime('%Y-%m-%d %H:%M:%S'),
                'activation_timestamp': activation_time.strftime('%Y-%m-%d %H:%M:%S'),
                'activation_channel': channel,
                'time_to_activate_hours': round(hours_to_activate, 2),
                'activation_status': random.choices(['Completed', 'Pending'], weights=[95, 5])[0],
                'activation_type': random.choice(['New Activation', 'SIM Swap', 'Replacement'])
            })
        
        df = pd.DataFrame(records)
    
    file_path = DATA_DIR / "sim_activation_fact.csv"
    df.to_csv(file_path, index=False)
    
    # Print stats by channel
    if len(df) > 0:
        channel_stats = df.groupby('activation_channel')['time_to_activate_hours'].mean()
        print(f"  Avg activation time by channel: {channel_stats.to_dict()}")
    
    print(f"  Created {len(df)} SIM activation records")
    return df


# ============================================================================
# PHASE 4: IT Incident Timestamps and Dispute Tracking
# ============================================================================

def enhance_it_incident_fact():
    """
    Add SLA tracking timestamps to it_incident_fact.csv
    """
    print("\n" + "=" * 60)
    print("PHASE 4: Enhancing it_incident_fact.csv with SLA tracking")
    print("=" * 60)
    
    file_path = DATA_DIR / "it_incident_fact.csv"
    df = pd.read_csv(file_path)
    
    # Shift dates to 2026 first if needed
    df['created_date'] = pd.to_datetime(df['created_date'])
    if df['created_date'].dt.year.max() < 2026:
        df = shift_datetime_to_2026(df, 'created_date', TARGET_START_DATE, TARGET_END_DATE)
    
    # Add SLA target based on severity
    # P1: 4 hours, P2: 8 hours, P3: 24 hours, P4: 72 hours
    sla_map = {'P1': 240, 'P2': 480, 'P3': 1440, 'P4': 4320, 
               'Critical': 240, 'High': 480, 'Medium': 1440, 'Low': 4320}
    
    df['sla_target_mins'] = df['severity'].map(sla_map).fillna(1440).astype(int)
    
    # Add timestamps
    df['created_timestamp'] = df['created_date']
    df['assigned_timestamp'] = pd.to_datetime(df['created_date']) + \
        pd.to_timedelta(np.random.randint(5, 30, size=len(df)), unit='m')
    
    # Resolved timestamp for closed incidents
    closed_mask = df['status'].isin(['Closed', 'Resolved'])
    df.loc[closed_mask, 'resolved_timestamp'] = pd.to_datetime(df.loc[closed_mask, 'created_date']) + \
        pd.to_timedelta(df.loc[closed_mask, 'resolution_mins'], unit='m')
    
    # Calculate SLA met
    df['sla_met'] = False
    df.loc[closed_mask, 'sla_met'] = df.loc[closed_mask, 'resolution_mins'] <= df.loc[closed_mask, 'sla_target_mins']
    
    # Print SLA stats
    if closed_mask.any():
        sla_compliance = df.loc[closed_mask, 'sla_met'].mean() * 100
        print(f"  SLA Compliance Rate: {sla_compliance:.1f}%")
    
    df.to_csv(file_path, index=False)
    print(f"  Enhanced {len(df)} incidents with SLA tracking")
    return df


def create_dispute_fact():
    """
    Create dispute_fact.csv - Dispute lifecycle tracking
    """
    print("\n" + "=" * 60)
    print("PHASE 4: Creating dispute_fact.csv")
    print("=" * 60)
    
    # Load invoice and customer data - ONLY 2026 invoices
    invoices_df = pd.read_csv(DATA_DIR / "invoice_fact.csv")
    invoices_df['invoice_date'] = pd.to_datetime(invoices_df['invoice_date'])
    invoices_2026 = invoices_df[invoices_df['invoice_date'].dt.year == 2026]
    
    if len(invoices_2026) == 0:
        # If no 2026 invoices, create synthetic dates
        print("  No 2026 invoices found, using synthetic dates")
        invoices_2026 = invoices_df.sample(n=min(5000, len(invoices_df)))
        invoices_2026['invoice_date'] = pd.date_range(start=TARGET_START_DATE, periods=len(invoices_2026), freq='H')
    
    customers_df = pd.read_csv(DATA_DIR / "customer_dim.csv")
    
    # Sample ~3% of 2026 invoices for disputes
    sample_size = max(500, int(len(invoices_2026) * 0.03))
    sampled_invoices = invoices_2026.sample(n=min(sample_size, len(invoices_2026)))
    
    dispute_types = ['Incorrect Charge', 'Service Not Received', 'Rate Dispute', 
                     'Contract Terms', 'Billing Error', 'Usage Dispute']
    resolution_types = ['Full Credit', 'Partial Credit', 'No Action Required', 
                        'Goodwill Gesture', 'Rate Adjustment']
    teams = ['Billing Team', 'Customer Service', 'Disputes Team', 'Finance']
    
    records = []
    for idx, (_, inv) in enumerate(sampled_invoices.iterrows()):
        dispute_date = pd.to_datetime(inv['invoice_date']) + timedelta(days=random.randint(3, 10))
        disputed_amount = round(float(inv['total_amount']) * random.uniform(0.1, 0.5), 2)
        
        status = random.choices(['Resolved', 'In Progress', 'Escalated'], weights=[70, 20, 10])[0]
        days_to_resolve = random.randint(3, 30)
        resolution_date = dispute_date + timedelta(days=days_to_resolve) if status == 'Resolved' else None
        
        records.append({
            'dispute_id': str(uuid.uuid4()),
            'customer_key': inv['customer_key'],
            'invoice_id': inv['invoice_id'],
            'dispute_date': dispute_date.strftime('%Y-%m-%d'),
            'dispute_type': random.choice(dispute_types),
            'disputed_amount': disputed_amount,
            'status': status,
            'assigned_to': random.choice(teams),
            'response_date': (dispute_date + timedelta(days=random.randint(1, 5))).strftime('%Y-%m-%d'),
            'resolution_date': resolution_date.strftime('%Y-%m-%d') if resolution_date else None,
            'resolution_type': random.choice(resolution_types) if status == 'Resolved' else None,
            'final_amount': round(disputed_amount * random.uniform(0, 0.8), 2) if status == 'Resolved' else None,
            'days_to_resolve': days_to_resolve if status == 'Resolved' else None,
            'sla_met': random.random() < 0.85 if status == 'Resolved' else None,
            'created_date': dispute_date.strftime('%Y-%m-%d %H:%M:%S')
        })
    
    df = pd.DataFrame(records)
    file_path = DATA_DIR / "dispute_fact.csv"
    df.to_csv(file_path, index=False)
    
    # Print stats
    resolved = df[df['status'] == 'Resolved']
    if len(resolved) > 0:
        avg_resolution = resolved['days_to_resolve'].mean()
        print(f"  Avg resolution time: {avg_resolution:.1f} days")
    
    print(f"  Created {len(df)} disputes ({len(df)/len(invoices_df)*100:.1f}% dispute rate)")
    return df


# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    """Run all data regeneration and enhancement phases."""
    print("\n" + "=" * 60)
    print("SnowTelco Demo Data Regeneration & Enhancement")
    print(f"Target: All data in range {TARGET_START_DATE.strftime('%B %Y')} to {TARGET_END_DATE.strftime('%B %d, %Y')}")
    print("=" * 60)
    
    # ==========================================================================
    # PHASE 1: Date Fixes - Shift old dates to 2026
    # ==========================================================================
    print("\n\n" + "=" * 60)
    print("PHASE 1: CRITICAL DATE FIXES (2020/2023 -> 2026)")
    print("=" * 60)
    fix_number_port_fact_dates()
    fix_contact_center_dates()
    fix_network_alarm_dates()
    
    # ==========================================================================
    # PHASE 1B: Critical regenerations
    # ==========================================================================
    print("\n\nPHASE 1B: CRITICAL DATA REGENERATIONS")
    print("=" * 60)
    regenerate_mobile_subscribers()  # Creates subscriber base with B2C/B2B
    regenerate_network_performance()
    regenerate_mobile_usage()
    
    # ==========================================================================
    # PHASE 2: High Impact Data Gaps
    # ==========================================================================
    print("\n\nPHASE 2: HIGH IMPACT DATA GAPS")
    print("=" * 60)
    # 2.1 - Port data already enhanced in fix_number_port_fact_dates
    # 2.2 - Payment method connection
    add_payment_method_to_payment_fact()
    # 2.3 - Revenue assurance tables
    create_credit_note_fact()
    create_billing_adjustment_fact()
    create_unbilled_usage_fact()
    
    # ==========================================================================
    # PHASE 3: Medium Impact Data Gaps
    # ==========================================================================
    print("\n\nPHASE 3: MEDIUM IMPACT DATA GAPS")
    print("=" * 60)
    # 3.1 - Network generation
    add_network_generation_to_plans()
    # 3.2 - FCR already added in fix_contact_center_dates
    # 3.3 - SIM activation tracking
    create_sim_activation_fact()
    
    # ==========================================================================
    # PHASE 4: Lower Impact Enhancements
    # ==========================================================================
    print("\n\nPHASE 4: LOWER IMPACT ENHANCEMENTS")
    print("=" * 60)
    enhance_it_incident_fact()
    create_dispute_fact()
    
    # ==========================================================================
    # PHASE 4B: Add 2025-2026 partners
    # ==========================================================================
    print("\n\nPHASE 4B: ADD 2025-2026 PARTNERS")
    print("=" * 60)
    add_2025_2026_partners()
    
    # ==========================================================================
    # PHASE 5: Extend remaining fact tables to Feb 2026
    # ==========================================================================
    print("\n\nPHASE 5: EXTEND REMAINING FACT TABLES")
    print("=" * 60)
    extend_sales_fact()
    extend_finance_transactions()
    extend_marketing_campaign_fact()
    extend_hr_employee_fact()
    extend_support_ticket_fact()
    extend_invoice_fact()
    extend_payment_fact()
    extend_digital_interaction_fact()
    extend_mobile_churn_fact()
    extend_partner_performance_fact()
    extend_sla_measurement_fact()
    extend_roaming_usage_fact()
    extend_iot_usage_fact()
    extend_loyalty_transaction_fact()
    extend_complaint_fact()
    extend_inventory_fact()
    extend_purchase_order_fact()
    extend_sf_opportunities()
    
    print("\n" + "=" * 60)
    print("DATA REGENERATION & ENHANCEMENT COMPLETE")
    print("=" * 60)
    print(f"\nAll data now in range: {TARGET_START_DATE.strftime('%B %Y')} to {TARGET_END_DATE.strftime('%B %d, %Y')}")
    print("\nNew files created:")
    print("  - credit_note_fact.csv (Revenue Assurance)")
    print("  - billing_adjustment_fact.csv (Revenue Assurance)")
    print("  - unbilled_usage_fact.csv (Revenue Assurance)")
    print("  - sim_activation_fact.csv (Operations)")
    print("  - dispute_fact.csv (Billing)")
    print("\nEnhanced columns added:")
    print("  - payment_fact.csv: payment_method_key")
    print("  - mobile_plan_dim.csv: network_generation")
    print("  - contact_center_call_fact_*.csv: is_first_call_resolved, callback_required")
    print("  - it_incident_fact.csv: sla_target_mins, created_timestamp, assigned_timestamp, resolved_timestamp, sla_met")
    print("\nNext steps:")
    print("1. Review the generated data")
    print("2. Update semantic_views.sql with new views")
    print("3. Update demo_setup.sql agent configuration")
    print("4. Reload data into Snowflake")


if __name__ == "__main__":
    main()
