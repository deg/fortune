#!/bin/bash

# Setup script for fortune integrations
# Run this to configure various fortune display methods

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORTUNE_DIR="$SCRIPT_DIR"

echo "🪄 Fortune Integration Setup"
echo "============================"

# Make scripts executable
chmod +x "$FORTUNE_DIR"/*.sh

# 1. Terminal startup integration
echo
echo "1. Terminal Startup Integration"
echo "This adds fortune to your shell startup with smart timing"
read -p "Add to ~/.zshrc? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! grep -q "fortune_terminal_startup.sh" ~/.zshrc; then
        echo "# Fortune display on terminal startup" >> ~/.zshrc
        echo "source \"$FORTUNE_DIR/fortune_terminal_startup.sh\"" >> ~/.zshrc
        echo "✅ Added to ~/.zshrc"
    else
        echo "⚠️  Already in ~/.zshrc"
    fi
fi

# 2. Cron job setup
echo
echo "2. Cron Job Setup"
echo "This will show fortunes periodically via notifications"
read -p "Set up cron job for fortunes every 3 hours? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    CRON_JOB="0 */3 * * * \"$FORTUNE_DIR/fortune_cron.sh\" notification"
    if ! crontab -l 2>/dev/null | grep -q "fortune_cron.sh"; then
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ Added cron job (runs every 3 hours during active hours)"
    else
        echo "⚠️  Cron job already exists"
    fi
fi

# 3. Quick test
echo
echo "3. Testing Integration"
echo "Testing fortune command..."
fortune >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "✅ Fortune command works globally"
else
    echo "❌ Fortune command not found. Run: uv tool install --editable ."
fi

echo
echo "Testing notification..."
"$FORTUNE_DIR/fortune_notification.sh" "Test Fortune" >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "✅ Notifications working"
else
    echo "❌ Notifications failed"
fi

echo
echo "🎉 Setup complete!"
echo
echo "Available commands:"
echo "  fortune                    - Manual fortune display"
echo "  ./fortune_notification.sh  - Send desktop notification"
echo "  ./fortune_cron.sh          - Manual cron trigger"
echo
echo "Integration points:"
echo "  - Terminal startup (smart timing)"
echo "  - Cron jobs (periodic notifications)"
echo "  - Manual usage anytime"
echo
echo "To remove cron job: crontab -e"