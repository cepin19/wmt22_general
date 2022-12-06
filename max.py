import csv,sys
import pandas as pd

updates=[]
bleus=[]

with open(sys.argv[1]) as f:
    for i,line in enumerate(f):
#        if i<60:
 #           continue
        if i%2:
            bleus.append(float(line.strip()))
        else:
            updates.append(line.strip())
print(updates[bleus.index(max(bleus))])
print(max(bleus))
