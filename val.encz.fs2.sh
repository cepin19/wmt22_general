#!/bin/bash
#echo "Validating..."
#python -m pip install sacrebleu --user
moses_home=/home/big_maggie/usr/moses20161024/mosesdecoder/
date=`date +"%d_%m_%Y_%H:%M"`
segmenter=/lnet/work/people/jon/en_fr_term/publish
cat $1 | $segmenter/factored-segmenter decode  --model corp/encs2.fsm | perl corp/fix-cs-quotes-etc.pl    > data/output.postprocessed.encs.$date
cat data/output.postprocessed.encs.$date   |python -m sacrebleu corp/news19.cs.snt | cut -f 3 -d ' ' | cut -f 1 -d ',' 

