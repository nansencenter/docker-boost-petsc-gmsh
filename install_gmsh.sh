#!/bin/sh
PREFIX=/opt/local/gmsh
mkdir -p $PREFIX

cd $NEXTSIM_ROOT_DIR
wget -nv -nc -O gmsh.tgz $GMSH_URL
mkdir gmsh && tar -xzf gmsh.tgz -C gmsh --strip-components=1
cd gmsh

mkdir build
cd build

cmake .. \
        -DCMAKE_CXX_COMPILER=`which g++` \
        -DCMAKE_C_COMPILER=`which gcc` \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_BUILD_TYPE=release \
        -DENABLE_BUILD_LIB=ON \
        -DENABLE_BUILD_SHARED=ON \
        -DENABLE_BUILD_DYNAMIC=ON \
        -DENABLE_MPI=ON \
        -DENABLE_MUMPS=ON \
        -DENABLE_PETSC=ON \
        -DENABLE_OPENMP=ON

make -j8 install

echo "export GMSH_DIR=$PREFIX" >> $NEXTSIM_SRC_FILE

cd $NEXTSIM_ROOT_DIR
rm -rf gmsh
