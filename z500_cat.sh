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
	echo $dir/$res/Experiment_$e/E$(printf "%03g" i)/outdata/oifs/z500_6hourly
	cd E$(printf "%03g" i)/outdata/oifs/z500_6hourly

	if [ $res == 'T159' ]
	then
		if [ $e == '11' ]
		then
			cdo -seltimestep,244/1703 ../00001/z500_00001.nc z500_6hourly.nc
		else
			for l in {1..2}
			do
				cdo cat ../0000${x}/z500_0000${x}.nc tmp
			done
			cdo -seltimestep,244/1703 tmp z500_6hourly.nc
			rm tmp
		fi
	else
		for x in {2..7}
		do
			printf "      Leg number ${l}\n"
			cdo cat ../0000${x}/z500_0000${x}.nc z500_6hourly.nc
		done
	fi

	cd ../../../..
done
