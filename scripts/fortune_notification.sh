#!/bin/bash

# Send fortune as macOS desktop notification
# Usage: ./fortune_notification.sh [title]

TITLE="${1:-🪄 Fortune Cookie}"

# Get a fortune and clean it up for notification
FORTUNE=$(fortune 2>&1 | sed 's/╔═════════════════════════════ 🪄 Fortune Cookie ══════════════════════════════╗//g' | \
                      sed 's/╚══════════════════════════════════════════════════════════════════════════════╝//g' | \
                      sed 's/║//g' | \
                      sed 's/^ *//g' | \
                      sed '/^$/d' | \
                      tr '\n' ' ' | \
                      sed 's/  */ /g' | \
                      cut -c 1-200)  # Limit to 200 chars for notification

# Escape the fortune text for AppleScript properly
# Use base64 encoding to avoid escaping issues with special characters
FORTUNE_B64=$(printf '%s' "$FORTUNE" | base64)
TITLE_B64=$(printf '%s' "$TITLE" | base64)

# Use AppleScript that decodes the base64 strings
osascript <<EOF 2>&1
set fortuneText to do shell script "echo '$FORTUNE_B64' | base64 -d"
set dialogTitle to do shell script "echo '$TITLE_B64' | base64 -d"
tell application "System Events"
    display dialog fortuneText with title dialogTitle buttons {"OK"} default button "OK"
end tell
EOF
EXIT_CODE=$?

# Exit with appropriate code
if [[ $EXIT_CODE -eq 0 ]]; then
    exit 0
else
    echo "ERROR: Failed to display notification (exit code: $EXIT_CODE)" >&2
    echo "Fortune was: $FORTUNE" >&2
    exit $EXIT_CODE
fi