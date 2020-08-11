#!/bin/ksh
res=T511
#expid=16
for expid in {11,16}
do
	for i in {201..300}
	do
		mkdir /p/largedata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/
		cp -rf /p/scratch/chhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/outdata/  /p/largedata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/outdata/
	done
done
