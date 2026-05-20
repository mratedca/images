FROM golang:1.26-bookworm AS go_install
RUN go install github.com/bazelbuild/bazelisk@latest

FROM ubuntu:24.04 AS mold_install
RUN apt update -y && apt install -y wget
RUN wget https://github.com/rui314/mold/releases/download/v2.41.0/mold-2.41.0-x86_64-linux.tar.gz
RUN tar -xf mold-2.41.0-x86_64-linux.tar.gz

FROM swift:6.3.1
RUN apt update && apt install -y python3 git
COPY --from=go_install /go/bin/bazelisk /usr/local/bin/bazelisk

COPY --from=mold_install /mold-2.41.0-x86_64-linux/bin /bin
COPY --from=mold_install /mold-2.41.0-x86_64-linux/lib /lib
COPY --from=mold_install /mold-2.41.0-x86_64-linux/libexec /libexec
COPY --from=mold_install /mold-2.41.0-x86_64-linux/share /share
