#!/bin/bash

export INCLUDEOS_VERSION='dev'

#fw_depends clang-3.8
fw_depends docker

# fail fast
set -e

# from https://github.com/includeos/includeos-docker-images.git 2017-08-13
echo "Installing IncludeOS"
docker build --tag includeos/includeos-common:0.10.0.1 --build-arg TAG=dev -f Dockerfile.common .
docker build --tag includeos/includeos-build:0.10.0.1 -f Dockerfile.build .
docker build --tag includeos/includeos-qemu:0.10.0.1 -f Dockerfile.qemu .

echo "Building IncludeOS Mana server"
rm -fr build
mkdir build
cd build
docker run --rm -v $(dirname $PWD):/service includeos/includeos-build:0.10.0.1

echo "Booting IncludeOS Mana server"
docker run -p 8080:8080 --rm -v $(pwd):/service/build includeos/includeos-qemu:0.10.0.1 mana_simple.img
