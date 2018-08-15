#!/bin/sh
PREFIX=/opt/local/boost
mkdir -p $PREFIX

cd $NEXTSIM_ROOT_DIR
wget -nc -nv -O boost.tar.gz $BOOST_URL
tar -xzf boost.tar.gz
cd boost
./bootstrap.sh --prefix=$PREFIX --with-libraries=program_options,filesystem,system,mpi,serialization,date_time
echo "using mpi ;" >> project-config.jam
./b2 -j8
./b2 install

echo "export BOOST_INCDIR=$PREFIX/include" >> $NEXTSIM_SRC_FILE
echo "export BOOST_LIBDIR=$PREFIX/lib" >> $NEXTSIM_SRC_FILE

cd $NEXTSIM_ROOT_DIR
rm boost
