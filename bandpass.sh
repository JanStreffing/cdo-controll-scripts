#!/bin/ksh
#SBATCH --job-name=B$1
#SBATCH -p batch
#SBATCH --time=08:00:00
#SBATCH -A chhb19

e=$1
start=$2
end=$3
res=$4
var=$5
dir=$6

for i in {${start}..${end}}
do
	echo "   ======================================================================"
	echo "   Applying 2 to 8 day band pass filter on 6hourly U V VO for E$(printf "%03g" i)"
	echo "   ======================================================================"
	rm -rf $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/bandpass
	mkdir $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/bandpass
	cd $dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/bandpass
	pwd
	if [ $res == 'T159' ]
	then
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -bandpass,182,730 ../00001/6h_V_00001.nc V_bpf &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -bandpass,182,730 -chname,U,V ../00001/6h_U_00001.nc U_bpf &
		wait
	else
		for RUN_NUMBER_oifs in {2..7}
		do
			printf "      Leg number ${l}\n"
			cdo -s cat ../$(printf "%05g" l)/6h_V_$(printf "%05g" l).nc V_cat.nc &
			cdo -s cat ../$(printf "%05g" l)/6h_U_$(printf "%05g" l).nc U_cat.nc &
			wait
		done
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -bandpass,182,730 V_cat.nc V_bpf &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -bandpass,182,730 -chname,U,V U_cat.nc U_bpf &
		wait
	fi

	cdo -sqr U_bpf U2_bpf &
	cdo -sqr V_bpf V2_bpf &
	wait	
	cdo -chname,V,N -timmean -mul U_bpf V_bpf N.nc
	cdo sub U2_bpf V2_bpf U2-V2
	cdo -chname,V,M -timmean -divc,0.5 U2-V2 M.nc
	cdo merge M.nc N.nc MN.nc
	file_string+="$dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/bandpass/MN.nc "
	rm M.nc N.nc U2-V2 U2_bpf V2_bpf U_bpf V_bpf
done

mkdir $dir/$res/Experiment_${e}/ensemble_mean
cd $dir/$res/Experiment_${e}/ensemble_mean
cdo ensmean $filestring MN_ensmean.nc
