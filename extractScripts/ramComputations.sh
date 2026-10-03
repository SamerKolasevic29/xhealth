#!/usr/bin/env bash

# Sada vadimo RAM usage
# 1. vadimo memory Total i Free

read TOTAL FREE <<< $(awk 'NR==1 {t=$2} NR==2 {f=$2} END {print t, f}' /proc/meminfo)
T_MB=$(($TOTAL / 1024))
F_MB=$(($FREE / 1024))

U_MB=$((($T_MB - $F_MB) / 1024))

$USAGE_PERC=$(awk -v total=$TOTAL -v free=$F_MB 'BEGIN {printf "%.2f", ((total - free) / total) * 100}')





