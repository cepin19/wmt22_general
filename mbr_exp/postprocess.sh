for f in out/*encz*mixed*out_nbest
do
	sed 's/ ||| /\t/g' $f | cut -f2 | /home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish//factored-segmenter decode  --model ../corp/encs2.fsm   > $f.post
done
