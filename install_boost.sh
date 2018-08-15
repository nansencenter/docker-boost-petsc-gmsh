#!/bin/sh
PREFIX=/opt/local/boost
mkdir -p $PREFIX

cd $NEXTSIMDIR
wget -nc -nv -O boost.tgz https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
mkdir boost
tar -xzf boost.tgz -C boost --strip-components=1
cd boost
./bootstrap.sh --prefix=$PREFIX --with-libraries=program_options,filesystem,system,mpi,serialization,date_time
echo "using mpi ;" >> project-config.jam
./b2 -j8
./b2 install

echo "export BOOST_INCDIR=$PREFIX/include" >> $NEXTSIMDIR/nextsim.src
echo "export BOOST_LIBDIR=$PREFIX/lib" >> $NEXTSIMDIR/nextsim.src

cd $NEXTSIMDIR
rm -rf boost boost.tgz
