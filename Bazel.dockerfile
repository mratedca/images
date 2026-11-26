FROM golang:1.27-bookworm@sha256:ce59b41415e2524ae99926fe1f37ce48ba8c194dcbd2a56a65436cdcefa2bd34 AS go_install
RUN go install github.com/bazelbuild/bazelisk@latest

FROM ubuntu:24.04@sha256:562111b88caa79c71391c0c4d3c2114a7d5c35915c20561fd893cb1e07929e6b AS mold_install
RUN apt update -y && apt install -y wget
RUN wget https://github.com/rui314/mold/releases/download/v2.41.0/mold-2.41.0-x86_64-linux.tar.gz
RUN tar -xf mold-2.41.0-x86_64-linux.tar.gz

FROM swift:6.3.1@sha256:af0181a2fe491b45c935a962a45ab77db3d0b867016e481ac164704f09c656fa
RUN apt update && apt install -y python3 git
COPY --from=go_install /go/bin/bazelisk /usr/local/bin/bazelisk

COPY --from=mold_install /mold-2.41.0-x86_64-linux/bin /bin
COPY --from=mold_install /mold-2.41.0-x86_64-linux/lib /lib
COPY --from=mold_install /mold-2.41.0-x86_64-linux/libexec /libexec
COPY --from=mold_install /mold-2.41.0-x86_64-linux/share /share
