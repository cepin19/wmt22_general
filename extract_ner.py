import sys
import re
import json
with open ("../../surface_forms.json") as l:
    lemmas=json.load(l)

forms={}
types=("area","name","near", "street")
for t in types: #build en lemmas->cz surface forms dict
    for lemma in lemmas[t]:
        for form in lemmas[t][lemma]:
            if lemma in forms:
                forms[lemma].append(form.split('\t')[1]) #choose the surface form
            else:
                forms[lemma]=[form.split('\t')[1]]
#print(forms)
r=re.compile(r'name="(.*?)"|area="(.*?)"|address="(.*?)"')
total=0
found=0
with open("../source/all-da_loc.txt") as expected_ne: # expand-das.txt contains en lemmas for source, we need to map them to czech surface forms and check if there is any in the translation
    for line,line_ne in zip(sys.stdin,expected_ne):
 #       print(line)
        m=re.findall(r,line_ne)
        for match in m:
            for ne in match:
                for part in ne.split(' or '):#smichov or hradcany
                    if part:
                        total+=1
                        part=re.sub(r'[0-9]','',part).strip()
                        if any(f.lower().replace(u'\xa0',u' ') in line.lower().replace(u'\xa0',u' ') for f in forms[part]): #nbsp somewhere
                            found+=1
#                            sys.stderr.write("found {} ({})\n".format(part,','.join(forms[part])))
                        else:
                            sys.stderr.write("Not found {}, expected something from: {}. Line: {}\n".format(part,','.join(forms[part]),line))
print(found/total)
