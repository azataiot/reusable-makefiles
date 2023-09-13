.PHONY: push prdev pr

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

## Push current branch
push: ensure-clean
	@BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD); \
	echo "Pushing to $$BRANCH_NAME branch..."; \
	git push origin $$BRANCH_NAME; \
	if [[ $$BRANCH_NAME == release-* ]] || [[ $$BRANCH_NAME == hotfix-* ]]; then \
		TAG_NAME=$(shell git describe --tags --abbrev=0 2>/dev/null); \
		if [ -n "$$TAG_NAME" ]; then \
			echo "Pushing $$TAG_NAME tag..."; \
			git push origin $$TAG_NAME --force-with-lease; \
		else \
			echo "No tags found to push."; \
		fi; \
	fi;
	echo "Done!";

## Create PR to dev branch
prdev: ensure-clean
	@CURRENT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD); \
	if [[ "$$CURRENT_BRANCH" == release/* ]] || [[ "$$CURRENT_BRANCH" == hotfix/* ]]; then \
		read -p "You are on a $$CURRENT_BRANCH branch. It's recommended to PR release and hotfix branches to main. Do you want to continue creating a PR to dev? (y/N): " confirm; \
		[[ -z "$$confirm" ]] && confirm="N"; \
		[[ $$confirm == [yY] || $$confirm == [yY][eE][sS] ]] || exit 1; \
	fi; \
	echo "Creating PR from $$CURRENT_BRANCH to dev branch..."; \
	gh pr create --base dev --head $$CURRENT_BRANCH; \
	echo "Done!";

## Create PR to main branch from release or hotfix branch
pr: ensure-clean
	@CURRENT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD); \
	if [[ "$$CURRENT_BRANCH" == release/* ]] || [[ "$$CURRENT_BRANCH" == hotfix/* ]]; then \
		echo "Creating PR from $$CURRENT_BRANCH to main branch..."; \
		gh pr create -f --base main --head $$CURRENT_BRANCH; \
		echo "Done!"; \
	else \
		echo "Current branch is not a release or hotfix branch. Please switch to a release or hotfix branch before creating a PR to main."; \
	fi
