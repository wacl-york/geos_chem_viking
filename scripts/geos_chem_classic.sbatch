#!/usr/bin/env bash
################################################################################
# GEOS-Chem Classic
#===============================================================================
# This file describes a simple GEOS-Chem job on Viking. Many of the SBATCH
# directives can be left as they are; some will require modification as
# documented.
################################################################################

#===============================================================================
# BEGIN SLURM DIRECTIVES
#===============================================================================
#-------------------------------------------------------------------------------
# ntasks - The number of 'tasks' you wish to run. In our case, we wish to run
#          a single instance of GEOS-Chem Classic, so this can be left at '1'.
#-------------------------------------------------------------------------------
#SBATCH --ntasks=1

#-------------------------------------------------------------------------------
# cpus-per-task - The number of cores you wish to use for your task. From
#                 benchmarking and Viking architecture, 20 cores is a sensible
#                 number of cores to guarantee good model performance.
#-------------------------------------------------------------------------------
#SBATCH --cpus-per-task=20

#-------------------------------------------------------------------------------
# mem-per-cpu - The amount of memory to be allocated per core used for your
#               task. Viking is configured to allow no more than 4.8GB per core
#               when using this option, and 2GB per core is more than enough
#               for standard GEOS-Chem runs.
#-------------------------------------------------------------------------------
#SBATCH --mem-per-cpu=2GB

#-------------------------------------------------------------------------------
# time - Maximum wallclock time to be consumed by your job, in the format
#        DAYS-HH:MM:SS. For reference, a month of GEOSFP, 4x5, tropchem takes
#        roughly 01:30:00.
#-------------------------------------------------------------------------------
#SBATCH --time=02:00:00

#-------------------------------------------------------------------------------
# output - The file for the combined standard output and standard error log.
#          This can be an absolute path, or a relative path. The example below
#          uses %x, a special variable containing the name of the job set in the
#          job-name directive.
#
#          Any directory into which logs are being written must exist before
#          running your job.
#-------------------------------------------------------------------------------
#SBATCH --output=%x.log

#-------------------------------------------------------------------------------
# partition - The SLURM partition to use for your job. SLURM partitions are
#             analogous to queues. The 'nodes' partition is the regular Viking
#             nodes partition - all nodes in this partition can support a GEOS-
#             Chem classic run. 
#-------------------------------------------------------------------------------
#SBATCH --partition=nodes

#-------------------------------------------------------------------------------
# job-name - The name of your job. This will set the contents of special
#            variables set and used by SLURM, e.g. the %x variable used in the
#            output example above.
#-------------------------------------------------------------------------------
#SBATCH --job-name=GEOS-Chem_Classic

#-------------------------------------------------------------------------------
# mail-user - The email address to which you wish to receive notifcations about
#             your job.
#-------------------------------------------------------------------------------
#SBATCH --mail-user=EMAIL.ADDRESS@york.ac.uk

#-------------------------------------------------------------------------------
# mail-type - The types of notifications you wish to receive about your job. ALL
#             gives you notifications when your job starts, ends, fails, is
#             requeued, and some special notifications if you are using the
#             burst buffer (we are not).
#-------------------------------------------------------------------------------
#SBATCH --mail-type=ALL

#-------------------------------------------------------------------------------
# account - The Viking project account to associate this job with. Evans Group
#           general project code is 'chem-acm-2018'.
#-------------------------------------------------------------------------------
#SBATCH --account=chem-acm-2018
#===============================================================================
# END SLURM DIRECTIVES
#===============================================================================

# CHANGE TO GEOS-Chem run directory, assuming job was submitted from there:
cd "${SLURM_SUBMIT_DIR}" || exit 1

# Set OpenMP thread count to number of cores requested for job:
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"

# Set up GEOS-Chem environment from environment script:
if ! [[ -f "setup_geos_environment.sh" ]]; then
  echo "ERROR: UNABLE TO SET UP GEOS-Chem ENVIRONMENT FROM SETUP SCRIPT"
  echo "ERROR: PLEASE CONFIRM THAT setup_environment.sh EXISTS IN RUN DIRECTORY"
  exit 1
fi

source setup_geos_environment.sh

# Run GEOS-Chem:
srun geos.mp
