#!/usr/bin/env python3
"""
SnowTelco RAN (Radio Access Network) Data Generator
====================================================
Generates comprehensive RAN data including:
- RAN Site dimension (cell tower sites)
- RAN Equipment dimension (gNodeB, eNodeB, BBU, RRU, Antennas)
- RAN Cell dimension (sectors/cells per site)
- RAN Performance fact (KPIs: throughput, latency, PRB utilization, signal strength)
- RAN Alarm fact (RAN-specific alarms)

Usage:
    python scripts/generate_ran_data.py
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

# UK Cities and regions for site distribution - aligned with subscriber data
UK_CITIES = [
    # Major cities (higher site density) - matching subscriber data
    {'city': 'London', 'county': 'Greater London', 'lat': 51.5074, 'lon': -0.1278, 'weight': 20, 'area': 'urban'},
    {'city': 'Birmingham', 'county': 'West Midlands', 'lat': 52.4862, 'lon': -1.8904, 'weight': 8, 'area': 'urban'},
    {'city': 'Manchester', 'county': 'Greater Manchester', 'lat': 53.4808, 'lon': -2.2426, 'weight': 8, 'area': 'urban'},
    {'city': 'Leeds', 'county': 'West Yorkshire', 'lat': 53.8008, 'lon': -1.5491, 'weight': 5, 'area': 'urban'},
    {'city': 'Liverpool', 'county': 'Merseyside', 'lat': 53.4084, 'lon': -2.9916, 'weight': 5, 'area': 'urban'},
    {'city': 'Sheffield', 'county': 'South Yorkshire', 'lat': 53.3811, 'lon': -1.4701, 'weight': 5, 'area': 'urban'},
    {'city': 'Bristol', 'county': 'Avon', 'lat': 51.4545, 'lon': -2.5879, 'weight': 4, 'area': 'urban'},
    {'city': 'Glasgow', 'county': 'Scotland', 'lat': 55.8642, 'lon': -4.2518, 'weight': 5, 'area': 'urban'},
    {'city': 'Edinburgh', 'county': 'Scotland', 'lat': 55.9533, 'lon': -3.1883, 'weight': 4, 'area': 'urban'},
    {'city': 'Cardiff', 'county': 'Wales', 'lat': 51.4816, 'lon': -3.1791, 'weight': 4, 'area': 'urban'},
    {'city': 'Belfast', 'county': 'Northern Ireland', 'lat': 54.5973, 'lon': -5.9301, 'weight': 4, 'area': 'urban'},
    {'city': 'Newcastle', 'county': 'Tyne and Wear', 'lat': 54.9783, 'lon': -1.6178, 'weight': 4, 'area': 'urban'},
    {'city': 'Nottingham', 'county': 'Nottinghamshire', 'lat': 52.9548, 'lon': -1.1581, 'weight': 4, 'area': 'urban'},
    # Secondary cities (medium density) - matching subscriber data
    {'city': 'Southampton', 'county': 'Hampshire', 'lat': 50.9097, 'lon': -1.4044, 'weight': 3, 'area': 'suburban'},
    {'city': 'Leicester', 'county': 'Leicestershire', 'lat': 52.6369, 'lon': -1.1398, 'weight': 3, 'area': 'suburban'},
    {'city': 'Coventry', 'county': 'West Midlands', 'lat': 52.4068, 'lon': -1.5197, 'weight': 3, 'area': 'suburban'},
    {'city': 'Reading', 'county': 'Berkshire', 'lat': 51.4543, 'lon': -0.9781, 'weight': 3, 'area': 'suburban'},
    {'city': 'Cambridge', 'county': 'Cambridgeshire', 'lat': 52.2053, 'lon': 0.1218, 'weight': 3, 'area': 'suburban'},
    {'city': 'Oxford', 'county': 'Oxfordshire', 'lat': 51.7520, 'lon': -1.2577, 'weight': 3, 'area': 'suburban'},
    {'city': 'Brighton', 'county': 'East Sussex', 'lat': 50.8225, 'lon': -0.1372, 'weight': 3, 'area': 'suburban'},
    # Additional cities from subscriber data
    {'city': 'Newport', 'county': 'Wales', 'lat': 51.5842, 'lon': -2.9977, 'weight': 3, 'area': 'suburban'},
    {'city': 'Plymouth', 'county': 'Devon', 'lat': 50.3755, 'lon': -4.1427, 'weight': 3, 'area': 'suburban'},
    {'city': 'York', 'county': 'North Yorkshire', 'lat': 53.9591, 'lon': -1.0815, 'weight': 3, 'area': 'suburban'},
    {'city': 'Aberdeen', 'county': 'Scotland', 'lat': 57.1497, 'lon': -2.0943, 'weight': 3, 'area': 'suburban'},
    {'city': 'Portsmouth', 'county': 'Hampshire', 'lat': 50.8198, 'lon': -1.0880, 'weight': 3, 'area': 'suburban'},
    {'city': 'Blackpool', 'county': 'Lancashire', 'lat': 53.8175, 'lon': -3.0357, 'weight': 3, 'area': 'suburban'},
    {'city': 'Swansea', 'county': 'Wales', 'lat': 51.6214, 'lon': -3.9436, 'weight': 3, 'area': 'suburban'},
    {'city': 'Dundee', 'county': 'Scotland', 'lat': 56.4620, 'lon': -2.9707, 'weight': 3, 'area': 'suburban'},
    {'city': 'Bradford', 'county': 'West Yorkshire', 'lat': 53.7960, 'lon': -1.7594, 'weight': 3, 'area': 'suburban'},
    {'city': 'Wolverhampton', 'county': 'West Midlands', 'lat': 52.5870, 'lon': -2.1288, 'weight': 3, 'area': 'suburban'},
    {'city': 'Exeter', 'county': 'Devon', 'lat': 50.7184, 'lon': -3.5339, 'weight': 3, 'area': 'suburban'},
    {'city': 'Chester', 'county': 'Cheshire', 'lat': 53.1930, 'lon': -2.8931, 'weight': 3, 'area': 'suburban'},
    {'city': 'Bath', 'county': 'Somerset', 'lat': 51.3751, 'lon': -2.3617, 'weight': 3, 'area': 'suburban'},
    {'city': 'Guildford', 'county': 'Surrey', 'lat': 51.2362, 'lon': -0.5704, 'weight': 3, 'area': 'suburban'},
    {'city': 'Preston', 'county': 'Lancashire', 'lat': 53.7632, 'lon': -2.7031, 'weight': 3, 'area': 'suburban'},
    {'city': 'Milton Keynes', 'county': 'Buckinghamshire', 'lat': 52.0406, 'lon': -0.7594, 'weight': 3, 'area': 'suburban'},
    {'city': 'Derby', 'county': 'Derbyshire', 'lat': 52.9225, 'lon': -1.4746, 'weight': 3, 'area': 'suburban'},
    {'city': 'Hull', 'county': 'East Yorkshire', 'lat': 53.7676, 'lon': -0.3274, 'weight': 3, 'area': 'suburban'},
]

# Site types
SITE_TYPES = {
    'Macro': {'desc': 'Macro Cell', 'coverage_km': (1.5, 3.0), 'height_m': (25, 45), 'weight': 0.50},
    'Small': {'desc': 'Small Cell', 'coverage_km': (0.2, 0.5), 'height_m': (5, 15), 'weight': 0.25},
    'DAS': {'desc': 'Distributed Antenna System', 'coverage_km': (0.1, 0.3), 'height_m': (3, 10), 'weight': 0.10},
    'Rural': {'desc': 'Rural Macro', 'coverage_km': (5.0, 15.0), 'height_m': (30, 60), 'weight': 0.10},
    'Rooftop': {'desc': 'Rooftop Site', 'coverage_km': (0.5, 1.5), 'height_m': (15, 30), 'weight': 0.05},
}

# RAN Equipment vendors and models
RAN_VENDORS = {
    'Ericsson': {
        'gnodeb': ['Ericsson AIR 6449', 'Ericsson AIR 6419', 'Ericsson AIR 3246', 'Ericsson Radio 4422'],
        'enodeb': ['Ericsson RBS 6601', 'Ericsson RBS 6301', 'Ericsson Radio 4415'],
        'bbu': ['Ericsson Baseband 6630', 'Ericsson Baseband 6648'],
        'rru': ['Ericsson Radio 2219', 'Ericsson Radio 4478'],
        'antenna': ['Ericsson AIR 6488', 'Ericsson Antenna 8843'],
    },
    'Nokia': {
        'gnodeb': ['Nokia AirScale', 'Nokia AEQC', 'Nokia AWHQA'],
        'enodeb': ['Nokia Flexi Multiradio 10', 'Nokia Flexi Zone'],
        'bbu': ['Nokia AirScale Baseband', 'Nokia Cloud RAN'],
        'rru': ['Nokia AHFIB', 'Nokia AHHF'],
        'antenna': ['Nokia AirScale Antenna', 'Nokia MIMO Antenna 8T8R'],
    },
    'Huawei': {
        'gnodeb': ['Huawei AAU5613', 'Huawei AAU5239', 'Huawei AAU5611'],
        'enodeb': ['Huawei BTS3900', 'Huawei DBS3900'],
        'bbu': ['Huawei BBU5900', 'Huawei BBU3910'],
        'rru': ['Huawei RRU5301', 'Huawei RRU3971'],
        'antenna': ['Huawei AAU3940', 'Huawei APUS13M'],
    },
    'Samsung': {
        'gnodeb': ['Samsung 5G RAN', 'Samsung Compact Macro'],
        'enodeb': ['Samsung LTE Access Unit', 'Samsung eNodeB'],
        'bbu': ['Samsung BBU', 'Samsung vRAN'],
        'rru': ['Samsung 5G mmWave', 'Samsung Mid-Band Radio'],
        'antenna': ['Samsung Massive MIMO', 'Samsung 8T8R Antenna'],
    },
}

# Frequency bands
FREQUENCY_BANDS = {
    '5G': [
        {'band': 'n78', 'frequency_mhz': 3500, 'bandwidth_mhz': 100, 'type': 'C-Band'},
        {'band': 'n77', 'frequency_mhz': 3700, 'bandwidth_mhz': 80, 'type': 'C-Band'},
        {'band': 'n28', 'frequency_mhz': 700, 'bandwidth_mhz': 20, 'type': 'Low-Band'},
        {'band': 'n258', 'frequency_mhz': 26000, 'bandwidth_mhz': 400, 'type': 'mmWave'},
        {'band': 'n1', 'frequency_mhz': 2100, 'bandwidth_mhz': 20, 'type': 'Mid-Band'},
    ],
    '4G': [
        {'band': 'B20', 'frequency_mhz': 800, 'bandwidth_mhz': 10, 'type': 'Low-Band'},
        {'band': 'B3', 'frequency_mhz': 1800, 'bandwidth_mhz': 20, 'type': 'Mid-Band'},
        {'band': 'B1', 'frequency_mhz': 2100, 'bandwidth_mhz': 15, 'type': 'Mid-Band'},
        {'band': 'B7', 'frequency_mhz': 2600, 'bandwidth_mhz': 20, 'type': 'High-Band'},
    ],
}

# Alarm types for RAN
RAN_ALARM_TYPES = [
    {'type': 'VSWR High', 'severity': ['Warning', 'Major'], 'impact': 'Service Affecting'},
    {'type': 'Cell Outage', 'severity': ['Critical', 'Major'], 'impact': 'Customer Impacting'},
    {'type': 'S1 Link Down', 'severity': ['Critical'], 'impact': 'Customer Impacting'},
    {'type': 'X2 Link Failure', 'severity': ['Major', 'Warning'], 'impact': 'Service Affecting'},
    {'type': 'GPS Synchronization Lost', 'severity': ['Major', 'Warning'], 'impact': 'Service Affecting'},
    {'type': 'High PRB Utilization', 'severity': ['Warning', 'Minor'], 'impact': 'Non-Service Affecting'},
    {'type': 'Handover Failure Rate High', 'severity': ['Warning', 'Minor'], 'impact': 'Service Affecting'},
    {'type': 'RRU Communication Failure', 'severity': ['Critical', 'Major'], 'impact': 'Customer Impacting'},
    {'type': 'Power Amplifier Degradation', 'severity': ['Major', 'Warning'], 'impact': 'Service Affecting'},
    {'type': 'Antenna Tilt Mismatch', 'severity': ['Warning', 'Minor'], 'impact': 'Non-Service Affecting'},
    {'type': 'License Capacity Warning', 'severity': ['Warning'], 'impact': 'Non-Service Affecting'},
    {'type': 'Temperature Threshold Exceeded', 'severity': ['Major', 'Warning'], 'impact': 'Service Affecting'},
    {'type': 'Interference Detected', 'severity': ['Warning', 'Minor'], 'impact': 'Service Affecting'},
    {'type': 'Backhaul Congestion', 'severity': ['Major', 'Warning'], 'impact': 'Customer Impacting'},
    {'type': 'UE Context Release Abnormal', 'severity': ['Warning', 'Minor'], 'impact': 'Service Affecting'},
]


def generate_ran_sites(num_sites=500):
    """Generate RAN site dimension data."""
    sites = []
    
    # Calculate total weight for city distribution
    total_weight = sum(c['weight'] for c in UK_CITIES)
    
    site_id = 1
    for city_info in UK_CITIES:
        # Number of sites for this city based on weight
        city_sites = int(num_sites * city_info['weight'] / total_weight)
        
        for i in range(city_sites):
            # Determine site type based on area
            if city_info['area'] == 'urban':
                site_type_weights = {'Macro': 0.35, 'Small': 0.40, 'DAS': 0.15, 'Rooftop': 0.10, 'Rural': 0.00}
            elif city_info['area'] == 'suburban':
                site_type_weights = {'Macro': 0.50, 'Small': 0.30, 'DAS': 0.05, 'Rooftop': 0.10, 'Rural': 0.05}
            else:  # rural
                site_type_weights = {'Macro': 0.20, 'Small': 0.05, 'DAS': 0.00, 'Rooftop': 0.05, 'Rural': 0.70}
            
            site_type = random.choices(list(site_type_weights.keys()), 
                                       weights=list(site_type_weights.values()))[0]
            type_info = SITE_TYPES[site_type]
            
            # Generate location with some randomness
            lat = city_info['lat'] + random.uniform(-0.15, 0.15)
            lon = city_info['lon'] + random.uniform(-0.15, 0.15)
            
            # Determine technology (more 5G in urban areas)
            if city_info['area'] == 'urban':
                tech_weights = {'5G': 0.70, '4G/5G': 0.25, '4G': 0.05}
            elif city_info['area'] == 'suburban':
                tech_weights = {'5G': 0.40, '4G/5G': 0.40, '4G': 0.20}
            else:
                tech_weights = {'5G': 0.15, '4G/5G': 0.35, '4G': 0.50}
            
            technology = random.choices(list(tech_weights.keys()), 
                                        weights=list(tech_weights.values()))[0]
            
            # Vendor distribution
            vendor = random.choices(
                list(RAN_VENDORS.keys()),
                weights=[0.35, 0.30, 0.25, 0.10]  # Ericsson, Nokia, Huawei, Samsung
            )[0]
            
            # Generate site details
            coverage_km = round(random.uniform(*type_info['coverage_km']), 2)
            tower_height = random.randint(*type_info['height_m'])
            
            # Install date (older sites more likely to be 4G)
            if '5G' in technology:
                install_date = datetime(2019, 1, 1) + timedelta(days=random.randint(0, 2200))
            else:
                install_date = datetime(2015, 1, 1) + timedelta(days=random.randint(0, 3650))
            
            # Status
            status_weights = {'Active': 0.92, 'Maintenance': 0.04, 'Degraded': 0.03, 'Offline': 0.01}
            status = random.choices(list(status_weights.keys()), 
                                   weights=list(status_weights.values()))[0]
            
            # Generate site name
            site_code = f"{city_info['city'][:3].upper()}-{site_type[:3].upper()}-{site_id:04d}"
            site_name = f"{city_info['city']} {type_info['desc']} {i+1}"
            
            # Address (simplified)
            street_num = random.randint(1, 200)
            streets = ['High Street', 'Main Road', 'Station Road', 'Church Lane', 'Park Avenue', 
                      'London Road', 'Queen Street', 'King Street', 'Market Street', 'Mill Lane']
            address = f"{street_num} {random.choice(streets)}"
            postcode = f"{city_info['city'][:2].upper()}{random.randint(1,20)} {random.randint(1,9)}{random.choice('ABCDEFGHJKLMNPQRSTUVWXYZ')}{random.choice('ABCDEFGHJKLMNPQRSTUVWXYZ')}"
            
            sites.append({
                'site_id': site_id,
                'site_code': site_code,
                'site_name': site_name,
                'site_type': site_type,
                'site_type_desc': type_info['desc'],
                'address': address,
                'city': city_info['city'],
                'county': city_info['county'],
                'postcode': postcode,
                'latitude': round(lat, 6),
                'longitude': round(lon, 6),
                'area_type': city_info['area'],
                'technology': technology,
                'primary_vendor': vendor,
                'tower_height_m': tower_height,
                'coverage_radius_km': coverage_km,
                'num_sectors': random.choice([3, 3, 3, 6]) if site_type in ['Macro', 'Rural'] else random.choice([1, 2, 3]),
                'backhaul_type': random.choice(['Fiber', 'Fiber', 'Fiber', 'Microwave', 'Microwave']),
                'power_source': random.choice(['Grid', 'Grid', 'Grid', 'Grid + Battery', 'Grid + Generator']),
                'status': status,
                'install_date': install_date.strftime('%Y-%m-%d'),
                'last_maintenance': (datetime(2025, 12, 31) - timedelta(days=random.randint(0, 365))).strftime('%Y-%m-%d'),
            })
            
            site_id += 1
    
    return pd.DataFrame(sites)


def generate_ran_equipment(sites_df):
    """Generate RAN equipment dimension data."""
    equipment = []
    equip_id = 1
    
    for _, site in sites_df.iterrows():
        vendor = site['primary_vendor']
        technology = site['technology']
        num_sectors = site['num_sectors']
        
        # Determine what equipment to generate based on technology
        has_5g = '5G' in technology
        has_4g = '4G' in technology or '5G' not in technology
        
        # Generate BBU (Baseband Unit)
        bbu_model = random.choice(RAN_VENDORS[vendor]['bbu'])
        equipment.append({
            'equipment_id': equip_id,
            'site_id': site['site_id'],
            'equipment_type': 'BBU',
            'equipment_name': f"BBU-{site['site_code']}",
            'vendor': vendor,
            'model': bbu_model,
            'serial_number': f"SN{random.randint(100000000, 999999999)}",
            'technology': technology,
            'frequency_band': None,
            'power_watts': random.randint(200, 500),
            'status': site['status'],
            'install_date': site['install_date'],
            'firmware_version': f"v{random.randint(18, 24)}.{random.randint(0, 9)}.{random.randint(0, 99)}",
        })
        equip_id += 1
        
        # Generate gNodeB/eNodeB and RRUs per sector
        for sector in range(1, num_sectors + 1):
            sector_letter = chr(64 + sector)  # A, B, C, etc.
            
            # 5G equipment (gNodeB)
            if has_5g:
                gnodeb_model = random.choice(RAN_VENDORS[vendor]['gnodeb'])
                band = random.choice(FREQUENCY_BANDS['5G'])
                equipment.append({
                    'equipment_id': equip_id,
                    'site_id': site['site_id'],
                    'equipment_type': 'gNodeB',
                    'equipment_name': f"gNB-{site['site_code']}-{sector_letter}",
                    'vendor': vendor,
                    'model': gnodeb_model,
                    'serial_number': f"SN{random.randint(100000000, 999999999)}",
                    'technology': '5G NR',
                    'frequency_band': band['band'],
                    'power_watts': random.randint(40, 80),
                    'status': site['status'],
                    'install_date': site['install_date'],
                    'firmware_version': f"v{random.randint(20, 24)}.{random.randint(0, 9)}.{random.randint(0, 99)}",
                })
                equip_id += 1
            
            # 4G equipment (eNodeB)
            if has_4g:
                enodeb_model = random.choice(RAN_VENDORS[vendor]['enodeb'])
                band = random.choice(FREQUENCY_BANDS['4G'])
                equipment.append({
                    'equipment_id': equip_id,
                    'site_id': site['site_id'],
                    'equipment_type': 'eNodeB',
                    'equipment_name': f"eNB-{site['site_code']}-{sector_letter}",
                    'vendor': vendor,
                    'model': enodeb_model,
                    'serial_number': f"SN{random.randint(100000000, 999999999)}",
                    'technology': '4G LTE',
                    'frequency_band': band['band'],
                    'power_watts': random.randint(30, 60),
                    'status': site['status'],
                    'install_date': site['install_date'],
                    'firmware_version': f"v{random.randint(16, 22)}.{random.randint(0, 9)}.{random.randint(0, 99)}",
                })
                equip_id += 1
            
            # RRU (Remote Radio Unit)
            rru_model = random.choice(RAN_VENDORS[vendor]['rru'])
            equipment.append({
                'equipment_id': equip_id,
                'site_id': site['site_id'],
                'equipment_type': 'RRU',
                'equipment_name': f"RRU-{site['site_code']}-{sector_letter}",
                'vendor': vendor,
                'model': rru_model,
                'serial_number': f"SN{random.randint(100000000, 999999999)}",
                'technology': technology,
                'frequency_band': None,
                'power_watts': random.randint(100, 200),
                'status': site['status'],
                'install_date': site['install_date'],
                'firmware_version': f"v{random.randint(18, 24)}.{random.randint(0, 9)}.{random.randint(0, 99)}",
            })
            equip_id += 1
            
            # Antenna
            antenna_model = random.choice(RAN_VENDORS[vendor]['antenna'])
            equipment.append({
                'equipment_id': equip_id,
                'site_id': site['site_id'],
                'equipment_type': 'Antenna',
                'equipment_name': f"ANT-{site['site_code']}-{sector_letter}",
                'vendor': vendor,
                'model': antenna_model,
                'serial_number': f"SN{random.randint(100000000, 999999999)}",
                'technology': technology,
                'frequency_band': None,
                'power_watts': 0,
                'status': site['status'],
                'install_date': site['install_date'],
                'firmware_version': None,
            })
            equip_id += 1
    
    return pd.DataFrame(equipment)


def generate_ran_cells(sites_df):
    """Generate RAN cell dimension data."""
    cells = []
    cell_id = 1
    
    for _, site in sites_df.iterrows():
        technology = site['technology']
        num_sectors = site['num_sectors']
        vendor = site['primary_vendor']
        
        has_5g = '5G' in technology
        has_4g = '4G' in technology or '5G' not in technology
        
        for sector in range(1, num_sectors + 1):
            sector_letter = chr(64 + sector)
            azimuth = (sector - 1) * (360 // num_sectors)
            
            # 5G NR Cells
            if has_5g:
                band = random.choice(FREQUENCY_BANDS['5G'])
                cell_name = f"NR-{site['site_code']}-{sector_letter}"
                
                # Calculate capacity based on band
                if band['type'] == 'mmWave':
                    max_throughput = random.randint(2000, 4000)
                    max_users = random.randint(200, 500)
                elif band['type'] == 'C-Band':
                    max_throughput = random.randint(800, 1500)
                    max_users = random.randint(300, 800)
                else:
                    max_throughput = random.randint(300, 600)
                    max_users = random.randint(400, 1000)
                
                cells.append({
                    'cell_id': cell_id,
                    'site_id': site['site_id'],
                    'cell_name': cell_name,
                    'cell_type': 'NR',
                    'technology': '5G NR',
                    'frequency_band': band['band'],
                    'frequency_mhz': band['frequency_mhz'],
                    'bandwidth_mhz': band['bandwidth_mhz'],
                    'sector': sector,
                    'azimuth_degrees': azimuth,
                    'electrical_tilt': random.randint(2, 8),
                    'mechanical_tilt': random.randint(0, 5),
                    'antenna_height_m': site['tower_height_m'],
                    'tx_power_dbm': random.randint(40, 46),
                    'max_throughput_mbps': max_throughput,
                    'max_connected_users': max_users,
                    'pci': random.randint(0, 503),
                    'tac': random.randint(10000, 99999),
                    'vendor': vendor,
                    'status': site['status'],
                })
                cell_id += 1
            
            # 4G LTE Cells
            if has_4g:
                band = random.choice(FREQUENCY_BANDS['4G'])
                cell_name = f"LTE-{site['site_code']}-{sector_letter}"
                
                # Calculate capacity based on band
                if band['type'] == 'High-Band':
                    max_throughput = random.randint(200, 400)
                    max_users = random.randint(150, 300)
                elif band['type'] == 'Mid-Band':
                    max_throughput = random.randint(100, 250)
                    max_users = random.randint(200, 500)
                else:
                    max_throughput = random.randint(50, 150)
                    max_users = random.randint(300, 700)
                
                cells.append({
                    'cell_id': cell_id,
                    'site_id': site['site_id'],
                    'cell_name': cell_name,
                    'cell_type': 'LTE',
                    'technology': '4G LTE',
                    'frequency_band': band['band'],
                    'frequency_mhz': band['frequency_mhz'],
                    'bandwidth_mhz': band['bandwidth_mhz'],
                    'sector': sector,
                    'azimuth_degrees': azimuth,
                    'electrical_tilt': random.randint(2, 8),
                    'mechanical_tilt': random.randint(0, 5),
                    'antenna_height_m': site['tower_height_m'],
                    'tx_power_dbm': random.randint(40, 46),
                    'max_throughput_mbps': max_throughput,
                    'max_connected_users': max_users,
                    'pci': random.randint(0, 503),
                    'tac': random.randint(10000, 99999),
                    'vendor': vendor,
                    'status': site['status'],
                })
                cell_id += 1
    
    return pd.DataFrame(cells)


def generate_ran_performance(cells_df, start_date='2024-01-01', end_date='2026-01-28'):
    """Generate RAN performance fact data."""
    performance = []
    perf_id = 1
    
    # Generate hourly data for sampling (we'll sample to reduce size)
    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')
    
    # Sample cells and times to keep data manageable
    # Generate daily aggregated data instead of hourly
    current_date = start
    
    while current_date <= end:
        # Sample a subset of cells each day
        sampled_cells = cells_df.sample(n=min(len(cells_df), 200))
        
        for _, cell in sampled_cells.iterrows():
            # Generate performance based on technology
            is_5g = cell['technology'] == '5G NR'
            max_throughput = cell['max_throughput_mbps']
            max_users = cell['max_connected_users']
            
            # Time-based patterns (weekend vs weekday, time of day simulation)
            is_weekend = current_date.weekday() >= 5
            base_utilization = 0.4 if is_weekend else 0.6
            
            # Random variation
            utilization = min(0.98, max(0.05, base_utilization + random.uniform(-0.25, 0.35)))
            
            # Calculate metrics
            avg_throughput = max_throughput * utilization * random.uniform(0.6, 0.95)
            
            # PRB (Physical Resource Block) utilization
            prb_utilization = utilization * 100 * random.uniform(0.85, 1.1)
            prb_utilization = min(100, max(0, prb_utilization))
            
            # Connected users
            connected_users = int(max_users * utilization * random.uniform(0.5, 1.2))
            connected_users = min(max_users, max(0, connected_users))
            
            # Latency (5G is much lower)
            if is_5g:
                latency = random.uniform(5, 25)
            else:
                latency = random.uniform(20, 60)
            
            # Signal strength (RSRP)
            rsrp = random.uniform(-110, -70)
            
            # Signal quality (RSRQ)
            rsrq = random.uniform(-19, -3)
            
            # SINR (Signal to Interference + Noise Ratio)
            sinr = random.uniform(-5, 25)
            
            # Handover success rate
            handover_success = random.uniform(95, 99.9)
            
            # Call drop rate
            call_drop_rate = random.uniform(0.01, 2.0)
            
            # RRC connection success
            rrc_success = random.uniform(97, 99.9)
            
            # E-RAB setup success
            erab_success = random.uniform(97, 99.9)
            
            # Availability
            availability = random.choices([100.0, 99.99, 99.9, 99.5, 99.0, 95.0],
                                         weights=[0.6, 0.2, 0.1, 0.05, 0.03, 0.02])[0]
            
            performance.append({
                'perf_id': perf_id,
                'cell_id': cell['cell_id'],
                'site_id': cell['site_id'],
                'metric_date': current_date.strftime('%Y-%m-%d'),
                'metric_hour': random.randint(0, 23),  # Peak hour representation
                'technology': cell['technology'],
                'frequency_band': cell['frequency_band'],
                'avg_throughput_mbps': round(avg_throughput, 2),
                'max_throughput_mbps': round(max_throughput * random.uniform(0.8, 1.0), 2),
                'prb_utilization_pct': round(prb_utilization, 2),
                'connected_users': connected_users,
                'max_connected_users': max_users,
                'avg_latency_ms': round(latency, 2),
                'rsrp_dbm': round(rsrp, 2),
                'rsrq_db': round(rsrq, 2),
                'sinr_db': round(sinr, 2),
                'handover_success_pct': round(handover_success, 2),
                'call_drop_rate_pct': round(call_drop_rate, 3),
                'rrc_setup_success_pct': round(rrc_success, 2),
                'erab_setup_success_pct': round(erab_success, 2),
                'availability_pct': round(availability, 2),
            })
            perf_id += 1
        
        current_date += timedelta(days=1)
    
    return pd.DataFrame(performance)


def generate_ran_alarms(cells_df, equipment_df, start_date='2024-01-01', end_date='2026-01-28'):
    """Generate RAN alarm fact data."""
    alarms = []
    alarm_id = 1
    
    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')
    total_days = (end - start).days
    
    # Generate approximately 50-100 alarms per day
    num_alarms = total_days * random.randint(50, 100)
    
    # Get active equipment and cells
    active_equipment = equipment_df[equipment_df['status'] != 'Offline']
    active_cells = cells_df[cells_df['status'] != 'Offline']
    
    for _ in range(num_alarms):
        alarm_type_info = random.choice(RAN_ALARM_TYPES)
        
        # Decide if alarm is for cell or equipment
        if random.random() < 0.6:  # 60% cell alarms
            target = active_cells.sample(n=1).iloc[0]
            target_type = 'Cell'
            target_id = target['cell_id']
            target_name = target['cell_name']
            site_id = target['site_id']
        else:  # 40% equipment alarms
            target = active_equipment.sample(n=1).iloc[0]
            target_type = target['equipment_type']
            target_id = target['equipment_id']
            target_name = target['equipment_name']
            site_id = target['site_id']
        
        # Generate alarm time
        alarm_time = start + timedelta(
            days=random.randint(0, total_days),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59),
            seconds=random.randint(0, 59)
        )
        
        severity = random.choice(alarm_type_info['severity'])
        
        # Clear time (some alarms may not be cleared yet)
        if alarm_time < datetime(2026, 1, 25):  # Give buffer for recent alarms
            duration_minutes = random.choices(
                [random.randint(5, 60), random.randint(60, 360), random.randint(360, 1440), random.randint(1440, 4320)],
                weights=[0.4, 0.35, 0.2, 0.05]
            )[0]
            clear_time = alarm_time + timedelta(minutes=duration_minutes)
            acknowledged = True
        else:
            clear_time = None
            acknowledged = random.random() < 0.5
        
        # Root cause
        root_causes = ['Hardware', 'Software', 'Configuration', 'External', 'Environmental', 'Unknown']
        root_cause = random.choice(root_causes)
        
        # Operator names
        operators = ['James Wilson', 'Sarah Chen', 'Michael Brown', 'Emma Davies', 'David Singh',
                    'Sophie Taylor', 'Oliver Johnson', 'Emily White', 'Thomas Anderson', 'Lucy Martin']
        
        alarms.append({
            'alarm_id': alarm_id,
            'site_id': site_id,
            'target_type': target_type,
            'target_id': target_id,
            'target_name': target_name,
            'alarm_type': alarm_type_info['type'],
            'severity': severity,
            'impact': alarm_type_info['impact'],
            'raised_time': alarm_time.strftime('%Y-%m-%d %H:%M:%S'),
            'cleared_time': clear_time.strftime('%Y-%m-%d %H:%M:%S') if clear_time else None,
            'duration_minutes': int((clear_time - alarm_time).total_seconds() / 60) if clear_time else None,
            'acknowledged': acknowledged,
            'acknowledged_by': random.choice(operators) if acknowledged else None,
            'root_cause': root_cause,
            'ticket_id': f"INC{random.randint(100000, 999999)}" if random.random() < 0.7 else None,
        })
        alarm_id += 1
    
    return pd.DataFrame(alarms)


def main():
    """Main function to generate all RAN data."""
    print("=" * 60)
    print("SnowTelco RAN Data Generator")
    print("=" * 60)
    
    # Ensure output directory exists
    os.makedirs(DEMO_DATA_PATH, exist_ok=True)
    
    # Generate RAN Sites
    print("\n[1/5] Generating RAN Sites...")
    sites_df = generate_ran_sites(num_sites=500)
    sites_path = os.path.join(DEMO_DATA_PATH, 'ran_site_dim.csv')
    sites_df.to_csv(sites_path, index=False)
    print(f"      Created {len(sites_df)} sites -> {sites_path}")
    
    # Generate RAN Equipment
    print("\n[2/5] Generating RAN Equipment...")
    equipment_df = generate_ran_equipment(sites_df)
    equipment_path = os.path.join(DEMO_DATA_PATH, 'ran_equipment_dim.csv')
    equipment_df.to_csv(equipment_path, index=False)
    print(f"      Created {len(equipment_df)} equipment records -> {equipment_path}")
    
    # Generate RAN Cells
    print("\n[3/5] Generating RAN Cells...")
    cells_df = generate_ran_cells(sites_df)
    cells_path = os.path.join(DEMO_DATA_PATH, 'ran_cell_dim.csv')
    cells_df.to_csv(cells_path, index=False)
    print(f"      Created {len(cells_df)} cells -> {cells_path}")
    
    # Generate RAN Performance
    print("\n[4/5] Generating RAN Performance data...")
    print("      (This may take a moment...)")
    performance_df = generate_ran_performance(cells_df)
    performance_path = os.path.join(DEMO_DATA_PATH, 'ran_performance_fact.csv')
    performance_df.to_csv(performance_path, index=False)
    print(f"      Created {len(performance_df)} performance records -> {performance_path}")
    
    # Generate RAN Alarms
    print("\n[5/5] Generating RAN Alarms...")
    alarms_df = generate_ran_alarms(cells_df, equipment_df)
    alarms_path = os.path.join(DEMO_DATA_PATH, 'ran_alarm_fact.csv')
    alarms_df.to_csv(alarms_path, index=False)
    print(f"      Created {len(alarms_df)} alarms -> {alarms_path}")
    
    # Summary
    print("\n" + "=" * 60)
    print("RAN Data Generation Complete!")
    print("=" * 60)
    print(f"\nFiles created in {DEMO_DATA_PATH}:")
    print(f"  - ran_site_dim.csv       ({len(sites_df)} sites)")
    print(f"  - ran_equipment_dim.csv  ({len(equipment_df)} equipment)")
    print(f"  - ran_cell_dim.csv       ({len(cells_df)} cells)")
    print(f"  - ran_performance_fact.csv ({len(performance_df)} records)")
    print(f"  - ran_alarm_fact.csv     ({len(alarms_df)} alarms)")
    
    # Print some statistics
    print("\n" + "-" * 40)
    print("Data Statistics:")
    print("-" * 40)
    print(f"\nSites by Technology:")
    print(sites_df['technology'].value_counts().to_string())
    print(f"\nSites by Area Type:")
    print(sites_df['area_type'].value_counts().to_string())
    print(f"\nEquipment by Type:")
    print(equipment_df['equipment_type'].value_counts().to_string())
    print(f"\nCells by Technology:")
    print(cells_df['technology'].value_counts().to_string())
    print(f"\nAlarms by Severity:")
    print(alarms_df['severity'].value_counts().to_string())


if __name__ == '__main__':
    main()
