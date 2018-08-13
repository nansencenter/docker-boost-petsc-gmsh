FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    cmake \
    libblas-dev \
    liblapack-dev \
    libopenmpi-dev \
    software-properties-common \
    python \
    valgrind \
    wget


RUN add-apt-repository ppa:mhier/libboost-latest && apt-get update && apt-get install -y \
    libboost1.67-dev

RUN add-apt-repository ppa:jonathonf/gcc && apt-get update && apt-get install -y \
    g++ \
    gcc \
    gfortran

COPY install_petsc.sh /scripts/
WORKDIR /scripts
RUN ./install_petsc.sh

##TODO: move to install_petsc.sh
WORKDIR /scripts/petsc-3.9.3
RUN make PETSC_DIR=/scripts/petsc-3.9.3 PETSC_ARCH=arch-linux2-c-opt all
RUN make PETSC_DIR=/scripts/petsc-3.9.3 PETSC_ARCH=arch-linux2-c-opt install

COPY install_gmsh.sh /scripts/
WORKDIR /scripts
RUN ./install_gmsh.sh

##TODO: move to install_gmsh.sh
WORKDIR /scripts/gmsh-gmsh_3_0_6/build
RUN make install


CMD [ "/bin/bash" ]
