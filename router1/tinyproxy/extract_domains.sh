#!/bin/bash

# Replace 'your_input_file.txt' with the actual input file path
input_file="blacklist.txt"

# Use grep and cut to extract domain names
grep -oE '([0-9]+\.){3}[0-9]+\s+[a-zA-Z0-9.-]+' "$input_file" | cut -f2 -d' '

