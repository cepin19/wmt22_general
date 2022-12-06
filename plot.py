import csv,sys
import seaborn as sns
import matplotlib
import pandas as pd
import matplotlib.pyplot as plt

updates=[]
bleu=[]
correct=[]
changes=["train","cs","train","en"]
#change_labels=[]
#with open('res.csv', newline='') as csvfile:
#    reader = csv.reader(csvfile, delimiter=',', quotechar='|')
#    next(reader, None)
#    for row in reader:
#        updates.append(int(row[0]))
#        bleu.append(float(row[2]))
#        correct.append(int(row[1]))
with open(sys.argv[1]) as f:
    for i,line in enumerate(f.readlines()):
        if i%2:
            bleu.append(float(line.strip()))
        else:
            updates.append(int(line.strip()))
#        change_labels.append(changes[i%4])
dataset_changes=[x for x in range(0,updates[-1],40000)]
print(dataset_changes)

sns.set_theme()
data = pd.DataFrame({"Update":updates,"BLEU":bleu})#,"Correct":correct})

#sns.lineplot(x='Update', y='Correct',
#             data=data,color='g',label='Correct',  marker='o')
ax2=plt.twinx()
sns.lineplot(x='Update', y='BLEU', 
             data=data,color='b',label='BLEU',ax=ax2, marker='o')
ax2.set_ylim((10,40))

plt.legend()
for i,change in enumerate(dataset_changes):
    plt.axvline(x=change,color='grey',linestyle="--")
    plt.text(change,41,changes[i%4])
matplotlib.pyplot.show()

