.PHONY: help install run build clean test test-shell test-all data setup notify clipboard cron-test

# Default shell
SHELL := /bin/bash

help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies and project in editable mode"
	@echo "  make run        - Run the fortune CLI"
	@echo "  make build      - Build the project"
	@echo "  make clean      - Remove build artifacts and virtual environment"
	@echo "  make test       - Run Python tests"
	@echo "  make test-shell - Run shell script tests (requires: brew install bats-core)"
	@echo "  make test-all   - Run all tests (Python + shell scripts)"
	@echo "  make test-cov   - Run Python tests with coverage report"
	@echo "  make data       - Download fortune data files"
	@echo "  make setup      - Set up fortune integrations (terminal, cron, etc.)"
	@echo "  make notify     - Send fortune as desktop notification"
	@echo "  make clipboard  - Copy fortune to clipboard"
	@echo "  make cron-test  - Test cron fortune delivery (scripts/ directory)"

install:
	uv sync

run:
	uv run fortune

build:
	uv build

clean:
	rm -rf dist .venv .uv
	find . -type d -name "__pycache__" -exec rm -rf {} +

test-python:
	python -m pytest

test-shell:
	@if command -v bats >/dev/null 2>&1; then \
		bats tests/shell/; \
	else \
		echo "Error: bats not found. Install with: brew install bats-core"; \
		exit 1; \
	fi

test: test-python test-shell

test-cov:
	python -m pytest --cov=fortune --cov-report=term-missing

# Download fortune data files from the BSD fortune program
# Source: OpenBSD fortune game source code
# https://cvsweb.openbsd.org/cgi-bin/cvsweb/src/games/fortune/fortune/
data:
	mkdir -p fortune/data
	curl -o fortune/data/fortunes https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes
	curl -o fortune/data/fortunes2 https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes2

setup:
	./scripts/setup_integrations.sh

notify:
	./scripts/fortune_notification.sh

clipboard:
	./scripts/fortune_clipboard.sh

cron-test:
	./scripts/fortune_cron.sh notification
