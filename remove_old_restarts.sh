#! /bin/ksh -l

e=16

#for e in {11}
#do
  for i in {1..20}
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

  done
#done
