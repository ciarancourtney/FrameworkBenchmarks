echo "Building IncludeOS Mana server"
rm -fr build
mkdir build
pushd build
cmake .. && make
popd
