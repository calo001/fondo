FROM elementary/docker:odin-unstable
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get --assume-yes install libsoup2.4-dev

COPY . /fondo

WORKDIR /fondo

RUN ls /fondo/po

RUN meson build --prefix=/usr && \
    cd build && \
    ninja com.github.calo001.fondo-pot && \
    ninja com.github.calo001.fondo-update-po && \
    ninja extra-update-po

RUN ls /fondo/po