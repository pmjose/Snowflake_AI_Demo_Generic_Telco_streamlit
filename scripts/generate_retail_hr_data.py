#!/usr/bin/env python3
"""
Generate Retail Store and Enhanced HR data for SnowTelco:
1. Retail Store Data - Store locations, sales, footfall
2. Enhanced HR Data - Employee work locations, reporting, performance

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

# UK Cities with populations for store distribution
UK_CITIES = {
    'London': {'population': 9000000, 'stores': 45, 'region': 'London'},
    'Birmingham': {'population': 1150000, 'stores': 12, 'region': 'West Midlands'},
    'Manchester': {'population': 550000, 'stores': 10, 'region': 'North West'},
    'Leeds': {'population': 500000, 'stores': 8, 'region': 'Yorkshire'},
    'Glasgow': {'population': 635000, 'stores': 8, 'region': 'Scotland'},
    'Liverpool': {'population': 500000, 'stores': 7, 'region': 'North West'},
    'Bristol': {'population': 465000, 'stores': 6, 'region': 'South West'},
    'Sheffield': {'population': 585000, 'stores': 6, 'region': 'Yorkshire'},
    'Edinburgh': {'population': 540000, 'stores': 6, 'region': 'Scotland'},
    'Cardiff': {'population': 365000, 'stores': 5, 'region': 'Wales'},
    'Newcastle': {'population': 300000, 'stores': 5, 'region': 'North East'},
    'Nottingham': {'population': 330000, 'stores': 5, 'region': 'East Midlands'},
    'Leicester': {'population': 355000, 'stores': 4, 'region': 'East Midlands'},
    'Southampton': {'population': 255000, 'stores': 4, 'region': 'South East'},
    'Brighton': {'population': 290000, 'stores': 4, 'region': 'South East'},
    'Reading': {'population': 230000, 'stores': 3, 'region': 'South East'},
    'Aberdeen': {'population': 200000, 'stores': 3, 'region': 'Scotland'},
    'Belfast': {'population': 340000, 'stores': 4, 'region': 'Northern Ireland'},
    'Coventry': {'population': 370000, 'stores': 3, 'region': 'West Midlands'},
    'Plymouth': {'population': 265000, 'stores': 3, 'region': 'South West'},
    'Stoke': {'population': 255000, 'stores': 2, 'region': 'West Midlands'},
    'Wolverhampton': {'population': 265000, 'stores': 2, 'region': 'West Midlands'},
    'Derby': {'population': 260000, 'stores': 2, 'region': 'East Midlands'},
    'Swansea': {'population': 245000, 'stores': 2, 'region': 'Wales'},
    'Milton Keynes': {'population': 230000, 'stores': 2, 'region': 'South East'},
    'Cambridge': {'population': 125000, 'stores': 2, 'region': 'East'},
    'Oxford': {'population': 155000, 'stores': 2, 'region': 'South East'},
    'York': {'population': 210000, 'stores': 2, 'region': 'Yorkshire'},
    'Norwich': {'population': 145000, 'stores': 2, 'region': 'East'},
    'Exeter': {'population': 130000, 'stores': 1, 'region': 'South West'},
}

# ============================================================================
# 1. RETAIL STORE DATA
# ============================================================================

def generate_retail_store_dim():
    """Generate retail store dimension table."""
    
    store_types = ['Flagship', 'Standard', 'Express', 'Kiosk', 'Partner Store']
    store_formats = ['High Street', 'Shopping Centre', 'Retail Park', 'Airport', 'Train Station']
    
    stores = []
    store_id = 1
    
    for city, info in UK_CITIES.items():
        num_stores = info['stores']
        for i in range(num_stores):
            # Determine store type based on position
            if i == 0 and num_stores >= 5:
                store_type = 'Flagship'
            elif i < num_stores * 0.3:
                store_type = 'Standard'
            elif i < num_stores * 0.6:
                store_type = random.choice(['Standard', 'Express'])
            else:
                store_type = random.choice(['Express', 'Kiosk', 'Partner Store'])
            
            # Store format
            if store_type == 'Flagship':
                store_format = 'High Street'
            elif store_type == 'Kiosk':
                store_format = random.choice(['Shopping Centre', 'Airport', 'Train Station'])
            else:
                store_format = random.choice(store_formats)
            
            # Opening date
            years_open = random.randint(1, 15)
            open_date = datetime.now() - timedelta(days=years_open * 365 + random.randint(0, 364))
            
            # Store size
            if store_type == 'Flagship':
                sqft = random.randint(3000, 6000)
            elif store_type == 'Standard':
                sqft = random.randint(1500, 3000)
            elif store_type == 'Express':
                sqft = random.randint(800, 1500)
            elif store_type == 'Kiosk':
                sqft = random.randint(100, 400)
            else:
                sqft = random.randint(500, 1200)
            
            # Staff count based on size
            staff_count = max(2, sqft // 300)
            
            stores.append({
                'store_id': store_id,
                'store_name': f'SnowTelco {city} {store_format.split()[0]} {i+1}' if i > 0 else f'SnowTelco {city} {store_type}',
                'store_code': f'ST{store_id:04d}',
                'store_type': store_type,
                'store_format': store_format,
                'city': city,
                'region': info['region'],
                'postcode': f'{city[:2].upper()}{random.randint(1,9)} {random.randint(1,9)}{random.choice("ABCDEFGHJKLMNPQRSTUVWXYZ")}{random.choice("ABCDEFGHJKLMNPQRSTUVWXYZ")}',
                'latitude': round(random.uniform(50.0, 58.0), 6),
                'longitude': round(random.uniform(-5.0, 2.0), 6),
                'opening_date': open_date.strftime('%Y-%m-%d'),
                'store_sqft': sqft,
                'staff_count': staff_count,
                'manager_name': f'{random.choice(["James","Sarah","Michael","Emma","David","Sophie","Daniel","Lucy"])} {random.choice(["Smith","Jones","Williams","Brown","Taylor","Davies","Wilson","Evans"])}',
                'status': random.choices(['Active', 'Refurbishment', 'Closing'], weights=[0.95, 0.03, 0.02])[0],
                'has_repair_centre': random.choices([True, False], weights=[0.3, 0.7])[0] if store_type in ['Flagship', 'Standard'] else False,
                'has_business_area': store_type == 'Flagship',
            })
            store_id += 1
    
    return pd.DataFrame(stores)


def generate_retail_sales_fact(stores_df, num_records=200000):
    """Generate retail sales fact table."""
    
    product_categories = ['Handset', 'SIM Only', 'Accessories', 'Tablet', 'Wearable', 'Broadband', 'Insurance', 'Trade-in']
    category_weights = [0.30, 0.25, 0.18, 0.08, 0.06, 0.05, 0.05, 0.03]
    
    payment_types = ['Contract', 'PAYG', 'One-time', 'Upgrade']
    
    sales = []
    store_ids = stores_df['store_id'].tolist()
    
    for i in range(1, num_records + 1):
        store_id = random.choice(store_ids)
        store_row = stores_df[stores_df['store_id'] == store_id].iloc[0]
        
        sale_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        
        # Weekday vs weekend patterns
        is_weekend = sale_date.weekday() >= 5
        
        category = random.choices(product_categories, weights=category_weights)[0]
        
        # Price based on category
        if category == 'Handset':
            unit_price = round(random.uniform(200, 1200), 2)
            quantity = 1
        elif category == 'SIM Only':
            unit_price = round(random.uniform(10, 50), 2)
            quantity = 1
        elif category == 'Accessories':
            unit_price = round(random.uniform(10, 100), 2)
            quantity = random.randint(1, 3)
        elif category == 'Tablet':
            unit_price = round(random.uniform(300, 800), 2)
            quantity = 1
        elif category == 'Wearable':
            unit_price = round(random.uniform(150, 400), 2)
            quantity = 1
        elif category == 'Broadband':
            unit_price = round(random.uniform(25, 60), 2)
            quantity = 1
        elif category == 'Insurance':
            unit_price = round(random.uniform(8, 15), 2)
            quantity = 1
        else:  # Trade-in
            unit_price = round(random.uniform(-300, -50), 2)  # Negative for trade-in credit
            quantity = 1
        
        total_amount = round(unit_price * quantity, 2)
        
        # Commission for staff
        commission = round(abs(total_amount) * random.uniform(0.02, 0.08), 2)
        
        sales.append({
            'sale_id': i,
            'store_id': store_id,
            'sale_date': sale_date.strftime('%Y-%m-%d'),
            'sale_timestamp': (sale_date + timedelta(hours=random.randint(9, 20), minutes=random.randint(0, 59))).strftime('%Y-%m-%d %H:%M:%S'),
            'sale_month': sale_date.strftime('%Y-%m'),
            'product_category': category,
            'product_name': f'{category} Product {random.randint(1, 50)}',
            'quantity': quantity,
            'unit_price': unit_price,
            'total_amount': total_amount,
            'payment_type': random.choice(payment_types) if category in ['Handset', 'SIM Only', 'Tablet'] else 'One-time',
            'contract_length_months': random.choice([12, 24, 36]) if category in ['Handset', 'SIM Only', 'Broadband'] else None,
            'customer_type': random.choices(['New', 'Upgrade', 'Add Line'], weights=[0.40, 0.45, 0.15])[0],
            'staff_id': f'EMP{random.randint(1, 500):04d}',
            'commission_amount': commission,
            'is_weekend': is_weekend,
            'channel': 'Retail Store',
        })
    
    return pd.DataFrame(sales)


def generate_retail_footfall_fact(stores_df, num_records=50000):
    """Generate retail footfall/traffic fact table."""
    
    footfall = []
    store_ids = stores_df['store_id'].tolist()
    
    # Generate daily footfall for each store
    record_id = 1
    for store_id in store_ids:
        store_row = stores_df[stores_df['store_id'] == store_id].iloc[0]
        store_type = store_row['store_type']
        
        # Base footfall by store type
        if store_type == 'Flagship':
            base_footfall = random.randint(300, 600)
        elif store_type == 'Standard':
            base_footfall = random.randint(150, 300)
        elif store_type == 'Express':
            base_footfall = random.randint(80, 150)
        elif store_type == 'Kiosk':
            base_footfall = random.randint(40, 100)
        else:
            base_footfall = random.randint(50, 120)
        
        current_date = START_DATE
        while current_date <= END_DATE:
            # Day of week adjustment
            dow = current_date.weekday()
            if dow == 5:  # Saturday
                multiplier = 1.4
            elif dow == 6:  # Sunday
                multiplier = 1.1
            elif dow == 0:  # Monday
                multiplier = 0.85
            else:
                multiplier = 1.0
            
            # Seasonal adjustment
            month = current_date.month
            if month in [11, 12]:  # Holiday season
                multiplier *= 1.3
            elif month in [1, 2]:  # Post-holiday lull
                multiplier *= 0.85
            
            daily_footfall = int(base_footfall * multiplier * random.uniform(0.8, 1.2))
            
            # Conversion rate (typically 15-35%)
            conversion_rate = round(random.uniform(0.15, 0.35), 3)
            transactions = int(daily_footfall * conversion_rate)
            
            footfall.append({
                'footfall_id': record_id,
                'store_id': store_id,
                'footfall_date': current_date.strftime('%Y-%m-%d'),
                'footfall_month': current_date.strftime('%Y-%m'),
                'day_of_week': current_date.strftime('%A'),
                'visitor_count': daily_footfall,
                'transaction_count': transactions,
                'conversion_rate': conversion_rate,
                'avg_dwell_time_mins': random.randint(8, 25),
                'peak_hour': random.choice(['12:00', '13:00', '14:00', '15:00', '16:00', '17:00']),
                'weather': random.choices(['Sunny', 'Cloudy', 'Rainy', 'Cold'], weights=[0.25, 0.40, 0.25, 0.10])[0],
            })
            record_id += 1
            current_date += timedelta(days=random.randint(1, 3))  # Sample days, not every day
    
    return pd.DataFrame(footfall)


# ============================================================================
# 2. ENHANCED HR DATA
# ============================================================================

def generate_enhanced_employee_dim(stores_df, num_employees=2000):
    """Generate enhanced employee dimension with work locations."""
    
    departments = [
        'Retail Operations', 'Network Engineering', 'Customer Service', 'Finance', 
        'Marketing', 'Sales - B2B', 'Sales - Consumer', 'HR', 'IT', 'Legal',
        'Product Management', 'Supply Chain', 'Facilities', 'Security', 'Executive'
    ]
    
    job_levels = ['Entry', 'Junior', 'Mid', 'Senior', 'Lead', 'Manager', 'Director', 'VP', 'C-Suite']
    
    employment_types = ['Full-time', 'Part-time', 'Contract', 'Intern']
    
    # Work locations - mix of stores, offices, and remote
    office_locations = ['London HQ', 'Manchester Office', 'Birmingham Office', 'Edinburgh Office', 'Cardiff Office']
    
    employees = []
    
    for i in range(1, num_employees + 1):
        department = random.choices(departments, weights=[
            0.25, 0.12, 0.18, 0.06, 0.05, 0.08, 0.06, 0.04, 0.06, 0.02, 0.03, 0.02, 0.01, 0.01, 0.01
        ])[0]
        
        # Job level distribution
        job_level = random.choices(job_levels, weights=[
            0.15, 0.20, 0.25, 0.18, 0.10, 0.07, 0.03, 0.015, 0.005
        ])[0]
        
        # Hire date
        tenure_days = random.randint(30, 3650)  # Up to 10 years
        hire_date = datetime.now() - timedelta(days=tenure_days)
        
        # Work location based on department
        if department == 'Retail Operations':
            store = stores_df.sample(1).iloc[0]
            work_location = store['store_name']
            work_city = store['city']
            work_type = 'On-site'
        elif department in ['Network Engineering', 'IT']:
            work_location = random.choice(office_locations)
            work_city = work_location.split()[0]
            work_type = random.choices(['On-site', 'Hybrid', 'Remote'], weights=[0.3, 0.5, 0.2])[0]
        elif department in ['Customer Service']:
            work_location = random.choice(['London Contact Centre', 'Manchester Contact Centre', 'Glasgow Contact Centre'])
            work_city = work_location.split()[0]
            work_type = random.choices(['On-site', 'Hybrid', 'Remote'], weights=[0.4, 0.4, 0.2])[0]
        else:
            work_location = random.choice(office_locations)
            work_city = work_location.split()[0]
            work_type = random.choices(['On-site', 'Hybrid', 'Remote'], weights=[0.2, 0.5, 0.3])[0]
        
        # Salary based on level
        salary_ranges = {
            'Entry': (22000, 28000), 'Junior': (28000, 38000), 'Mid': (38000, 55000),
            'Senior': (55000, 75000), 'Lead': (70000, 95000), 'Manager': (80000, 120000),
            'Director': (110000, 160000), 'VP': (150000, 250000), 'C-Suite': (250000, 500000)
        }
        salary_range = salary_ranges[job_level]
        salary = round(random.uniform(salary_range[0], salary_range[1]), 0)
        
        # Manager ID
        if job_level in ['Entry', 'Junior', 'Mid']:
            manager_id = f'EMP{random.randint(1, 500):04d}'
        elif job_level in ['Senior', 'Lead']:
            manager_id = f'EMP{random.randint(1, 200):04d}'
        elif job_level == 'Manager':
            manager_id = f'EMP{random.randint(1, 50):04d}'
        else:
            manager_id = None
        
        employees.append({
            'employee_id': f'EMP{i:04d}',
            'employee_name': f'{random.choice(["James","Sarah","Michael","Emma","David","Sophie","Daniel","Lucy","Thomas","Charlotte","William","Olivia","Harry","Amelia","George","Emily"])} {random.choice(["Smith","Jones","Williams","Brown","Taylor","Davies","Wilson","Evans","Thomas","Roberts","Johnson","Walker","Wright","Thompson","White","Hall"])}',
            'email': f'emp{i:04d}@snowtelco.co.uk',
            'department': department,
            'job_title': f'{job_level} {department.split(" - ")[0] if " - " in department else department} Specialist' if job_level not in ['Manager', 'Director', 'VP', 'C-Suite'] else f'{job_level} of {department}',
            'job_level': job_level,
            'employment_type': random.choices(employment_types, weights=[0.80, 0.12, 0.06, 0.02])[0],
            'hire_date': hire_date.strftime('%Y-%m-%d'),
            'tenure_years': round(tenure_days / 365, 1),
            'work_location': work_location,
            'work_city': work_city,
            'work_type': work_type,
            'salary': salary,
            'manager_id': manager_id,
            'cost_centre': f'CC{departments.index(department) + 1:03d}',
            'status': random.choices(['Active', 'On Leave', 'Notice Period'], weights=[0.94, 0.04, 0.02])[0],
            'gender': random.choice(['M', 'F', 'Other']),
            'age_band': random.choices(['18-24', '25-34', '35-44', '45-54', '55+'], weights=[0.10, 0.35, 0.30, 0.18, 0.07])[0],
            'performance_rating': random.choices([1, 2, 3, 4, 5], weights=[0.03, 0.12, 0.35, 0.35, 0.15])[0],
            'last_promotion_date': (hire_date + timedelta(days=random.randint(180, tenure_days))).strftime('%Y-%m-%d') if tenure_days > 365 else None,
            'training_hours_ytd': random.randint(0, 80),
        })
    
    return pd.DataFrame(employees)


def generate_employee_survey_fact(employees_df, num_records=4000):
    """Generate employee engagement survey data."""
    
    survey_types = ['Annual Engagement', 'Pulse Survey', 'Exit Survey', 'Onboarding Survey']
    
    surveys = []
    employee_ids = employees_df['employee_id'].tolist()
    
    for i in range(1, num_records + 1):
        employee_id = random.choice(employee_ids)
        employee = employees_df[employees_df['employee_id'] == employee_id].iloc[0]
        
        survey_date = START_DATE + timedelta(days=random.randint(0, TOTAL_DAYS))
        survey_type = random.choices(survey_types, weights=[0.40, 0.45, 0.05, 0.10])[0]
        
        # Scores typically 1-5 or 1-10
        engagement_score = random.choices([1, 2, 3, 4, 5], weights=[0.02, 0.08, 0.25, 0.40, 0.25])[0]
        
        surveys.append({
            'survey_id': i,
            'employee_id': employee_id,
            'department': employee['department'],
            'work_location': employee['work_location'],
            'survey_date': survey_date.strftime('%Y-%m-%d'),
            'survey_month': survey_date.strftime('%Y-%m'),
            'survey_type': survey_type,
            'engagement_score': engagement_score,
            'satisfaction_score': random.randint(1, 5),
            'manager_rating': random.randint(1, 5),
            'career_growth_score': random.randint(1, 5),
            'work_life_balance': random.randint(1, 5),
            'compensation_satisfaction': random.randint(1, 5),
            'would_recommend': random.choices([True, False], weights=[0.72, 0.28])[0],
            'enps_score': random.randint(-100, 100),  # Employee NPS
            'comments_provided': random.choices([True, False], weights=[0.35, 0.65])[0],
        })
    
    return pd.DataFrame(surveys)


# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    print("=" * 60)
    print("Generating Retail Store and Enhanced HR Data")
    print("=" * 60)
    
    # 1. Retail Store Data
    print("\n1. Generating Retail Store Data...")
    
    stores_df = generate_retail_store_dim()
    stores_df.to_csv(os.path.join(OUTPUT_DIR, 'retail_store_dim.csv'), index=False)
    print(f"   - retail_store_dim.csv: {len(stores_df)} stores")
    
    sales_df = generate_retail_sales_fact(stores_df)
    sales_df.to_csv(os.path.join(OUTPUT_DIR, 'retail_sales_fact.csv'), index=False)
    print(f"   - retail_sales_fact.csv: {len(sales_df)} sales records")
    
    footfall_df = generate_retail_footfall_fact(stores_df)
    footfall_df.to_csv(os.path.join(OUTPUT_DIR, 'retail_footfall_fact.csv'), index=False)
    print(f"   - retail_footfall_fact.csv: {len(footfall_df)} footfall records")
    
    # 2. Enhanced HR Data
    print("\n2. Generating Enhanced HR Data...")
    
    employees_df = generate_enhanced_employee_dim(stores_df)
    employees_df.to_csv(os.path.join(OUTPUT_DIR, 'employee_detail_dim.csv'), index=False)
    print(f"   - employee_detail_dim.csv: {len(employees_df)} employees")
    
    surveys_df = generate_employee_survey_fact(employees_df)
    surveys_df.to_csv(os.path.join(OUTPUT_DIR, 'employee_survey_fact.csv'), index=False)
    print(f"   - employee_survey_fact.csv: {len(surveys_df)} survey responses")
    
    # Summary
    print("\n" + "=" * 60)
    print("GENERATION COMPLETE")
    print("=" * 60)
    
    total_records = len(stores_df) + len(sales_df) + len(footfall_df) + len(employees_df) + len(surveys_df)
    
    print(f"\nTotal new records: {total_records:,}")
    print(f"Files created: 5")
    print(f"  - Retail: {len(stores_df)} stores, {len(sales_df)} sales, {len(footfall_df)} footfall")
    print(f"  - HR: {len(employees_df)} employees, {len(surveys_df)} surveys")
    print(f"Output directory: {OUTPUT_DIR}")


if __name__ == '__main__':
    main()
