#!/usr/bin/env bash
set -euxo pipefail

# Derive tag from BASE_IMAGE_TAG (strip digest)
UBUNTU_SHORT_VERSION="${BASE_IMAGE_TAG%%@*}"
if [ -n "${CI_PIPELINE_IID:-}" ]; then
    OUTPUT_TAG_NAME="${UBUNTU_SHORT_VERSION}.${CI_PIPELINE_IID}"
else
    OUTPUT_TAG_NAME="${UBUNTU_SHORT_VERSION}"
fi

# Append arch suffix in CI
ARCH_SUFFIX=""
if [ -n "${ARCH:-}" ]; then
    ARCH_SUFFIX="-${ARCH}"
fi

IMAGE_TAG="${CI_REGISTRY_IMAGE:-dev-utils}:${OUTPUT_TAG_NAME}${TAG_SUFFIX:-}${ARCH_SUFFIX}"

docker build \
    --pull \
    --build-arg "BASE_IMAGE_TAG=${BASE_IMAGE_TAG}" \
    --tag "$IMAGE_TAG" \
    .

# Push only on default branch
if [ -n "${CI_COMMIT_BRANCH:-}" ] && [ "$CI_COMMIT_BRANCH" == "${CI_DEFAULT_BRANCH:-}" ]; then
    docker push "$IMAGE_TAG"
fi
