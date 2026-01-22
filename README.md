# Fortune Python

A simple CLI tool that prints a random fortune.

## Tooling

This project uses [uv](https://github.com/astral-sh/uv) for dependency management and project workflows.

## Getting Started

### Installation

#### Option 1: Global Installation (Recommended)

Install the fortune command globally for system-wide access:

```bash
uv tool install --editable .
```

This makes `fortune` available from anywhere in your terminal.

#### Option 2: Local Development

Use the Makefile to install dependencies and set up the virtual environment:

```bash
make install
```

### Usage

Once installed globally, simply run:

```bash
fortune
```

For local development, you can also use:

```bash
make run
# or
uv run fortune
```

## Makefile Commands

- `make install`: Sets up the project and syncs dependencies.
- `make run`: Executes the `fortune` command.
- `make build`: Builds the package (wheel and source distribution).
- `make clean`: Removes temporary files and the `.venv`.
- `make test`: Runs unit tests.
