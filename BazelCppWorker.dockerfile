FROM ubuntu:24.04@sha256:562111b88caa79c71391c0c4d3c2114a7d5c35915c20561fd893cb1e07929e6b

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
