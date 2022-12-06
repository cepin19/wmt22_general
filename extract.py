import xml.etree.ElementTree as ET
import sys,re
r=re.compile(f'<.*?>')

def all_texts(root):
    if root.text is not None:
        yield root.text
    for child in root:
        if len(list(child))>0:
            yield ''.join(all_texts(child)).strip()

        if child.text is not None:
            yield child.text
        if child.tail is not None:
            yield child.tail
doc=""
for line in sys.stdin:
    entities=[]
    try:
        doc = ET.fromstring("<doc>"+line+"</doc>")
    except:
        continue
    nes=doc.findall("ne")
    for ne in nes:
        text=''.join(all_texts(ne)).strip()
        type=ne.attrib["type"]
        entities.append("<ne type={}>{}</ne>".format(type,text))
    print("{}\t{}".format(re.sub(r,'',line.strip())," ".join(entities)))
