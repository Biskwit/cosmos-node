FROM golang:1.18-alpine
USER root
ARG GAIA_VERSION=v9.0.0-rc3

ENV PACKAGES curl make git libc-dev bash gcc linux-headers wget lz4-libs aria2 lz4 jq
RUN apk add --no-cache $PACKAGES

WORKDIR /downloads/
RUN git clone https://github.com/cosmos/gaia.git
RUN cd gaia && git checkout ${GAIA_VERSION} && make build && cp ./build/gaiad /usr/local/bin/

COPY ./app.toml /root/.gaia/config/app.toml
COPY ./config.toml /root/.gaia/config/config.toml
COPY ./client.toml /root/.gaia/config/client.toml
COPY ./node-default.sh ./node-default.sh

RUN gaiad init exanode_cosmos && \
    wget https://raw.githubusercontent.com/cosmos/mainnet/master/genesis/genesis.cosmoshub-4.json.gz && \
    gzip -d genesis.cosmoshub-4.json.gz && \
    mv genesis.cosmoshub-4.json /root/.gaia/config/genesis.json && \
    wget https://quicksync.io/addrbook.cosmos.json && \
    mv addrbook.cosmos.json /root/.gaia/config/addrbook.json


EXPOSE 26656 26657 1317 9090
ENTRYPOINT ["./node-default.sh"]