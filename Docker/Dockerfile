FROM ubuntu:18.04 AS build
LABEL author="Andrew Bailey"
LABEL maintainer="andbaile@ucsc.edu"

# apt-get installs
RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf wget curl git build-essential libbz2-dev zlib1g-dev liblzma-dev libeigen3-dev libssl-dev libcurl4-openssl-dev ca-certificates libhdf5-dev python3.7-dev python3-pip && \
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
RUN wget https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 --no-check-certificate && \
    tar -vxjf htslib-1.9.tar.bz2 && \
    rm htslib-1.9.tar.bz2 && \
    cd /root/htslib-1.9 && \
    ./configure --prefix /usr/local --enable-plugins CPPFLAGS="-fPIC" CFLAGS="-fPIC" && \
    make && \
    make install

# install pip and setuptools
WORKDIR /root/
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.7 get-pip.py && \
    python3.7 -m pip install setuptools

RUN git clone --recursive https://github.com/adbailey4/nanopolish.git --branch rna_option
#COPY . /root/nanopolish
WORKDIR /root/nanopolish/build
RUN cmake ../ -DCMAKE_VERBOSE_MAKEFILE=ON -DBUILD_SHARED_LIBS=OFF && make -j 8
#RUN cmake ../ -DCMAKE_VERBOSE_MAKEFILE=ON -DBUILD_SHARED_LIBS=ON && make -j 8

FROM ubuntu:18.04 as runtime
RUN apt-get update
COPY --from=build /root/nanopolish/build/nanopolish /bin/nanopolish

RUN mkdir /data
WORKDIR /data
ENTRYPOINT ["nanopolish"]
