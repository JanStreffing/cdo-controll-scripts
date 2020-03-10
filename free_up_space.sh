#!/bin/ksh
for res in {T159,T511,T1279}
do
	for expid in {11,16}
	do
		for i in {1..300}
		do
			mkdir /p/fastdata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/
			mkdir /p/fastdata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/
			mv /p/largedata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/post*  /p/fastdata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/
		done
	done
done
