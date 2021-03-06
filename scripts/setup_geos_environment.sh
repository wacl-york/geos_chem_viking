################################################################################
# OPTIONS
#-------------------------------------------------------------------------------
# Set the edition of GEOS-Chem to be run (CLASSIC or GCHP) and the compiler
# toolchain to be used (GNU or INTEL).
################################################################################
TOOLCHAIN="INTEL"

if ! [[ ${TOOLCHAIN} == "GNU" || ${TOOLCHAIN} == "INTEL" ]]; then
  echo "YOU MUST SPECIFY EITHER GNU OR INTEL FOR TOOLCHAIN - EXITING"
  return
fi

echo "SETTING UP ENVIRONMENT USING ${TOOLCHAIN} TOOLCHAIN"
################################################################################
# ENVIRONMENT MODULES
#-------------------------------------------------------------------------------
# These modules MUST be loaded in the below order before compiling and running
# GEOS-Chem.
#
# The netCDF-Fortran module loads all of its dependencies automatically.
################################################################################
module purge
if [[ ${TOOLCHAIN} == "GNU" ]]; then
  module load data/netCDF-Fortran/4.5.3-gompi-2021a
else
  module load data/netCDF-Fortran/4.5.3-iimpi-2021a
fi
module load tools/git/2.32.0-GCCcore-10.3.0-nodocs
module load lang/flex/2.6.4-GCCcore-10.3.0
module load devel/CMake/3.20.1-GCCcore-10.3.0
################################################################################
# COMPILER VARIABLES
#-------------------------------------------------------------------------------
# The toolchain-specific NetCDF-Fortran module must be loaded in the above order
# before setting these variables.
################################################################################
if [[ ${TOOLCHAIN} == "GNU" ]]; then
  export CC="gcc"
  export CXX="g++"
  export FC="gfortran"
else
  export CC="icc"
  export CXX="icpc"
  export FC="ifort"
fi

export COMPILER="${FC}"
################################################################################
# HDF5 LIBRARY VARIABLES
#-------------------------------------------------------------------------------
# This disables file locking, which is unsupported on the Lustre filesystem.
################################################################################
export HDF5_USE_FILE_LOCKING="FALSE"
################################################################################
# NETCDF LIBRARY VARIABLES
#-------------------------------------------------------------------------------
# The toolchain-specific NetCDF-Fortran module must be loaded in the above order
# before setting these variables.
################################################################################
GC_C_BASE="$(dirname $(dirname $(command -v nc-config)))"
GC_F_BASE="$(dirname $(dirname $(command -v nf-config)))"
export GC_BIN="$GC_C_BASE/bin"
export GC_INCLUDE="$GC_C_BASE/include"
export GC_LIB="$GC_C_BASE/lib"
export GC_F_BIN="$GC_F_BASE/bin"
export GC_F_INCLUDE="$GC_F_BASE/include"
export GC_F_LIB="$GC_F_BASE/lib"
################################################################################
# OPENMP VARIABLES
#-------------------------------------------------------------------------------
# These must be set before running GEOS-Chem Classic.
################################################################################
export OMP_STACKSIZE=500m
################################################################################
# USER LIMIT VARIABLES
#-------------------------------------------------------------------------------
#
################################################################################
ulimit -s unlimited
