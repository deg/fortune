#!/bin/bash

# Cron job for periodic fortune delivery
# Add to crontab with: crontab -e
# Example: 0 */2 * * * /path/to/fortune_cron.sh  # Every 2 hours

# Configuration
NOTIFICATION_TYPE="${1:-notification}"  # 'notification' or 'terminal'
QUIET_HOURS_START=23  # Don't show between 10 PM...
QUIET_HOURS_END=10     # ...and 8 AM

# Check if we're in quiet hours
current_hour=$(date +%H)
if [[ $current_hour -ge $QUIET_HOURS_START ]] || [[ $current_hour -le $QUIET_HOURS_END ]]; then
    exit 0  # Quiet time, don't disturb
fi

# Check if user is active (has been idle less than 30 minutes)
idle_time=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/{print int($NF/1000000000)}')
max_idle_minutes=30
if [[ $idle_time -gt $((max_idle_minutes * 60)) ]]; then
    exit 0  # User is idle, don't disturb
fi

case "$NOTIFICATION_TYPE" in
    "notification")
        ./fortune_notification.sh
        ;;
    "terminal")
        # Only show if terminal is active
        if [[ -n "$TERM_PROGRAM" ]] || [[ -n "$TMUX" ]]; then
            echo
            fortune
            echo
        fi
        ;;
    *)
        echo "Usage: $0 [notification|terminal]"
        exit 1
        ;;
esac
