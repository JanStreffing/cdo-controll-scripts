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
	echo "   prep E$(printf "%03g" i) for MiLES blocking analysis "
	echo "   ====================================================="
	printf $dir
	cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/z500_6hourly
	pwd
	cdo sellonlatbox,0,360,0,90 -remapbil,r144x73 -setname,zg -setunit,Pa z500_$(printf "%03g" ${i})_daily.nc zg50000_${res}_$(printf "%03g" ${i})_${e}_fullfile.nc
	mkdir  /p/largedata/hhb19/jstreffi/runtime/oifsamip/MILES/data/zg50000/${res}_$(printf "%03g" ${i})/
	mkdir  /p/largedata/hhb19/jstreffi/runtime/oifsamip/MILES/data/zg50000/${res}_$(printf "%03g" ${i})/${e}/
	ln -s $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/z500_6hourly/zg50000_${res}_$(printf "%03g" ${i})_${e}_fullfile.nc /p/largedata/hhb19/jstreffi/runtime/oifsamip/MILES/data/zg50000/${res}_$(printf "%03g" ${i})/${e}/zg50000_${res}_$(printf "%03g" ${i})_${e}_fullfile.nc
done


