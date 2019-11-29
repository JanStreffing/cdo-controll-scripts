#! /bin/ksh -l

#e=16

for e in 11 16
do
  cd /mnt/lustre01/work/ba1035/a270092/runtime/oifsamip/T511/
  for i in {2..100}
  do
    echo "        ====================================================="
    echo "        Removing all but the last restart for $(printf "%03g" i)"
    echo "        ====================================================="
    echo Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00001
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00001
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00002
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00003
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00004
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00005
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00006
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00007
    rm -rf Experiment_${e}/E$(printf "%03g" i)/restart/oifs/00008
    rm -rf Experiment_${e}/E$(printf "%03g" i)/post*
    rm -rf Experiment_${e}/E$(printf "%03g" i)/input*
  done
done
