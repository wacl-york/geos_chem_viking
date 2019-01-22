# GEOS-Chem Classic on Viking
This repository contains a boilerplate job script and environment setup script for submitting GEOS-Chem Classic runs to Viking, the University of York's HPC facility. The scripts can be found in the `scripts` directory of this repository.

## Accessing Viking
There is a two stage process for accessing Viking. PI's should apply for a Viking project account, and individual users should apply for access using a specific project account. The full details of this two-stage application process can be found [here](https://wiki.york.ac.uk/display/RHPC/VK1%29+How+to+access+Viking).

For Evans Group users, a project code already exists - *chem-acm-2018*. You can skip straight to the individual user application form, which can be found [here](https://goo.gl/forms/0Uhl5sIOhFlYtZc63). Once your Viking account creation has been confirmed, you can start a session on Viking using `ssh`:

```bash
ssh USERNAME@viking.york.ac.uk
```

## Viking Filesystem
There are two important directories to consider when working on Viking.

First is your home directory, where you will be after starting a session - `/users/USERNAME`. This directory is not mounted from a high-performance filestore, and as such *should not* be used as the location for anything that you want to use with a high-performance job. Your quota for this directory is 50GB, and there is no backup of its contents.

Second is your scratch directory - `/users/USERNAME/scratch`. This directory is mounted from a high-performance filestore, and you *should* use this directory for all of your high-performance work. Your quota for this directory is 3TB, and there is no backup of its contents.

## Viking Modules
Viking uses an updated version of the Environment Modules system that is on YARCC. One of the advantages of the updates is that it is much more straightforward to manage module dependencies. For example:

```bash
module load data/netCDF-Fortran/4.4.4-intel-2018b
```

will load NetCDF Fortran 4.4.4 and all of its dependencies, compiled with the 2018 edition of the Intel compilers. Another nice feature is the ability to search for modules using the `module spider` command.

## Compiling GEOS-Chem on YARCC
There are a few simple steps to go through in order to compile GEOS-Chem Classic with either the 2018 Intel compilers or GNU Compiler Collection v7.3.0.

Firstly, you should clone this repository into either your Viking home directory or your Viking scratch directory, using the following command:

```bash
git clone https://github.com/wacl-york/geos_chem_viking.git
```
