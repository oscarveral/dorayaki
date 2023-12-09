#!/bin/bash

# File containing IP ranges (one range per line)
ip_ranges_file="ip_ranges.txt"

# Function to check connectivity for an IP address
check_connectivity() {
    if ping -c 1 -W 1 "$1" &> /dev/null; then
        echo "SUCCESS: $1 is reachable."
    else
        echo "FAILURE: $1 is unreachable."
    fi
}

# Read IP ranges from the file and check connectivity for each IP
while IFS= read -r ip_range; do
    # Extract start and end IP addresses from the range
    start_ip=$(echo "$ip_range" | cut -d '-' -f 1)
    end_ip=$(echo "$ip_range" | cut -d '-' -f 2)

    # Loop through the range of IP addresses
    current_ip=$(echo "$start_ip" | tr '.' ' ' | awk '{print $4}')
    end_octet=$(echo "$end_ip" | tr '.' ' ' | awk '{print $4}')

    while [ "$current_ip" -le "$end_octet" ]; do
        current_address="$(echo "$start_ip" | rev | cut -d '.' -f 2- | rev).$current_ip"
        check_connectivity "$current_address"
        ((current_ip++))
    done
done < "$ip_ranges_file"

