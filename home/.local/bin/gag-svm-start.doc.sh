#!/usr/bin/env bash
qm set $1 \
    --vga none \
    --hostpci0 0000:03:00.0,pcie=1 \
    --hostpci1 0000:06:00,pcie=1 \
    --hostpci2 0000:0c:00,pcie=1,x-vga=1 \
    --hostpci3 0000:0e:00.3,pcie=1 \
    --hostpci4 0000:0e:00.4,pcie=1

qm start $1
sleep 5

qm set $1 \
    --delete hostpci0,hostpci1,hostpci2,hostpci3,hostpci4 \
    --vga qxl,memory=32
