import sys
import re
import json

#print(forms)
r=re.compile(r'name=(.*?)\)|area=(.*?)\)|address=(.*?)\)')
total=0
found=0
with open("cs_restaurant_dataset/devel/source/all-da_loc.txt") as expected_ne: # expand-das.txt contains en lemmas for source, we need to map them to czech surface forms and check if there is any in the translation
    for line,line_ne in zip(sys.stdin,expected_ne):
 #       print(line)
        m=re.findall(r,line_ne)
        for match in m:
            for ne in match:
                ne=ne.replace('"','')
                for part in ne.split(' or '):#smichov or hradcany
                    if part:
                        total+=1
                        part=re.sub(r'[0-9]','',part).strip()
                        if part.lower().replace(u'\xa0',u' ') in line.lower().replace(u'\xa0',u' '): #nbsp somewhere
                            found+=1
#                            sys.stderr.write("found {} ({})\n".format(part,','.join(forms[part])))
                        else:
                            sys.stderr.write("Not found {}. Line: {}\n".format(part,line))
print(found/total)
