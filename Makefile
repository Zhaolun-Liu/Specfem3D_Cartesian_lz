#=====================================================================
#
#               S p e c f e m 3 D  V e r s i o n  3 . 0
#               ---------------------------------------
#
#     Main historical authors: Dimitri Komatitsch and Jeroen Tromp
#                        Princeton University, USA
#                and CNRS / University of Marseille, France
#                 (there are currently many more authors!)
# (c) Princeton University and CNRS / University of Marseille, July 2012
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#=====================================================================
#
# United States Government Sponsorship Acknowledged.
#
# Makefile.  Generated from Makefile.in by configure.
#######################################

FC = ifort
FCFLAGS = -g ${DEBUG_COUPLED_FLAG}
FC_DEFINE = -D
MPIFC = mpifort
MPILIBS = 

FLAGS_CHECK = -xHost -fpe0 -ftz  -assume byterecl -align sequence -std03 -diag-disable 6477 -implicitnone -gen-interfaces -warn all -O3 -check nobounds

FCFLAGS_f90 = -mod ./obj -I./obj -I.  -I${SETUP}

FC_MODEXT = mod
FC_MODDIR = ./obj

FCCOMPILE_CHECK = ${FC} ${FCFLAGS} $(FLAGS_CHECK) $(COND_OPENMP_FFLAGS)

MPIFCCOMPILE_CHECK = ${MPIFC} ${FCFLAGS} $(FLAGS_CHECK) $(COND_OPENMP_FFLAGS)

CC = icc
CFLAGS = -g -O2 $(CPPFLAGS)
CPPFLAGS = -I${SETUP}  -I/usr/include/scotch $(COND_MPI_CPPFLAGS)

# all linker flags
MPILIBS += -L/usr/local/fftw/intel-16.0/openmpi-1.10.2/3.3.4/lib64 -L/usr/local/cuda-8.0/lib64 -L/usr/lib64/nvidia 

#######################################
####
#### MPI
####
#######################################

MPI = yes
#MPI = no

FCLINK = $(MPIFCCOMPILE_CHECK)
#FCLINK = $(FCCOMPILE_CHECK)

COND_MPI_CPPFLAGS = -DWITH_MPI
#COND_MPI_CPPFLAGS =

# objects toggled between the parallel and serial version
COND_MPI_OBJECTS = $O/parallel.sharedmpi.o
#COND_MPI_OBJECTS = $O/serial.shared.o

MPI_INCLUDES =  -I/usr/local/openmpi/3.0.0/intel180/x86_64/include

#######################################
####
#### SCOTCH
####
#######################################

SCOTCH_BUNDLED = 1

SCOTCH_DIR = ./src/decompose_mesh/scotch_5.1.12b
SCOTCH_INCDIR = ./src/decompose_mesh/scotch_5.1.12b/include
SCOTCH_LIBDIR = ./src/decompose_mesh/scotch_5.1.12b/lib

SCOTCH_INC = -I${SCOTCH_INCDIR}
SCOTCH_LIBS = -L${SCOTCH_LIBDIR} -lscotch -lscotcherr

### added support for METIS as well, thus uncomment the line below and compile METIS if you want to use it instead of SCOTCH
#SCOTCH_LIBS = -L${SCOTCH_LIBDIR} -lscotch -lscotcherr -L./src/decompose_mesh/metis-4.0.3 -L./metis-4.0.3 -lmetis


#######################################
####
#### CUDA
#### with configure: ./configure --with-cuda=cuda5 CUDA_FLAGS=.. CUDA_LIB=.. CUDA_INC=.. MPI_INC=.. ..
####
#######################################

CUDA = yes
#CUDA = no

# CUDA version 5x and 6x and 8x
#CUDA5 = yes
CUDA5 = no

#CUDA6 = yes
CUDA6 = no

CUDA8 = yes
#CUDA8 = no

# CUDA compilation with linking
CUDA_PLUS = yes
#CUDA_PLUS = no


# default cuda libraries
# runtime library -lcudart needed, others are optional -lcuda -lcublas

CUDA_FLAGS = 
CUDA_INC =  -I${SETUP}
CUDA_LINK =  -lcudart -lstdc++

NVCC = nvcc
#NVCC = icc

# GPU architecture

