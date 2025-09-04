#!/usr/bin/env bash

set -euxo pipefail

# Install Python and misc utils
apt-get update
apt-get install -y software-properties-common

add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install -y \
    age \
    apt-transport-https \
    ca-certificates \
    curl \
    dialog \
    jq \
    python3 \
    "python${PYTHON_VERSION}-dev" \
    python3-pip \
    unzip \
    wget

# Cleanup
rm -rf /var/lib/apt/lists/*
