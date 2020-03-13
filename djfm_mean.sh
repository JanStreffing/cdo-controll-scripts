#!/bin/ksh
#SBATCH --job-name=OPP
#SBATCH -p shared
#SBATCH --time=08:00:00
#SBATCH -A ba1035

e=$1
start=$2
end=$3
res=$4
var=$5
dir=$6

for i in {${start}..${end}}
do
	echo "   ====================================================="
	echo "   prep $var DJFM mean values for E$(printf "%03g" i)"
	echo "   ====================================================="
	printf $dir
	mkdir $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/djfm_mean
	cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/djfm_mean
	pwd
	for p in $var
	do
		rm -rf ${p}_djfm_mean.nc ${p}_cat.nc
		printf "     Working on paramter ${p}\n"
                if [ $res == 'T1279' ]
                then
                        if [ $var == PRECIP ] 
                        then
				for RUN_NUMBER_oifs in {2..7}
				do
					cdo chname,LSP,CP ../0000${RUN_NUMBER_oifs}/LSP_$(printf "%05d" ${RUN_NUMBER_oifs}).nc ../0000${RUN_NUMBER_oifs}/temporary_LSP.nc
					cdo add ../0000${RUN_NUMBER_oifs}/temporary_LSP.nc ../0000${RUN_NUMBER_oifs}/CP_$(printf "%05d" ${RUN_NUMBER_oifs}).nc ../0000${RUN_NUMBER_oifs}/temporary_PRECIP.nc
					cdo chname,CP,PRECIP ../0000${RUN_NUMBER_oifs}/temporary_PRECIP.nc ../0000${RUN_NUMBER_oifs}/PRECIP_$(printf "%05d" ${RUN_NUMBER_oifs}).nc
				done
			fi
		fi
		if [ $res == 'T159' ]
		then
			if [ $var == T2M ] ||  [ $var == MSL ] || [ $var == z500 ] 
			then
				cdo timmean -remapcon,r320x160 -seltimestep,976/1335 ../00001/${p}_00001.nc ${p}_djfm_mean.nc
			else
                                cdo timmean -remapcon,r320x160 -seltimestep,8/12 ../00001/${p}_00001.nc ${p}_djfm_mean.nc
			fi
		else
			for l in {2..7}
			do
				printf "      Leg number ${l}\n"
				cdo -s cat ../$(printf "%05g" l)/${p}_$(printf "%05g" l).nc ${p}_cat.nc
			done
			if [ $var == T2M ] ||  [ $var == MSL ] || [ $var == z500 ]
                        then
                        	cdo timmean -remapcon,r320x160 -seltimestep,732/1091 ${p}_cat.nc ${p}_djfm_mean.nc
                        else
                                cdo timmean -remapcon,r320x160 -seltimestep,6/10 ${p}_cat.nc ${p}_djfm_mean.nc
                        fi
		fi
		if [ $res == 'T1279' ]
		then
			cdo -remapcon,r320x160 ${p}_djfm_mean.nc tmp
			mv tmp ${p}_djfm_mean.nc
		fi

		if [ $var == 'U' ]; then
			cdo sellonlatbox,-180,180,0,90 ${p}_djfm_mean.nc ${p}_djfm_mean_nh.nc
		fi
		rm ${p}_cat.nc
	done
	pwd
done


