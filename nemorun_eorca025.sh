#!/bin/bash
###
### parallel job script example
###
## name of your job
#SBATCH --job-name=eo025
#SBATCH --account=project_2000789
##SBATCH --time=24:00:00
#SBATCH --time=00:15:00
#SBATCH --nodes=3
#SBATCH --partition=medium
#SBATCH --ntasks-per-node=128

module purge
module load gcc/11.2.0 mpich/4.0.1 boost/1.77.0-mpi netcdf-c/4.8.1 netcdf-fortran/4.5.3
## run my MPI executable
srun ./nemo

