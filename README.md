# Fortune Python

A simple CLI tool that prints a random fortune.

## Tooling

This project uses [uv](https://github.com/astral-sh/uv) for dependency management and project workflows.

## Getting Started

### Installation

Use the Makefile to install dependencies and set up the virtual environment:

```bash
make install
```

### Usage

Run the CLI tool using `uv run`:

```bash
make run
```

Or run it directly via `uv`:

```bash
uv run fortune
```

## Makefile Commands

- `make install`: Sets up the project and syncs dependencies.
- `make run`: Executes the `fortune` command.
- `make build`: Builds the package (wheel and source distribution).
- `make clean`: Removes temporary files and the `.venv`.
- `make test`: Runs unit tests.
