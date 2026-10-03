#!/usr/bin/env bash

# RAM multi-time params extraction

# 1. extracting Total RAM & Available RAM
read TOTAL AVAILABLE <<< $(awk 'NR==1 {t=$2} NR==3 {f=$2} END {print t, f}' /proc/meminfo)

# 2. To MB (for better accuracy, converting to GB is easy)
T_MB=$(($TOTAL / 1024))
A_MB=$(($AVAILABLE / 1024))

# 3. Calculating Usage
U_MB=$(($T_MB - $A_MB))

# 4. Calculating Usage percentage
USAGE_PERC=$(awk -v total=$TOTAL -v free=$AVAILABLE 'BEGIN {printf "%.2f", ((total - free) / total) * 100}')

# 5. Debug oputput
echo -e "\t--[RAM REPORT]--"
echo -e "Total:      \033[36m$T_MB MB\033[0m"
echo -e "Used: 	     \033[36m$U_MB MB\033[0m"
echo -e "Available: \033[36m$A_MB MB\033[0m"
echo -e "---\nRAM: \033[36m$USAGE_PERC%"



