marian=marian-dev/build
dev="0 1 2 3 4 5 6 7 "
w=7000
i=0
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
tmp=/mnt/h/tmp
if [[ $(hostname) == *dll10* ]];then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
        tmp=.
#       echo "dll10"
fi
while true
do
for corp in czeng20-train.filt.filtered.gt0.02 czeng20-csmono.filt.filtered.gt0.02 ParaCrawl-v9.en-cs.filtered.gt0.02 czeng20-csmono.filt.filtered.gt0.02 CCMatrix.cs-en.filtered.gt0.02 czeng20-enmono.filt.filtered.gt0.02 CCAligned.cs-en.filtered.gt0.02 czeng20-csmono.filt.filtered.gt0.02  czeng20-train.filt.filtered.gt0.02 czeng20-enmono.filt.filtered.gt0.02
do
src=$corp.en.fs2
tgt=$corp.cs.fs2
scores=$corp.adq_scores
i=$((i+1))
updates=$((i*50000))
$marian/marian \
    --model model/model_transformer_encz+bt+ccmatrix+ccalign+paracrawl.big_continued_adqd.split2.fs2.new_block.npz   --type transformer \
    --train-sets  corp/$src corp/$tgt  \
    --max-length 150 \
    --vocabs corp/vocab2.fsv corp/vocab2.fsv \
    --mini-batch-fit -w $w --mini-batch 1000 --maxi-batch 1000 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics ce-mean-words perplexity translation bleu-detok\
    --valid-sets corp/news19.en.fs2 corp/news19.cs.fs2 \
    --valid-script-path ./val.encz.fs2.sh \
    --valid-translation-output data/valid.bpe.encz.output --quiet-translation \
    --beam-size 6 --normalize=0.6 \
    --valid-mini-batch 16 \
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_encz+bt+ccmatrix+ccalign+paracrawl.big.log --valid-log data/valid.log \
    --enc-depth 6 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/$scores \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev --sync-sgd --seed 1234 --optimizer-delay 1 \
	--exponential-smoothing --sqlite -T $tmp -a ${updates}u --no-restore-corpus 

done 
done
