#!/bin/bash



#fw_depends mysql python3

set -e

sudo apt-get install -yqq python3-dev genisoimage

rm -rf venv
$PY3_ROOT/bin/python3 -m venv venv

sudo apt-get install -yqq libmysqlclient-dev

sudo apt-get install -yqq libpq-dev

# uncomment if running on wsl https://github.com/Microsoft/BashOnWindows/issues/1043
#sudo apt-get install grub-pc-bin


venv/bin/pip install -r requirements.txt

echo "Installing rumpkernel rumprun"
git clone http://repo.rumpkernel.org/rumprun
cd rumprun
git submodule update --init
./build-rr.sh hw

export PATH="${PATH}:$(pwd)/rumprun/bin"

cd py3-rump
make
cd ..

genisoimage -r -o main.iso main.py venv/lib/python3.5/site-packages

rumprun-bake hw_generic python.bin py3-rump/build/python

sudo ip tuntap add tap0 mode tap
sudo ip addr add 10.0.120.100/24 dev tap0
sudo ip link set dev tap0 up

rumprun kvm -i \
	-I if,vioif,'-net tap,ifname=tap0,script=no' \
        -W if,inet,static,10.0.120.101/24 \
	-b py3-rump/images/python.iso,/python/lib/python3.5 \
	-b main.iso,/python/lib/python3.5/site-packages \
	-e PYTHONHOME=/python \
        -- python.bin -m main


pip install --install-option="--prefix=${PY2_ROOT}" -r $TROOT/requirements.txt

gunicorn --pid=gunicorn.pid hello.wsgi:application -c gunicorn_conf.py --env DJANGO_DB=mysql &
