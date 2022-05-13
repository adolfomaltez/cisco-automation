#!/bin/bash
# Script: start-nxoss.sh
# Function: Start 2 CISCO NXOS instances using QEMU

# Stop VirtualBox
service vboxdrv stop

# Creating TAPs interfaces for nxos1
tunctl -u root -t tap131
tunctl -u root -t tap1311
tunctl -u root -t tap1312
brctl addif br0 tap131
brctl addif br0 tap1311
brctl addif br0 tap1312
ip link set tap131 up
ip link set tap1311 up
ip link set tap1312 up

# Creating TAPs interfaces for nxos2
tunctl -u root -t tap132
tunctl -u root -t tap1321
tunctl -u root -t tap1322
brctl addif br0 tap132
brctl addif br0 tap1321
brctl addif br0 tap1322
ip link set tap132 up
ip link set tap1321 up
ip link set tap1322 up



# Start nxos1 instance (4vCPU/8GB)
qemu-system-x86_64 -nographic -m 8096 -smp 4 -bios OVMF-20160813.fd \
-enable-kvm -device ahci,id=ahci0,bus=pci.0 \
-drive file=nxos1-nexus9300v.9.3.3.qcow2,if=none,id=drive-sata-disk0,format=qcow2 \
-device ide-hd,bus=ahci0.0,drive=drive-sata-disk0,id=drive-sata-disk0 \
-netdev tap,id=tap131  -device e1000,netdev=tap131  \
-netdev tap,id=tap1311 -device e1000,netdev=tap1311 \
-netdev tap,id=tap1312 -device e1000,netdev=tap1312 \
-vnc 192.168.10.11:6 -serial telnet::3131,server,nowait &

# Start nxos2 instance (4vCPU/8GB)
qemu-system-x86_64 -nographic -m 8096 -smp 4 -bios OVMF-20160813.fd \
-enable-kvm -device ahci,id=ahci0,bus=pci.0 \
-drive file=nxos2-nexus9300v.9.3.3.qcow2,if=none,id=drive-sata-disk0,format=qcow2 \
-device ide-hd,bus=ahci0.0,drive=drive-sata-disk0,id=drive-sata-disk0 \
-netdev tap,id=tap132  -device e1000,netdev=tap132  \
-netdev tap,id=tap1321 -device e1000,netdev=tap1321 \
-netdev tap,id=tap1322 -device e1000,netdev=tap1322 \
-vnc 192.168.10.11:7 -serial telnet::3132,server,nowait &
