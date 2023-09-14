# version/simple/Makefile

.PHONY: simple-version

## Set or bump the version
version:
	@if [ ! -f .VERSION ]; then \
		echo "0.0.1" > .VERSION; \
		echo "No current version found. Created version 0.0.1"; \
	fi; \
	echo "Current version: $$(cat .VERSION)"; \
	read -p "Enter new version: " new_version; \
	if [ "$$new_version" ]; then \
		echo "$$new_version" > .VERSION; \
		echo "Version set to $$new_version"; \
		git add .VERSION; \
		git commit -m "Bump version to $$new_version"; \
	else \
		echo "No version input provided. Version remains unchanged."; \
	fi
