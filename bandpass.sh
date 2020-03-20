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
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,944/1367 ../00001/6h_VO_00001.nc VO_bpf_prep &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,944/1367 ../00001/6h_V_00001.nc V_bpf_prep &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,944/1367 ../00001/6h_U_00001.nc U_bpf_prep &
		wait


	else
		for RUN_NUMBER_oifs in {2..7}
		do
			printf "      Leg number ${l}\n"
			cdo -s cat ../$(printf "%05g" l)/6h_VO_$(printf "%05g" l).nc VO_cat.nc &
			cdo -s cat ../$(printf "%05g" l)/6h_V_$(printf "%05g" l).nc V_cat.nc &
			cdo -s cat ../$(printf "%05g" l)/6h_U_$(printf "%05g" l).nc U_cat.nc &
			wait
		done
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,700/1123 VO_cat.nc VO_bpf_prep &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,700/1123 V_cat.nc V_bpf_prep &
		/p/project/chhb19/jstreffi/software/miniconda3/envs/pyn_env_py2/bin/cdo -P 8 -sellonlatbox,-180,180,0,90 -seltimestep,700/1123 U_cat.nc U_bpf_prep &
		wait
	fi

	export var=VO
	ncl /p/project/chhb19/jstreffi/postprocessing/ncl-plot-scripts/bandpass.ncl &
	export var=V
	ncl /p/project/chhb19/jstreffi/postprocessing/ncl-plot-scripts/bandpass.ncl &
	export var=U
	ncl /p/project/chhb19/jstreffi/postprocessing/ncl-plot-scripts/bandpass.ncl &
	wait
	cdo -seltimestep,32/392 VO_bpf.nc VO_bpf
	cdo -seltimestep,32/392 V_bpf.nc V_bpf
	cdo -seltimestep,32/392 U_bpf.nc U_bpf

	cdo timstd VO_bpf VO_std &
	cdo timstd V_bpf V_std &
	cdo timstd U_bpf U_std &

	cdo -timmean -mul U_bpf VO_bpf COV_U_VO.nc
	cdo -timmean -mul V_bpf VO_bpf COV_V_VO.nc
	cdo merge COV_U_VO.nc COV_V_VO.nc EV.nc

	cdo sqr COV_U_VO.nc COV_U_VO2.nc
	cdo -chname,V,U -sqr COV_V_VO.nc COV_V_VO2.nc
	cdo -sqrt -add COV_U_VO2.nc COV_V_VO2.nc Magnitude.nc

	file_string+="$dir/$res/Experiment_${e}/E$(printf "%03g" i)/outdata/oifs/bandpass/EV.nc "
	rm M.nc N.nc U2-V2 U2_bpf* V2_bpf* U_bpf* V_bpf* COV*
done

mkdir $dir/$res/Experiment_${e}/ensemble_mean
cd $dir/$res/Experiment_${e}/ensemble_mean
echo $file_string
rm EV.nc
cdo ensmean $file_string EV.nc
