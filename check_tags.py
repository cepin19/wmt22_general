import sys
import re
success=0
total=0
for i,line in enumerate(sys.stdin):
    translation=line.split('\t')[0]
    tags=line.split('\t')[1]
    tags=re.sub(r'<.*?>',';',tags)
#    print(tags)
    for t in tags.split(';'):
        t=t.strip()
        if t:
            total+=1 
            if t in translation:
                success+=1
            else:
                print(i)
                print(line)
                print(t)
print("Success: {}".format(success))
print("Total: {}".format(total))
print(success/total)
