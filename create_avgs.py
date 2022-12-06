import glob
import os.path
import re
import sys
import numpy as np
def average(models,target_fn):
    n = len(models)
    average = dict()

    for filename in models:
        print("Loading {}".format(filename))
        with open(filename, "rb") as mfile:
            # Loads matrix from model file
            m = np.load(mfile)
            for k in m:
                if k != "history_errs":
                    # Sometimes files get corrupted
                    try:
                        m[k].shape
                    except:
                        sys.stderr.write("corrupted: {}\n".format(filename))
                    # Initialize the key)
                    if k not in average:
                        average[k] = m[k]
                    # Add to the appropriate value
                    elif average[k].shape == m[k].shape and "special" not in k:
                        average[k] += m[k]

    # Actual averaging
    for k in average:
        if "special" not in k:
            average[k] /= n

    # Save averaged model to file
    print("Saving to {}".format(target_fn))
    np.savez(target_fn, **average)




r=re.compile(r'iter.*')
chck_count=8
save_iter=5000
i=re.compile(r'.*iter(.*).npz')
filenames=glob.glob('czen_models/*iter*')
models=set([re.sub(r,'',f) for f in filenames])#get all model types
for f  in filenames:
    match=re.match(i,f)
    print(iter)
    iter=int(match.groups()[0])
    if iter>chck_count*save_iter:
        iters=[x for x in range (iter-(chck_count-1)*save_iter,iter+1,save_iter)] # get 8 previous checkpoints
        print("averaging {}".format(iters))
        target_fn=re.sub(r'iter',"avg"+str(iter-(chck_count-1)*save_iter)+"to",f).replace("czen_models","models_avg_czen")
        if os.path.exists(target_fn):
            print("already exists, skipping")
            continue
        print ("saving to {}".format(target_fn))
        models=[re.sub('iter.*','iter{}.npz'.format(it),f) for it in iters ] #complete prev checkpoint pathc
        try:
            average(models,target_fn)
        except Exception as e:
            sys.stderr.write(str(e)+'\n')

print(models)
