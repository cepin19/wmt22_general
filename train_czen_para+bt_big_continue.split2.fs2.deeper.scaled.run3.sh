marian=marian-dev/build
dev="0 1 2 3 4 5 6 7 "
w=7000
for e in {2..25..6}
do
echo "Starting epoch $e for para1"
let i=e+1
let j=e+2
let k=e+3
let l=e+4
let m=e+5
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1-t/
tmp=/mnt/h/tmp
if [[ $(hostname) == *dll10* ]];then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1-t/
        tmp=.
#       echo "dll10"
fi



$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz   --type transformer \
    --train-sets  corp/czeng20-train.head25M.filt.cs.fs2 corp/czeng20-train.head25M.filt.en.fs2  \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/czeng20-train.head25M.filt.adq \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev --sync-sgd --seed 1234 --optimizer-delay 1 \
	--exponential-smoothing --sqlite -T $tmp -e $e --no-restore-corpus 

echo "Starting epoch $i for mono1"
$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz --type transformer \
    --train-sets  corp/czeng20-csmono.head25M.filt.cs.fs2 corp/czeng20-csmono.head25M.filt.en.fs2 \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/czeng20-csmono.head25M.filt.adq \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev --sync-sgd --seed 1234 --optimizer-delay 1 \
        --exponential-smoothing --sqlite -T $tmp -e $i --no-restore-corpus 


echo "Starting epoch $j for para2"

$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz --type transformer \
    --train-sets  corp/czeng20-train.tail+25M.filt.cs.fs2 corp/czeng20-train.tail+25M.filt.en.fs2 \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/czeng20-train.tail+25M.filt.adq \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev  --sync-sgd --seed 1234 --optimizer-delay 1 \
        --exponential-smoothing --sqlite -T $tmp -e $j --no-restore-corpus 

echo "Starting epoch $k for enmono2"
$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz --type transformer \
    --train-sets  corp/czeng20-enmono.tail+20M.filt.cs.fs2 corp/czeng20-enmono.tail+20M.filt.en.fs2 \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/czeng20-enmono.tail+20M.filt.adq   \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev  --sync-sgd --seed 1234 --optimizer-delay 1 \
        --exponential-smoothing --sqlite -T $tmp -e $k --no-restore-corpus 


echo "Starting epoch $l for czmono2"
$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz --type transformer \
    --train-sets  corp/czeng20-csmono.tail+25M.filt.cs.fs2 corp/czeng20-csmono.tail+25M.filt.en.fs2 \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 16000 --lr-report  --data-weighting corp/czeng20-csmono.tail+25M.filt.adq \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev  --sync-sgd --seed 1234 --optimizer-delay 1 \
        --exponential-smoothing --sqlite -T $tmp -e $l --no-restore-corpus 

echo "Starting epoch $m for enmono1"
$marian/marian \
    --model model/model_transformer_czen.big_continued_adqd.split2.deeper.fs2.run3.npz --type transformer \
    --train-sets  corp/czeng20-enmono.head20M.filt.cs.fs2 corp/czeng20-enmono.head20M.filt.en.fs2 \
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
    --overwrite --keep-best \
    --early-stopping 95 --cost-type=ce-mean-words \
    --log data/train_czen2.deeper.run3.log --valid-log data/valid.log \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --transformer-preprocess n --transformer-postprocess da \
    --tied-embeddings-all --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --learn-rate 0.0001 --lr-warmup 32000 --lr-decay-inv-sqrt 32000 --lr-report  --data-weighting corp/czeng20-enmono.head20M.filt.adq \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --devices $dev  --sync-sgd --seed 1234 --optimizer-delay 1 \
        --exponential-smoothing --sqlite -T $tmp -e $m --no-restore-corpus 

done 
