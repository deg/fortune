# Development Setup

This document contains technical setup information for developers working on the Fortune project.

## Tooling

This project uses [uv](https://github.com/astral-sh/uv) for dependency management and project workflows.

## Development Installation

For local development, use the Makefile to install dependencies and set up the virtual environment:

```bash
make install
```

## Makefile Commands

- `make install`: Sets up the project and syncs dependencies.
- `make run`: Executes the `fortune` command.
- `make build`: Builds the package (wheel and source distribution).
- `make clean`: Removes temporary files and the `.venv`.
- `make test`: Runs unit tests.
- `make test-cov`: Runs tests with coverage report.

## Testing

The project includes comprehensive testing for both Python code and shell scripts:

### Python Tests
Unit tests covering:
- Fortune file parsing (BSD format with `%` separators)
- Error handling for missing/corrupted files
- CLI argument parsing (`--help`, `-h`)
- Edge cases (empty directories, hidden files, encoding issues)

### Shell Script Tests
Shell script tests using [Bats](https://github.com/bats-core/bats-core) covering:
- `fortune_clipboard.sh`: Clipboard functionality and text cleaning
- `fortune_cron.sh`: Cron job logic, quiet hours, and activity detection
- `fortune_notification.sh`: Desktop notifications with character limits and fallbacks
- `fortune_terminal_startup.sh`: Smart timing with probability and interval checks
- `setup_integrations.sh`: Interactive setup with zshrc and cron job configuration

### Running Tests

```bash
# Install Bats for shell script testing
brew install bats-core

# Run Python tests only
make test

# Run shell script tests only
make test-shell

# Run all tests (Python + shell scripts)
make test-all

# Run Python tests with coverage report
make test-cov
```