# CUDA architecture / code version
# Fermi: -gencode=arch=compute_10,code=sm_10 not supported
# Tesla (default)     : -gencode=arch=compute_20,code=sm_20
# Geforce GT 650m     : -gencode=arch=compute_30,code=sm_30
# Kepler (cuda5,K20)  : -gencode=arch=compute_35,code=sm_35
# Kepler (cuda6.5,K80): -gencode=arch=compute_37,code=sm_37
# Pascal  (cuda8,P100): -gencode=arch=compute_60,code=sm_60
GENCODE_20 = -gencode=arch=compute_20,code=\"sm_20,compute_20\"
GENCODE_30 = -gencode=arch=compute_30,code=\"sm_30,compute_30\"
GENCODE_35 = -gencode=arch=compute_35,code=\"sm_35,compute_35\"
GENCODE_37 = -gencode=arch=compute_37,code=\"sm_37\"
GENCODE_60 = -gencode=arch=compute_60,code=\"sm_60\"

# CUDA version 8.x
GENCODE = $(GENCODE_60)
# CUDA version 6.5
#GENCODE = $(GENCODE_37)
# CUDA version 5.x
#GENCODE = $(GENCODE_35)
# CUDA version 4.x
#GENCODE = $(GENCODE_20)

# CUDA flags and linking
NVCC_FLAGS_BASE = $(CUDA_FLAGS) $(CUDA_INC) $(MPI_INCLUDES) $(COND_MPI_CPPFLAGS)
NVCC_FLAGS = $(NVCC_FLAGS_BASE) -dc -DCUDA $(GENCODE)
#NVCC_FLAGS = $(NVCC_FLAGS_BASE) -DCUDA -DUSE_OLDER_CUDA4_GPU $(GENCODE)

NVCCLINK_BASE = $(NVCC) $(CUDA_INC) $(MPI_INCLUDES) $(COND_MPI_CPPFLAGS) -DCUDA
NVCCLINK = $(NVCCLINK_BASE) -dlink $(GENCODE)
#NVCCLINK = $(NVCCLINK_BASE) -DUSE_OLDER_CUDA4_GPU $(GENCODE)

#NVCC_FLAGS = $(MPI_INCLUDES) $(COND_MPI_CPPFLAGS)
#NVCCLINK = $(NVCC) $(NVCC_FLAGS)


#######################################
####
#### OpenMP
#### with configure: ./configure --with-openmp FLAGS_CHECK="-openmp .." OPENMP_LIB=..
####
#######################################

#OPENMP = yes
OPENMP = no

#OPENMP_LIBS = $(OPENMP_LIB)
OPENMP_LIBS = 
#COND_OPENMP_FFLAGS = -DOPENMP_MODE
COND_OPENMP_FFLAGS =

# objects toggled between openmp and non-openmp version
##COND_OPENMP_OBJECTS = $O/older_not_maintained_compute_forces_viscoelastic_Dev_openmp.openmp.o
#COND_OPENMP_OBJECTS = 
COND_OPENMP_OBJECTS =


#######################################
####
#### ADIOS
#### with configure: ./configure --with-adios ADIOS_CONFIG=..
####
#######################################

#ADIOS = yes
ADIOS = no

ADIOS_INC = 
ADIOS_LINK = 

FCFLAGS_f90 += $(ADIOS_INC)
MPILIBS += $(ADIOS_LINK)


#######################################
####
#### directories
####
#######################################

## compilation directories
# B : build directory
B = .
# E : executables directory
E = $B/bin
# O : objects directory
O = $B/obj
# S_TOP : source file root directory
S_TOP = .
# L : libraries directory
L = $B/lib
# setup file directory
SETUP = $B/setup
# output file directory
OUTPUT = $B/OUTPUT_FILES


#######################################
####
#### targets
####
#######################################

# code subdirectories
SUBDIRS = \
	auxiliaries \
	check_mesh_quality \
	cuda \
	decompose_mesh \
	generate_databases \
	meshfem3D \
	shared \
	specfem3D \
	tomography/postprocess_sensitivity_kernels \
	tomography \
	$(EMPTY_MACRO)

# default targets for the pure Fortran version
DEFAULT = \
	xdecompose_mesh \
	xmeshfem3D \
	xgenerate_databases \
	xspecfem3D \
	$(EMPTY_MACRO)

ifeq ($(MPI),yes)
DEFAULT += $E/xdecompose_mesh_mpi
endif

default: $(DEFAULT)

all: default aux check_mesh postprocess tomography

backup:
	cp -rp src setup DATA/Par_file* Makefile bak

