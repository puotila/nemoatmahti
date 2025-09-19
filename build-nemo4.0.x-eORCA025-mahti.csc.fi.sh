#!/bin/bash

set -ex

# NEMO4.0.7 eORCA025 build and install instructions for mahti.csc.fi
#
# 2018-12-11, Juha Lento, CSC
# 2018-12-14, Petteri Uotila, INAR/UH
# 2021-01-28, Petteri Uotila, INAR/UH
# 2021-09-10, Petteri Uotila, INAR/UH
# 2022-07-02, Petteri Uotila, INAR/UH
# 2023-01-03, Petteri Uotila, INAR/UH

INITIALS=HPU # set your initials here
PROJ=project_2004927 

nemo_version=4.0.7

compiler=gcc
compiler_version=11.2.0
mpi=openmpi
mpi_version=4.1.2

module purge
module load StdEnv ${compiler}/${compiler_version} ${mpi}/${mpi_version}
module load boost/1.77.0-mpi
module load netcdf-c/4.8.1 netcdf-fortran/4.5.3
module load hdf5/1.10.7-mpi

export PROJAPPL=/projappl/$PROJ
export SCRATCH=/scratch/$PROJ

cd /scratch/$PROJ/$USER
# Checkout sources
if [[ ! -d nemo_$nemo_version ]]; then
    svn co https://svn-mirror.nemo-ocean.eu/NEMO/releases/r4.0/r$nemo_version nemo_$nemo_version
    # svn co https://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r$nemo_version nemo_$nemo_version
fi
cd nemo_$nemo_version

export XIOS_HOME=/projappl/${PROJ}/puotila/XIOS/trunk

cat > arch/arch-${compiler}-mahti.csc.fi.fcm <<EOF
%HDF5_HOME           $HDF5_INSTALL_ROOT
%NCDF_C_HOME         $NETCDF_C_INSTALL_ROOT
%NCDF_F_HOME         $NETCDF_FORTRAN_INSTALL_ROOT
%XIOS_HOME           $XIOS_HOME

%NCDF_INC            -I%NCDF_F_HOME/include -I%NCDF_C_HOME/include -I%HDF5_HOME/include
%NCDF_LIB            -L%NCDF_F_HOME/lib -lnetcdff -L%NCDF_C_HOME/lib -lnetcdf
%XIOS_INC            -I%XIOS_HOME/inc 
%XIOS_LIB            -L%XIOS_HOME/lib -lxios -lstdc++ 

%CPP	             cpp -Dkey_nosignedzero 
%FC	             mpif90 -c -cpp
%FCFLAGS             -fdefault-real-8 -O1 -funroll-all-loops -fcray-pointer -ffree-line-length-none -fallow-argument-mismatch
%FFLAGS              %FCFLAGS
%LD                  mpif90
%LDFLAGS             -lstdc++
%FPPFLAGS            -P -C -traditional
%AR                  ar
%ARFLAGS             rs
%MK                  gmake
%USER_INC            %XIOS_INC %NCDF_INC
%USER_LIB            %XIOS_LIB %NCDF_LIB

%CC                  gcc
%CFLAGS              -O0
EOF

./makenemo -j 8 -m ${compiler}-mahti.csc.fi -d "OCE ICE" -r ORCA2_ICE_PISCES -n eORCA025_${INITIALS} del_key "key_top" clean
./makenemo -j 8 -m ${compiler}-mahti.csc.fi -d "OCE ICE" -r ORCA2_ICE_PISCES -n eORCA025_${INITIALS} del_key "key_top"

# get input data and run the experiment
cd cfgs/eORCA025_${INITIALS}/EXP00

ln -s $SCRATCH/nemoinput/eORCA025/eORCA_R025_zps_domcfg_hmin-5.nc
echo "                               0  0.0000000000000000E+00  0.0000000000000000E+00" > EMPave_old.dat

cp -p /projappl/$PROJ/$USER/nemoatmahti/namelist_cfg.eorca025 namelist_cfg
cp -p /projappl/$PROJ/$USER/nemoatmahti/namelist_ice_cfg.eorca025 namelist_ice_cfg
cp -p /projappl/$PROJ/$USER/nemoatmahti/nemorun_eorca025.sh .
cp -p /projappl/$PROJ/$USER/nemoatmahti/master_eorca025.cfg .
cp -p $XIOS_HOME/bin/xios_server.exe .

sbatch << EOF
#!/bin/bash
###
#SBATCH --job-name=eo025
#SBATCH --account=${PROJ}
##SBATCH --mem-per-cpu=2G
## how long a job takes, wallclock time hh:mm:ss
#SBATCH --time 01:00:00
#SBATCH --nodes=1
#SBATCH --partition=test
#SBATCH --ntasks-per-node=64

module purge
module load StdEnv ${compiler}/${compiler_version} ${mpi}/${mpi_version}
module load boost/1.77.0-mpi netcdf-c/4.8.1 netcdf-fortran/4.5.3

## run my MPI executable
srun ./nemo
EOF
