#!/bin/sh
PREFIX=/usr/local/petsc
mkdir -p $PREFIX

cd $NEXTSIM_ROOT_DIR

wget -nv -nc -O pets.tar.gz $PETSC_URL
tar -xzf petsc.tar.gz
cd petsc

./configure \
	-with-python \
	--with-cxx=mpicxx \
	--with-cc=mpicc \
	--with-fc=mpif90 \
	--with-mpiexec=mpiexec \
	--with-debugging=0 \
	--with-c-support=1 \
	--with-c++-support=1 \
	--with-shared-libraries=1 \
	--with-blacs \
	--download-blacs=yes \
	--with-parmetis=1 \
	--download-parmetis=yes \
	--with-scalapack=1 \
	--download-scalapack=yes \
	--with-mumps=1 \
	--download-mumps=yes \
	--with-suitesparse=1 \
	--download-suitesparse=yes \
	--with-c2html=0 \
	--with-metis=1 \
	--download-metis=yes \
	--prefix=$PREFIX

make -j8 PETSC_DIR=$NEXTSIM_ROOT_DIR/petsc PETSC_ARCH=arch-linux2-c-opt all
make -j8 PETSC_DIR=$NEXTSIM_ROOT_DIR/petsc PETSC_ARCH=arch-linux2-c-opt install

echo "export PETSC_DIR=$PREFIX" >> $NEXTSIM_SRC_FILE
echo "export PETSC_ARCH=arch-linux2-c-opt" >> $NEXTSIM_SRC_FILE

cd $NEXTSIM_ROOT_DIR
rm -rf petsc

