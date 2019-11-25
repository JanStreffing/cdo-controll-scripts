#!/bin/bash
#SBATCH --account=hhb19
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1 
#SBATCH --job-name=pfix
#SBATCH --output=mpi-out.%j
#SBATCH --error=mpi-out.%j
#SBATCH --time=08:00:00
#SBATCH --partition=batch

#Usage:
# sbatch --export=TOPLEVEL='/p/scratch/chhb19/jstreffi/runtime/oifsamip/T1279/Experiment_11/E001/',RUN_NUMBER_oifs=00000,RES_oifs='TL1279',OIFS_PAMIP_PP=1 fix-oifs-postp.sh
# ./fix-oifs-postp.sh 
TOPLEVEL="/p/scratch/chhb19/jstreffi/runtime/oifsamip/T1279/Experiment_11/E015/"
RUN_NUMBER_oifs="00002"
RES_oifs="TL1279"
OIFS_PAMIP_PP=1


#source /p/project/chhb19/jstreffi/esm-master/esm-environment/juwels.fz-juelich.de intelmpi19



			print "switching to: " ${TOPLEVEL}/outdata/oifs/${RUN_NUMBER_oifs}/
			cd ${TOPLEVEL}/outdata/oifs/${RUN_NUMBER_oifs}/
		    	rm -f *0000000000*

			echo "Concatenating OIFS output files"
			pwd
			ls *
			for GRID in SH GG
			do
		    		cat ICM${GRID}* > ICM${GRID}CAT

        	                case $RES_oifs in
	                                TL159|TL255)

						if [[ "x$GRID" == "xGG" ]]; then
							cdo -f nc -t ecmwf copy -remapcon,r320x160 -setgridtype,regular ICM${GRID}CAT ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc  
						else
							cdo -f nc -t ecmwf copy -remapcon,r320x160 -setgridtype,regular -sp2gpl ICM${GRID}CAT ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc  
						fi
						;;
                                        TL1279)

                                                if [[ "x$GRID" == "xGG" ]]; then
                                                        cdo -f nc -t ecmwf copy -remapcon,r960x480 -setgridtype,regular ICM${GRID}CAT ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc
                                                else
                                                        cdo -f nc -t ecmwf copy -remapcon,r960x480 -setgridtype,regular -sp2gpl ICM${GRID}CAT ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc
                                                fi
						;;
				esac

			    	echo "Cutting off the last OIFS timestep that we write because of ifs_lastout"
			    	ncdump -h ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc >>temp
			    	INPUT=$(awk 'NR==3' temp)
			   	rm temp
			    	SUBSTRING=$(echo $INPUT| cut -d'(' -f2 )
			    	LAST_TIME_STEP=$(echo $SUBSTRING| cut -d' ' -f1 )
			    	SECOND_LAST_TIME_STEP=$((LAST_TIME_STEP - 1))
			    	cdo seltimestep,1/$SECOND_LAST_TIME_STEP ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc

			    	echo "Calculating mean values for OIFS output"
		    		if [[ $OIFS_PAMIP_PP == 0 ]]; then
					cdo daymean ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_daymean.nc
				fi
		    		cdo monmean ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_monmean.nc

			    	echo "Linking OIFS output files in convenient folders"
				cd ${TOPLEVEL}/outdata/oifs/
				mkdir -p daymean monmean
				cd ${TOPLEVEL}/outdata/oifs/daymean 
				ln -s ../$(printf "%05d" ${RUN_NUMBER_oifs})/ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_daymean.nc ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_daymean.nc
				cd ${TOPLEVEL}/outdata/oifs/monmean
				ln -s ../$(printf "%05d" ${RUN_NUMBER_oifs})/ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_monmean.nc ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_monmean.nc
				cd ${TOPLEVEL}/outdata/oifs/$(printf "%05d" ${RUN_NUMBER_oifs})/	
			done

	                if [[ $OIFS_PAMIP_PP == 1 ]]; then # Keep only those variables that are needed for the PAMIP runs. Store them only at needed frequency
        	                echo "          Reducing output frequency and variable selection to PAMIP standard"
                	        cd ${TOPLEVEL}/outdata/oifs/$(printf "%05d" ${RUN_NUMBER_oifs})/
                        	cdo sellevel,50000 -selvar,Z ICMPPSH$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc z500_$(printf "%05d" ${RUN_NUMBER_oifs}).nc
	                        cdo splitname ICMPPGG$(printf "%05d" ${RUN_NUMBER_oifs})_monmean.nc remove_me_ &
        	                cdo splitname ICMPPSH$(printf "%05d" ${RUN_NUMBER_oifs})_monmean.nc remove_me_ &
                	        wait
                        	for filename in remove_me_*; do
	                                 [ -f "$filename" ] || continue
        	                        first=${filename#"remove_me_"}
                	                last=${first%*.nc*}
                        	        mv ${filename} ${last}_$(printf "%05d" ${RUN_NUMBER_oifs}).nc
	                        done
	                        cdo selvar,T2M ICMPPGG$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc T2M_$(printf "%05d" ${RUN_NUMBER_oifs}).nc
       	 	                cdo selvar,MSL ICMPPGG$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc MSL_$(printf "%05d" ${RUN_NUMBER_oifs}).nc
                	fi


			for GRID in SH GG
			do
				echo "Removing raw OIFS output"
		   		rm -f ICM${GRID}* 	
				echo "Removing uncut output files"
				rm -f ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs}).nc
                                rm -f ICMPP${GRID}$(printf "%05d" ${RUN_NUMBER_oifs})_cut.nc
				mecho 'oifs post-processing finished'
			done		
			
