#!/usr/bin/env bash

# Based on https://gist.github.com/EvgenyOrekhov/1ed8a4466efd0a59d73a11d753c0167b

fw_installed docker && return 0

#set -euo pipefail
#IFS=$'\n\t'

sudo apt-get -y install apt-transport-https ca-certificates \
    && sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release --codename --short) main" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt-get update \
    && sudo apt-get -y install "linux-image-extra-$(uname -r)" linux-image-extra-virtual \
    && sudo apt-get -y install docker-engine \
    && sudo usermod -aG docker "$USER" \
    && sudo systemctl enable docker \
    && sudo su --login $USER && echo "\nLogged into docker group so logout/login not required to run docker as non-root user\n" \
    && echo -e "\nDocker installed successfully\n" \
    && touch $IROOT/docker.installed
