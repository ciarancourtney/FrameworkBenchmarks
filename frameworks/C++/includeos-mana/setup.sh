#!/bin/bash

export INCLUDEOS_VERSION='dev'

#fw_depends clang-3.8
fw_depends docker

# fail fast
set -e

# from https://github.com/includeos/includeos-docker-images.git 2017-08-13
docker build --tag includeos/includeos-common:0.10.0.1 --build-arg TAG=dev -f Dockerfile.common .
docker build --tag includeos/includeos-build:0.10.0.1 -f Dockerfile.build .
docker build --tag includeos/includeos-qemu:0.10.0.1 -f Dockerfile.qemu .

source _build_app.sh

source _boot_server.sh
