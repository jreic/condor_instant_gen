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

#if [ -d "$1/$2" ]
#then
#  echo "Directory $1/$2 exists! Please pick a new directory or delete the existing one, so we don't overwrite any outputs by mistake"
#  exit 1
#fi

# for grid proxy: typically only needed for the condor jobs, not for local ones
if [ -n "$3" ]
then
  export X509_USER_PROXY=$3
fi

# use this dir for writing out temporary outputs, so condor does not automatically transfer them back to the output dir
timestamp="`date +%s`"
mkdir myTmpDir_$timestamp
cd myTmpDir_$timestamp

#year=20161
#year=20162
#year=2017
year=2018
# FIXME add a year string conversion to turn 2018 into UL18 for other purposes downstream--only matters if we ever run over more than just 2018 B parked data
yearStr="UL18_bParking"

# FIXME I currently set a different output folder for each job based on the $2 number, but could move it into the input/output file names too. Maybe fine as-is, but can think more.
myOutputDir=$1/$2
mkdir -p $myOutputDir

sherpaExe=/afs/cern.ch/user/j/jreicher/workdir/public/instantons/sherpa/sherpa-v3.0.0-source/build/bin/Sherpa
genToRecoBase=/afs/cern.ch/user/j/jreicher/workdir/public/SUEP_WH/suep-production

cmsswGenDir=$genToRecoBase/CMSSW_10_6_30_patch1/src
cmsswSimDir=$genToRecoBase/CMSSW_10_6_30_patch1/src
# FIXME HLT dir is year dependent
cmsswHltDir=$genToRecoBase/CMSSW_10_2_16_UL/src
cmsswAodDir=$genToRecoBase/CMSSW_10_6_30_patch1/src
cmsswMiniAodDir=$genToRecoBase/CMSSW_10_6_30_patch1/src

nevents=2500
randomseed=$((129*$year+$2))


echo -e "\nStart Sherpa\n"

# FIXME We'll probably want multiple yaml files for different parameters (e.g. mass points, in the future)
$sherpaExe /afs/cern.ch/user/j/jreicher/workdir/public/instantons/condor_instant_gen/Instanton.yaml -g -e $nevents -R $randomseed


echo -e "\nStart hepmc3 to hepmc2 conversion\n"
/afs/cern.ch/user/j/jreicher/workdir/public/instantons/HepMC3Convert/build/outputs/convert_example.exe -i hepmc3 -o hepmc2 out.hepevt out.hepevt2; rm out.hepevt


# setups needed for apptainer
source /cvmfs/cms.cern.ch/cmsset_default.sh;

gencmd="echo -e \"\nStart hepmc2 to GEN\n\"; cd $cmsswGenDir; cmsenv; cd -; cmsRun /afs/cern.ch/user/j/jreicher/workdir/public/instantons/condor_instant_gen/hepmc2gen.py inputFiles=file:out.hepevt2 randomSeed=$randomseed firstRun=$(($2+1)); rm out.hepevt2"
simcmd="echo -e \"\nStart GEN to SIMDIGI\n\"; cd $cmsswSimDir; cmsenv; cd -; cmsRun $genToRecoBase/test/$yearStr/sim-digi_pythia.py inputFiles=file:HepMC_GEN.root outputFile=simdigi.root; rm HepMC_GEN.root"
hltcmd="echo -e \"\nStart SIMDIGI to HLT\n\"; cd $cmsswHltDir; cmsenv; cd -; cmsRun $genToRecoBase/test/$yearStr/hlt_pythia.py inputFiles=file:simdigi.root outputFile=hlt.root; rm simdigi.root"
aodcmd="echo -e \"\nStart HLT to AOD\n\"; cd $cmsswAodDir; cmsenv; cd -; cmsRun $genToRecoBase/test/$yearStr/aod_pythia.py inputFiles=file:hlt.root outputFile=aod.root; rm hlt.root"
miniaodcmd="echo -e \"\nStart AOD to MiniAOD\n\"; cd $cmsswMiniAodDir; cmsenv; cd -; cmsRun $genToRecoBase/test/$yearStr/miniaod_pythia.py inputFiles=file:aod.root outputFile=miniaod.root; rm aod.root; mv miniaod.root $myOutputDir"

cmssw-el7 -- "source /cvmfs/cms.cern.ch/cmsset_default.sh; source /cvmfs/cms.cern.ch/common/crab-setup.sh; $gencmd; $simcmd; $hltcmd; $aodcmd; $miniaodcmd;"

