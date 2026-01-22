#!/bin/bash

# Send fortune as macOS desktop notification
# Usage: ./fortune_notification.sh [title]

TITLE="${1:-🪄 Fortune Cookie}"

# Get a fortune and clean it up for notification
FORTUNE=$(fortune | sed 's/╔═════════════════════════════ 🪄 Fortune Cookie ══════════════════════════════╗//g' | \
                      sed 's/╚══════════════════════════════════════════════════════════════════════════════╝//g' | \
                      sed 's/║//g' | \
                      sed 's/^ *//g' | \
                      sed '/^$/d' | \
                      tr '\n' ' ' | \
                      sed 's/  */ /g' | \
                      cut -c 1-200)  # Limit to 200 chars for notification

# Send notification
osascript -e "display notification \"$FORTUNE\" with title \"$TITLE\""