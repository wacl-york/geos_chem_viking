#!/usr/bin/env bash
################################################################################
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=04:00:00
#SBATCH --output=logs/GEOSChem_Classic_v12.1.1_intel.log
#SBATCH --partition=nodes
#SBATCH --job-name=GEOSChem_Classic_v12.1.1_intel
#SBATCH --mail-user=killian.murphy@york.ac.uk
#SBATCH --mail-type=ALL
################################################################################
cd "${SLURM_SUBMIT_DIR}"
source setup_geos_environment_intel.sh
./geos.mp
