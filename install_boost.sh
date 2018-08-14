#!/bin/sh
export BOOST_PREFIX=/opt/boost

wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
tar -xzf boost_1_68_0.tar.gz
cd boost_1_68_0

mkdir $BOOST_PREFIX

./bootstrap.sh \
	--prefix=$BOOST_PREFIX \
	--without-libraries=python \
	cxxflags="-arch x86_64" \
	address-model=32_64 \
	threading=single,multi \
	macos-version=10.10

echo "using mpi ;" >> project-config.jam

./b2 -j8 \
	 --layout=tagged \
	 --debug-configuration \
	 --prefix=$BOOST_PREFIX \
	 toolset=darwin \
	 variant=release \
	 threading=single,multi \
	 link=shared,static \
	 cxxflags="-std=c++11"

./b2 install --prefix=$BOOST_PREFIX
