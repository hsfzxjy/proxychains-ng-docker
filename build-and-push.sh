#!/bin/bash

for PCNG_TAG in v4.15; do
    for BASE in debian:bullseye; do
        IMAGE_TAG="hsfzxjy/proxychains-ng:${BASE/:/-}-${PCNG_TAG}"
        ./build.sh "$BASE" "${PCNG_TAG}" "${IMAGE_TAG}"
        docker push "${IMAGE_TAG}"
    done
done
