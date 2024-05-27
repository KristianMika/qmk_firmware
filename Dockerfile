FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install --assume-yes \
    sudo \
    git \
    wget \
    tar \
    python3 \
    python3-pip \
    libncurses5 \
    gcc-arm-none-eabi \
    gcc-avr \
    avrdude \
    dfu-programmer \
    dfu-util

RUN python3 -m pip install qmk

RUN addgroup --gid 1000 builder && \
    adduser --uid 1000 --system --group builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers # an ugly hack, but the setup script requires it
RUN mkdir /qmk && chown builder:builder /qmk
USER builder

ADD entrypoint.sh /entrypoint.sh
WORKDIR /qmk

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["compile", "-kb", "cheapino", "-km", "kristian"]
