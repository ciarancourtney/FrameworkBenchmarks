echo "Booting IncludeOS Mana server"
docker run -p 8080:8080 --rm -v $(pwd):/service/build includeos/includeos-qemu:0.10.0.1 build/mana_simple.img
