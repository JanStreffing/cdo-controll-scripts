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
  echo "   prep seasonal mean values for E$(printf "%03g" i)"
  echo "   ====================================================="
  printf $dir
#  mkdir $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/seasonal_mean
  cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/seasonal_mean
  pwd
  for p in $var
  do
    printf "     Working on paramter ${p}\n"
    for l in {2..7}
    do
      printf "      Leg number ${l}\n"
      cdo -s cat ../$(printf "%05g" l)/${p}_$(printf "%05g" l).nc ${p}_cat.nc
    done
    cdo seasmean ${p}_cat.nc ${p}_seasmean.nc
    rm ${p}_cat.nc
  done
  pwd
done


