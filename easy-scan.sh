#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <ips_input_file>"
    exit 1
fi

ips_input_file="$1"
open_ports_scan_output="open-ports-scan.scan"
custom_scan_output="custom-scan.scan"

echo -e "\033[0;32mPerforming initial scan to find open ports...\033[0m"
nmap --open -p- -iL "$ips_input_file" -oG "$open_ports_scan_output" -vv

open_ports=$(grep -oP '\d+/open' "$open_ports_scan_output" | cut -d '/' -f 1 | sort -nu | paste -sd ',' -)

if [ -z "$open_ports" ]; then
    echo "No open ports found. Exiting."
    exit 1
fi

echo -e "\033[0;32mFound open ports. Go touch some grass while the magic happens.\033[0m"
sleep 5

echo -e "\033[0;31mOpen ports found:\033[0m $open_ports"
sleep 5
echo "\033[0mPerforming full scan on found ports...\033[0m"

nmap -iL "$ips_input_file" -p"$open_ports" -sCV -A -oN "$custom_scan_output" -vv

echo -e "\033[0;32mFull scan completed. Results are saved in\033[0m '$custom_scan_output'."
