FROM golang:1.26-bookworm AS go_install
RUN go install github.com/bazelbuild/bazelisk@latest

FROM ubuntu:24.04 AS mold_install
RUN apt update -y && apt install -y wget
RUN wget https://github.com/rui314/mold/releases/download/v2.41.0/mold-2.41.0-x86_64-linux.tar.gz
RUN tar -xf mold-2.41.0-x86_64-linux.tar.gz

FROM ubuntu:24.04 AS swift_install
RUN apt update && apt install -y curl gpg
RUN curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz && \
  tar zxf swiftly-$(uname -m).tar.gz && \
  ./swiftly init -y -shell-followup

FROM ubuntu:24.04
RUN apt update && apt install -y python3 git
COPY --from=go_install /go/bin/bazelisk /usr/local/bin/bazelisk

COPY --from=mold_install /mold-2.41.0-x86_64-linux/bin /bin
COPY --from=mold_install /mold-2.41.0-x86_64-linux/lib /lib
COPY --from=mold_install /mold-2.41.0-x86_64-linux/libexec /libexec
COPY --from=mold_install /mold-2.41.0-x86_64-linux/share /share

RUN apt install -y --no-install-recommends --no-install-suggests binutils unzip gnupg2 libc6-dev libcurl4-openssl-dev libgcc-13-dev libpython3-dev libstdc++-13-dev libxml2-dev libncurses-dev libz3-dev pkg-config zlib1g-dev
COPY --from=swift_install ./swiftly /usr/local/bin/swiftly
RUN swiftly init -y --skip-install
RUN swiftly install latest --no-verify
ENV SWIFTLY_HOME=/root/.local/share/swiftly
ENV PATH="${SWIFTLY_HOME}/bin:${PATH}"
