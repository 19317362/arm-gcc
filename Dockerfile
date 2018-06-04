FROM ubuntu:18.04

ENV CROSS_TRIPLE arm-none-eabi
ENV CROSS_ROOT /usr/${CROSS_TRIPLE}

# 
# && dpkg --add-architecture armhf
# build-essential gcc-arm-none-eabi qemu-user qemu-user-static libbz2-dev:armhf libexpat1-dev:armhf ncurses-dev:armhf libssl-dev:armhf
# 
RUN echo "deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports/ bionic main universe" | tee /etc/apt/sources.list.d/bionic-armhf.list \
    && apt update \
    && apt upgrade -y \
    && apt install -y git bzip2 wget qemu-user qemu-user-static \
    && apt clean \
    && cd /tmp \
    && wget "https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" -O gcc-arm-linux.tar.bz2 \
    && mkdir -p "$CROSS_ROOT" \
    && tar -xjf gcc-arm-linux.tar.bz2 -C "$CROSS_ROOT" \
    && touch "/$CROSS_ROOT/gcc-arm-eabi-${TOOLCHAIN_VER}-linux" \
    && rm -f gcc-arm-linux.tar.bz2

ENV AS=/usr/bin/${CROSS_TRIPLE}-as \
    AR=/usr/bin/${CROSS_TRIPLE}-ar \
    CC=/usr/bin/${CROSS_TRIPLE}-gcc \
    CPP=/usr/bin/${CROSS_TRIPLE}-cpp \
    CXX=/usr/bin/${CROSS_TRIPLE}-g++ \
    LD=/usr/bin/${CROSS_TRIPLE}-ld \
    FC=/usr/bin/${CROSS_TRIPLE}-gfortran

LABEL description="Image for building and debugging ARM Embedded projects" \
      maintainer="Denis Denisov <denji0k@gmail.com>"

ENV PATH "$CROSS_ROOT/bin:$PATH"
