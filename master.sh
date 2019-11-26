#!/bin/bash

start=1
end=100
res=T159
dir='/mnt/lustre01/work/ba1035/a270092/runtime/oifsamip'

for e in {11,16}
do
	for var in z500 U MSL T2M SD SF
	do
		if [ "$var" == "z500" ]
		then
			./z500_cat.sh $e $start $end $res $var $dir
		else
			./prep_for_scripts.sh $e $start $end $res $var $dir
		fi
	done
done

start=1
end=100

for e in {11,16}
do
	for var in z500 U MSL T2M SD SF synact NAO
	do
		if [ "$var" == "synact" ]
		then
			./synact_PAMIP.job $e $start $end $res $var $dir
  			./post_data_oifs_synact_stddev.job $e $start $end $res $var $dir
		elif [ "$var" == "NAO" ]
		then
	                ./post_data_oifs_nao.job $e $start $end $res $var $dir
		else
			./mean_for_scripts.sh $e $start $end $res $var $dir
			./split_to_seasons.sh $e $start $end $res $var $dir
		fi
		
	done
done
