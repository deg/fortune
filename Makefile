.PHONY: help install run build clean test

# Default shell
SHELL := /bin/bash

help:
	@echo "Available commands:"
	@echo "  make install  - Install dependencies and project in editable mode"
	@echo "  make run      - Run the fortune CLI"
	@echo "  make build    - Build the project"
	@echo "  make clean    - Remove build artifacts and virtual environment"
	@echo "  make test     - Run tests (if any)"

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
