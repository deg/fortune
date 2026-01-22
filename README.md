# Fortune

✨ A delightful CLI tool that brings a touch of wisdom and whimsy to your terminal with random fortunes.

*Licensed under the MIT License*

## Quick Start

### Install
```bash
uv tool install --editable .
```

### Use
```bash
fortune
```

That's it! Get inspired by classic Unix wisdom, one fortune at a time.

## Features

### 🖥️ Smart Terminal Integration
Add fortunes to your terminal startup with intelligent timing:
```bash
make setup  # Adds to ~/.zshrc (shows occasionally, not every shell)
```

### 🔔 Desktop Notifications
Receive periodic fortune notifications during your workday:
```bash
make notify    # Send immediate notification
make setup     # Set up cron job (every 3 hours, 10 AM - 11 PM)
```

### 📋 Clipboard Magic
Copy fortunes to share with friends:
```bash
make clipboard  # Copy current fortune to clipboard
```

### ⚙️ Smart Behavior
- **Quiet Hours**: Automatically respects 11 PM - 10 AM
- **Activity Detection**: Only shows when you've been active
- **Intelligent Timing**: Not every shell session, just occasionally

## For Developers

See [SETUP.md](SETUP.md) for development setup, testing, and technical details.

## License

Copyright (c) 2025 David Goldfarb (deg@degel.com)

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
