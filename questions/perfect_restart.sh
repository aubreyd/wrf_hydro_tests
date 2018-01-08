#!/bin/bash
###################################
##q Perfect Restart of Candidate Binary
##q Question: Does a restart of the model yield an identical restart file at a later time?
##q Directories:
##q    Candidate Run        : $domainRunDir/run.candidate
##q    Candidate Restart run: $domainRunDir/run.candidate.restart
###################################

echo
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "\e[7;49;32mperfect_restart.sh:\e[0m"
echo -e "\e[0;49;32mRunning candidate binary from restart (with $nCoresDefault cores).\e[0m"
cd $domainRunDir/run.candidate.restart || \
    { echo "Can not cd to $domainRunDir/run.candidate.restart. Exiting."; exit 1; }
cp $candidateBinary .
mpirun -np $nCoresDefault ./`basename $candidateBinary` 1> `date +'%Y-%m-%d_%H-%M-%S.stdout'` 2> `date +'%Y-%m-%d_%H-%M-%S.stderr'` 

## did the model finish successfully?
## This grep is >>>> FRAGILE <<<<. But fortran return codes are un reliable. 
nSuccess=`grep 'The model finished successfully.......' diag_hydro.* | wc -l` || echo fooooo
if [[ $nSuccess -ne $nCoresDefault ]]; then
    echo -e "\e[5;49;31mCandidate binary restart run failed unexpectedly.\e[0m"
    exit 1
fi
echo -e "\e[0;49;32mCandidate binary restart run successful.\e[0m"

cd ../
echo
echo -e "\e[0;49;32mQuestion: Perfect restarts?\e[0m".

#compare restart files
python3 $answerKeyDir/compare_restarts.py \
        $domainRunDir/run.candidate.restart \
        $domainRunDir/run.candidate \
    || { echo -e "\e[5;49;31mAnswer: Perfect restart comparison failed.\e[0m"; exit 1; }
echo -e "\e[5;49;32mAnswer: Perfect restart comparison successful!\e[0m"

exit 0
