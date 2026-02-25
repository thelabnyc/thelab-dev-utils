#!/usr/bin/env bash
set -euxo pipefail

UBUNTU_SHORT_VERSION="${BASE_IMAGE_TAG%%@*}"
OUTPUT_TAG_NAME="${UBUNTU_SHORT_VERSION}.${CI_PIPELINE_IID}"

SOURCE_AMD64="${CI_REGISTRY_IMAGE}:${OUTPUT_TAG_NAME}-amd64"
SOURCE_ARM64="${CI_REGISTRY_IMAGE}:${OUTPUT_TAG_NAME}-arm64"

for TAG in "${CI_REGISTRY_IMAGE}:${OUTPUT_TAG_NAME}" "${CI_REGISTRY_IMAGE}:latest"; do
    docker buildx imagetools create \
        --tag "$TAG" \
        "$SOURCE_AMD64" \
        "$SOURCE_ARM64"
done
