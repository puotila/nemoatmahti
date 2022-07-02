#!/bin/bash

set -ex

# NEMO build and install instructions for mahti.csc.fi
#
# 2018-12-11, Juha Lento, CSC
# 2018-12-14, Petteri Uotila, INAR/UH
# 2022-06-30, Petteri Uotila, INAR/UH

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

cd /scratch/$PROJ/$USER
# Checkout sources

git clone --branch $nemo_version https://forge.nemo-ocean.eu/nemo/nemo.git nemo_$nemo_version
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

./makenemo -j 8 -m ${compiler}-mahti.csc.fi -r GYRE_PISCES -n MY_GYRE del_key key_top

# run the experiment
cd cfgs/MY_GYRE/EXP00

sbatch << EOF
#!/bin/bash
###
#SBATCH --job-name=nemo
#SBATCH --account=project_2000789
#SBATCH --time=00:30:00
##SBATCH --mem-per-cpu=2G
#SBATCH --nodes=1
#SBATCH --partition=test
##SBATCH --ntasks-per-node=16

module purge
module load StdEnv ${compiler}/${compiler_version} ${mpi}/${mpi_version}
module load boost/1.77.0-mpi netcdf-c/4.8.1 netcdf-fortran/4.5.3
## run my MPI executable
srun ./nemo

EOF

