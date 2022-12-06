import csv,sys
import pandas as pd

updates=[]
scores=[]
block_size=40000
block_types=4
best_total=12
best_types={0:4,1:4,2:4} #auth, csmono, enmono
best_types={0:0,1:0,2:12}
#best_types={0:0,1:12,2:0}
#best_types={0:12,1:0,2:0}
if len(sys.argv)>2:
    best_types={0:int(sys.argv[3]),1:int(sys.argv[4]),2:int(sys.argv[5])}

block_counter={0:0,1:0,2:0}
print(best_types)
with open(sys.argv[1]) as f:
    for i,line in enumerate(f):
#        if i<60:
 #           continue
        if i%2:
            scores.append(float(line.strip()))
        else:
            updates.append(line.strip())
regions=[((int(u)-1)//block_size)%block_types for u in updates]
score_dict=dict(zip(updates,scores))
#regions=[((int(u)-1)//block_size)%block_types for u in updates]
print(regions)
#only works reliably in python3.6+
score_dict=dict(sorted(score_dict.items(), key=lambda item: item[1], reverse=True))

#print(list(score_dict.items())[:best_total])
final_items=[]
for s in score_dict.items():
    u=s[0]
    block=((int(u)-1)//block_size)%block_types
    if block==2:block=0 # second repetiotion of auth in our setting, which goes auth->csmono->auth->enmono
    if block==3:block=2
#    if len(final_items)<best_total:
#        final_items.append(s)
#        block_counter[block]+=1
#    continue
    if block_counter[block]<best_types[block]:
        block_counter[block]+=1
        final_items.append(s)

    cont=False
    for bc,bt in zip(block_counter.values(),best_types.values()):
        if bc!=bt:
            cont=True
    if not cont:
        break
print(final_items)
print(block_counter)
print(sum(list(i[1] for i in final_items))/best_total)
candidates=[]
for c in final_items:
    with open("out/model_transformer_encz.base.block_40k.{}.out_nbest.post".format(c[0])) as f:
        candidates.append(f.readlines())
with open(sys.argv[2]+'.merged_nbest','w') as out, open(sys.argv[2]+".avg_score",'w') as s:
    i=0
    s.write(str(sum(list(i[1] for i in final_items))/best_total))
    while i<len(candidates[0]):
        for c in candidates:
            out.write(c[i])
        i+=1

