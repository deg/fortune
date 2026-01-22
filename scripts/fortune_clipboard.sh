#!/bin/bash

# Copy fortune to clipboard for easy sharing
# Usage: ./fortune_clipboard.sh

FORTUNE=$(fortune | sed 's/╔═════════════════════════════ 🪄 Fortune Cookie ══════════════════════════════╗//g' | \
                      sed 's/╚══════════════════════════════════════════════════════════════════════════════╝//g' | \
                      sed 's/║//g' | \
                      sed 's/^ *//g' | \
                      sed '/^$/d' | \
                      sed 's/^/  /g')

# Copy to clipboard
echo -n "$FORTUNE" | pbcopy

echo "🪄 Fortune copied to clipboard:"
echo "$FORTUNE"