#!/bin/sh

echo "export NETCDF_DIR=/usr/lib/x86_64-linux-gnu/" >> $NEXTSIM_SRC_FILE
echo "export OPENMPI_LIB_DIR=/usr/lib/x86_64-linux-gnu/openmpi/lib" >> $NEXTSIM_SRC_FILE
echo "export OPENMPI_INCLUDE_DIR=/usr/lib/x86_64-linux-gnu/openmpi/include" >> $NEXTSIM_SRC_FILE
echo 'export LD_LIBRARY_PATH=$BOOST_LIBDIR:$GMSH_DIR/lib' >> $NEXTSIM_SRC_FILE

