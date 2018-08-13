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

COPY install_gmsh.sh /scripts/
WORKDIR /scripts
RUN ./install_gmsh.sh

CMD [ "/bin/bash" ]
