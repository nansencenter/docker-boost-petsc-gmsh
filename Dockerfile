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
RUN apt-get update && apt-get install -y \
    bison \
    flex \
    libdata-dumper-simple-perl \
    python \
    valgrind
RUN wget -nc -nv http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.3.tar.gz \
&&  tar -xzf petsc-3.9.3.tar.gz
WORKDIR petsc-3.9.3
ENV OPTIONS    -with-python \
    --with-c-support=1 \
    --with-c++-support=1 \
    --with-shared-libraries=1 \
    --with-cxx=mpicxx \
    --with-cc=mpicc \
    --with-fc=mpif90 \
    --CFLAGS='-O3' \
    --CXXFLAGS='-O3' \
    --FFLAGS='-O3' \
    --with-mpiexec=mpiexec \
    --with-blacs \
    --download-blacs=yes \
    --with-scalapack=1 \
    --download-scalapack=yes \
    --download-fblaslapack=yes \
    --with-mumps=1 \
    --download-mumps=yes \
    --with-pastix=1 \
    --download-pastix=yes \
    --with-superlu=1 \
    --download-superlu=yes \
    --with-superlu_dist=1 \
    --download-superlu_dist=yes \
    --with-ml=1 \
    --download-ml=yes \
    --with-suitesparse=1 \
    --download-suitesparse=yes \
    --with-ptscotch=1 \
    --download-ptscotch=yes \
    --with-c2html=0
RUN ./configure $OPTIONS --with-debugging=1 --prefix=/opt/local/petsc-debug
RUN make -j8 PETSC_DIR=. PETSC_ARCH=arch-linux2-c-debug all \
&&  make -j8 PETSC_DIR=. PETSC_ARCH=arch-linux2-c-debug install

FROM boost_petsc_gmsh:base as gmsh
RUN wget -nc -nv https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_3_0_6/gmsh-gmsh_3_0_6.tar.gz \
&&  tar -xzf gmsh-gmsh_3_0_6.tar.gz
WORKDIR gmsh-gmsh_3_0_6
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/local/gmsh \
    -DENABLE_BUILD_LIB=ON \
    -DENABLE_BUILD_SHARED=ON \
    -DENABLE_BUILD_DYNAMIC=ON \
    -DCMAKE_BUILD_TYPE=release \
	-DENABLE_MPI=OFF \
	-DENABLE_MUMPS=OFF \
	-DENABLE_PETSC=OFF \
	-DENABLE_OPENMP=OFF
RUN make -j8 \
&&  make install

FROM boost_petsc_gmsh:base
COPY --from=boost /opt/local/boost /opt/local/boost
COPY --from=petsc /opt/local/petsc-debug /opt/local/petsc-debug
COPY --from=gmsh /opt/local/gmsh /opt/local/gmsh
RUN echo '/opt/local/boost/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/petsc-debug/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/gmsh/lib/' >> /etc/ld.so.conf \
&&  ldconfig \
&&  ln -s /opt/local/gmsh/bin/gmsh /usr/local/bin/gmsh
COPY .nextsimrc /root/.nextsimrc

CMD [ "/bin/bash" ]
