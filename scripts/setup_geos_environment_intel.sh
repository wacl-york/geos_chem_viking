################################################################################
# ENVIRONMENT MODULES
#-------------------------------------------------------------------------------
# These modules MUST be loaded in the below order before compiling and running
# GEOS-Chem.
#
# The netCDF-Fortran module loads all of its dependencies automatically.
################################################################################
module load data/netCDF-Fortran/4.4.4-intel-2018b
################################################################################
# COMPILER VARIABLES
#-------------------------------------------------------------------------------
# The modules:
#        - data/netCDF-Fortran/4.4.4-intel-2018b
# must be loaded in the above order before setting these variables.
################################################################################
export CC=icc
export CXX=icpc
export FC=ifort
export COMPILER=$FC
################################################################################
# HDF5 LIBRARY VARIABLES
#-------------------------------------------------------------------------------
# This disables file locking, which is unsupported on the Lustre filesystem.
################################################################################
export HDF5_USE_FILE_LOCKING=FALSE
################################################################################
# NETCDF LIBRARY VARIABLES
#-------------------------------------------------------------------------------
# The modules:
#        - data/netCDF-Fortran/4.4.4-intel-2018b
# must be loaded in the above order before setting these variables.
################################################################################
GC_C_BASE="$(dirname $(dirname $(which nc-config)))"
GC_F_BASE="$(dirname $(dirname $(which nf-config)))"

echo "GC_C_BASE SET TO ${GC_C_BASE}"
echo "GC_F_BASE SET TO ${GC_F_BASE}"

export GC_BIN="$GC_C_BASE/bin"
export GC_INCLUDE="$GC_C_BASE/include"
export GC_LIB="$GC_C_BASE/lib"
export GC_F_BIN="$GC_F_BASE/bin"
export GC_F_INCLUDE="$GC_F_BASE/include"
export GC_F_LIB="$GC_F_BASE/lib"
################################################################################
# OPENMP VARIABLES
#-------------------------------------------------------------------------------
# These must be set before running GEOS-Chem.
################################################################################
export OMP_STACKSIZE=500m
################################################################################
# USER LIMIT VARIABLES
#-------------------------------------------------------------------------------
#
################################################################################
ulimit -s unlimited
