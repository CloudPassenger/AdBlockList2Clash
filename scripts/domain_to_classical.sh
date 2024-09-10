#!/bin/bash

# Check if the input file and output file are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_yaml_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 1
fi

# Process the file content
sed '
    # Replace Behavior line
    s/# Behavior: domain/# Behavior: classical/
    # Start processing after payload: line
    /^payload:/,$ {
        # Replace "+. 为 "DOMAIN-SUFFIX,
        s/^  - ""+\./  - "DOMAIN-SUFFIX,/
        # For lines not starting with "+.", add "DOMAIN," at the beginning
        s/^  - "\([^D"]\)/  - "DOMAIN,\1/
    }
' "$input_file" > "$output_file"

echo "✨ Conversion completed. Output saved to $output_file"

