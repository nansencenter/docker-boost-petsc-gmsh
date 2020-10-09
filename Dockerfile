FROM ubuntu:bionic as builder
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


# new boost: https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz
FROM builder as boost
RUN wget -nc -nv https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz \
&& tar -xzf boost_1_72_0.tar.gz
WORKDIR boost_1_72_0
RUN ./bootstrap.sh \
    --prefix=/opt/local/boost \
    --with-libraries=program_options,filesystem,system,mpi,serialization,date_time \
&& echo "using mpi ;" >> project-config.jam \
&& ./b2 -j8 \
&& ./b2 install


# new pets https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.4.tar.gz
FROM builder as petsc
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
RUN ./configure $OPTIONS --with-debugging=0 --prefix=/opt/local/petsc
RUN make -j8 PETSC_DIR=. PETSC_ARCH=arch-linux2-c-opt all \
&&  make -j8 PETSC_DIR=. PETSC_ARCH=arch-linux2-c-opt install

# new gmsh https://gitlab.onelab.info/gmsh/gmsh/-/archive/gmsh_4_6_0/gmsh-gmsh_4_6_0.tar.gz

FROM builder as gmsh
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

# prepare conda package for production image
FROM continuumio/miniconda3 as conda
COPY environment_pro.yml /tmp/environment_pro.yml
RUN conda env create -f /tmp/environment_pro.yml
RUN conda install conda-pack && \
    conda-pack -n environment -o /tmp/env.tar && \
    mkdir /venv && tar -C /venv -xf /tmp/env.tar && \
    /venv/bin/conda-unpack

# base image for both production and development
# TODO: maybe move ssh, valgrind, bc, git to development
FROM ubuntu:bionic as base
RUN apt-get update  --fix-missing && apt-get install -y \
    libblas-dev \
    liblapack-dev \
    libopenmpi-dev \
    libnetcdf-dev \
    libnetcdf-c++4-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
COPY --from=boost /opt/local/boost /opt/local/boost
COPY --from=petsc /opt/local/petsc /opt/local/petsc
COPY --from=gmsh /opt/local/gmsh /opt/local/gmsh
RUN echo '/opt/local/boost/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/petsc/lib/' >> /etc/ld.so.conf \
&&  echo '/opt/local/gmsh/lib/' >> /etc/ld.so.conf \
&&  ldconfig \
&&  ln -s /opt/local/gmsh/bin/gmsh /usr/local/bin/gmsh
ENV OPENMPI_INCLUDE_DIR=/usr/lib/x86_64-linux-gnu/openmpi/include
ENV OPENMPI_LIB_DIR=/usr/lib/x86_64-linux-gnu/openmpi/lib
ENV BOOST_INCDIR=/opt/local/boost/include
ENV BOOST_LIBDIR=/opt/local/boost/lib
ENV PETSC_DIR=/opt/local/petsc
ENV GMSH_DIR=/opt/local/gmsh
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
CMD [ "/bin/bash" ]

# production image
FROM base as production
COPY --from=conda /venv /venv
ENV PATH="/venv/bin:$PATH"

# development image
FROM base as development
ENV PATH /opt/conda/bin:$PATH
RUN apt-get update --fix-missing && apt-get install -y \
    cmake \
    g++ \
    gcc \
    make \
    fonts-liberation \
    grsync \
    imagemagick \
    lftp \
    libnetcdf-c++4-dev \
    libnetcdf-dev \
    libx11-dev \
    locales \
    nco \
    rsync \
    ssh \
    valgrind \
    bc \
    git \
    wget \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
COPY environment_dev.txt /tmp/env.txt
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda update -yq conda && \
    conda install -c conda-forge --file /tmp/env.txt && \
    /opt/conda/bin/conda clean -a && \
    rm -rf $HOME/.cache/yarn && \
    rm -rf /opt/conda/pkgs/*
