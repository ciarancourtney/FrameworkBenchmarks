#!/bin/bash

fw_depends mysql rumprun

set -e

echo "Installing qemu"
sudo apt-get install -yqq qemu-system-x86
# uncomment if running on wsl https://github.com/Microsoft/BashOnWindows/issues/1043
#sudo apt-get install grub-pc-bin

echo "Creating virtualenv"
rm -rf venv
virtualenv venv --always-copy  # always-copy because virtualbox sync folders don't support symlinks
venv/bin/pip install -r requirements.txt

wget https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-2.1.7.tar.gz -O /tmp/mysql-connector-python-2.1.7.tar.gz
venv/bin/pip install /tmp/mysql-connector-python-2.1.7.tar.gz

echo "Baking Image"
#FIXME import modules correctly
cp -R hello/hello venv/lib/python3.5/site-packages/
cp -R hello/world venv/lib/python3.5/site-packages/

genisoimage -r -o main.iso hello/main.py venv/lib/python3.5/site-packages
rumprun-bake hw_generic python.bin ${IROOT}/rumprun-packages/python3/build/python

echo "Booting VM using DHCP"
PY_ISO="${IROOT}/rumprun-packages/python3/images/python.iso"
rumprun qemu -i -g '-nographic -vga none' \
	-I 'nic,vioif,-net user,hostfwd=tcp::8080-:8080' \
    -W nic,inet,dhcp \
	-b ${PY_ISO},/python/lib/python3.5 \
	-b main.iso,/python/lib/python3.5/site-packages \
	-e PYTHONHOME=/python \
    -- python.bin -m main

# run using a tun/tap tunnel , will be hosted on 10.0.120.101:8080
# taps can be problematic on ubuntu, check a MAC is assigned using $ arp -n, if not del and add again
#sudo ip tuntap add tap0 mode tap
#sudo ip addr add 10.0.120.100/24 dev tap0
#sudo ip link set dev tap0 up
#rumprun qemu -i -g '-nographic -vga none' -I if,vioif,'-net tap,ifname=tap0,script=no'-W if,inet,static,10.0.120.101/24 -b /home/vagrant/FrameworkBenchmarks/installs/rumprun-packages/python3/images/python.iso,/python/lib/python3.5 -b main.iso,/python/lib/python3.5/site-packages -e PYTHONHOME=/python -- python.bin -m main

# run using DHCP and map to localhost:8080
#rumprun qemu -i -g '-nographic -vga none' -I 'nic,vioif,-net user,hostfwd=tcp::8080-:8080' -W nic,inet,dhcp -b /home/vagrant/FrameworkBenchmarks/installs/rumprun-packages/python3/images/python.iso,/python/lib/python3.5 -b main.iso,/python/lib/python3.5/site-packages -e PYTHONHOME=/python -- python.bin -m main