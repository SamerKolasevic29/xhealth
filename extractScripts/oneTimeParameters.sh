#!/usr/bin/env bash

# the main goal of xhealth is:
#       -- giving one-time params
#       -- giving the dynamic (multi-time) params

# This Script is prototype of extracting one-time params
        # -- hostname
        # -- os / distro
        # -- Kernel version
        # -- CPU model
        # -- Number of cores
        # -- Total RAM
        # -- Architecture

# Hostname (/proc/sys/kernel/hostname) 
HOSTNAME=$(cat /proc/sys/kernel/hostname)

# OS / Distro
DISTRO=$(source /etc/os-release && echo $PRETTY_NAME)
echo $DISTRO

# Kernel version
KERN=$(cat /proc/sys/kernel/osrelease)

#CPU model (tricky, heres te reason)
# x86/x86_64            model name
# ARM / Raspberry Pi    Model, Hardware, Processor
# ARM64                 CPU implementer, CPU part
# PowerPC               cpu, clock
# S390                  vendor_id
# --- 
# grep awk sed combo
CPU_MODEL=$(grep -m1 -E 'model name|^Model|^Hardware|^Processor' /proc/cpuinfo \
 | cut -d: -f2- | sed 's/^[[:space:]]*//')

# Number of cores
CORE_NUM=$(grep -c ^processor /proc/cpuinfo)

# Total RAM (kB, MB, GB)
RAM_KB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)

# Total RAM in MB 
RAM_MB=$((RAM_KB / 1024))

# Total RAM in GB
RAM_GB=$((RAM_MB / 1024))

# Acrhitecture
ARCH=$(uname -m)
