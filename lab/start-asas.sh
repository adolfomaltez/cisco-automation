#!/bin/bash
# Script: start-asas.sh
# Function: Start 2 ASA instances using QEMU

# Stop VirtualBox
service vboxdrv stop

# Create TAPs interfaces
tunctl -u root -t tap111
tunctl -u root -t tap112
brctl addif br0 tap111
brctl addif br0 tap112
ip link set tap111 up
ip link set tap112 up


# Start asa1 instance (2vCPU/2GB)
qemu-system-x86_64 -m 2048M -boot c -smp cpus=2 -hda asa1--asav971.qcow2 \
-enable-kvm -vnc 192.168.10.11:2 \
-net "nic,macaddr=00:00:ab:cd:1f:00,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:1f:01,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:1f:02,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:1f:03,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:1f:04,model=e1000" \
-net "tap,ifname=tap111" -serial "telnet::3111,server,nowait" &

# Start asa2 instance (2vCPU/2GB)
qemu-system-x86_64 -m 2048M -boot c -smp cpus=2 -hda asa2--asav971.qcow2 \
-enable-kvm -vnc 192.168.10.11:3 \
-net "nic,macaddr=00:00:ab:cd:2f:00,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:2f:01,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:2f:02,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:2f:03,model=e1000" \
-net "nic,macaddr=00:00:ab:cd:2f:04,model=e1000" \
-net "tap,ifname=tap112" -serial "telnet::3112,server,nowait" &
