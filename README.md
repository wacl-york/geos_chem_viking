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

First is your home directory, where you will be after starting a session - `/users/USERNAME`. This directory is not mounted from a high-performance filestore, and as such _*should not*_ be used as the location for anything that you want to use with a high-performance job. Your quota for this directory is 50GB, and there is no backup of its contents.

Second is your scratch directory - `/users/USERNAME/scratch`. This directory is mounted from a high-performance filestore, and you _*should*_ use this directory for all of your high-performance work. Your quota for this directory is 3TB, and there is no backup of its contents.

## Viking Modules
Viking uses an updated version of the Environment Modules system that is on YARCC. One of the advantages of the updates is that it is much more straightforward to manage module dependencies. For example:

```bash
module load data/netCDF-Fortran/4.4.4-intel-2018b
```

will load NetCDF FORTRAN 4.4.4 and all of its dependencies, compiled with the 2018 edition of the Intel compilers. Another nice feature is the ability to search for modules using the `module spider` command.

## Compiling GEOS-Chem on Viking
There are a few simple steps to go through in order to compile GEOS-Chem Classic with either the 2018 Intel compilers or GNU Compiler Collection v7.3.0.

Firstly, you should clone this repository into either your Viking home directory or your Viking scratch directory, using the following command:

```bash
git clone https://github.com/wacl-york/geos_chem_viking.git
```

This allows you to easily set your run directories up with fresh copies of the environment and run scripts, and also allows you to keep the scripts up to date using `git pull`.

You should then create both a GEOS-Chem Classic source code directory and a GEOS-Chem Unit Tester directory somewhere in your scratch directory, as you would when building the model anywhere else. Create your run directory using the unit tester and modify the files inside of it (remembering to set your `CODE_DIR` in the `Makefile`) as usual, and you are ready to compile. The location of the GEOS-Chem input data on Viking is:

```bash
/mnt/lustre/groups/chem-acm-2018/earth0_data/GEOS
```

with `ExtData` located at:

```bash
/mnt/lustre/groups/chem-acm-2018/earth0_data/GEOS/ExtData
```

Once you have a run directory, you should copy the `setup_geos_environment.sh` script from this repository into your run directory. You only need to change anything in this file if you are doing something novel, as it is set up to configure your environment for GEOS-Chem Classic using the Intel toolchain. Activate the GEOS-Chem Classic environment as follows:

```bash
source setup_geos_environment.sh
```

At this point you can build the model. Remember to set any options that you want to compile with!

## Running GEOS-Chem on Viking
All you need to run GEOS-Chem on Viking is a Slurm run script. Slurm on Viking is the equivalent of PBS on earth0 and SGE on YARCC, a workload manager. Slurm works similarly to the others in some ways, and differently in others. If you are interested in reading about Slurm in detail, you can find the manual [here](https://slurm.schedmd.com/).

Copy the `geos_chem_classic.sbatch` script from this repository into your run directory. This script already contains a simple set of Slurm directives to get the model running with good performance. You may wish to change the following directives: time (the script is set up for a one month run), output (the location of the job log output), job-name, and mail-user (your email address). All of the Slurm directives are documented in the run script, and if you have any problems/queries about its contents you can either consult the Slurm manual or contact me at <killian.murphy@york.ac.uk>.

Once you are happy with the contents of the run script, you can submit the job to Slurm with the following command:

```bash
sbatch geos_chem_classic.sbatch
```

You should now have a model run queued on Viking!

## Support & Troubleshooting
You can contact me at <killian.murphy@york.ac.uk> in the event of any issues with your jobs, or if you would like to go through the initial setup and first run submission on Viking.
