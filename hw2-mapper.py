#!/usr/bin/env python
import sys
from csv import reader

# skip first line (the header)
next(sys.stdin)

for line in reader(sys.stdin):
    boro, crime = (line[13].strip(), line[7].strip())
    if not boro or not crime:
        continue

    # rest of the code
    crime = crime.replace('-', ' ').replace(',', ' ')
    print(f'{boro}:{crime}\t1')
