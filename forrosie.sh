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
	cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/monthly_mean
        if [ $var == 'T2M' ]; then
	        cdo -chname,T2M,tas -timmean -seltimestep,1/3 ${var}_monmean.nc /p/largedata/hhb19/jstreffi/runtime/oifsamip/EADE/tas_${e}_DJF_E$(printf "%03g" i)_${res}.nc
	fi
        if [ $var == 'MSL' ]; then
	        cdo -chname,MSL,psl -timmean -seltimestep,1/3 ${var}_monmean.nc /p/largedata/hhb19/jstreffi/runtime/oifsamip/EADE/psl_${e}_DJF_E$(printf "%03g" i)_${res}.nc
	fi
	pwd
done


