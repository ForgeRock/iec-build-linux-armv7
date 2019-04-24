#
# Copyright 2019 ForgeRock AS
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

FROM golang:1.12.3-stretch

ENV CONTAINER_NAME linux-armv7

RUN apt-get update -y && apt-get install -y \
    libtool \
    autoconf \
    automake \
    xz-utils

WORKDIR /root

 
ADD https://releases.linaro.org/components/toolchain/binaries/6.2-2016.11/arm-linux-gnueabihf/gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf.tar.xz .
RUN mkdir -p /opt/toolchains/aarch32 && \
    tar xf gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf.tar.xz -C /opt/toolchains/aarch32 --strip-components=1


ADD https://download.libsodium.org/libsodium/releases/libsodium-1.0.17.tar.gz .
RUN export PATH=/opt/toolchains/aarch32/bin:$PATH && \
    tar xf libsodium-1.0.17.tar.gz && \
    cd libsodium-1.0.17 && \
    ./configure -host=arm-linux-gnueabihf --prefix=/root/linux-armv7 && \
    make install

ADD https://github.com/zeromq/libzmq/releases/download/v4.2.5/zeromq-4.2.5.tar.gz .
RUN export PATH=/opt/toolchains/aarch32/bin:$PATH && \
    export PKG_CONFIG_PATH=/root/linux-armv7/lib/pkgconfig && \
    tar xf zeromq-4.2.5.tar.gz && \
    cd zeromq-4.2.5 && \
    ./autogen.sh && \
    ./configure --with-libsodium --without-docs --enable-drafts --host=arm-linux-gnueabihf --prefix=/root/linux-armv7 && \
    make install

WORKDIR /root/iec
