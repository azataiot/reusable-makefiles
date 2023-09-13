# pre-commit/Makefile

.PHONY: pre-commit

# EAlso need to write a script to ensure that the pre-commit is installed.
ensure-pre-commit:
	@command -v pre-commit >/dev/null 2>&1 || { echo >&2 "Pre-commit is not installed. Aborting."; exit 1; }


## Run pre-commit hooks
pre-commit:
	@echo "Running pre-commit..."
	@pre-commit run --all-files
	@echo "Done!"
