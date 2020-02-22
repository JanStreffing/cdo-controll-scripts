#!/bin/ksh

for expid in {11,16}
do
	for i in {101..300}
	do
		cp -rf /p/scratch/chhb19/jstreffi/runtime/oifsamip/T159/Experiment_${expid}/E$(printf "%03d" $i)/  /p/largedata/hhb19/jstreffi/runtime/oifsamip/T159/Experiment_${expid}/E$(printf "%03d" $i)/
	done
done
