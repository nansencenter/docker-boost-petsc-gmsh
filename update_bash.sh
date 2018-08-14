#!/bin/sh

echo "export GMSH_DIR=/opt/local/gmsh/3.06" >> /root/.bashrc

echo "export NETCDF_DIR=/usr/lib/x86_64-linux-gnu/" >> /root/.bashrc

echo "export PETSC_DIR=/opt/local/petsc" >> /root/.bashrc
echo "export PETSC_ARCH=arch-linux2-c-opt" >> /root/.bashrc

echo "export BOOST_INCDIR=/usr/include/boost" >> /root/.bashrc
echo "export BOOST_LIBDIR=/usr/lib/x86_64-linux-gnu" >> /root/.bashrc

echo "export OPENMPI_LIB_DIR=/usr/lib/x86_64-linux-gnu" >> /root/.bashrc
echo "export OPENMPI_INCLUDE_DIR=/usr/lib/openmpi/include" >> /root/.bashrc

echo 'export LD_LIBRARY_PATH=$BOOST_LIBDIR:$GMSH_DIR/lib' >> /root/.bashrc
