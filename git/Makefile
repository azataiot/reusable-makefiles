# Check for uncommitted changes
ensure-clean:
	@if ! git diff-index --quiet HEAD -- || ! git diff --staged --quiet; then \
		echo "Uncommitted or unstaged changes found. Please commit and stage your changes."; \
		exit 1; \
	fi

# Check if current branch is dev
ensure-dev-branch:
	@if [ "$(shell git rev-parse --abbrev-ref HEAD)" != "dev" ]; then \
		echo "Current branch is not dev. Please switch to the dev branch."; \
		exit 1; \
	fi

# Also need to write a script to ensure that the pre-commit is installed.
ensure-pre-commit:
	@command -v pre-commit >/dev/null 2>&1 || { echo >&2 "Pre-commit is not installed. Aborting."; exit 1; }


## Run pre-commit hooks
pre-commit:
	@echo "Running pre-commit..."
	@pre-commit run --all-files
	@echo "Done!"