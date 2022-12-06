export spm_dir=/lnet/work/people/jon/spm_iridium/sentencepiece/build/src/
export spm_dir=/lnet/express/work/people/jon/marian/build-CPUONLY/
head -q -n 15000000 <(shuf corp/czeng20-train.filt.cln.en.snt )  <(shuf corp/czeng20-train.filt.cln.cs.snt )  > tmp
#cat corp/czeng20-train.filt.cln.en.snt corp/czeng20-train.filt.cln.cs.snt > tmp
env LC_ALL=en_US.UTF-8 factored-segmenter-spm-old/bin/Release/netcoreapp3.1/linux-x64/publish/factored-segmenter  train --model encs7.fsm \
     -v encs7.fsv  --single-letter-case-factors  --serialize-indices-and-unrepresentables  \
    --min-piece-count 40  --min-char-count 15  --vocab-size 30000 \
    tmp
