#!/bin/bash

# Loop through all Makefiles in the repository
for file in $(find . -name 'Makefile'); do
    # Check if .PHONY is present in the Makefile
    if ! grep -q '.PHONY' "$file"; then
        echo "Error: $file does not contain .PHONY"
        exit 1
    fi
done

echo "All Makefiles contain .PHONY"
exit 0
