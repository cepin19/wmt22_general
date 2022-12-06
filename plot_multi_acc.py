import csv,sys
import seaborn as sns
import matplotlib
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import rcParams
accs=[]
updates=[]
bleus=[]
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
#model_names=["20k exp","40k exp","80k exp","160k exp"]
#model_names=["mixed","40k block", "40k block avg8",  "40k block exp", "40k block exp+avg8"]
#model_names=["20k noexp avg","40k noexp avg","80k noexp avg","160k noexp avg"]
#model_names=["20k exp avg","40k exp avg","80k exp avg","160k exp avg"]
#model_names=["20k exp","40k exp","80k exp","160k exp"]
model_names=["BLEU", "NE ACC"]
#model_names=["mixed","40k block"]
#model_names=["40k block base", "40k block big 6-6", "40k block big 12-6"]
#model_names=["40k block", "40k block no enmono"]
if "comet" in sys.argv[1]:
    metric="COMET"
else:
    metric="BLEU"

#metric="BLEUS"
#    model_names.append(fn)
fn_bleu=sys.argv[1]
with open(fn_bleu) as f:
    model_name=[]
    model_bleu=[]
    model_updates=[]
    for i,line in enumerate(f.readlines()):
        if i%2:
            model_bleu.append(float(line.strip()))
        else:
            if "to" in line:# for averages, the updates have form update_of_the_first_checkpointtoupdate_of the last checkpoint
                line=line[line.find("to")+2:]
            model_updates.append(int(line.strip()))
    bleus.append(model_bleu)
    updates.append(model_updates)



fn_acc=sys.argv[2]
with open(fn_acc) as f:
    model_name=[]
    model_bleu=[]
    model_updates=[]
    for i,line in enumerate(f.readlines()):
        if i%2:
            model_bleu.append(float(line.strip()))
        else:
            if "to" in line:# for averages, the updates have form update_of_the_first_checkpointtoupdate_of the last checkpoint
                line=line[line.find("to")+2:]
            model_updates.append(int(line.strip()))
    accs.append(model_bleu)
    updates.append(model_updates)

#        change_labels.append(changes[i%4])
longest_updates=max(updates,key=len)
dataset_changes=[x for x in range(0,longest_updates[-1],40000)]
print(dataset_changes)


sns.set_theme()
sns.set(font_scale = 1.15)
#ax2=plt.twinx()
fig,ax=plt.subplots(figsize=(18,6))
data = pd.DataFrame()
for update,bleu,model_name,acc in zip(updates,bleus,model_names,accs):
    for u,b,a in zip(update,bleu,acc):
        data = data.append({"Update":u,metric:b,"model_name":model_name,"Acc":a},ignore_index = True)#,"Correct":correct})
print(data)
#sns.lineplot(x='Update', y='Correct',
#             data=data,color='g',label='Correct',  marker='o')
p=sns.lineplot(x='Update', y=metric, 
         data=data,ax=ax, marker='', markersize=4, color="blue", linewidth = 1.65)#, style="model_name")
ax2=p.axes.twinx()
p=sns.lineplot(x='Update', y="Acc",
         data=data,ax=ax2, marker='', markersize=4, color="green", linewidth = 1.65)#, style="model_name")


if metric=='BLEU':
    if "encz" in sys.argv[1]:
        ax.set_ylim((29.1,36.5))
    elif "czen" in sys.argv[1]:
        ax.set_ylim((20,26.5))
    if "18" in sys.argv[1]:
        ax.set_ylim((27,32.5))

elif metric=='COMET':
    if "encz" in sys.argv[1]:
        ax.set_ylim((0.635,0.76))
    elif "czen" in sys.argv[1]:
        ax.set_ylim((0.2,.5))
    if "18" in sys.argv[1]:
        ax.set_ylim((0.4,0.6))

sns.set(font_scale = 1.2)
ax.set_xlim((480000,1320000))
ax.set_xticks(range(480000,1300000,160000))
plt.ticklabel_format(useOffset=False, style='plain')

ax2.plot([], [], '-r', label = 'Acc', color='green')
ax2.plot([], [], '-r', label = metric, color='blue')
#ax2.set_ylim((0.9,1.0))

ax2.legend(title='Metric', loc='lower right')
plt.xlabel("Updates",size=18)
#plt.ylabel(metric,size=18)
plt.xticks(fontsize=16)
if metric=="COMET":
    plt.yticks(fontsize=14) 
else:
    plt.yticks(fontsize=16)

#p.set_yticklabels(p.get_yticks(), size=25)
#plt.legend()
col=['green','blue','green','red']
for i,change in enumerate(dataset_changes):
    plt.axvline(x=change,color='grey',linestyle="-",alpha=0.15)
#    plt.text(change,41,changes[i%4])
    plt.axvspan(xmin=change, xmax=change+40000, facecolor=col[i%4], alpha=0.035)
fig.savefig('plot.pdf',dpi=300, pad_inches=0.0, bbox_inches='tight')
matplotlib.pyplot.show()
