#!/bin/bash

# scripts/check_phony.sh

# Initialize an associative array to store PHONY targets
declare -A phony_targets

# Loop through all Makefiles in the repository
find . -name 'Makefile' | while IFS= read -r file; do
    # Check if .PHONY is present in the Makefile
    if ! grep -q '.PHONY' "$file"; then
        echo "Error: $file does not contain .PHONY"
        exit 1
    else
        # Extract PHONY targets and check for duplicates
        targets=$(grep '.PHONY:' "$file" | cut -d ':' -f 2)
        for target in $targets; do
            if [[ ${phony_targets["$target"]} ]]; then
                echo "Error: Duplicate .PHONY target $target found in $file"
                exit 1
            else
                phony_targets["$target"]=1
            fi
        done
    fi
done

echo "All Makefiles contain .PHONY without duplicate targets"
exit 0
