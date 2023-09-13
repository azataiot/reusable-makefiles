#!/bin/bash

# Temporary file to store all .PHONY targets
temp_file=$(mktemp)

# Loop through all Makefiles in the repository
while IFS= read -r -d '' file; do
    # Debug print: Display the current Makefile being processed
    echo "Processing: $file"

    # Extract .PHONY targets from the Makefile and append to temp_file
    grep -E '^\.PHONY:' "$file" | sed 's/.PHONY: //' | tr ' ' '\n' >> "$temp_file"
done < <(find . -name 'Makefile' -print0)

# Check for duplicate targets
if sort "$temp_file" | uniq -d | grep -q .; then
    echo "Error: Duplicate .PHONY targets found:"
    sort "$temp_file" | uniq -d
    rm -f "$temp_file"
    exit 1
fi

rm -f "$temp_file"
echo "All Makefiles contain .PHONY without duplicate targets"
exit 0
