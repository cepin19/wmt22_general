#TODO:add different survace forms
import sys
i=-1
districts=["Bohunice", "Bosonohy", "Bystrc", "Černovice", "Chrlice", "Ivanovice", "Jehnice", "Jundrov", "Kníničky", "Kohoutovice", "Komín", "Královo Pole", "Líšeň", "Maloměřice", "Obřany", "Medlánky", "Nový Lískovec", "Ořešín", "Řečkovice", "Mokrá Hora", "Sever", "Slatina", "Starý Lískovec", "Tuřany", "Útěchov", "Vinohrady", "Žabovřesky", "Žebětín", "Židenice"]
districts=["Bohunice", "Bosonohy", "Bystrc", "Černovice", "Chrlice", "Ivanovice", "Jehnice", "Jundrov", "Kníničky", "Kohoutovice", "Komín", "Královo Pole", "Líšeň", "Maloměřice", "Obřany", "Medlánky", "Nový Lískovec", "Ořešín", "Řečkovice", "Mokrá Hora", "Slatina", "Starý Lískovec", "Tuřany", "Útěchov", "Vinohrady", "Žabovřesky", "Žebětín", "Židenice"]

correct=0
for line in sys.stdin:
    i+=1
    sys.stderr.write(line)
    #if i%4==0:
    d=districts[i//4]
    if d in line:
        correct+=1
        sys.stderr.write("Correct: {}".format(line))
    else:
        sys.stderr.write("Incorrect (instead of {}): {}".format(d,line))

print(correct/i)

