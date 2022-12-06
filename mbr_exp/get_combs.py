m1=13
for i in range (0,m1):
    m2=m1-i
    for j in range(0,m2):
        m3=m2-j
        for k in range(0,m3):
            if i+j+k==12:
                print("{0}_{1}_{2} {0} {1} {2}".format(i,j,k))

