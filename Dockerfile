FROM ubuntu:24.04

ARG OPENCODE_VERSION=1.14.24
ENV OPENCODE_VERSION=${OPENCODE_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    ripgrep \
    fd-find \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN arch=$(uname -m) && \
    case "$arch" in \
        aarch64) target="linux-arm64" ;; \
        x86_64)  target="linux-x64" ;; \
        *)       echo "Unsupported arch: $arch"; exit 1 ;; \
    esac && \
    url="https://github.com/anomalyco/opencode/releases/download/v${OPENCODE_VERSION}/opencode-${target}.tar.gz" && \
    curl -fsSL "$url" -o /tmp/opencode.tar.gz && \
    tar -xzf /tmp/opencode.tar.gz -C /usr/local/bin opencode && \
    chmod +x /usr/local/bin/opencode && \
    rm /tmp/opencode.tar.gz

VOLUME ["/workspace"]
WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/opencode"]
