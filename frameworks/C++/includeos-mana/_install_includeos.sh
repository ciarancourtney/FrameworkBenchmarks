echo "Installing IncludeOS $INCLUDEOS_VERSION"

# Install dependencies not provided by toolset/
sudo apt-get install -yqq nasm bridge-utils qemu jq

rm -fr IncludeOS
git clone --branch $INCLUDEOS_VERSION https://github.com/hioa-cs/IncludeOS
pushd IncludeOS
git checkout 4b5722943b1945010c032fde3e6cbf20b5abc30e  # FIXME solo5_repo build fails (GCC 5.4.1 Vs 5.4.0 regression?)
./install.sh -y
popd
