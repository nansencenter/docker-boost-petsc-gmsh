FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:mhier/libboost-latest && apt-get update && apt-get install -y \
    libboost1.67-dev

CMD [ "/bin/bash" ]
