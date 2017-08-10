qemu-system-x86_64 -m 128 -nographic -net nic,model=virtio -net user -kernel $INCLUDEOS_PREFIX/chainloader -initrd acorn &
