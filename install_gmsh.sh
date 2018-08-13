#!/bin/sh

wget https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_3_0_6/gmsh-gmsh_3_0_6.tar.gz
tar -xzf gmsh-gmsh_3_0_6.tar.gz
cd gmsh-gmsh_3_0_6

mkdir build
cd build

cmake .. \
        -DCMAKE_CXX_COMPILER=`which g++` \
        -DCMAKE_C_COMPILER=`which gcc` \
        -DCMAKE_INSTALL_PREFIX=/opt/local/gmsh/3.06 \
        -DCMAKE_BUILD_TYPE=release \
        -DENABLE_BUILD_LIB=ON \
        -DENABLE_BUILD_SHARED=ON \
        -DENABLE_BUILD_DYNAMIC=ON \
        -DENABLE_MPI=OFF \
        -DENABLE_MUMPS=OFF \
        -DENABLE_PETSC=OFF \
        -DENABLE_OPENMP=ON \
        -DCMAKE_PREFIX_PATH:path=/usr/bin \
        -DBLAS_LAPACK_LIBRARIES:string="-L/usr/lib/x86_64-linux-gnu/ -lsci_gnu_mp"
