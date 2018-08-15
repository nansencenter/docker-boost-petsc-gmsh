FROM ubuntu:latest as boost
ENV NEXTSIMDIR /nextsim
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libopenmpi-dev \
    wget \
&& rm -rf /var/lib/apt/lists/*
COPY install_boost.sh $NEXTSIMDIR/
RUN $NEXTSIMDIR/install_boost.sh


FROM ubuntu:latest as petsc
ENV NEXTSIMDIR /nextsim
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    gfortran \
    make \
    python \
    libopenmpi-dev \
    wget \
&& rm -rf /var/lib/apt/lists/*
COPY install_petsc.sh $NEXTSIMDIR/
RUN $NEXTSIMDIR/install_petsc.sh


#FROM ubuntu:latest as gmsh
#ENV GMSH_URL https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_2_16_0/gmsh-gmsh_2_16_0.tar.gz
#RUN ./install_gmsh.sh
#RUN cat install_nextsim.src >> $NEXTSIM_SRC_FILE
#RUN ./install_petsc.sh


CMD [ "/bin/bash" ]
