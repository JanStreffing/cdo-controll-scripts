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
	echo "   fixing E$(printf "%03g" i)"
	echo "   ====================================================="
	cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/
	pwd
	for p in $var
	do
		printf "     Working on paramter ${p}\n"
		for l in {2..7}
		do
			printf "      Pruning number ${l}\n"
			cdo seltimestep,1,2 $(printf "%05g" l)/${p}_$(printf "%05g" l).nc  $(printf "%05g" l)/${p}_tmp.nc &
		done
		wait
		for l in {2..7}
		do
			printf "      Moving Leg number ${l}\n"
			mv $(printf "%05g" l)/${p}_tmp.nc $(printf "%05g" l)/${p}_$(printf "%05g" l).nc &
		done
		wait
	done
done


