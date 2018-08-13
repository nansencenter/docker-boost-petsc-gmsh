#!/bin/sh
cd /usr/bin
ln -sf gcc-5 gcc
ln -sf gcc-ar-5 gcc-ar

cd /scripts
wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.3.tar.gz
tar -xzvf petsc-3.9.3.tar.gz
#cd petsc-3.9.3
#pconfigure.sh
