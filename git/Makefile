# git/Makefile

.PHONY: push prdev pr branch branch-obsolete


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

## Checkout a new branch
branch:
	@bash -c ' \
	echo "Choose a branch type:"; \
	PS3="Select an option: "; \
	options=("main" "dev" "feature" "release" "hotfix" "temp" "quit"); \
	select opt in "$${options[@]}"; do \
		case $$opt in \
			main) \
				git checkout main; \
				read -p "Do you want to run git pull? [Y/n]: " pull_choice; \
				[ -z "$$pull_choice" ] && pull_choice="Y"; \
				if [ $$pull_choice = "Y" ] || [ $$pull_choice = "y" ]; then \
					git pull origin main; \
				fi; \
				break; \
				;; \
			dev) \
				git rev-parse --verify dev >/dev/null 2>&1 || git checkout -b dev; \
				git checkout dev; \
				read -p "Do you want to run git pull? [Y/n]: " pull_choice; \
				[ -z "$$pull_choice" ] && pull_choice="Y"; \
				if [ $$pull_choice = "Y" ] || [ $$pull_choice = "y" ]; then \
					git pull origin dev; \
				fi; \
				break; \
				;; \
			feature) \
				read -p "Enter the feature name: " feature_name; \
				git checkout -b feature/$$feature_name; \
				break; \
				;; \
			release) \
				read -p "Enter the release version: " version; \
				git checkout -b release/$$version; \
				break; \
				;; \
			hotfix) \
				read -p "Enter the hotfix version: " version; \
				git checkout -b hotfix/$$version; \
				break; \
				;; \
			temp) \
				random_string=$$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13); \
				git checkout -b temp/$$random_string; \
				break; \
				;; \
			quit) \
				echo "Exiting..."; \
				break; \
				;; \
			*) \
				echo "Invalid choice"; \
				;; \
		esac; \
	done; \
	'



## Make the current branch obsolete and remove it from remote and local repositories
branch-obsolete: ensure-clean
	@CURRENT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD); \
	if [[ "$$CURRENT_BRANCH" == main ]] || [[ "$$CURRENT_BRANCH" == dev ]]; then \
		echo "Cannot make $$CURRENT_BRANCH obsolete."; \
		exit 1; \
	fi; \
	echo "Making $$CURRENT_BRANCH obsolete..."; \
	git branch -m obsolete/$$CURRENT_BRANCH; \
	git push origin --delete $$CURRENT_BRANCH; \
	git push origin --delete $$CURRENT_BRANCH --force-with-lease; \
	git push origin obsolete/$$CURRENT_BRANCH; \
	git push origin obsolete/$$CURRENT_BRANCH --force-with-lease; \
	git branch -D obsolete/$$CURRENT_BRANCH; \
	echo "Done!";
