FROM nansencenter/boost_petsc_gmsh:0.0.6 as base
LABEL maintainer="Anton Korosov <anton.korosov@nersc.no>"

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/root \
    PROJ_LIB=/opt/conda/share/proj

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

# Install conda and Python packages
RUN wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh --no-check-certificate && \
    /bin/bash /tmp/miniconda.sh -fbp $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set show_channel_urls true && \
    conda update --all --quiet --yes && \
    conda init  && \
    __conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)" && \
    eval "$__conda_setup" && \
    conda create -n pynextsim python=3.6 --yes

# tweak configuration:
#  - default matplotlib backend
#  - add missing PROJ_LIB needed for Basemap
#  - search history using pgup/pgdwn
#  - save history in $HOME/env
WORKDIR /root
RUN mkdir -p .config/matplotlib && \
    echo 'backend : tkagg' >> .config/matplotlib/matplotlibrc && \
    echo '"\e[5~": history-search-backward' >> .inputrc && \
    echo '"\e[6~": history-search-forward' >> .inputrc && \
    echo 'if [ -f "env/.nextsimrc" ]; then source env/.nextsimrc; fi' >> .bashrc && \
    echo 'conda activate pynextsim' >> .bashrc

FROM boost_petsc_gmsh_conda:base as conda
COPY requirements.txt requirements.txt
RUN __conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)" && \
    eval "$__conda_setup" && \
    conda activate pynextsim && \
    conda install -q -y --file requirements.txt && \
    rm requirements.txt && \
    conda clean -tipsy && \
    rm -rf $HOME/.cache/yarn && \
    rm -rf $CONDA_DIR/pkgs/*
