#!/usr/bin/env bash

# this Bash script will extract params from /prc/stat for CPU%
# Method:
# 1. in first line of /prc/stat are the params respectivly:
# 	~~ user - normal processes in user mode
# 	~~ nice - niced processes in user mode 
# 	~~ system - kernel mode time

# 	~~ idle - doing nothing 	[IDLE]
# 	~~ iowait - waiting for I/O	[IDLE]

# 	~~ irq - servicing hardware interrupts
# 	~~ softirq - servicing software interrupts
# 	~~ steal - involuntary wait 
# 	~~ guest - time spent running a normal guest OS
# 	~~ guest_nice - time spent running niced guest

# 2. extract them to vars first time
# 3. extract them to vars second time (after one second) 

# 4. calculate TOTAL and IDLE 
# 	~ TOTAL1 and TOTAL2 are every param except params with IDLE tag (idle, iowait)
# 	~ IDLE1 and IDLE2 are params with IDLE tag (idle, iostat)

# 5. calculate DELTA_TOTAL and DELTA_IDLE
# 6. CPU% is: ((DELTA_TOTAL - DELTA_IDLE) / DELTA_TOTAL) * 100


# First reading
read CPU U1 N1 S1 I1 IO1 IRQ1 SOFT1 STEAL1 <<< $(awk 'NR==1 {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)
T1=$((U1 + N1 + S1 + I1 + IO1 + IRQ1 + SOFT1 + STEAL1))
IDLE1=$((I1 + IO1))

# Wait 1 second
sleep 1

# Second reading
read CPU U2 N2 S2 I2 IO2 IRQ2 SOFT2 STEAL2 <<< $(awk 'NR==1 {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat)
T2=$((U2 + N2 + S2 + I2 + IO2 + IRQ2 + SOFT2 + STEAL2))
IDLE2=$((I2 + IO2))

# Calculate delta
DELTA_TOTAL=$((T2 - T1))
DELTA_IDLE=$((IDLE2 - IDLE1))

# CPU% in that 1 second
CPU_USAGE=$(awk -v total="$DELTA_TOTAL" -v idle="$DELTA_IDLE" 'BEGIN { printf "%.2f", ((total - idle) / total) * 100 }')

echo "CPU usage: $CPU_USAGE%"
