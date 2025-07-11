#!/usr/bin/env bash

set -euxo pipefail

# Install
curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -p).zip" -o "/opt/awscliv2.zip"
unzip "/opt/awscliv2.zip" -d /opt/
/opt/aws/install

# Cleanup
rm /opt/awscliv2.zip

# Check version
aws --version
