FROM ubuntu:bionic as base
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    gcc \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libopenmpi-dev \
    make \
    wget \
&& rm -rf /var/lib/apt/lists/*

FROM boost_petsc_gmsh:base as boost
RUN wget -nc -nv https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz \
&& tar -xzf boost_1_68_0.tar.gz
WORKDIR boost_1_68_0
RUN ./bootstrap.sh \
    --prefix=/opt/local/boost \
    --with-libraries=program_options,filesystem,system,mpi,serialization,date_time \
&& echo "using mpi ;" >> project-config.jam \
&& ./b2 -j8 \
&& ./b2 install

FROM boost_petsc_gmsh:base as petsc
RUN apt-get update && apt-get install -y python valgrind
RUN wget -nc -nv http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.3.tar.gz \
&&  tar -xzf petsc-3.9.3.tar.gz
WORKDIR petsc-3.9.3
RUN ./configure \
	-with-python \
	--with-cxx=mpicxx \
	--with-cc=mpicc \
	--with-fc=mpif90 \
	--with-mpiexec=mpiexec \
	--with-debugging=yes \
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
	--prefix=/opt/local/petsc
RUN make -j8 PETSC_DIR=./ PETSC_ARCH=arch-linux2-c-opt all \
&&  make -j8 PETSC_DIR=./ PETSC_ARCH=arch-linux2-c-opt install

FROM boost_petsc_gmsh:base as gmsh
RUN wget -nc -nv https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_2_16_0/gmsh-gmsh_2_16_0.tar.gz \
&&  tar -xzf gmsh-gmsh_2_16_0.tar.gz
WORKDIR gmsh-gmsh_2_16_0
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/local/gmsh \
    -DENABLE_BUILD_LIB=ON \
    -DENABLE_BUILD_SHARED=ON \
    -DENABLE_BUILD_DYNAMIC=ON \
    -DCMAKE_BUILD_TYPE=release
RUN make -j8 \
&&  make install

FROM boost_petsc_gmsh:base
COPY nextsim.src /nextsim/nextsim.src
COPY --from=boost /opt/local/boost /opt/local/boost
COPY --from=petsc /opt/local/petsc /opt/local/petsc
COPY --from=gmsh /opt/local/gmsh /opt/local/gmsh
RUN echo '/opt/local/boost/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/petsc/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/gmsh/lib/' >> /etc/ld.so.conf \
&& ldconfig
WORKDIR /nextsim

CMD [ "/bin/bash" ]
