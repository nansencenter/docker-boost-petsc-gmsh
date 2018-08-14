#!/bin/sh

CFG_FILE=/root/nextsim_libs.src
echo "export GMSH_DIR=/opt/local/gmsh/3.06" >> $CFG_FILE

echo "export NETCDF_DIR=/usr/lib/x86_64-linux-gnu/" >> $CFG_FILE

echo "export PETSC_DIR=/opt/local/petsc" >> $CFG_FILE
echo "export PETSC_ARCH=arch-linux2-c-opt" >> $CFG_FILE

echo "export BOOST_INCDIR=/usr/include/boost" >> $CFG_FILE
echo "export BOOST_LIBDIR=/usr/lib/x86_64-linux-gnu" >> $CFG_FILE

echo "export OPENMPI_LIB_DIR=/usr/lib/x86_64-linux-gnu/openmpi/lib" >> $CFG_FILE
echo "export OPENMPI_INCLUDE_DIR=/usr/lib/x86_64-linux-gnu/openmpi/include" >> $CFG_FILE

echo 'export LD_LIBRARY_PATH=$BOOST_LIBDIR:$GMSH_DIR/lib' >> $CFG_FILE
