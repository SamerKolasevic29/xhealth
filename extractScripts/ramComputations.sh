#!/usr/bin/env bash

# Sada vadimo RAM usage
# 1. vadimo memory Total i Free

read TOTAL AVAILABLE <<< $(awk 'NR==1 {t=$2} NR==3 {f=$2} END {print t, f}' /proc/meminfo)
T_MB=$(($TOTAL / 1024))
A_MB=$(($AVAILABLE / 1024))

U_MB=$(($T_MB - $A_MB))

USAGE_PERC=$(awk -v total=$TOTAL -v free=$AVAILABLE 'BEGIN {printf "%.2f", ((total - free) / total) * 100}')

echo -e "\t--[RAM REPORT]--"
echo -e "Total:      \033[36m$T_MB MB\033[0m"
echo -e "Used: 	     \033[36m$U_MB MB\033[0m"
echo -e "Available: \033[36m$A_MB MB\033[0m"
echo -e "---\nRAM: \033[36m$USAGE_PERC%"



