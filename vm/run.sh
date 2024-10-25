#!/bin/sh
qemu-system-x86_64 \
    -enable-kvm \
    -boot d \
    -cdrom arch.iso \
    -drive file=disk.img,format=qcow2 \
    -m 4G \
    -smp 4 \
    -virtfs local,path=..,mount_tag=shared,security_model=mapped-xattr,id=sharedfolder
