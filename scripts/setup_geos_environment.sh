################################################################################
# OPTIONS
#-------------------------------------------------------------------------------
# Set the edition of GEOS-Chem to be run (CLASSIC or GCHP) and the compiler
# toolchain to be used (GNU or INTEL).
################################################################################
EDITION="CLASSIS"
TOOLCHAIN="GNU"

if ! [[ ${EDITION} == "CLASSIC" || ${EDITION} == "GCHP" ]]; then
  echo "YOU MUST SPECIFY EITHER CLASSIC OR GCHP FOR EDITION - EXITING"
  exit 1
fi

if ! [[ ${TOOLCHAIN} == "GNU" || ${TOOLCHAIN} == "INTEL" ]]; then
  echo "YOU MUST SPECIFY EITHER GNU OR INTEL FOR TOOLCHAIN - EXITING"
  exit 1
fi

echo "SETTING UP ENVIRONMENT FOR ${EDITION} USING ${TOOLCHAIN} TOOLCHAIN"
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
  module load data/netCDF-Fortran/4.4.4-foss-2018b
else
  module load data/netCDF-Fortran/4.4.4-intel-2018b
fi
module load tools/git
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

if [[ ${EDITION} == "GCHP" ]]; then
  export OMPI_CC="${CC}"
  export OMPI_CXX="${CXX}"
  export OMPI_FC="${FC}"
fi
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
if [[ ${EDITION} == "CLASSIC" ]]; then
  export OMP_STACKSIZE=500m
fi
################################################################################
# USER LIMIT VARIABLES
#-------------------------------------------------------------------------------
#
################################################################################
if [[ ${EDITION} == "CLASSIC" ]]; then
  ulimit -s unlimited
else
  ulimit -c unlimited
  ulimit -l unlimited
  ulimit -u 50000
  ulimit -v unlimited
fi
################################################################################
# ESMF VARIABLES
#-------------------------------------------------------------------------------
#
################################################################################
if [[ ${EDITION} == "GCHP" ]]; then
  export ESMF_BOPT="O"
  export ESMF_COMPILER="${FC}"
  export ESMF_COMM="openmpi"
  export MPI_ROOT="$(dirname $(dirname $(command -v mpicc)))"
fi
