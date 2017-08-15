#!/bin/bash

OCAML_VER='4.03.0'

UBUNTU_VER=$(lsb_release -sr | cut -d'.' -f1)
expr $UBUNTU_VER

echo "Installing Dependencies"
sudo apt-get update
sudo apt-get install m4

echo "Installing OPAM (takes >10min)"
if (( $UBUNTU_VER >= 16 )); then
    sudo apt-get install -y opam
else
    sudo add-apt-repository ppa:avsm/ppa
    sudo apt-get update
    sudo apt-get install ocaml ocaml-native-compilers camlp4-extra opam
fi
opam init
eval $(opam config env)

echo "Switching to OCaml Compiler $OCAML_VER"
opam switch $OCAML_VER

echo "    Setting up compiler env"
eval `opam config env`

echo "Installing MirageOS"
opam install mirage=3.0.5
