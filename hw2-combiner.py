#!/usr/bin/env python
import sys

boro_current = None
crime_current = None
crime_count = 0

for line in sys.stdin:
    key, value = line.split('\t', 1)
    boro, crime = key.split(':', 1)
    boro, crime, value = (boro.strip(), crime.strip(), value.strip())

    if boro_current != boro or crime_current != crime:
        if boro_current != None and crime_current != None:
            print(f'{boro_current}:{crime_current}\t{crime_count}')
        boro_current = boro
        crime_current = crime
        crime_count = 0

    crime_count += int(value)

print(f'{boro_current}:{crime_current}\t{crime_count}')
