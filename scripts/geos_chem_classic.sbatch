#!/usr/bin/env bash
################################################################################
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=04:00:00
#SBATCH --output=logs/GEOSChem_Classic_v12.1.1.log
#SBATCH --partition=nodes
#SBATCH --job-name=GEOSChem_Classic_v12.1.1
#SBATCH --mail-user=killian.murphy@york.ac.uk
#SBATCH --mail-type=ALL
################################################################################
cd "${SLURM_SUBMIT_DIR}"
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
source setup_geos_environment_intel.sh
srun geos.mp
