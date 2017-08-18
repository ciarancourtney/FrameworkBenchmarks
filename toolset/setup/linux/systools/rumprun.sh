#!/bin/bash

fw_installed rumprun && return 0

echo "Installing rumprun"
sudo apt-get install -yqq genisoimage

echo "Installing Python 3.5 (rumprun doesn't support 3.6 yet)"
sudo add-apt-repository -y ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install -y python3.5

wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo python3.5 /tmp/get-pip.py
sudo python3.5 -m pip install virtualenv

pushd $IROOT
git clone http://repo.rumpkernel.org/rumprun
pushd rumprun
git checkout c7f2f016becc1cd0e85da6e1b25a8e7f9fb2aa74  # master@2017-03-17
git submodule update --init
./build-rr.sh -q hw
popd
export PATH="${PATH}:${IROOT}/rumprun/rumprun/bin"

echo "Cloning rumprun-packages"
git clone https://github.com/rumpkernel/rumprun-packages.git
pushd rumprun-packages
git checkout 45217367a054c126db7adc926943778e9ae20d4c  # master@2017-08-17
echo 'RUMPRUN_TOOLCHAIN_TUPLE=x86_64-rumprun-netbsd' > config.mk

# Fix 'KERN_ARND' undeclared error in netbsd
sed -i.bak s/libressl-2.4.2.tar.gz/libressl-2.6.0.tar.gz/g libressl/Makefile

echo "Statically compiling Python 3"
pushd python3
make
popd
popd

touch $IROOT/rumprun.installed
