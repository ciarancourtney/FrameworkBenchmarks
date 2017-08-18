#!/bin/bash

fw_depends mysql python3 rumprun

set -e

# mysql deps
sudo apt-get install -yqq libmysqlclient-dev

#postgres deps
sudo apt-get install -yqq libpq-dev

echo "Installing qemu"
sudo apt-get install -yqq qemu-system-x86
# uncomment if running on wsl https://github.com/Microsoft/BashOnWindows/issues/1043
#sudo apt-get install grub-pc-bin

echo "Creating virtualenv"
rm -rf venv
virtualenv venv --always-copy
venv/bin/pip install -r requirements.txt

echo "Baking Image"
genisoimage -r -o main.iso main.py venv/lib/python3.5/site-packages
rumprun-bake hw_generic python.bin ${IROOT}/rumprun-packages/python3/build/python

echo "Creating network tun to VM"
sudo ip tuntap add tap0 mode tap
sudo ip addr add 10.0.120.100/24 dev tap0
sudo ip link set dev tap0 up

echo "Booting VM"
PY_ISO="${IROOT}/rumprun-packages/python3/images/python.iso"
rumprun qemu -i -g '-nographic -vga none' \
	-I if,vioif,'-net tap,ifname=tap0,script=no' \
        -W if,inet,static,10.0.120.101/24 \
	-b ${PY_ISO},/python/lib/python3.5 \
	-b main.iso,/python/lib/python3.5/site-packages \
	-e PYTHONHOME=/python \
        -- python.bin -m main


#rumprun qemu -i -g '-nographic -vga none' \
#	-I if,vioif,'-net tap,ifname=tap0,script=no' \
#        -W if,inet,static,10.0.120.101/24 \
#	-b /home/vagrant/FrameworkBenchmarks/installs/rumprun-packages/python3/images/python.iso,/python/lib/python3.5 \
#	-b main.iso,/python/lib/python3.5/site-packages \
#	-e PYTHONHOME=/python \
#        -- python.bin -m main