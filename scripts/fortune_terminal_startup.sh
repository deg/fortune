#!/bin/bash

# Smart fortune display for terminal startup
# Shows fortune only occasionally to avoid being annoying

# Configuration
FORTUNE_CHANCE=0.3  # 30% chance to show fortune
LAST_FORTUNE_FILE="$HOME/.last_fortune_time"
MIN_INTERVAL_MINUTES=60  # Don't show more often than once per hour

# Check if we should show a fortune
show_fortune() {
    # Check time since last fortune
    if [[ -f "$LAST_FORTUNE_FILE" ]]; then
        last_time=$(cat "$LAST_FORTUNE_FILE")
        current_time=$(date +%s)
        time_diff=$((current_time - last_time))
        min_interval_seconds=$((MIN_INTERVAL_MINUTES * 60))

        if [[ $time_diff -lt $min_interval_seconds ]]; then
            return 1  # Too soon, don't show
        fi
    fi

    # Random chance check
    if [[ $(echo "scale=2; $RANDOM/32767 < $FORTUNE_CHANCE" | bc -l) == "1" ]]; then
        echo "$(date +%s)" > "$LAST_FORTUNE_FILE"
        return 0  # Show fortune
    fi

    return 1  # Don't show
}

# Only show fortune if conditions are met
if show_fortune; then
    echo
    fortune
    echo
fi