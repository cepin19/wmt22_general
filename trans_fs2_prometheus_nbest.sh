marian=/servers/translation-servers/marian-dev/build/marian-decoder
#marian=/servers/translation-servers/marian-dev/build/marian-decoder
/home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish//factored-segmenter encode  --model ../corp/encs2.fsm | $marian  -v ../corp/vocab2.fsv ../corp/vocab2.fsv   --maxi-batch-sort src -b 6 -n 1 --n-best $@ 

