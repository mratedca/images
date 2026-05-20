FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Image used as the remote-execution container for the mono repo's
# CppCompile / CppLink / Genrule actions. Kept small (no swift, no git,
# no go, no python install) but ships:
#
#   - libc / libstdc++ dev headers — the LLVM toolchain has its own
#     clang and libc++ but still falls back to /usr/include for the C
#     standard library (math.h's FP_NAN macros etc.). Without these,
#     CppCompile fails with "undeclared identifier 'FP_NAN'".
#   - system libs needed by the cmake-built deps that mono pulls in
#     (libpqxx, cpr, ...). Hermetic-toolchain follow-up would let us
#     drop these — see NOTELY-348.
#   - a small debug toolbox (file, strace, less, procps, gdb) so that
#     when a remote action fails, you can poke at it via BuildBuddy SSH
#     and actually inspect the failure.
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        libc6-dev \
        libstdc++-13-dev \
        libpq-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        zlib1g-dev \
        file \
        strace \
        less \
        procps \
        gdb \
    && rm -rf /var/lib/apt/lists/*
