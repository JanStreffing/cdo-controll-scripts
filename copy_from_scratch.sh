#!/bin/bash

for expid in 16 #16 
do
	for i in {21..40}
	do
		cp -rf /p/scratch/chhb19/jstreffi/runtime/oifsamip/T1279/Experiment_${expid}/E$(printf "%03d" $i)/  /p/largedata/hhb19/jstreffi/runtime/oifsamip/T1279/Experiment_${expid}/E$(printf "%03d" $i)/
	done
done
