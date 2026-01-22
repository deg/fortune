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

## Integration Options

Modern fortune delivery for macOS workflows:

### 🖥️ Terminal Startup
Smart integration that shows fortunes occasionally (not every shell):
```bash
./setup_integrations.sh  # Adds to ~/.zshrc with intelligent timing
```

### 🔔 Desktop Notifications
Periodic fortune notifications during active hours:
```bash
./fortune_notification.sh  # Send immediate notification
./setup_integrations.sh    # Set up cron job (every 3 hours)
```

### 📋 Productivity Integration
Copy fortunes to clipboard for sharing:
```bash
./fortune_clipboard.sh  # Copy fortune to clipboard
```

### ⚙️ Custom Integration
- **Cron Jobs**: `./fortune_cron.sh notification` or `./fortune_cron.sh terminal`
- **Quiet Hours**: Automatically respects 10 PM - 8 AM
- **Activity Detection**: Only shows when you've been active recently

## Makefile Commands

- `make install`: Sets up the project and syncs dependencies.
- `make run`: Executes the `fortune` command.
- `make build`: Builds the package (wheel and source distribution).
- `make clean`: Removes temporary files and the `.venv`.
- `make test`: Runs unit tests.
