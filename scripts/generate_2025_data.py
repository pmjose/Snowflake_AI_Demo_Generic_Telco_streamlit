#!/usr/bin/env python3
"""
SnowTelco 2025 Historical Data Generator
=========================================
Generates synthetic data for calendar year 2025 (Jan 1 - Dec 31, 2025).

This script creates CSV files in demo_data/additional_data/2025/csv/
that can be loaded into Snowflake to provide historical context.

Key Features:
- ID ranges start at 10,000,000+ to avoid collisions
- Files auto-split at 95MB
- YoY metrics ~5-10% lower than 2026 (growth story)
- Seasonal patterns included

Usage:
    python scripts/generate_2025_data.py
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os
import uuid

# Configuration
DEMO_DATA_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'demo_data')
OUTPUT_PATH = os.path.join(DEMO_DATA_PATH, 'additional_data', '2025', 'csv')
MAX_FILE_SIZE_MB = 95

# Date range for 2025
START_DATE = datetime(2025, 1, 1)
END_DATE = datetime(2025, 12, 31)

# ID offset to avoid collisions with existing data
ID_OFFSET = 10_000_000

# Random seed for reproducibility
np.random.seed(2025)
random.seed(2025)

# UK-specific distributions
UK_REGIONS = ['London', 'South East', 'South West', 'Midlands', 'North West', 'North East', 'Scotland', 'Wales', 'Northern Ireland']
REGION_WEIGHTS = [0.20, 0.15, 0.10, 0.15, 0.12, 0.08, 0.10, 0.05, 0.05]

CUSTOMER_TYPES = ['Consumer', 'SMB', 'Enterprise']
CUSTOMER_TYPE_WEIGHTS = [0.70, 0.20, 0.10]

SEGMENTS = ['Budget', 'Standard', 'Premium', 'VIP']
SEGMENT_WEIGHTS = [0.25, 0.40, 0.25, 0.10]

PAYMENT_METHODS = ['Direct Debit', 'Credit Card', 'Debit Card', 'Bank Transfer', 'Cheque']
PAYMENT_METHOD_WEIGHTS = [0.65, 0.15, 0.10, 0.08, 0.02]

INVOICE_STATUS = ['Paid', 'Outstanding', 'Overdue']
INVOICE_STATUS_WEIGHTS = [0.85, 0.10, 0.05]

TICKET_PRIORITIES = ['P1', 'P2', 'P3', 'P4']
TICKET_PRIORITY_WEIGHTS = [0.02, 0.08, 0.30, 0.60]

TICKET_STATUS = ['Open', 'In Progress', 'Pending Customer', 'Resolved', 'Escalated']
TICKET_STATUS_WEIGHTS = [0.10, 0.15, 0.10, 0.60, 0.05]

CHANNELS = ['Phone', 'Email', 'Chat', 'Portal', 'Partner']
CHANNEL_WEIGHTS = [0.35, 0.25, 0.20, 0.15, 0.05]

ALARM_SEVERITIES = ['Critical', 'Major', 'Minor', 'Warning']
ALARM_SEVERITY_WEIGHTS = [0.05, 0.15, 0.40, 0.40]


def get_seasonal_factor(date):
    """Returns a seasonal multiplier (0.8 - 1.2) based on month."""
    month = date.month
    # Q4 highest (holiday), Q1 lowest, summer dip
    factors = {
        1: 0.85,  # January - post-holiday slump
        2: 0.90,
        3: 0.95,
        4: 1.00,
        5: 1.00,
        6: 0.95,  # Summer dip starts
        7: 0.90,
        8: 0.85,  # August - holiday season
        9: 0.95,
        10: 1.05,
        11: 1.10,  # Pre-holiday buildup
        12: 1.15,  # Holiday peak
    }
    return factors.get(month, 1.0)


def split_and_save_df(df, base_filename, output_path=OUTPUT_PATH):
    """
    Save DataFrame to CSV, splitting into multiple files if > 95MB.
    Returns list of created filenames.
    """
    os.makedirs(output_path, exist_ok=True)
    
    # Estimate row size
    sample_csv = df.head(1000).to_csv(index=False)
    bytes_per_row = len(sample_csv.encode('utf-8')) / min(1000, len(df))
    max_rows = int((MAX_FILE_SIZE_MB * 1024 * 1024) / bytes_per_row)
    
    files_created = []
    
    if len(df) <= max_rows:
        # Single file
        filepath = os.path.join(output_path, f"{base_filename}.csv")
        df.to_csv(filepath, index=False)
        files_created.append(filepath)
        print(f"  Created: {base_filename}.csv ({len(df):,} rows)")
    else:
        # Split into multiple files
        num_files = (len(df) // max_rows) + 1
        for i in range(num_files):
            start_idx = i * max_rows
            end_idx = min((i + 1) * max_rows, len(df))
            chunk = df.iloc[start_idx:end_idx]
            
            filepath = os.path.join(output_path, f"{base_filename}_{i+1}.csv")
            chunk.to_csv(filepath, index=False)
            files_created.append(filepath)
            print(f"  Created: {base_filename}_{i+1}.csv ({len(chunk):,} rows)")
    
    return files_created


def load_dimension_keys(dim_name):
    """Load dimension table and return list of valid keys."""
    filepath = os.path.join(DEMO_DATA_PATH, f"{dim_name}.csv")
    if os.path.exists(filepath):
        df = pd.read_csv(filepath)
        key_col = df.columns[0]  # First column is usually the key
        return df[key_col].tolist()
    return []


def generate_invoice_fact_2025():
    """Generate ~400,000 invoice records for 2025."""
    print("\nGenerating invoice_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    records = []
    invoice_id = ID_OFFSET + 1
    
    # Generate ~33k invoices per month
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_invoices = int(33000 * seasonal)
        
        for _ in range(num_invoices):
            customer_key = random.choice(customer_keys)
            customer_type = random.choices(CUSTOMER_TYPES, weights=CUSTOMER_TYPE_WEIGHTS)[0]
            
            invoice_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            due_date = invoice_date + timedelta(days=30)
            
            # Base amount varies by customer type
            if customer_type == 'Enterprise':
                base_amount = random.uniform(500, 5000)
            elif customer_type == 'SMB':
                base_amount = random.uniform(100, 1000)
            else:
                base_amount = random.uniform(20, 100)
            
            # 2025 is ~5% lower than 2026
            base_amount *= 0.95
            
            tax_amount = base_amount * 0.20  # UK VAT
            total_amount = base_amount + tax_amount
            
            status = random.choices(INVOICE_STATUS, weights=INVOICE_STATUS_WEIGHTS)[0]
            paid_date = None
            if status == 'Paid':
                paid_date = invoice_date + timedelta(days=random.randint(1, 28))
            
            payment_method = random.choices(PAYMENT_METHODS, weights=PAYMENT_METHOD_WEIGHTS)[0]
            
            billing_period_start = datetime(2025, month, 1)
            billing_period_end = month_end
            
            records.append({
                'invoice_id': invoice_id,
                'invoice_number': f'INV{invoice_id:08d}',
                'customer_key': customer_key,
                'customer_type': customer_type,
                'invoice_date': invoice_date.strftime('%Y-%m-%d'),
                'due_date': due_date.strftime('%Y-%m-%d'),
                'amount': round(base_amount, 2),
                'tax_amount': round(tax_amount, 2),
                'total_amount': round(total_amount, 2),
                'status': status,
                'paid_date': paid_date.strftime('%Y-%m-%d') if paid_date else '',
                'payment_method': payment_method,
                'billing_period_start': billing_period_start.strftime('%Y-%m-%d'),
                'billing_period_end': billing_period_end.strftime('%Y-%m-%d')
            })
            invoice_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'invoice_fact_2025')
    return df


def generate_payment_fact_2025():
    """Generate ~380,000 payment records for 2025."""
    print("\nGenerating payment_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    records = []
    payment_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_payments = int(31500 * seasonal)
        
        for _ in range(num_payments):
            customer_key = random.choice(customer_keys)
            payment_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            amount = random.uniform(20, 500) * 0.95  # 5% lower than 2026
            status = 'Completed' if random.random() < 0.98 else 'Refunded'
            
            records.append({
                'payment_id': payment_id,
                'payment_reference': f'PAY{payment_id:08d}',
                'invoice_id': ID_OFFSET + random.randint(1, 400000),
                'customer_key': customer_key,
                'payment_date': payment_date.strftime('%Y-%m-%d'),
                'amount': round(amount, 2),
                'method_key': random.randint(1, 5),
                'status': status,
                'card_last_four': str(random.randint(1000, 9999)) if random.random() < 0.25 else '',
                'transaction_id': f'TXN{uuid.uuid4().hex[:12].upper()}',
                'payment_method_key': random.randint(1, 5)
            })
            payment_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'payment_fact_2025')
    return df


def generate_mobile_usage_fact_2025():
    """Generate ~400,000 mobile usage records for 2025."""
    print("\nGenerating mobile_usage_fact_2025...")
    
    subscriber_keys = load_dimension_keys('mobile_subscriber_dim')
    if not subscriber_keys:
        subscriber_keys = list(range(1, 30001))
    
    records = []
    usage_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        usage_month = f"2025-{month:02d}"
        seasonal = get_seasonal_factor(datetime(2025, month, 1))
        
        # Sample ~33k subscribers per month
        monthly_subscribers = random.sample(subscriber_keys, min(33000, len(subscriber_keys)))
        
        for sub_key in monthly_subscribers:
            data_used = random.uniform(1, 50) * seasonal * 0.95
            data_allowance = random.choice([5, 10, 20, 50, 100])
            minutes_used = int(random.uniform(50, 500) * seasonal)
            sms_sent = int(random.uniform(10, 200) * seasonal)
            
            bill_amount = random.uniform(15, 80) * 0.95  # 5% lower
            nps = random.randint(-100, 100) if random.random() < 0.3 else None
            
            records.append({
                'usage_id': usage_id,
                'subscriber_key': sub_key,
                'usage_month': usage_month,
                'data_used_gb': round(data_used, 2),
                'data_allowance_gb': data_allowance,
                'minutes_used': minutes_used,
                'sms_sent': sms_sent,
                'roaming_data_gb': round(random.uniform(0, 2), 2) if random.random() < 0.15 else 0,
                'roaming_minutes': int(random.uniform(0, 50)) if random.random() < 0.15 else 0,
                'international_minutes': int(random.uniform(0, 30)) if random.random() < 0.10 else 0,
                'bill_amount': round(bill_amount, 2),
                'payment_status': random.choices(['Paid', 'Pending', 'Overdue'], weights=[0.85, 0.10, 0.05])[0],
                'nps_score': nps
            })
            usage_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'mobile_usage_fact_2025')
    return df


def generate_support_ticket_fact_2025():
    """Generate ~200,000 support tickets for 2025."""
    print("\nGenerating support_ticket_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    records = []
    ticket_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        # More tickets in busy periods, inverse of sales
        num_tickets = int(16500 * (2 - seasonal))
        
        for _ in range(num_tickets):
            customer_key = random.choice(customer_keys)
            customer_type = random.choices(CUSTOMER_TYPES, weights=CUSTOMER_TYPE_WEIGHTS)[0]
            
            created_date = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days),
                hours=random.randint(0, 23),
                minutes=random.randint(0, 59),
                seconds=random.randint(0, 59)
            )
            
            priority = random.choices(TICKET_PRIORITIES, weights=TICKET_PRIORITY_WEIGHTS)[0]
            status = random.choices(TICKET_STATUS, weights=TICKET_STATUS_WEIGHTS)[0]
            channel = random.choices(CHANNELS, weights=CHANNEL_WEIGHTS)[0]
            
            first_response_mins = int(random.uniform(5, 120))
            resolved_date = None
            resolution_mins = None
            csat_score = None
            
            if status == 'Resolved':
                resolution_mins = int(random.uniform(30, 1440))
                resolved_date = created_date + timedelta(minutes=resolution_mins)
                csat_score = random.randint(1, 5) if random.random() < 0.6 else None
            
            records.append({
                'ticket_id': ticket_id,
                'ticket_number': f'TKT{ticket_id:08d}',
                'customer_key': customer_key,
                'customer_type': customer_type,
                'service_instance_id': random.randint(1, 500000) if random.random() < 0.7 else '',
                'category_key': random.randint(1, 35),
                'priority': priority,
                'status': status,
                'channel': channel,
                'created_date': created_date.strftime('%Y-%m-%d %H:%M:%S'),
                'resolved_date': resolved_date.strftime('%Y-%m-%d %H:%M:%S') if resolved_date else '',
                'first_response_mins': first_response_mins,
                'resolution_mins': resolution_mins if resolution_mins else '',
                'csat_score': csat_score if csat_score else '',
                'agent_key': random.randint(1, 200),
                'escalated': 'True' if status == 'Escalated' else 'False'
            })
            ticket_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'support_ticket_fact_2025')
    return df


def generate_network_performance_fact_2025():
    """Generate ~1,500,000 network performance records for 2025."""
    print("\nGenerating network_performance_fact_2025...")
    
    element_ids = load_dimension_keys('network_element_dim')
    if not element_ids:
        element_ids = list(range(1, 501))
    
    records = []
    perf_id = ID_OFFSET + 1
    
    # Generate hourly metrics for each day
    current_date = START_DATE
    while current_date <= END_DATE:
        seasonal = get_seasonal_factor(current_date)
        
        # Sample 150-200 elements per hour
        for hour in range(24):
            num_elements = random.randint(150, 200)
            sampled_elements = random.sample(element_ids, min(num_elements, len(element_ids)))
            
            for elem_id in sampled_elements:
                metric_datetime = current_date.replace(hour=hour, minute=0, second=0)
                
                # Performance slightly worse in 2025 (improvement story)
                throughput = random.uniform(0.5, 10) * 0.95
                latency = random.uniform(5, 50) * 1.05  # Higher latency
                utilization = random.uniform(20, 85) * seasonal
                packet_loss = random.uniform(0, 2) * 1.10  # More packet loss
                availability = random.uniform(98, 100) * 0.998  # Slightly lower
                
                records.append({
                    'perf_id': perf_id,
                    'element_id': elem_id,
                    'metric_datetime': metric_datetime.strftime('%Y-%m-%d %H:%M:%S'),
                    'metric_date': current_date.strftime('%Y-%m-%d'),
                    'metric_hour': hour,
                    'throughput_gbps': round(throughput, 3),
                    'latency_ms': round(latency, 2),
                    'utilization_pct': round(utilization, 2),
                    'packet_loss_pct': round(packet_loss, 4),
                    'error_count': random.randint(0, 10),
                    'availability_pct': round(availability, 4)
                })
                perf_id += 1
        
        current_date += timedelta(days=1)
        
        # Progress indicator
        if current_date.day == 1:
            print(f"  Processing {current_date.strftime('%Y-%m')}...")
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'network_performance_fact_2025')
    return df


def generate_contact_center_call_fact_2025():
    """Generate ~1,000,000 contact center call records for 2025."""
    print("\nGenerating contact_center_call_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    agent_keys = load_dimension_keys('contact_center_agent_dim')
    if not agent_keys:
        agent_keys = list(range(1, 501))
    
    queues = ['Sales', 'Support', 'Billing', 'Technical', 'Retention', 'Partner']
    dispositions = ['Resolved', 'Callback', 'Transfer', 'Escalated', 'Abandoned']
    disposition_weights = [0.55, 0.15, 0.10, 0.10, 0.10]
    
    records = []
    call_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_calls = int(83000 * (2 - seasonal))  # More calls during slow business periods
        
        for _ in range(num_calls):
            customer_key = random.choice(customer_keys)
            customer_type = random.choices(CUSTOMER_TYPES, weights=CUSTOMER_TYPE_WEIGHTS)[0]
            agent_key = random.choice(agent_keys)
            
            start_time = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days),
                hours=random.randint(8, 20),  # Business hours
                minutes=random.randint(0, 59),
                seconds=random.randint(0, 59)
            )
            
            wait_time_secs = int(random.uniform(30, 600))
            handle_time_secs = int(random.uniform(120, 1800))
            end_time = start_time + timedelta(seconds=wait_time_secs + handle_time_secs)
            
            disposition = random.choices(dispositions, weights=disposition_weights)[0]
            csat_score = random.randint(1, 5) if random.random() < 0.4 else None
            
            # FCR slightly worse in 2025
            is_fcr = random.random() < 0.68 if disposition == 'Resolved' else False
            callback_required = disposition == 'Callback'
            
            records.append({
                'call_id': call_id,
                'customer_key': customer_key,
                'customer_type': customer_type,
                'agent_key': agent_key,
                'queue': random.choice(queues),
                'start_time': start_time.strftime('%Y-%m-%d %H:%M:%S.%f'),
                'end_time': end_time.strftime('%Y-%m-%d %H:%M:%S.%f'),
                'wait_time_secs': wait_time_secs,
                'handle_time_secs': handle_time_secs,
                'disposition': disposition,
                'ticket_id': ID_OFFSET + random.randint(1, 200000) if random.random() < 0.3 else '',
                'transfer_count': random.randint(0, 3) if disposition == 'Transfer' else 0,
                'csat_score': csat_score if csat_score else '',
                'call_recording_url': f's3://recordings/2025/{month:02d}/{start_time.day:02d}/{call_id}.wav',
                'is_first_call_resolved': is_fcr,
                'callback_required': callback_required
            })
            call_id += 1
        
        print(f"  Processing 2025-{month:02d}...")
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'contact_center_call_fact_2025')
    return df


def generate_network_alarm_fact_2025():
    """Generate ~500,000 network alarm records for 2025."""
    print("\nGenerating network_alarm_fact_2025...")
    
    element_ids = load_dimension_keys('network_element_dim')
    if not element_ids:
        element_ids = list(range(1, 501))
    
    alarm_types = ['Hardware Failure', 'Software Error', 'Capacity Warning', 'Connectivity Loss', 
                   'Performance Degradation', 'Security Alert', 'Configuration Error']
    root_causes = ['Hardware', 'Software', 'Configuration', 'External', 'Unknown', 'Capacity']
    impacts = ['Service Affecting', 'Customer Impacting', 'Performance', 'None']
    
    records = []
    alarm_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        # More alarms in 2025 (improvement story for 2026)
        num_alarms = int(42000 * 1.10)
        
        for _ in range(num_alarms):
            element_id = random.choice(element_ids)
            
            raised_time = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days),
                hours=random.randint(0, 23),
                minutes=random.randint(0, 59),
                seconds=random.randint(0, 59)
            )
            
            severity = random.choices(ALARM_SEVERITIES, weights=ALARM_SEVERITY_WEIGHTS)[0]
            
            # Clear time depends on severity
            clear_minutes = {
                'Critical': random.randint(15, 120),
                'Major': random.randint(30, 240),
                'Minor': random.randint(60, 480),
                'Warning': random.randint(120, 720)
            }[severity]
            
            cleared_time = raised_time + timedelta(minutes=clear_minutes)
            acknowledged = random.random() < 0.90
            
            records.append({
                'alarm_id': alarm_id,
                'element_id': element_id,
                'alarm_type': random.choice(alarm_types),
                'severity': severity,
                'raised_time': raised_time.strftime('%Y-%m-%d %H:%M:%S.%f'),
                'cleared_time': cleared_time.strftime('%Y-%m-%d %H:%M:%S'),
                'acknowledged': acknowledged,
                'acknowledged_by': f'Engineer_{random.randint(1, 50)}' if acknowledged else '',
                'ticket_id': ID_OFFSET + random.randint(1, 200000) if random.random() < 0.4 else '',
                'root_cause': random.choice(root_causes),
                'impact': random.choice(impacts)
            })
            alarm_id += 1
        
        print(f"  Processing 2025-{month:02d}...")
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'network_alarm_fact_2025')
    return df


def generate_it_incident_fact_2025():
    """Generate ~100,000 IT incident records for 2025."""
    print("\nGenerating it_incident_fact_2025...")
    
    app_ids = load_dimension_keys('it_application_dim')
    if not app_ids:
        app_ids = list(range(1, 101))
    
    incident_types = ['Outage', 'Performance', 'Security', 'Change Failure', 'Capacity', 'Integration']
    statuses = ['Open', 'In Progress', 'Resolved', 'Closed']
    status_weights = [0.05, 0.10, 0.25, 0.60]
    
    records = []
    incident_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        num_incidents = int(8300 * 1.05)  # 5% more incidents in 2025
        
        for _ in range(num_incidents):
            app_id = random.choice(app_ids)
            priority = random.choices(TICKET_PRIORITIES, weights=TICKET_PRIORITY_WEIGHTS)[0]
            status = random.choices(statuses, weights=status_weights)[0]
            
            created_date = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days)
            )
            
            # SLA targets by priority
            sla_targets = {'P1': 60, 'P2': 240, 'P3': 480, 'P4': 1440}
            sla_target_mins = sla_targets[priority]
            
            created_timestamp = created_date.replace(
                hour=random.randint(0, 23),
                minute=random.randint(0, 59)
            )
            
            assigned_timestamp = created_timestamp + timedelta(minutes=random.randint(5, 60))
            
            resolved_timestamp = None
            sla_met = None
            if status in ['Resolved', 'Closed']:
                resolution_mins = int(random.uniform(30, sla_target_mins * 1.5))
                resolved_timestamp = created_timestamp + timedelta(minutes=resolution_mins)
                sla_met = resolution_mins <= sla_target_mins
            
            records.append({
                'incident_id': incident_id,
                'incident_number': f'INC{incident_id:08d}',
                'application_id': app_id,
                'incident_type': random.choice(incident_types),
                'priority': priority,
                'status': status,
                'created_date': created_date.strftime('%Y-%m-%d'),
                'sla_target_mins': sla_target_mins,
                'created_timestamp': created_timestamp.strftime('%Y-%m-%d %H:%M:%S'),
                'assigned_timestamp': assigned_timestamp.strftime('%Y-%m-%d %H:%M:%S'),
                'resolved_timestamp': resolved_timestamp.strftime('%Y-%m-%d %H:%M:%S') if resolved_timestamp else '',
                'sla_met': sla_met if sla_met is not None else ''
            })
            incident_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'it_incident_fact_2025')
    return df


def generate_sales_fact_2025():
    """Generate ~50,000 sales records for 2025.
    
    Schema matches base sales_fact table:
    sale_id, date, customer_key, product_key, sales_rep_key, region_key, vendor_key, amount, units
    """
    print("\nGenerating sales_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    product_keys = load_dimension_keys('product_dim')
    if not product_keys:
        product_keys = list(range(1, 65))
    
    rep_keys = load_dimension_keys('sales_rep_dim')
    if not rep_keys:
        rep_keys = list(range(1, 201))
    
    region_keys = load_dimension_keys('region_dim')
    if not region_keys:
        region_keys = list(range(1, 500))
    
    vendor_keys = load_dimension_keys('vendor_dim')
    if not vendor_keys:
        vendor_keys = list(range(1, 30))
    
    records = []
    sale_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_sales = int(4200 * seasonal * 0.95)  # 5% lower than 2026
        
        for _ in range(num_sales):
            sale_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            units = random.randint(1, 20)
            amount = round(random.uniform(50, 2000) * 0.95, 2)  # 5% lower than 2026
            
            records.append({
                'sale_id': sale_id,
                'date': sale_date.strftime('%Y-%m-%d'),
                'customer_key': random.choice(customer_keys),
                'product_key': random.choice(product_keys),
                'sales_rep_key': random.choice(rep_keys),
                'region_key': random.choice(region_keys),
                'vendor_key': random.choice(vendor_keys),
                'amount': amount,
                'units': units
            })
            sale_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'sales_fact_2025')
    return df


def generate_finance_transactions_2025():
    """Generate ~300,000 finance transaction records for 2025."""
    print("\nGenerating finance_transactions_2025...")
    
    account_keys = load_dimension_keys('account_dim')
    if not account_keys:
        account_keys = list(range(1, 51))
    
    transaction_types = ['Revenue', 'Cost', 'Depreciation', 'Accrual', 'Adjustment', 'Transfer']
    
    records = []
    trans_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_trans = int(25000 * seasonal * 0.95)
        
        for _ in range(num_trans):
            trans_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            trans_type = random.choice(transaction_types)
            
            # Amount varies by type
            if trans_type == 'Revenue':
                amount = random.uniform(100, 10000)
            elif trans_type == 'Cost':
                amount = -random.uniform(50, 5000)
            else:
                amount = random.uniform(-1000, 1000)
            
            amount *= 0.95  # 5% lower
            
            records.append({
                'transaction_id': trans_id,
                'account_key': random.choice(account_keys),
                'transaction_date': trans_date.strftime('%Y-%m-%d'),
                'transaction_type': trans_type,
                'amount': round(amount, 2),
                'currency': 'GBP',
                'description': f'{trans_type} transaction',
                'posted': random.choice([True, False]),
                'period': f'2025-{month:02d}'
            })
            trans_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'finance_transactions_2025')
    return df


def generate_marketing_campaign_fact_2025():
    """Generate ~30,000 marketing campaign records for 2025."""
    print("\nGenerating marketing_campaign_fact_2025...")
    
    campaign_keys = load_dimension_keys('campaign_dim')
    if not campaign_keys:
        campaign_keys = list(range(1, 51))
    
    channels = ['Email', 'Social', 'PPC', 'Display', 'TV', 'Radio', 'Direct Mail']
    
    records = []
    record_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_records = int(2500 * seasonal * 0.95)
        
        for _ in range(num_records):
            campaign_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            channel = random.choice(channels)
            
            impressions = int(random.uniform(1000, 100000) * seasonal)
            clicks = int(impressions * random.uniform(0.01, 0.05))
            conversions = int(clicks * random.uniform(0.02, 0.10))
            spend = random.uniform(100, 5000) * 0.95
            
            records.append({
                'record_id': record_id,
                'campaign_key': random.choice(campaign_keys),
                'campaign_date': campaign_date.strftime('%Y-%m-%d'),
                'channel': channel,
                'impressions': impressions,
                'clicks': clicks,
                'conversions': conversions,
                'spend': round(spend, 2),
                'revenue_attributed': round(conversions * random.uniform(50, 200), 2)
            })
            record_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'marketing_campaign_fact_2025')
    return df


def generate_digital_interaction_fact_2025():
    """Generate ~800,000 digital interaction records for 2025."""
    print("\nGenerating digital_interaction_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    interaction_types = ['App Login', 'Web Login', 'Bill View', 'Payment', 'Support', 
                         'Plan Change', 'Usage Check', 'Profile Update']
    devices = ['Mobile', 'Desktop', 'Tablet']
    device_weights = [0.60, 0.30, 0.10]
    
    records = []
    interaction_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        num_interactions = int(67000 * 0.95)  # Slightly less digital adoption in 2025
        
        for _ in range(num_interactions):
            interaction_time = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days),
                hours=random.randint(0, 23),
                minutes=random.randint(0, 59),
                seconds=random.randint(0, 59)
            )
            
            records.append({
                'interaction_id': interaction_id,
                'customer_key': random.choice(customer_keys),
                'interaction_timestamp': interaction_time.strftime('%Y-%m-%d %H:%M:%S'),
                'interaction_type': random.choice(interaction_types),
                'device_type': random.choices(devices, weights=device_weights)[0],
                'session_duration_secs': random.randint(30, 1800),
                'pages_viewed': random.randint(1, 20),
                'completed': random.random() < 0.85
            })
            interaction_id += 1
        
        if month % 3 == 0:
            print(f"  Processing Q{month // 3} 2025...")
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'digital_interaction_fact_2025')
    return df


def generate_loyalty_transaction_fact_2025():
    """Generate ~400,000 loyalty transaction records for 2025."""
    print("\nGenerating loyalty_transaction_fact_2025...")
    
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    program_keys = load_dimension_keys('loyalty_program_dim')
    if not program_keys:
        program_keys = list(range(1, 6))
    
    trans_types = ['Earn', 'Redeem', 'Bonus', 'Expire', 'Adjustment']
    trans_weights = [0.50, 0.30, 0.10, 0.05, 0.05]
    
    records = []
    trans_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_trans = int(33000 * seasonal * 0.95)
        
        for _ in range(num_trans):
            trans_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            trans_type = random.choices(trans_types, weights=trans_weights)[0]
            
            if trans_type in ['Earn', 'Bonus']:
                points = random.randint(10, 500)
            elif trans_type == 'Redeem':
                points = -random.randint(100, 2000)
            elif trans_type == 'Expire':
                points = -random.randint(50, 500)
            else:
                points = random.randint(-100, 100)
            
            records.append({
                'transaction_id': trans_id,
                'customer_key': random.choice(customer_keys),
                'program_key': random.choice(program_keys),
                'transaction_date': trans_date.strftime('%Y-%m-%d'),
                'transaction_type': trans_type,
                'points': points,
                'description': f'{trans_type} points'
            })
            trans_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'loyalty_transaction_fact_2025')
    return df


def generate_sim_activation_fact_2025():
    """Generate ~60,000 SIM activation records for 2025."""
    print("\nGenerating sim_activation_fact_2025...")
    
    subscriber_keys = load_dimension_keys('mobile_subscriber_dim')
    if not subscriber_keys:
        subscriber_keys = list(range(1, 30001))
    
    activation_channels = ['Online', 'Retail Store', 'Partner', 'Telesales', 'Self-Service']
    channel_weights = [0.30, 0.25, 0.20, 0.15, 0.10]
    
    activation_statuses = ['Completed', 'Pending', 'Failed', 'Cancelled']
    status_weights = [0.85, 0.08, 0.04, 0.03]
    
    activation_types = ['New Activation', 'Replacement', 'SIM Swap', 'Upgrade', 'Port-In']
    type_weights = [0.35, 0.25, 0.20, 0.12, 0.08]
    
    records = []
    activation_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        # ~5000 activations per month, slightly lower than 2026
        num_activations = int(5000 * seasonal * 0.95)
        
        for _ in range(num_activations):
            subscriber_key = random.choice(subscriber_keys)
            
            # Order timestamp
            order_time = month_start + timedelta(
                days=random.randint(0, (month_end - month_start).days),
                hours=random.randint(8, 20),
                minutes=random.randint(0, 59),
                seconds=random.randint(0, 59)
            )
            
            channel = random.choices(activation_channels, weights=channel_weights)[0]
            status = random.choices(activation_statuses, weights=status_weights)[0]
            activation_type = random.choices(activation_types, weights=type_weights)[0]
            
            # Time to activate varies by channel (hours)
            if channel == 'Retail Store':
                time_to_activate = random.uniform(0.5, 4)
            elif channel == 'Online':
                time_to_activate = random.uniform(12, 48)
            elif channel == 'Self-Service':
                time_to_activate = random.uniform(0.25, 2)
            else:
                time_to_activate = random.uniform(4, 72)
            
            # 2025 had slightly longer activation times
            time_to_activate *= 1.10
            
            activation_time = order_time + timedelta(hours=time_to_activate)
            
            # Generate ICCID (19-20 digits)
            iccid = f"8944{random.randint(10000000000000, 99999999999999)}"
            
            records.append({
                'activation_id': str(uuid.uuid4()),
                'order_id': f'ORD{ID_OFFSET + activation_id:06d}',
                'subscriber_key': subscriber_key,
                'sim_iccid': iccid,
                'order_timestamp': order_time.strftime('%Y-%m-%d %H:%M:%S'),
                'activation_timestamp': activation_time.strftime('%Y-%m-%d %H:%M:%S') if status == 'Completed' else '',
                'activation_channel': channel,
                'time_to_activate_hours': round(time_to_activate, 2) if status == 'Completed' else '',
                'activation_status': status,
                'activation_type': activation_type
            })
            activation_id += 1
        
        print(f"  Processing 2025-{month:02d}...")
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'sim_activation_fact_2025')
    return df


def generate_remaining_facts_2025():
    """Generate remaining smaller fact tables."""
    
    # Roaming Usage
    print("\nGenerating roaming_usage_fact_2025...")
    subscriber_keys = load_dimension_keys('mobile_subscriber_dim')
    if not subscriber_keys:
        subscriber_keys = list(range(1, 30001))
    
    partner_keys = load_dimension_keys('roaming_partner_dim')
    if not partner_keys:
        partner_keys = list(range(1, 101))
    
    records = []
    usage_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        # More roaming in summer
        seasonal = 1.5 if month in [6, 7, 8] else 1.0
        num_records = int(16500 * seasonal * 0.95)
        
        for _ in range(num_records):
            usage_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            records.append({
                'usage_id': usage_id,
                'subscriber_key': random.choice(subscriber_keys),
                'partner_key': random.choice(partner_keys),
                'usage_date': usage_date.strftime('%Y-%m-%d'),
                'data_mb': round(random.uniform(10, 500), 2),
                'voice_minutes': random.randint(0, 60),
                'sms_count': random.randint(0, 20),
                'wholesale_cost': round(random.uniform(1, 50), 2),
                'retail_charge': round(random.uniform(2, 100), 2)
            })
            usage_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'roaming_usage_fact_2025')
    
    # IoT Usage
    print("\nGenerating iot_usage_fact_2025...")
    records = []
    usage_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        num_records = int(16500 * 0.95)
        
        for _ in range(num_records):
            usage_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            records.append({
                'usage_id': usage_id,
                'subscription_id': random.randint(1, 50000),
                'usage_date': usage_date.strftime('%Y-%m-%d'),
                'data_mb': round(random.uniform(0.1, 100), 2),
                'messages_sent': random.randint(0, 1000),
                'messages_received': random.randint(0, 1000),
                'api_calls': random.randint(0, 10000)
            })
            usage_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'iot_usage_fact_2025')
    
    # SLA Measurement
    print("\nGenerating sla_measurement_fact_2025...")
    sla_keys = load_dimension_keys('sla_dim')
    if not sla_keys:
        sla_keys = list(range(1, 21))
    
    records = []
    measurement_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        num_records = int(33000 * 0.95)
        
        for _ in range(num_records):
            measurement_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            target_value = random.uniform(95, 99.9)
            # Slightly worse SLA performance in 2025
            actual_value = target_value * random.uniform(0.95, 1.02)
            
            records.append({
                'measurement_id': measurement_id,
                'sla_key': random.choice(sla_keys),
                'measurement_date': measurement_date.strftime('%Y-%m-%d'),
                'target_value': round(target_value, 2),
                'actual_value': round(actual_value, 2),
                'met': actual_value >= target_value,
                'breach_minutes': int(max(0, (target_value - actual_value) * 10)) if actual_value < target_value else 0
            })
            measurement_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'sla_measurement_fact_2025')
    
    # Complaint Fact
    print("\nGenerating complaint_fact_2025...")
    customer_keys = load_dimension_keys('customer_dim')
    if not customer_keys:
        customer_keys = list(range(1, 10001))
    
    complaint_types = ['Billing', 'Service', 'Network', 'Customer Service', 'Contract', 'Other']
    statuses = ['Open', 'Under Investigation', 'Resolved', 'Closed']
    
    records = []
    complaint_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        # More complaints in 2025 (improvement story)
        num_complaints = int(4200 * 1.10)
        
        for _ in range(num_complaints):
            complaint_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            records.append({
                'complaint_id': complaint_id,
                'customer_key': random.choice(customer_keys),
                'complaint_date': complaint_date.strftime('%Y-%m-%d'),
                'complaint_type': random.choice(complaint_types),
                'status': random.choice(statuses),
                'resolution_days': random.randint(1, 30) if random.random() < 0.7 else None,
                'compensation_amount': round(random.uniform(10, 100), 2) if random.random() < 0.2 else 0,
                'ofcom_escalated': random.random() < 0.02
            })
            complaint_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'complaint_fact_2025')
    
    # Order Line Fact
    print("\nGenerating order_line_fact_2025...")
    order_keys = load_dimension_keys('order_dim')
    if not order_keys:
        order_keys = list(range(1, 50001))
    
    product_keys = load_dimension_keys('product_dim')
    if not product_keys:
        product_keys = list(range(1, 65))
    
    records = []
    line_id = ID_OFFSET + 1
    
    for month in range(1, 13):
        month_start = datetime(2025, month, 1)
        if month == 12:
            month_end = datetime(2025, 12, 31)
        else:
            month_end = datetime(2025, month + 1, 1) - timedelta(days=1)
        
        seasonal = get_seasonal_factor(month_start)
        num_lines = int(12500 * seasonal * 0.95)
        
        for _ in range(num_lines):
            order_date = month_start + timedelta(days=random.randint(0, (month_end - month_start).days))
            
            quantity = random.randint(1, 5)
            unit_price = random.uniform(10, 200)
            
            records.append({
                'line_id': line_id,
                'order_key': random.choice(order_keys),
                'product_key': random.choice(product_keys),
                'order_date': order_date.strftime('%Y-%m-%d'),
                'quantity': quantity,
                'unit_price': round(unit_price, 2),
                'line_total': round(quantity * unit_price, 2),
                'discount_amount': round(random.uniform(0, 20), 2) if random.random() < 0.2 else 0
            })
            line_id += 1
    
    df = pd.DataFrame(records)
    split_and_save_df(df, 'order_line_fact_2025')


def main():
    """Main function to generate all 2025 data."""
    print("=" * 60)
    print("SnowTelco 2025 Historical Data Generator")
    print("=" * 60)
    print(f"\nOutput directory: {OUTPUT_PATH}")
    print(f"Date range: {START_DATE.date()} to {END_DATE.date()}")
    print(f"ID offset: {ID_OFFSET:,}")
    print(f"Max file size: {MAX_FILE_SIZE_MB} MB")
    
    os.makedirs(OUTPUT_PATH, exist_ok=True)
    
    start_time = datetime.now()
    
    # Generate all fact tables
    generate_invoice_fact_2025()
    generate_payment_fact_2025()
    generate_mobile_usage_fact_2025()
    generate_support_ticket_fact_2025()
    generate_network_performance_fact_2025()
    generate_contact_center_call_fact_2025()
    generate_network_alarm_fact_2025()
    generate_it_incident_fact_2025()
    generate_sales_fact_2025()
    generate_finance_transactions_2025()
    generate_marketing_campaign_fact_2025()
    generate_digital_interaction_fact_2025()
    generate_loyalty_transaction_fact_2025()
    generate_sim_activation_fact_2025()
    generate_remaining_facts_2025()
    
    elapsed = datetime.now() - start_time
    
    # Summary
    print("\n" + "=" * 60)
    print("GENERATION COMPLETE")
    print("=" * 60)
    print(f"Time elapsed: {elapsed}")
    print(f"\nFiles created in: {OUTPUT_PATH}")
    
    # List created files
    files = os.listdir(OUTPUT_PATH)
    csv_files = [f for f in files if f.endswith('.csv')]
    print(f"Total CSV files: {len(csv_files)}")
    
    total_size = sum(os.path.getsize(os.path.join(OUTPUT_PATH, f)) for f in csv_files)
    print(f"Total size: {total_size / (1024*1024):.1f} MB")


if __name__ == "__main__":
    main()
