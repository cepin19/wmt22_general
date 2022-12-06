marian=marian-dev/build
dev="0 1 2 3"
w=7000
i=0
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
marian=/lnet/express/work/people/jon/marian-troja/marian/build/

tmp=/mnt/h/tmp
if [[ $(hostname) == *dll10* ]];then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1-t/
        tmp=.
#       echo "dll10"
fi
src=czeng20-train+csmono+enmono.filt.filtered.gt0.02.cs.fs2
tgt=czeng20-train+csmono+enmono.filt.filtered.gt0.02.en.fs2
scores=czeng20-train+csmono+enmono.filt.filtered.gt0.02.adq_scores
$marian/marian \
    --model model/model_transformer_czen.base.fs2.mixed_corp.npz   --type transformer --task transformer-base \
    --train-sets  corp/$src corp/$tgt  \
    --max-length 150 \
    --vocabs corp/vocab2.fsv corp/vocab2.fsv \
    --mini-batch-fit -w $w --mini-batch 1000 --maxi-batch 1000 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics ce-mean-words perplexity translation bleu-detok\
    --valid-sets corp/news19.cs.fs2 corp/news19.en.fs2 \
    --valid-script-path ./val.czen.fs2.sh \
    --valid-translation-output data/valid.bpe.czen.output --quiet-translation \
    --beam-size 6 --normalize=0.6 \
    --valid-mini-batch 16 \
    --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_encz.mixed_corp.base.log --valid-log data/valid.log \
    --tied-embeddings-all  \
    --lr-report  --data-weighting corp/$scores \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev --sync-sgd --seed 1234 --optimizer-delay 1 \
	--exponential-smoothing --sqlite -T $tmp --no-restore-corpus 

