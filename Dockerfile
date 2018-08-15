FROM ubuntu:latest

ENV GMSH_URL https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_2_16_0/gmsh-gmsh_2_16_0.tar.gz
ENV PETSC_URL http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.3.tar.gz
ENV BOOST_URL https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
ENV NEXTSIM_ROOT_DIR /nextsim
ENV NEXTSIM_SRC_FILE $NEXTSIM_ROOT_DIR/nextsim.src

RUN apt-get update && apt-get install -y \
    cmake \
    libhdf5-dev \
    libhdf5-openmpi-dev \
    libblas-dev \
    liblapack-dev \
    libnetcdf-dev \
    libnetcdf-c++4-dev \
    libopenmpi-dev \
    software-properties-common \
    ssh \
    python \
    valgrind \
    vim \
    wget \
&& rm -rf /var/lib/apt/lists/*

COPY * $NEXTSIM_ROOT_DIR/

WORKDIR $NEXTSIM_ROOT_DIR
RUN ./install_boost.sh
RUN ./install_petsc.sh
RUN ./install_gmsh.sh
RUN cat nextsim.src.template >> $NEXTSIM_SRC_FILE

CMD [ "/bin/bash" ]
