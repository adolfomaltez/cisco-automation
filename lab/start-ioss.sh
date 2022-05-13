#!/bin/bash
# Script: start-ioss.sh
# Function: Start 2 IOS instances using Dynamips


# Create TAPs interfaces for r1
tunctl -u root -t tap101
brctl addif br0 tap101
ip link set tap101 up

# Create TAPs interfaces for r2
tunctl -u root -t tap102
brctl addif br0 tap102
ip link set tap102 up



# Start r1
dynamips -i 0 -j -T 3101 -p 1:0:PA-FE-TX -s 1:0:tap:tap101 c7200-advipservicesk9.124-2.T.bin &

# Start r2
dynamips -i 1 -j -T 3102 -p 1:0:PA-FE-TX -s 1:0:tap:tap102 c7200-advipservicesk9.124-2.T.bin &


# Some Notes
# Configure routers
telnet localhost 3101
telnet localhost 3102

# Connect to SSH
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -c aes256-cbc -lcisco 192.168.10.101
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -c aes256-cbc -lcisco 192.168.10.102

