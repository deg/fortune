#!/usr/bin/env bats

# Tests for fortune_notification.sh

setup() {
    TEST_DIR="$(mktemp -d)"
    SCRIPT_DIR="$TEST_DIR/scripts"
    mkdir -p "$SCRIPT_DIR"

    # Copy the script to test directory
    cp scripts/fortune_notification.sh "$SCRIPT_DIR/"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "fortune_notification.sh accepts custom title argument" {
    cd "$SCRIPT_DIR"

    # Create a mock osascript that just succeeds
    cat > "$SCRIPT_DIR/osascript" << 'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$SCRIPT_DIR/osascript"

    PATH="$SCRIPT_DIR:$PATH" run ./fortune_notification.sh "Custom Title"

    [ "$status" -eq 0 ]
}

@test "fortune_notification.sh works with default title" {
    cd "$SCRIPT_DIR"

    # Create a mock osascript that just succeeds
    cat > "$SCRIPT_DIR/osascript" << 'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$SCRIPT_DIR/osascript"

    PATH="$SCRIPT_DIR:$PATH" run ./fortune_notification.sh

    [ "$status" -eq 0 ]
}

@test "fortune_notification.sh handles osascript failure gracefully" {
    cd "$SCRIPT_DIR"

    # Create a mock osascript that fails (like it would in a sandboxed environment)
    cat > "$SCRIPT_DIR/osascript" << 'EOF'
#!/bin/bash
# Read all input (like real osascript does)
cat > /dev/null
# Then fail
exit 1
EOF
    chmod +x "$SCRIPT_DIR/osascript"

    # Make sure PATH includes SCRIPT_DIR so the mock is found
    PATH="$SCRIPT_DIR:$PATH" run ./fortune_notification.sh

    [ "$status" -eq 0 ]
    # Should show fallback message
    [[ "$output" == *"Dialog would display:"* ]]
}

@test "fortune_notification.sh processes fortune output" {
    cd "$SCRIPT_DIR"

    # Create a mock osascript that captures input
    cat > "$SCRIPT_DIR/osascript" << 'EOF'
#!/bin/bash
# Capture what would be displayed
cat > /tmp/notification_content.txt
exit 0
EOF
    chmod +x "$SCRIPT_DIR/osascript"

    # Create a mock fortune
    cat > "$SCRIPT_DIR/fortune" << 'EOF'
#!/bin/bash
echo "╔═════════════════════════════ 🪄 Fortune Cookie ══════════════════════════════╗"
echo "║                                                                            ║"
echo "║  Test fortune message                                                     ║"
echo "║                                                                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
EOF
    chmod +x "$SCRIPT_DIR/fortune"

    PATH="$SCRIPT_DIR:$PATH" run ./fortune_notification.sh

    [ "$status" -eq 0 ]

    # The script should have processed the fortune and called osascript
    # We can't easily test the exact output without more complex mocking,
    # but we can verify it ran without errors
}