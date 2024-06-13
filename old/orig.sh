


#####source /home/joey/alma8_setups/setup_cmssw-el7_apptainer.sh
#####source /home/joey/alma8_setups/setup_inside_cmssw-el7_apptainer.sh
#####cmsenv
#####
########cd /users/h2/johnpaul/sherpa-v3.0.0beta1-run
#########./run.sh >& log & # produces the file out.hepevt based on Instanton.yaml
########./run.sh |& tee $myOutputDir/log
#####./convert_example.exe -i hepmc3 -o hepmc2 out.hepevt out.hepevt2 # creates HepMC2 file
#####cd /users/h2/johnpaul/cmssw/CMSSW_10_6_20_patch1
#####source /home/joey/alma8_setups/setup_cmssw-el7_apptainer.sh
#####source /home/joey/alma8_setups/setup_inside_cmssw-el7_apptainer.sh
#####cmsenv
#####cmsRun hepmc2gen.py # creates the root file HepMC_GEN.root
