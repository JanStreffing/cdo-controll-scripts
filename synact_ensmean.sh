#!/bin/ksh
#SBATCH --job-name=OPP
#SBATCH -p shared
#SBATCH --time=08:00:00
#SBATCH -A ba1035

e=$1
start=$2
end=$3

for i in {$start..$end}
do
  echo "   ====================================================="
  echo "   Calculating ensemble mean values for Experiment_$e"
  echo "   ====================================================="
  pwd
  cd Experiment_${e}/ensemble_mea
  pwd
  for p in SD SF V T U T2M MSL z500
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
  cd ../../../../..
  ./cdo-postprocessing-scripts/synact_PAMIP_copy.job $1 $2 $3
  ./post_data_oifs_synact_stddev.job $1 $2 $3
done


