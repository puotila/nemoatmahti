#!/bin/sh
# Prepares new NEMO4.0.7 eORCA025 experiment
# For example:
# 1. mkdir $SCRATCH/$USER/nemo4.0.7/cfgs/eORCA025_INI/EXP01
# 2. cd $SCRATCH/$USER/nemo4.0.7/cfgs/eORCA025_INI/EXP01
# 3. sh -x ${NEMOATMAHTIREPO}/etablishNewEXPeORCA025.sh [run this script]
# 4. sbatch nemorun_eorca025.sh [start new run with cold start]
# etc...
#
# <petteri.uotila@helsinki.fi> 7.1.2023

PROJ=project_2004927
PROJAPPL=/project/${PROJ}
NEMOATMAHTIREPO=${PROJAPPL}/${USER}/nemoatmahti
SCRATCH=/scratch/${PROJ}

ln -s ${SCRATCH}/puotila/nemo_4.0.7/cfgs/eORCA025_HPU/BLD/bin/nemo.exe nemo
cp -p ${PROJAPPL}/puotila/XIOS/trunk/bin/xios_server.exe .

for fn in namelist_ref namelist_ice_ref grid_def_nemo.xml field_def_nemo-ice.xml field_def_nemo-oce.xml domain_def_nemo.xml axis_def_nemo.xml
do
    ln -s ../../SHARED/${fn} .
done
ln -s ${SCRATCH}/nemoinput/eORCA025/eORCA_R025_zps_domcfg_hmin-5.nc .

cp -p ${NEMOATMAHTIREPO}/namelist_ice_cfg.eorca025 namelist_ice_cfg
cp -p ${NEMOATMAHTIREPO}/namelist_cfg.eorca025 namelist_cfg

echo "                               0  0.0000000000000000E+00  0.0000000000000000E+00" > EMPave_old.dat

for fn in file_def_nemo-oce.xml file_def_nemo-ice.xml context_nemo.xml iodef.xml nemorun_eorca025.sh master_eorca025.cfg
    cp -p ${NEMOATMAHTIREPO}/${fn} .
do

