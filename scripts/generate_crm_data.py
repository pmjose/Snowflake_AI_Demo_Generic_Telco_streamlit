#!/usr/bin/env python3
"""
SnowTelco CRM/Sales Data Generator
==================================
Generates Salesforce-style CRM data including:
- Sales Quotas (sf_quotas)
- Pipeline Snapshots (sf_pipeline_snapshot)
- Additional Opportunities (sf_opportunities)

For years 2024, 2025, and 2026 (Jan-Feb).

Usage:
    python scripts/generate_crm_data.py
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# Configuration
DEMO_DATA_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'demo_data')
OUTPUT_2026_PATH = DEMO_DATA_PATH
OUTPUT_2025_PATH = os.path.join(DEMO_DATA_PATH, 'additional_data', '2025', 'csv')
OUTPUT_2024_PATH = os.path.join(DEMO_DATA_PATH, 'additional_data', '2024', 'csv')

# Random seed for reproducibility
np.random.seed(42)
random.seed(42)

# Salesforce-style stage definitions with probabilities
STAGES = [
    ('Prospecting', 10),
    ('Qualification', 20),
    ('Needs Analysis', 40),
    ('Value Proposition', 50),
    ('Proposal/Price Quote', 60),
    ('Negotiation/Review', 75),
    ('Id. Decision Makers', 80),
    ('Perception Analysis', 85),
    ('Closed Won', 100),
    ('Closed Lost', 0)
]

OPEN_STAGES = [s for s in STAGES if s[0] not in ('Closed Won', 'Closed Lost')]

# Stage distribution for open pipeline
OPEN_STAGE_WEIGHTS = [0.25, 0.18, 0.15, 0.12, 0.12, 0.10, 0.05, 0.03]

# Teams and territories
TEAMS = ['Enterprise', 'SMB', 'Consumer', 'Partners']
TEAM_WEIGHTS = [0.25, 0.35, 0.30, 0.10]

TERRITORIES = ['London', 'South East', 'Midlands', 'North', 'Scotland', 'Wales']
TERRITORY_WEIGHTS = [0.25, 0.20, 0.20, 0.20, 0.10, 0.05]

# Quota types
QUOTA_TYPES = ['Revenue', 'New Business', 'Renewals', 'Upsell']
QUOTA_TYPE_WEIGHTS = [0.40, 0.25, 0.20, 0.15]

# Lead sources
LEAD_SOURCES = ['Web', 'Phone Inquiry', 'Partner Referral', 'Purchased List', 'Other', 'Campaign']
LEAD_SOURCE_WEIGHTS = [0.30, 0.20, 0.20, 0.10, 0.10, 0.10]

# Opportunity types
OPP_TYPES = ['New Customer', 'Existing Customer - Upgrade', 'Existing Customer - Replacement', 
             'Existing Customer - Downgrade', 'Renewal']
OPP_TYPE_WEIGHTS = [0.30, 0.25, 0.20, 0.10, 0.15]

# Product names for opportunity naming
PRODUCTS = [
    'Cloud Communications', 'UCaaS Project', 'Contact Centre Solution',
    'Digital Transformation', 'Workforce Management', 'Mobile Enterprise',
    '5G Business Solution', 'IoT Platform', 'Secure Communications',
    'Hybrid Cloud', 'SD-WAN Deployment', 'SIP Trunks'
]


def load_sales_reps():
    """Load sales rep dimension."""
    filepath = os.path.join(DEMO_DATA_PATH, 'sales_rep_dim.csv')
    if os.path.exists(filepath):
        df = pd.read_csv(filepath)
        return df.to_dict('records')
    return []


def load_accounts():
    """Load Salesforce accounts."""
    filepath = os.path.join(DEMO_DATA_PATH, 'sf_accounts.csv')
    if os.path.exists(filepath):
        df = pd.read_csv(filepath)
        return df.to_dict('records')
    return []


def get_fiscal_quarter(month):
    """Returns fiscal quarter (1-4) for a given month."""
    return ((month - 1) // 3) + 1


def generate_quotas(year, reps, output_path, id_offset=0):
    """
    Generate sales quotas for a given year.
    
    Args:
        year: Calendar year
        reps: List of sales rep dictionaries
        output_path: Where to save the CSV
        id_offset: Offset for quota IDs
    """
    print(f"\nGenerating sf_quotas for {year}...")
    
    # Determine months to generate
    if year == 2026:
        months = [1, 2]  # Jan-Feb 2026
    else:
        months = list(range(1, 13))  # Full year
    
    # Base quota amounts by team (monthly)
    team_quotas = {
        'Enterprise': 150000,
        'SMB': 75000,
        'Consumer': 50000,
        'Partners': 100000
    }
    
    # YoY growth factors
    year_factors = {2024: 1.0, 2025: 1.05, 2026: 1.10}
    
    records = []
    quota_id = id_offset + 1
    
    for rep in reps:
        rep_key = rep['sales_rep_key']
        rep_name = rep['rep_name']
        role = rep['role']
        
        # Assign team based on role
        if 'Enterprise' in role:
            team = 'Enterprise'
        elif 'Channel' in role:
            team = 'Partners'
        elif 'Inside' in role:
            team = 'Consumer'
        else:
            team = random.choices(TEAMS, weights=TEAM_WEIGHTS)[0]
        
        # Assign territory
        territory = random.choices(TERRITORIES, weights=TERRITORY_WEIGHTS)[0]
        
        # Base quota for this rep
        base_quota = team_quotas[team] * year_factors.get(year, 1.0)
        
        # Add some variance (+/- 20%)
        rep_multiplier = 0.8 + random.random() * 0.4
        
        for month in months:
            # Seasonal adjustments
            seasonal_factor = {
                1: 0.90, 2: 0.95, 3: 1.00, 4: 1.00, 5: 0.95,
                6: 0.90, 7: 0.85, 8: 0.80, 9: 0.95, 10: 1.00,
                11: 1.10, 12: 1.15
            }.get(month, 1.0)
            
            period_start = datetime(year, month, 1)
            if month == 12:
                period_end = datetime(year, 12, 31)
            else:
                period_end = datetime(year, month + 1, 1) - timedelta(days=1)
            
            quota_amount = base_quota * rep_multiplier * seasonal_factor
            
            # Create quota for each quota type
            quota_type = random.choices(QUOTA_TYPES, weights=QUOTA_TYPE_WEIGHTS)[0]
            
            records.append({
                'quota_id': f'QTA{quota_id:08d}',
                'user_id': f'USR{rep_key:06d}',
                'rep_name': rep_name,
                'team': team,
                'period_start': period_start.strftime('%Y-%m-%d'),
                'period_end': period_end.strftime('%Y-%m-%d'),
                'quota_amount': round(quota_amount, 2),
                'quota_type': quota_type,
                'territory': territory,
                'fiscal_year': year,
                'fiscal_quarter': get_fiscal_quarter(month)
            })
            quota_id += 1
    
    df = pd.DataFrame(records)
    
    # Save
    os.makedirs(output_path, exist_ok=True)
    if year == 2026:
        filename = 'sf_quotas.csv'
    else:
        filename = f'sf_quotas_{year}.csv'
    
    filepath = os.path.join(output_path, filename)
    df.to_csv(filepath, index=False)
    print(f"  Created: {filename} ({len(df):,} rows)")
    
    return df


def generate_pipeline_snapshots(year, output_path, id_offset=0):
    """
    Generate weekly pipeline snapshots for trend analysis.
    
    Args:
        year: Calendar year
        output_path: Where to save the CSV
        id_offset: Offset for snapshot IDs
    """
    print(f"\nGenerating sf_pipeline_snapshot for {year}...")
    
    # Determine date range
    if year == 2026:
        start_date = datetime(2026, 1, 1)
        end_date = datetime(2026, 2, 28)
    else:
        start_date = datetime(year, 1, 1)
        end_date = datetime(year, 12, 31)
    
    # YoY factors
    year_factors = {2024: 1.0, 2025: 1.05, 2026: 1.10}
    base_factor = year_factors.get(year, 1.0)
    
    # Base pipeline values per stage
    base_values = {
        'Prospecting': 5000000,
        'Qualification': 4000000,
        'Needs Analysis': 3500000,
        'Value Proposition': 3000000,
        'Proposal/Price Quote': 2800000,
        'Negotiation/Review': 2500000,
        'Id. Decision Makers': 1500000,
        'Perception Analysis': 1000000,
        'Closed Won': 0,  # Not tracked in snapshot
        'Closed Lost': 0
    }
    
    records = []
    snapshot_id = id_offset + 1
    
    current_date = start_date
    while current_date <= end_date:
        # Weekly snapshots (Fridays)
        if current_date.weekday() == 4:  # Friday
            # Seasonal factor
            month = current_date.month
            seasonal = {
                1: 0.85, 2: 0.90, 3: 0.95, 4: 1.00, 5: 1.00, 6: 0.95,
                7: 0.90, 8: 0.85, 9: 0.95, 10: 1.05, 11: 1.10, 12: 1.15
            }.get(month, 1.0)
            
            for stage_name, probability in OPEN_STAGES:
                if base_values[stage_name] == 0:
                    continue
                
                # Add some randomness
                variance = 0.85 + random.random() * 0.30
                total_amount = base_values[stage_name] * base_factor * seasonal * variance
                
                # Calculate weighted amount
                weighted_amount = total_amount * (probability / 100)
                
                # Opportunity count (proportional to amount)
                opp_count = int(total_amount / 50000 * variance)  # Avg deal ~50k
                
                # Average days in stage
                avg_days = random.randint(5, 45)
                
                records.append({
                    'snapshot_id': f'SNP{snapshot_id:08d}',
                    'snapshot_date': current_date.strftime('%Y-%m-%d'),
                    'stage_name': stage_name,
                    'opportunity_count': opp_count,
                    'total_amount': round(total_amount, 2),
                    'weighted_amount': round(weighted_amount, 2),
                    'avg_days_in_stage': avg_days
                })
                snapshot_id += 1
        
        current_date += timedelta(days=1)
    
    df = pd.DataFrame(records)
    
    # Save
    os.makedirs(output_path, exist_ok=True)
    if year == 2026:
        filename = 'sf_pipeline_snapshot.csv'
    else:
        filename = f'sf_pipeline_snapshot_{year}.csv'
    
    filepath = os.path.join(output_path, filename)
    df.to_csv(filepath, index=False)
    print(f"  Created: {filename} ({len(df):,} rows)")
    
    return df


def generate_opportunities(year, accounts, output_path, id_offset=0, open_only=False):
    """
    Generate opportunity records.
    
    Args:
        year: Calendar year
        accounts: List of account dictionaries
        output_path: Where to save the CSV
        id_offset: Offset for opportunity IDs
        open_only: If True, only generate open pipeline (for 2026)
    """
    print(f"\nGenerating sf_opportunities for {year}{'(open pipeline)' if open_only else ''}...")
    
    # Determine record count
    if open_only:
        # 2026 open pipeline - 8,000 opportunities
        num_records = 8000
        start_date = datetime(2026, 1, 1)
        end_date = datetime(2026, 2, 28)
        close_start = datetime(2026, 2, 1)
        close_end = datetime(2026, 6, 30)  # Expected close dates
    elif year == 2025:
        num_records = 15000
        start_date = datetime(2025, 1, 1)
        end_date = datetime(2025, 12, 31)
        close_start = start_date
        close_end = end_date
    else:  # 2024
        num_records = 12000
        start_date = datetime(2024, 1, 1)
        end_date = datetime(2024, 12, 31)
        close_start = start_date
        close_end = end_date
    
    records = []
    opp_id = id_offset + 1
    
    for i in range(num_records):
        # Select random account
        account = random.choice(accounts)
        account_id = account['account_id']
        account_name = account['account_name']
        
        # Determine stage
        if open_only:
            # Only open stages for 2026
            stage_idx = random.choices(range(len(OPEN_STAGES)), weights=OPEN_STAGE_WEIGHTS)[0]
            stage_name, probability = OPEN_STAGES[stage_idx]
        else:
            # Historical data - weighted toward closed
            if random.random() < 0.48:  # 48% closed won
                stage_name, probability = 'Closed Won', 100
            elif random.random() < 0.97:  # ~3% of remainder closed lost
                stage_name, probability = 'Closed Lost', 0
            else:
                stage_idx = random.choices(range(len(OPEN_STAGES)), weights=OPEN_STAGE_WEIGHTS)[0]
                stage_name, probability = OPEN_STAGES[stage_idx]
        
        # Generate dates
        created_date = start_date + timedelta(days=random.randint(0, (end_date - start_date).days))
        
        if open_only:
            # Future close dates for open pipeline
            close_date = close_start + timedelta(days=random.randint(0, (close_end - close_start).days))
        else:
            # Historical close dates
            days_to_close = random.randint(30, 180)
            close_date = created_date + timedelta(days=days_to_close)
            if close_date > end_date:
                close_date = end_date
        
        # Amount based on account vertical
        vertical = account.get('vertical', 'SMB')
        if vertical == 'Enterprise':
            base_amount = random.uniform(50000, 250000)
        elif vertical == 'Public Sector':
            base_amount = random.uniform(30000, 150000)
        else:
            base_amount = random.uniform(5000, 75000)
        
        # Generate opportunity name
        product = random.choice(PRODUCTS)
        opp_name = f"{account_name} - {product}"
        
        # Lead source and type
        lead_source = random.choices(LEAD_SOURCES, weights=LEAD_SOURCE_WEIGHTS)[0]
        opp_type = random.choices(OPP_TYPES, weights=OPP_TYPE_WEIGHTS)[0]
        
        # Campaign ID (optional)
        campaign_id = random.randint(1, 500) if random.random() < 0.3 else None
        
        records.append({
            'opportunity_id': f'OPP{opp_id:08d}',
            'sale_id': opp_id if stage_name == 'Closed Won' else None,
            'account_id': account_id,
            'opportunity_name': opp_name,
            'stage_name': stage_name,
            'amount': round(base_amount, 2),
            'probability': probability,
            'close_date': close_date.strftime('%Y-%m-%d'),
            'created_date': created_date.strftime('%Y-%m-%d'),
            'lead_source': lead_source,
            'type': opp_type,
            'campaign_id': campaign_id
        })
        opp_id += 1
    
    df = pd.DataFrame(records)
    
    # Save
    os.makedirs(output_path, exist_ok=True)
    if open_only:
        filename = 'sf_opportunities_open.csv'
    else:
        filename = f'sf_opportunities_{year}.csv'
    
    filepath = os.path.join(output_path, filename)
    df.to_csv(filepath, index=False)
    print(f"  Created: {filename} ({len(df):,} rows)")
    
    return df


def main():
    """Generate all CRM data for 2024, 2025, 2026."""
    print("=" * 60)
    print("SnowTelco CRM/Sales Data Generator")
    print("=" * 60)
    
    # Load reference data
    reps = load_sales_reps()
    accounts = load_accounts()
    
    print(f"Loaded {len(reps)} sales reps")
    print(f"Loaded {len(accounts)} accounts")
    
    # Create output directories
    os.makedirs(OUTPUT_2026_PATH, exist_ok=True)
    os.makedirs(OUTPUT_2025_PATH, exist_ok=True)
    os.makedirs(OUTPUT_2024_PATH, exist_ok=True)
    
    # =========================================================================
    # 2026 Data (Jan-Feb, base data folder)
    # =========================================================================
    print("\n" + "=" * 40)
    print("Generating 2026 CRM Data (Jan-Feb)")
    print("=" * 40)
    
    generate_quotas(2026, reps, OUTPUT_2026_PATH, id_offset=0)
    generate_pipeline_snapshots(2026, OUTPUT_2026_PATH, id_offset=0)
    generate_opportunities(2026, accounts, OUTPUT_2026_PATH, id_offset=50_000_000, open_only=True)
    
    # =========================================================================
    # 2025 Data (Full year, additional_data/2025)
    # =========================================================================
    print("\n" + "=" * 40)
    print("Generating 2025 CRM Data (Full Year)")
    print("=" * 40)
    
    generate_quotas(2025, reps, OUTPUT_2025_PATH, id_offset=10_000_000)
    generate_pipeline_snapshots(2025, OUTPUT_2025_PATH, id_offset=10_000_000)
    generate_opportunities(2025, accounts, OUTPUT_2025_PATH, id_offset=30_000_000, open_only=False)
    
    # =========================================================================
    # 2024 Data (Full year, additional_data/2024)
    # =========================================================================
    print("\n" + "=" * 40)
    print("Generating 2024 CRM Data (Full Year)")
    print("=" * 40)
    
    generate_quotas(2024, reps, OUTPUT_2024_PATH, id_offset=20_000_000)
    generate_pipeline_snapshots(2024, OUTPUT_2024_PATH, id_offset=20_000_000)
    generate_opportunities(2024, accounts, OUTPUT_2024_PATH, id_offset=40_000_000, open_only=False)
    
    # =========================================================================
    # Summary
    # =========================================================================
    print("\n" + "=" * 60)
    print("Generation Complete!")
    print("=" * 60)
    
    # Count files and sizes
    for path, year in [(OUTPUT_2026_PATH, '2026'), (OUTPUT_2025_PATH, '2025'), (OUTPUT_2024_PATH, '2024')]:
        if year == '2026':
            files = ['sf_quotas.csv', 'sf_pipeline_snapshot.csv', 'sf_opportunities_open.csv']
        else:
            files = [f'sf_quotas_{year}.csv', f'sf_pipeline_snapshot_{year}.csv', f'sf_opportunities_{year}.csv']
        
        total_size = 0
        for f in files:
            filepath = os.path.join(path, f)
            if os.path.exists(filepath):
                size = os.path.getsize(filepath) / (1024 * 1024)
                total_size += size
        
        print(f"\n{year} Data: {total_size:.2f} MB total")


if __name__ == '__main__':
    main()
