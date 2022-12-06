export spm_dir=/lnet/work/people/jon/spm_iridium/sentencepiece/build/src/

#head -q -n 25000000 <(shuf corp/czeng20-train.filt.cln.en.snt )  <(shuf corp/czeng20-train.filt.cln.cs.snt )  > tmp
#cat corp/czeng20-train.filt.cln.en.snt corp/czeng20-train.filt.cln.cs.snt > tmp
env LC_ALL=en_US.UTF-8 ../factored-segmenter-spm/bin/Release/netcoreapp3.1/linux-x64/publish/factored-segmenter  train --model encs3.fsm \
     -v encs3.fsv  --single-letter-case-factors  --serialize-indices-and-unrepresentables  \
    --min-piece-count 38  --min-char-count 2  --vocab-size 32000 \
    tmp
