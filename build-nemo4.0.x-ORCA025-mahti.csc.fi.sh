#!/bin/bash

set -ex

# NEMO build and install instructions for mahti.csc.fi
#
# 2018-12-11, Juha Lento, CSC
# 2018-12-14, Petteri Uotila, INAR/UH
# 2021-01-28, Petteri Uotila, INAR/UH
# 2021-09-10, Petteri Uotila, INAR/UH
# 2022-07-02, Petteri Uotila, INAR/UH

PROJ=project_2000789 

nemo_version=4.2.0

compiler=gcc
compiler_version=11.2.0
mpi=mpich
mpi_version=4.0.1

module purge
module load StdEnv ${compiler}/${compiler_version} ${mpi}/${mpi_version}
module load boost/1.77.0-mpi
module load netcdf-c/4.8.1 netcdf-fortran/4.5.3

export PROJAPPL=/projappl/$PROJ
export SCRATCH=/scratch/$PROJ

cd /scratch/$PROJ/$USER
# Checkout sources
if [[ ! -d nemo_$nemo_version ]]; then
    git clone --branch $nemo_version https://forge.nemo-ocean.eu/nemo/nemo.git nemo_$nemo_version
fi
cd nemo_$nemo_version

cat > arch/arch-${compiler}-mahti.csc.fi.fcm <<EOF
%HDF5_HOME           /appl/spack/v017/install-tree/gcc-11.2.0/hdf5-1.10.7-veijpf
%NCDF_C_HOME         $NETCDF_C_INSTALL_ROOT
%NCDF_F_HOME         $NETCDF_FORTRAN_INSTALL_ROOT
%XIOS_HOME           /projappl/project_2000789/puotila/XIOS/trunk

%NCDF_INC            -I%NCDF_F_HOME/include -I%NCDF_C_HOME/include -I%HDF5_HOME/include
%NCDF_LIB            -L%NCDF_F_HOME/lib -lnetcdff -L%NCDF_C_HOME/lib -lnetcdf
%XIOS_INC            -I%XIOS_HOME/inc 
%XIOS_LIB            -L%XIOS_HOME/lib -lxios -lstdc++ 

%CPP	             cpp -Dkey_nosignedzero 
%FC	             mpif90 -c -cpp
%FCFLAGS             -fdefault-real-8 -O1 -funroll-all-loops -fcray-pointer -ffree-line-length-none
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

./makenemo -j 8 -m ${compiler}-mahti.csc.fi -d "OCE ICE" -r ORCA2_ICE_PISCES -n MY_ORCA025_ICE del_key "key_top"

# get input data and run the experiment
ENAME=EXP00
cd cfgs/MY_ORCA025_ICE/${ENAME}

ln -s $SCRATCH/nemoinput/ORCA025/ORCA_R025_zps_domcfg_hmin-5.nc
echo "                               0  0.0000000000000000E+00  0.0000000000000000E+00" > EMPave_old.dat

cp -p $PROJAPPL/$USER/nemoatmahti/namelist_cfg.orca025 namelist_cfg
cp -p $PROJAPPL/$USER/nemoatmahti/nemorun_orca025.sh .
cp -p $PROJAPPL/$USER/nemoatmahti/field_def_nemo-oce.xml .

sbatch << EOF
#!/bin/bash
###
## name of your job
#SBATCH --job-name=orca025
#SBATCH --account=project_2000789
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
