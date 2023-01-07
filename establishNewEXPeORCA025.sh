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

ln -s ../../SHARED/namelist_ref .
ln -s ../../SHARED/namelist_ice_ref .
ln -s ../../SHARED/grid_def_nemo.xml .
ln -s ../../SHARED/field_def_nemo-ice.xml .
ln -s ../../SHARED/field_def_nemo-oce.xml .
ln -s ../../SHARED/domain_def_nemo.xml .
ln -s ../../SHARED/axis_def_nemo.xml .
ln -s ${SCRATCH}/nemoinput/eORCA025/eORCA_R025_zps_domcfg_hmin-5.nc .

cp -p ${NEMOATMAHTIREPO}/namelist_ice_cfg.eorca025 namelist_ice_cfg
cp -p ${NEMOATMAHTIREPO}/namelist_cfg.eorca025 namelist_cfg
cp -p ${NEMOATMAHTIREPO}/file_def_nemo-oce.xml .
cp -p ${NEMOATMAHTIREPO}/file_def_nemo-ice.xml .
cp -p ${NEMOATMAHTIREPO}/context_nemo.xml .
cp -p ${NEMOATMAHTIREPO}/iodef.xml .
echo "                               0  0.0000000000000000E+00  0.0000000000000000E+00" > EMPave_old.dat

cp -p ${NEMOATMAHTIREPO}/puotila/nemoatmahti/nemorun_eorca025.sh .
cp -p ${NEMOATMAHTIREPO}/puotila/nemoatmahti/master_eorca025.cfg .
