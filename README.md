# reusable-makefiles
[![Code Quality](https://github.com/azataiot/reusable-makefiles/actions/workflows/code-quality.yaml/badge.svg)](https://github.com/azataiot/reusable-makefiles/actions/workflows/code-quality.yaml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/azataiot/reusable-makefiles)](https://github.com/azataiot/reusable-makefiles/releases)

A way of automating and reusing Makefiles.


## Installation

There is nothing you need to do except either copying the content below, and create a `Makefile` in your project root.

```makefile
.PHONY: help add-target remove-target remove-target-file update-targets

.DEFAULT_GOAL := help

INDEX_FILE = ~/.Makefiles/index.txt

# -- global targets--
## This help screen
help:
	@echo "Available targets:"
	@awk '/^[a-zA-Z\-\_0-9%:\\ ]+/ { \
	  helpMessage = match(lastLine, /^## (.*)/); \
	  if (helpMessage) { \
	    helpCommand = $$1; \
	    helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	    gsub("\\\\", "", helpCommand); \
	    gsub(":+$$", "", helpCommand); \
	    printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
	  } \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u

## Update the index of available Makefiles
update-targets:
	@mkdir -p ~/.Makefiles
	@echo "Fetching directory structure from the repository..."
	@curl -s "https://api.github.com/repos/azataiot/reusable-makefiles/git/trees/main?recursive=1" | \
	awk -F'"' '/"path":/ && /Makefile/ {print $$4}' > temp_index.txt
	@mv temp_index.txt $(INDEX_FILE)
	@echo "Updated the Makefile index."

## Add a reusable Makefile from the repository
add-target:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Please specify a target path using 'make add-target <path>'"; \
		exit 1; \
	fi; \
	TARGET_PATH=$(filter-out $@,$(MAKECMDGOALS)); \
	if grep -q "$$TARGET_PATH/Makefile" $(INDEX_FILE); then \
		mkdir -p ~/.Makefiles/$$TARGET_PATH; \
		wget -q --no-check-certificate -O ~/.Makefiles/$$TARGET_PATH/Makefile https://github.com/azataiot/reusable-makefiles/raw/main/$$TARGET_PATH/Makefile; \
		if ! grep -q "include ~/.Makefiles/$$TARGET_PATH/Makefile" Makefile; then \
			echo "include ~/.Makefiles/$$TARGET_PATH/Makefile" >> Makefile; \
			PHONY_TARGETS=$$(awk '/.PHONY:/ {print $$2}' ~/.Makefiles/$$TARGET_PATH/Makefile); \
			echo ".PHONY: $$PHONY_TARGETS" >> Makefile; \
			echo "Added $$TARGET_PATH Makefile to the current project."; \
		else \
			echo "$$TARGET_PATH Makefile is already included in the current project, skipping."; \
		fi; \
	else \
		echo "Error: $$TARGET_PATH Makefile not found in the index."; \
	fi


## Remove a reusable Makefile reference from the current Makefile
remove-target:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Please specify a target path using 'make remove-target <path>'"; \
		exit 1; \
	fi; \
	TARGET_PATH=$(filter-out $@,$(MAKECMDGOALS)); \
	if grep -q "$$TARGET_PATH/Makefile" $(INDEX_FILE); then \
		PHONY_TARGETS=$$(awk '/.PHONY:/ {print $$2}' ~/.Makefiles/$$TARGET_PATH/Makefile); \
		sed -i.bak '/.PHONY: $$PHONY_TARGETS/d' Makefile; \
		sed -i.bak '/include ~\/.Makefiles\/'$$TARGET_PATH'\/Makefile/d' Makefile; \
		echo "Removed $$TARGET_PATH Makefile reference from the current project."; \
	else \
		echo "Error: $$TARGET_PATH Makefile not found in the index."; \
	fi



## Remove a downloaded Makefile from disk
remove-target-file: remove-target
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Please specify a target path using 'make remove-target-file <path>'"; \
		exit 1; \
	fi; \
	TARGET_PATH=$(filter-out $@,$(MAKECMDGOALS)); \
	if grep -q "$$TARGET_PATH/Makefile" $(INDEX_FILE); then \
		rm -rf ~/.Makefiles/$$TARGET_PATH; \
		echo "Removed $$TARGET_PATH Makefile from disk."; \
	else \
		echo "Error: $$TARGET_PATH Makefile not found in the index."; \
	fi

# This is a workaround to allow passing arguments to Make targets
%:
	@:
```

Notice:

- The `INDEX_FILE` variable is set to `~/.Makefiles/index.txt` which is the index file that contains the list of all
  available Makefiles in this repository. You can change it to any other path you want.
- **I've not tested this on windows,** and It should work on windows as well, but I'm not sure. If you have any issues
  please let me know.

## Usage Examples

**default targets:**

```bash
❯ make help
Available targets:
  add-target                          Add a reusable Makefile from the repository
  help                                This help screen
  remove-target                       Remove a reusable Makefile reference from the current Makefile
  remove-target-file                  Remove a downloaded Makefile from disk
  update-targets                      Update the index of available Makefiles
```

**add-target:**  : Add a target fom this repository and includes it.
For example: in this repository we have a dir named as `git` and we can include the targets inside `git/Makefile` by
running:

**remove-target:** : Remove the previously included target from the current Makefile.

**remove-target-file:** : Remove the previously downloaded target from disk. (Please make sure that none of targets you
are removing are used in any other projects as well, safer to use the `remove-target` target instead)

## How this work?

Each directory (folder) in this repository is a target collection ( or a target group, whatever you call it, naming is
really hard) that includes a Makefile with targets that can be included in other projects.
And the folder can be nested as well, for example: `version/simple` is a target group that includes a
Makefile `version/simple/Makefile` that can be included in other projects.
