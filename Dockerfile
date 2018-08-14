FROM ubuntu:latest

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
    python \
    valgrind \
    wget

RUN add-apt-repository ppa:jonathonf/gcc && apt-get update && apt-get install -y \
    g++ \
    gcc \
    gfortran

COPY install_boost_simple.sh /scripts/
WORKDIR /scripts
RUN ./install_boost_simple.sh

COPY install_petsc.sh /scripts/
WORKDIR /scripts
RUN ./install_petsc.sh

COPY install_gmsh.sh /scripts/
WORKDIR /scripts
RUN ./install_gmsh.sh

COPY update_bash.sh /scripts/
WORKDIR /scripts
RUN ./update_bash.sh

CMD [ "/bin/bash" ]
