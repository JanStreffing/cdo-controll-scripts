#!/bin/bash

start=1
end=40
res=T1279
dir='/p/largedata/hhb19/jstreffi/runtime/oifsamip/'

for e in {11,16}
do
	for var in z500 U MSL T2M SD SF
	do
		./prep_for_scripts.sh $e $start $end $res $var $dir
		if [ "$var" == "z500" ]
		then
			./z500_cat.sh $e $start $end $res $var $dir
		fi
	done
done

start=1
end=40

for e in {11,16}
do
	for var in z500 U MSL T2M SD SF synact nao
	do
		./mean_for_scripts.sh $e $start $end $res $var $dir
		./split_to_seasons.sh $e $start $end $res $var $dir
		if [ "$var" == "synact" ]
		then
			./synact_PAMIP.job $e $start $end $res $var $dir
  			./post_data_oifs_synact_stddev.job $e $start $end $res $var $dir
		elif [ "$var" == "nao" ]
		then
	                ./post_data_oifs_nao.job $e $start $end $res $var $dir
		fi
	done
done
