#!/bin/bash

cmssw=${1}
input=${2}
maxEvents=${3}
outdir=${4}
adcThrMIP=${5}
adcThrMIPbxm1=${6}

name=`basename ${input}`

cd $cmssw/src
eval `scram r -sh`
cd -

cmsRun $cmssw/src/UserCode/HGCElectronicsValidation/test/hgcoccupancyanalysis_cfg.py \
    input=${input}/GSD \
    output=plots.root \
    adcThrMIP=${adcThrMIP} adcThrMIPbxm1=${adcThrMIPbxm1} \
    maxEvents=${maxEvents} 

mkdir -p $outdir
thrbxm1=${adcThrMIPbxm1/./p}
thrbxm1=${thrbxm1/-/m}
finalname=${name}_thr${adcThrMIP/./p}_thrbxm1${thrbxm1}
mv -v plots*.root ${outdir}/${finalname}.root

python $cmssw/src/UserCode/HGCElectronicsValidation/test/scripts/prepareOccupancySummary.py ${outdir}/${finalname}.root
