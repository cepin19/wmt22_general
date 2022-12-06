for model in model/*mixed*
do
	new_name=$(echo $model | sed 's/mixed_bad/mixed/')
	mv $model $new_name
done
