#!/bin/ksh
#SBATCH --job-name=OPP
#SBATCH -p shared
#SBATCH --time=08:00:00
#SBATCH -A ab0246



e=$1
start=$2
end=$3
res=$4
var=$5
dir=$6

cd $dir/$res/Experiment_$e
pwd
echo "   ====================================================="
echo "   Cat z500 for Experiment $e"
echo "   ====================================================="
for i in {$2..$3}
do
	echo "   ====================================================="
	echo "   Cat z500 for run E$(printf "%03g" i)"
	echo "   ====================================================="
	rm -rf E$(printf "%03g" i)/outdata/oifs/z500_6hourly
	mkdir E$(printf "%03g" i)/outdata/oifs/z500_6hourly
	cd E$(printf "%03g" i)/outdata/oifs/z500_6hourly
	
	for x in {2..7}
	do
		cdo cat ../0000${x}/z500_0000${x}.nc z500_6hourly.nc
	done

	cd ../../../..
done
cd .
