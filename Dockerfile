FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran-4.8 \
    software-properties-common \
    python \
    wget

COPY install_boost.sh /scripts/
WORKDIR /scripts
RUN ./install_boost.sh


#RUN add-apt-repository ppa:jonathonf/gcc && sudo apt-get update && apt-get install -y \
#    gcc-5

#COPY install_petsc.sh /scripts/
#WORKDIR /scripts
#RUN ./install_petsc.sh

CMD [ "/bin/bash" ]
