FROM ubuntu:24.04@sha256:562111b88caa79c71391c0c4d3c2114a7d5c35915c20561fd893cb1e07929e6b

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
        ca-certificates \
        libc6-dev \
        libstdc++-13-dev \
        libpq-dev \
        libssl-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
