FROM ubuntu:18.04 AS build
LABEL author="Andrew Bailey"
LABEL maintainer="andbaile@ucsc.edu"

# apt-get installs
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-6 g++-6 sudo autoconf wget git build-essential libbz2-dev zlib1g-dev liblzma-dev libeigen3-dev libssl-dev libcurl4-openssl-dev ca-certificates libhdf5-dev python3.7-dev python3-pip && \
    apt-get clean && \
    apt-get purge

# install cmake
WORKDIR /tmp
RUN mkdir /opt/cmake && \
    wget https://cmake.org/files/v3.17/cmake-3.17.0-Linux-x86_64.sh --no-check-certificate && \
    sh /tmp/cmake-3.17.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

# htslib
WORKDIR /root/
RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 --no-check-certificate && tar -vxjf htslib-1.9.tar.bz2 && rm htslib-1.9.tar.bz2
WORKDIR /root/htslib-1.9
RUN ./configure --prefix /usr/local --enable-plugins CPPFLAGS="-fPIC" CFLAGS="-fPIC" && make && make install

# install pip and setuptools
WORKDIR /root/
RUN apt-get install curl -y
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.7 get-pip.py
RUN python3.7 -m pip install setuptools
WORKDIR /root/
#RUN ls
#RUN git clone --recursive https://github.com/adbailey4/embed_fast5.git --branch filter_by_position
COPY . /root/nanopolish
WORKDIR /root/nanopolish
WORKDIR /root/nanopolish/build
RUN cmake ../ && make nanopolish

FROM ubuntu:18.04 as runtime
RUN apt-get update
COPY --from=build /root/nanopolish/build/nanopolish /bin/nanopolish

RUN mkdir /data
WORKDIR /data
ENTRYPOINT ["nanopolish"]
