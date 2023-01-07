#!/bin/bash
###
### parallel job script example
###
## name of your job
#SBATCH --job-name=eo025
#SBATCH --account=project_2004927
#SBATCH --time=12:00:00
#SBATCH --nodes=4
#SBATCH --partition=medium
#SBATCH --ntasks-per-node=128

module purge
module load gcc/11.2.0 openmpi/4.1.2 boost/1.77.0-mpi netcdf-c/4.8.1 netcdf-fortran/4.5.3 hdf5/1.10.7-mpi
## run my MPI executable
#srun -n194 --multi-prog master_eorca025.cfg
srun -n512 --multi-prog master_eorca025.cfg

