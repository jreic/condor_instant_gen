#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: ./instant_run.sh path/to/base/output/dir/ integer_subdirectory_index"
  exit 1
fi

if [[ $2 != +([0-9]) ]];
then
  echo "integer_subdirectory_index must be an integer value (it's used to set the unique random seed)"
  echo "Usage: ./instant_run.sh path/to/base/output/dir/ integer_subdirectory_index"
  exit 1
fi

if [ -d "$1/$2" ]
then
  echo "Directory $1/$2 exists! Please pick a new directory or delete the existing one, so we don't overwrite any outputs by mistake"
  exit 1
fi

#year=20161
#year=20162
#year=2017
year=2018

myOutputDir=$1/$2
mkdir -p $myOutputDir
cd $myOutputDir

sherpaDir=/users/h2/johnpaul/sherpa-v3.0.0beta1-run
sherpaExe=/users/h2/johnpaul/sherpa-v3.0.0beta1-source/build/bin/Sherpa
cmsswDir=/users/h2/johnpaul/cmssw/CMSSW_10_6_20_patch1

nevents=1000
randomseed=$((8854+$2+$year))

echo "Start Sherpa!"

# FIXME At some point, I will test writing the outputs directly on the condor node and only copying at the end to reduce the I/O strain a bit (will need to adjust the jdl file too), but probably okay as-is 
# FIXME We'll probably want multiple yaml files for different parameters
$sherpaExe $sherpaDir/Instanton.yaml -g -e $nevents -R $randomseed


echo "Start hepmc3 to hepmc2 conversion!"

$sherpaDir/convert_example.exe -i hepmc3 -o hepmc2 out.hepevt out.hepevt2


echo "Start hepmc2 to GEN conversion!"

source /cvmfs/cms.cern.ch/cmsset_default.sh;
export PATH="/cvmfs/oasis.opensciencegrid.org/mis/apptainer/1.2.5/bin:$PATH"

# FIXME revert back to this once JP's dir has the updated file
#cmssw-el7 "--bind /condor --bind /osg --bind /cms --bind /home --bind /users" -- "source /home/joey/alma8_setups/setup_inside_cmssw-el7_apptainer.sh; cd $cmsswDir; cmsenv; cd $myOutputDir; cmsRun $cmsswDir/hepmc2gen.py inputFiles=file:$myOutputDir/out.hepevt2 randomSeed=$randomseed"
cmssw-el7 "--bind /condor --bind /osg --bind /cms --bind /home --bind /users" -- "source /home/joey/alma8_setups/setup_inside_cmssw-el7_apptainer.sh; cd $cmsswDir; cmsenv; cd $myOutputDir; cmsRun /home/joey/instantons/condor_instant_gen/hepmc2gen.py inputFiles=file:$myOutputDir/out.hepevt2 randomSeed=$randomseed"

# FIXME I currently set a different output folder for each job based on the $2 number, but could move it into the input/output file names too. Maybe fine as-is, but can think more.
# FIXME At the end, we should delete the intermediate files (after we validate it slightly)
