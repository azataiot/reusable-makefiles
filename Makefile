.PHONY: help add remove remove-makefile

.DEFAULT_GOAL := help

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

## Add a reusable Makefile from the repository
add:
	@if [ -z "$(name)" ]; then \
		echo "Please specify a name using 'make add name=xxx'"; \
		exit 1; \
	fi; \
	mkdir -p ~/.Makefiles/$(name); \
	wget -O ~/.Makefiles/$(name)/Makefile https://github.com/azataiot/reusable-makefiles/raw/main/$(name)/Makefile; \
	echo "include ~/.Makefiles/$(name)/Makefile" >> Makefile; \
	echo "Added $(name) Makefile to the current project."

## Remove a reusable Makefile reference from the current Makefile
remove:
	@if [ -z "$(name)" ]; then \
		echo "Please specify a name using 'make remove name=xxx'"; \
		exit 1; \
	fi; \
	sed -i.bak '/include ~\/.Makefiles\/$(name)\/Makefile/d' Makefile; \
	echo "Removed $(name) Makefile reference from the current project."

## Remove a downloaded Makefile from disk
remove-makefile:
	@if [ -z "$(name)" ]; then \
		echo "Please specify a name using 'make remove-makefile name=xxx'"; \
		exit 1; \
	fi; \
	rm -rf ~/.Makefiles/$(name); \
	echo "Removed $(name) Makefile from disk."
