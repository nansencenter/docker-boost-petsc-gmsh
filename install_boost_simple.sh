#!/bin/sh
wget -nc -nv https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
tar -xzf boost_1_68_0.tar.gz
cd boost_1_68_0
./bootstrap.sh --prefix=/usr/local --with-libraries=program_options,filesystem,system,mpi,serialization,date_time
echo "using mpi ;" >> project-config.jam
./b2 -j8
./b2 install
