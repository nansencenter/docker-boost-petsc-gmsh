FROM nansencenter/boost_petsc_gmsh:0.0.6
LABEL maintainer="Anton Korosov <anton.korosov@nersc.no>"

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PYTHONUNBUFFERED=1
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/root \
    PROJ_LIB=$CONDA_DIR/share/proj

# Install all OS dependencies for notebook
RUN apt-get update && apt-get -yq dist-upgrade \
&&  apt-get install -yq --no-install-recommends \
    imagemagick \
    fonts-liberation \
    libx11-dev \
    libnetcdf-dev \
    libnetcdf-c++4-dev \
    locales \
    ssh \
    lftp \
    ncftp \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
&&  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
&&  echo "LANG=en_US.UTF-8" > /etc/locale.conf \
&&  locale-gen en_US.UTF-8

# Install conda
RUN wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh --no-check-certificate \
&&  /bin/bash /tmp/miniconda.sh -fbp $CONDA_DIR \
&&  rm /tmp/miniconda.sh

# Install Python packages
WORKDIR /tmp
COPY environment.yml .
RUN conda env create -f environment.yml \
&&  conda clean -tipsy \
&&  rm -rf $HOME/.cache/yarn \
&&  rm -rf $CONDA_DIR/pkgs/*

# tweak configuration:
#  - default matplotlib backend
#  - search history using pgup/pgdwn
WORKDIR /root
RUN mkdir -p .config/matplotlib \
&&  echo 'backend : tkagg' >> .config/matplotlib/matplotlibrc \
&&  echo '"\e[5~": history-search-backward' >> .inputrc \
&&  echo '"\e[6~": history-search-forward' >> .inputrc

ENV CONDA_DEFAULT_ENV pynextsim
ENV PATH $CONDA_DIR/envs/pynextsim/bin:$PATH
