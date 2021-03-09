#!/usr/bin/env python
import json
import sys

boro_current = None
crime_current = None
crime_count = 0

boro_dict = {'BORO': {}}

for line in sys.stdin:
    key, value = line.split('\t', 1)
    boro, crime = key.split(':', 1)
    boro, crime, value = (boro.strip(), crime.strip(), value.strip())

    if boro_current != boro:
        boro_dict['BORO'][boro] = {'CRIMES': {}}
        boro_current = boro
    if crime_current != crime:
        boro_dict['BORO'][boro]['CRIMES'][crime] = 0
        crime_current = crime

    boro_dict['BORO'][boro]['CRIMES'][crime] += int(value)

# TOTAL CRIMES By BORO
for key in boro_dict['BORO'].keys():
    boro_dict['BORO'][key][f'{key} CRIMES TOTAL'] = sum(boro_dict['BORO'][key]['CRIMES'].values())

boro_dict['BORO CRIMES OVERALL TOTAL'] = 0
for key in boro_dict['BORO'].keys():
    boro_dict['BORO CRIMES OVERALL TOTAL'] += boro_dict['BORO'][key][f'{key} CRIMES TOTAL']

print(json.dumps(boro_dict, indent=2))
