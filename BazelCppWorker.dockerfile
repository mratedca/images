FROM ubuntu:26.04@sha256:d66b366dac61b575bee2aef07e9c26e8070096fbe84a3d4d3eb0da069b5d76db

ENV DEBIAN_FRONTEND=noninteractive

# python3: rules_pkg's build_tar and other py_binary exec tools run `/usr/bin/env python3`
# on this executor (distclang's pkg_tar layers failed with "python3: No such file").
RUN apt update && apt install -y --no-install-recommends \
        ca-certificates \
        python3 \
        libc6-dev \
        libstdc++-13-dev \
        libpq-dev \
        libssl-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
