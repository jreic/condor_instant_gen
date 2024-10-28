#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: ./submit_qcd_pythia.sh path/to/base/output/dir"
  exit 1
fi

if [ -d "$1" ]
then
  echo "Directory $1 exists! Please pick a new directory or delete the existing one, so we don't overwrite any outputs by mistake"
  exit 1
fi

mkdir -p $1/logs; 
condor_submit outdir=$1 qcd_pythia_run.jdl