ifdef CLEAN
clean:
	@echo "cleaning by CLEAN"
	-rm -f $(foreach dir, $(CLEAN), $($(dir)_OBJECTS) $($(dir)_MODULES) $($(dir)_SHARED_OBJECTS) $($(dir)_TARGETS))
	-rm -f ${E}/*__genmod.*
	-rm -f ${O}/*__genmod.*
else
clean:
	@echo "cleaning all"
	-rm -f $(foreach dir, $(SUBDIRS), $($(dir)_OBJECTS) $($(dir)_MODULES) $($(dir)_TARGETS))
	-rm -f ${E}/*__genmod.*
	-rm -f ${O}/*__genmod.*
endif

realclean: clean
ifeq (${SCOTCH_BUNDLED},1)
	@echo "cleaning bundled Scotch in directory: ${SCOTCH_DIR}/src"
	$(MAKE) -C ${SCOTCH_DIR}/src realclean
endif
	-rm -rf $E/* $O/*

# unit testing
# If the first argument is "test"...
ifeq (test,$(findstring test,firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  TEST_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # turn them into do-nothing targets
  $(eval $(TEST_ARGS):;@:)
endif

tests:
	@echo "testing in directory: ${S_TOP}/tests/"
	cd ${S_TOP}/tests; ./run_all_tests.sh $(TEST_ARGS)
	@echo ""

help:
	@echo "usage: make [executable]"
	@echo ""
	@echo "supported main executables:"
	@echo "    xdecompose_mesh"
	@echo "    xmeshfem3D"
	@echo "    xgenerate_databases"
	@echo "    xspecfem3D"
	@echo ""
	@echo "defaults:"
	@echo "    xdecompose_mesh"
	@echo "    xmeshfem3D"
	@echo "    xgenerate_databases"
	@echo "    xspecfem3D"
	@echo ""
	@echo "    xcombine_surf_data"
	@echo "    xcombine_vol_data"
	@echo "    xcombine_vol_data_vtk"
	@echo "    xconvolve_source_timefunction"
	@echo "    xcreate_movie_shakemap_AVS_DX_GMT"
	@echo ""
	@echo "    xcheck_mesh_quality"
	@echo "    xconvert_skewness_to_angle"
	@echo ""
	@echo "additional executables:"
	@echo "- auxiliary executables: [make aux]"
	@echo "    xcombine_surf_data"
	@echo "    xcombine_vol_data"
	@echo "    xcombine_vol_data_vtk"
	@echo "    xconvolve_source_timefunction"
	@echo "    xcreate_movie_shakemap_AVS_DX_GMT"
	@echo ""
	@echo "- check mesh executables: [make check_mesh]"
	@echo "    xcheck_mesh_quality"
	@echo "    xconvert_skewness_to_angle"
	@echo ""
	@echo "- sensitivity kernel postprocessing tools: [make postprocess]"
	@echo "    xclip_sem"
	@echo "    xcombine_sem"
	@echo "    xsmooth_sem"
	@echo ""
	@echo "- tomography tools: [make tomography]"
	@echo "    xmodel_update"
	@echo "    xsum_kernels"
	@echo "    xsum_preconditioned_kernels"
	@echo ""
	@echo "for unit testing:"
	@echo "    tests"
	@echo ""

.PHONY: all default backup clean realclean help tests

#######################################

${SETUP}/version.fh: 
	@echo "GEN $@"
	@echo "! This file is generated by Make. Do not edit this file!" > $@
	@echo "character(len=*), parameter :: git_version = \"$$(cd ${S_TOP} && git describe --tags)\"" >> $@

#######################################

# Get dependencies and rules for building stuff
include $(patsubst %, ${S_TOP}/src/%/rules.mk, $(SUBDIRS))

#######################################

##
## Shortcuts
##

# Shortcut for: <prog>/<xprog> -> bin/<xprog>
define target_shortcut
$(patsubst $E/%, %, $(1)): $(1)
.PHONY: $(patsubst $E/%, %, $(1))
$(patsubst $E/x%, %, $(1)): $(1)
.PHONY: $(patsubst $E/x%, %, $(1))
endef

# Shortcut for: dir -> src/dir/<targets in here>
define shortcut
$(1): $($(1)_TARGETS)
.PHONY: $(1)
$$(foreach target, $$(filter $E/%,$$($(1)_TARGETS)), $$(eval $$(call target_shortcut,$$(target))))
endef

$(foreach dir, $(SUBDIRS), $(eval $(call shortcut,$(dir))))

# testing
test : tests

# Other old shortcuts
bak: backup
mesh : $E/xmeshfem3D
gen : $E/xgenerate_databases
spec : $E/xspecfem3D
dec : $E/xdecompose_mesh

.PHONY: bak mesh gen spec dec

