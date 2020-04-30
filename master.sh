#!/bin/bash

dir='/p/largedata/hhb19/jstreffi/runtime/oifsamip'

res='T511'
#for res in {T159,T511,T1279}
#do
	if [ $res == T1279 ]; then
		start=61
		end=100
	elif [ $res == T511 ]; then
		start=006
		end=006
	elif [ $res == T159 ]; then
		start=101
		end=300
	fi
	
	e=11
	#for e in {11,16}
	#do
		for var in a #z500 #Z U T T2M V SD SF #U V T SD SF #U #Z SD SF #nao
		do
			if [ "$var" == "z500" ]
			then
				printf "z500_cat.sh"
				./z500_cat.sh $e $start $end $res $var $dir
			fi
			if [ "$var" == "T2M" ]
			then
				printf "extremes for $var"
				./extreme.sh $e $start $end $res $var $dir
			fi
			if [ "$var" == "PRECIP" ]
			then
				printf "extremes for $var"
				./extreme.sh $e $start $end $res $var $dir
			fi
			echo $res, $start, $end
			#./bandpass.sh $e $start $end $res $var $dir
			#./djfm_mean_11.sh $e $start $end $res $var $dir
			#./monmean.sh $e $start $end $res $var $dir
			#./monmean_mid_lat.sh $e $start $end $res $var $dir
			#./seasmean.sh $e $start $end $res $var $dir
			#./forcing_part1.sh $e $start $end $res $var $dir
			#./fix_monthly.sh $e $start $end $res $var $dir
			#./fix_layers.sh $e $start $end $res $var $dir
		done
		#./forcing_part2.sh $e $start $end $res placeholder $dir
	#done

	#for e in {11,16}
	#do
		for var in a #synact #epf #pch #nao T2M z500 MSL #U T2M SD SF synact NAO
		do
			if [ "$var" == "synact" ]
			then
				printf "synact_PAMIP.job"
				./synact_PAMIP.job $e $start $end $res $var $dir
				#./post_data_oifs_synact_stddev.job $e $start $end $res $var $dir
			elif [ "$var" == "nao" ]
			then
				printf "post_data_oifs_nao.job"
				./post_data_oifs_nao.job $e $start $end $res $var $dir
			elif [ "$var" == "pch" ]
			then
				printf "post_data_oifs_pch.job"
				./post_data_oifs_pch.job $e $start $end $res $var $dir
			elif [ "$var" == "epf" ]
			then
				printf "epflux_cat.job"
				./epflux_cat.job $e $start $end $res $var $dir
			else
				printf "ensmean.sh"
			#./ensmean.sh $e $start $end $res $var $dir
			#./split_to_seasons.sh $e $start $end $res $var $dir
			fi
		#./sinuosity2.job $e $start $end $res $var $dir
		./MiLES_prep.sh $e $start $end $res $var $dir
		./MiLES_exec.sh $e $start $end $res $var $dir
		done
	#done
#done
