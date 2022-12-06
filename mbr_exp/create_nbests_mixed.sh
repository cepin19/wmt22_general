for model in $(ls -1v ../models/*encz*base*mixed*iter*npz) #ls for nice iterN sorting
do

modelName=$(basename $model | sed 's/.fs2//' | sed 's/model_transformer_encz_adq.//' | sed 's/.iter.*//'  )
iter=$(echo $model | sed 's/.*iter//' | sed 's/.npz//' )
echo $modelName
echo $iter
if [ ! -f  out/$modelName.$iter.out_nbest  ];then
        cat ../news20.en.snt | bash trans_fs2_prometheus_nbest.sh -m $model --mini-batch 32 -d 1 2 > out/$modelName.$iter.out_nbest
fi

if [ $(wc -l out/$modelName.$iter.out_nbest   | cut -f1 -d' ') != "8508" ] ; then

cat ../news20.en.snt | bash trans_fs2_prometheus_nbest.sh -m $model --mini-batch 32 -d 1 2  > out/$modelName.$iter.out_nbest
fi
done
