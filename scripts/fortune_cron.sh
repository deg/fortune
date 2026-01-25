#!/bin/bash

# Cron job for periodic fortune delivery
# Add to crontab with: crontab -e
# Example: 0 */2 * * * /path/to/fortune_cron.sh  # Every 2 hours

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Configuration
NOTIFICATION_TYPE="${1:-notification}"  # 'notification' or 'terminal'
TEST_MODE="${2:-}"  # Set to 'test' to bypass checks and show output
QUIET_HOURS_START=23  # Don't show between 10 PM...
QUIET_HOURS_END=10     # ...and 8 AM

# Skip checks in test mode
if [[ "$TEST_MODE" != "test" ]]; then
    # Check if we're in quiet hours
    current_hour=$(date +%H)
    if [[ $current_hour -ge $QUIET_HOURS_START ]] || [[ $current_hour -le $QUIET_HOURS_END ]]; then
        exit 0  # Quiet time, don't disturb
    fi

    # Check if user is active (has been idle less than 30 minutes)
    idle_time=$(ioreg -c IOHIDSystem 2>/dev/null | awk '/HIDIdleTime/{print int($NF/1000000000); exit}' || echo "0")
    max_idle_minutes=30
    if [[ -n "$idle_time" ]] && [[ "$idle_time" =~ ^[0-9]+$ ]] && [[ $idle_time -gt $((max_idle_minutes * 60)) ]]; then
        exit 0  # User is idle, don't disturb
    fi
fi

case "$NOTIFICATION_TYPE" in
    "notification")
        if [[ "$TEST_MODE" == "test" ]]; then
            # In test mode, show fortune in terminal and try notification
            echo "🧪 Test Mode: Showing fortune..."
            echo
            fortune
            echo
            echo "🧪 Test Mode: Attempting notification..."
        fi
        "$SCRIPT_DIR/fortune_notification.sh"
        ;;
    "terminal")
        # Only show if terminal is active (or in test mode)
        if [[ "$TEST_MODE" == "test" ]] || [[ -n "$TERM_PROGRAM" ]] || [[ -n "$TMUX" ]]; then
            echo
            fortune
            echo
        fi
        ;;
    *)
        echo "Usage: $0 [notification|terminal] [test]"
        exit 1
        ;;
esac
