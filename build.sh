#!/usr/bin/env bash
set -e

PROXY="${PROXY:-http://127.0.0.1:7777}"
BASE="$1"
PCNG_TAG="$2"
IMAGE_TAG="$3"

docker build --network=host \
    -t "${IMAGE_TAG}" \
    --file "./docker-images/pcng.dockerfile" \
    --build-arg PROXY="$PROXY" \
    --build-arg BASE="$BASE" \
    --build-arg PCNG_TAG="$PCNG_TAG" \
    "./docker-images/"
