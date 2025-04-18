#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: ./submit.sh path/to/base/output/dir"
  exit 1
fi

if [ -d "$1" ]
then
  echo "Directory $1 exists! Please pick a new directory or delete the existing one, so we don't overwrite any outputs by mistake"
  exit 1
fi

mkdir -p $1/logs; 

genToReco=/afs/cern.ch/user/j/jreicher/workdir/public/instantons/genToReco/
cp hepmc2gen.py $genToReco
cp Instanton_altscale.yaml $genToReco
cp /afs/cern.ch/user/j/jreicher/workdir/public/instantons/sherpa/sherpa-v3.0.0-source/build/bin/Sherpa $genToReco
cp /afs/cern.ch/user/j/jreicher/workdir/public/instantons/HepMC3Convert/build/outputs/convert_example.exe $genToReco

tar -czvf $1/input.tar.gz -C /afs/cern.ch/user/j/jreicher/workdir/public/instantons/genToReco .
condor_submit outdir=$1 instant_run_altscale.jdl
