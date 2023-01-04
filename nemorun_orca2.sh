#!/bin/bash
###
### parallel NEMO job script example
###
## name of your job
#SBATCH --job-name=nemo
#SBATCH --account=project_2004927
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --partition=test
#SBATCH --ntasks-per-node=3


module purge
module load gcc/11.2.0 mpich/4.0.1 boost/1.77.0-mpi netcdf-c/4.8.1 netcdf-fortran/4.5.3
## run my MPI executable
#srun ./nemo
srun --multi-prog master.cfg
