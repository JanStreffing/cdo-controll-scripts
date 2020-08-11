#!/bin/ksh
res=T1279
expid=16
for expid in {11,16}
do
	for i in {1..100}
	do
		tar -cvf /p/arch/hhb19/streffing1/PAMIP/${res}_EXP${expid}_E$(printf "%03d" $i).tar /p/largedata/hhb19/jstreffi/runtime/oifsamip/$res/Experiment_${expid}/E$(printf "%03d" $i)/
	done
done
