.PHONY: help install run build clean test data

# Default shell
SHELL := /bin/bash

help:
	@echo "Available commands:"
	@echo "  make install  - Install dependencies and project in editable mode"
	@echo "  make run      - Run the fortune CLI"
	@echo "  make build    - Build the project"
	@echo "  make clean    - Remove build artifacts and virtual environment"
	@echo "  make test     - Run tests (if any)"
	@echo "  make data     - Download fortune data files"

install:
	uv sync

run:
	uv run fortune

build:
	uv build

clean:
	rm -rf dist .venv .uv
	find . -type d -name "__pycache__" -exec rm -rf {} +

test:
	uv run python -m unittest discover fortune

# Download fortune data files from the BSD fortune program
# Source: OpenBSD fortune game source code
# https://cvsweb.openbsd.org/cgi-bin/cvsweb/src/games/fortune/fortune/
data:
	mkdir -p fortune/data
	curl -o fortune/data/fortunes https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes
	curl -o fortune/data/fortunes2 https://cdn.openbsd.org/pub/OpenBSD/src/share/games/fortune/fortune/fortunes2
