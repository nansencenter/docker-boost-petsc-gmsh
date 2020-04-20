FROM nansencenter/boost_petsc_gmsh:0.0.6
LABEL maintainer="Anton Korosov <anton.korosov@nersc.no>"

# Configure environment
ENV SIM_USR=sim \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$SIM_USR

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
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
&&  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
&&  echo "LANG=en_US.UTF-8" > /etc/locale.conf \
&&  locale-gen en_US.UTF-8

# User sim with uid=1000
RUN groupadd wheel -g 11 && \
    groupadd $SIM_USR -g 1000 && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    useradd -m -s /bin/bash -N -u 1000 -g 1000 $SIM_USR && \
    mkdir -p $CONDA_DIR && \
    chown $SIM_USR:$SIM_USR $CONDA_DIR && \
    chmod g+w /etc/passwd

USER sim

# Install conda and Python packages
COPY requirements.txt requirements.txt
RUN wget -nv https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh --no-check-certificate && \
    /bin/bash /tmp/miniconda.sh -fbp $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set show_channel_urls true && \
    conda update --all --quiet --yes && \
    conda install -q -y --file requirements.txt && \
    conda clean -tipsy && \
    rm -rf /home/$SIM_USR/.cache/yarn && \
    rm -rf $CONDA_DIR/pkgs/*

# tweak configuration:
#  - default matplotlib backend
#  - add missing PROJ_LIB needed for Basemap
#  - search history using pgup/pgdwn
#  - save history in $HOME/env
USER root
WORKDIR $HOME
RUN mkdir -p .config/matplotlib && \
    echo 'backend : tkagg' >> .config/matplotlib/matplotlibrc && \
    echo '"\e[5~": history-search-backward' >> .inputrc && \
    echo '"\e[6~": history-search-forward' >> .inputrc && \
    echo 'if [ -f "env/.nextsimrc" ]; then source env/.nextsimrc; fi' >> .bashrc && \
    echo 'export PROJ_LIB=/opt/conda/share/proj' >> .bashrc && \
    mkdir env && \
    ln -s $HOME/env/.bash_history && \
    mkdir -p .ipython/profile_default && \
    ln -s $HOME/env/history.sqlite .ipython/profile_default/history.sqlite && \
    chown sim:sim -R $HOME

