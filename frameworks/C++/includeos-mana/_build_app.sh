echo "Building IncludeOS Mana server"
rm -fr build
mkdir build
pushd build
docker run --rm -v $(dirname $PWD):/service includeos/includeos-build:0.10.0.1
popd
