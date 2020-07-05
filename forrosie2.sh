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
	cdo timmean $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/seasonal_mean/T_DJF.nc /p/largedata/hhb19/jstreffi/runtime/oifsamip/EADE/T_${e}_E$(printf "%03g" i)_${res}.nc
	cdo timmean $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/seasonal_mean/U_DJF.nc /p/largedata/hhb19/jstreffi/runtime/oifsamip/EADE/U_${e}_E$(printf "%03g" i)_${res}.nc
done
