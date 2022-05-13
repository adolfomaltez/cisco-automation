#!/bin/bash
# Script: start-iosxes.sh
# Function: Start 2 IOS-XE instances using QEMU

# Stop VirtualBox
service vboxdrv stop


# Create TAPs interfaces for iosxe1
tunctl -u root -t tap121
tunctl -u root -t tap1211
tunctl -u root -t tap1212
brctl addif br0 tap121
brctl addif br0 tap1211
brctl addif br0 tap1212
ip link set tap121 up
ip link set tap1211 up
ip link set tap1212 up

# Create TAPs interfaces for iosxe2
tunctl -u root -t tap122
tunctl -u root -t tap1221
tunctl -u root -t tap1222
brctl addif br0 tap122
brctl addif br0 tap1221
brctl addif br0 tap1222
ip link set tap122 up
ip link set tap1221 up
ip link set tap1222 up



# Start iosxe1 instance (4vCPU/4GB)
qemu-system-x86_64 -m 4096M -boot c -smp cpus=4 \
-hda iosxe1--csr1000v-universalk9.qcow2 \
-enable-kvm -vnc 192.168.10.11:4 \
-netdev tap,id=tap121 \
-device virtio-net,netdev=tap121 \
-netdev tap,id=tap1211 \
-device virtio-net,netdev=tap1211 \
-netdev tap,id=tap1212 \
-device virtio-net,netdev=tap1212 \
-serial telnet::3121,server,nowait &


# Start iosxe1 instance (4vCPU/4GB)
qemu-system-x86_64 -m 4096M -boot c -smp cpus=4 \
-hda iosxe2--csr1000v-universalk9.qcow2 \
-enable-kvm -vnc 192.168.10.12:5 \
-netdev tap,id=tap122 \
-device virtio-net,netdev=tap122 \
-netdev tap,id=tap1221 \
-device virtio-net,netdev=tap1221 \
-netdev tap,id=tap1222 \
-device virtio-net,netdev=tap1222 \
-serial telnet::3122,server,nowait &

