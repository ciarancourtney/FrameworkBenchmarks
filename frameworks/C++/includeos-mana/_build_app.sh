echo "Building IncludeOS Mana server"
rm -fr build
mkdir build
docker run --rm -v $(dirname $PWD):/build/service includeos/includeos-build:0.10.0.1
