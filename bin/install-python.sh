#!/usr/bin/env bash

set -euxo pipefail

# Install Python and misc utils
apt-get update
apt-get install -y software-properties-common

add-apt-repository ppa:deadsnakes/ppa
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    dialog \
    jq \
    "python${PYTHON_VERSION}-dev" \
    python3 \
    python3-ipython \
    python3-pip \
    unzip \
    wget

# Install Poetry
curl -sSL "https://install.python-poetry.org" | python3 -
export PATH="/root/.local/bin:${PATH}"

# Install Poetry plugins
poetry self add poetry-plugin-export

# Cleanup
rm -rf /var/lib/apt/lists/*
