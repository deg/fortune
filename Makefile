.PHONY: help install run build clean test test-python test-shell test-all test-cov data setup notify clipboard cron-test

# Default shell
SHELL := /bin/bash

.PHONY: help
help:
	@echo -e "\033[1;34mUsage:\033[0m make [target]"
	@echo ""
	@echo -e "\033[1;36mTargets:\033[0m"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	    helpMessage = match(lastComment, /^# (.*)/); \
	    helpCommand = $$1; sub(/:$$/, "", helpCommand); \
	    if (helpMessage) { \
	        printf "  \033[1;32m%-20s\033[0m \033[0;37m%s\033[0m\n", helpCommand, substr(lastComment, RSTART + 2, RLENGTH - 2); \
	    } else { \
	        printf "  \033[1;32m%-20s\033[0m \033[0;33m??? [No description]\033[0m\n", helpCommand; \
	    } \
	    lastComment = ""; \
	} \
	/^# / { \
	    lastComment = $$0; \
	} \
	/^\.PHONY:/ { \
	    next; \
	}' $(MAKEFILE_LIST) | sort
	@echo ""



# Install dependencies and project in editable mode
.PHONY: install
install:
	uv sync --extra dev

# Run the fortune CLI
.PHONY: run
run:
	uv run fortune

# Build the project
.PHONY: build
build:
	uv build

# Remove build artifacts and virtual environment
.PHONY: clean
clean:
	rm -rf dist .venv .uv
	find . -type d -name "__pycache__" -exec rm -rf {} +

# Run Python tests
.PHONY: test-python
test-python:
	uv run python -m pytest

# Run shell script tests (requires: brew install bats-core)
.PHONY: test-shell
test-shell:
	@if command -v bats >/dev/null 2>&1; then \
		bats tests/shell/; \
	else \
		echo "Error: bats not found. Install with: brew install bats-core"; \
		exit 1; \
	fi

# Run all tests (Python + shell scripts)
.PHONY: test
test: test-python test-shell


# Run Python tests with coverage report
.PHONY: test-cov
test-cov:
	uv run python -m pytest --cov=fortune --cov-report=term-missing

# Test cron fortune delivery (scripts/ directory)
.PHONY: test-cron
test-cron:
	./scripts/fortune_cron.sh notification test

# Download fortune data files from BSD fortune program
data:
	mkdir -p fortune/data
	curl -o fortune/data/fortunes https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes
	curl -o fortune/data/fortunes2 https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes2

# Set up fortune integrations (terminal, cron, etc.)
.PHONY: setup
setup:
	./scripts/setup_integrations.sh

# Send fortune as desktop notification
.PHONY: notify
notify:
	./scripts/fortune_notification.sh

# Copy fortune to clipboard
.PHONY: clipboard
clipboard:
	./scripts/fortune_clipboard.sh







