#!/bin/bash

export INCLUDEOS_VERSION='dev'

fw_depends clang-3.8

# fail fast
set -e

source _env_vars.sh

source _install_includeos.sh

source _build_app.sh

echo "Booting IncludeOS Mana server"
cd build
boot mana_simple
