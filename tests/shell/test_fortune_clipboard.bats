#!/usr/bin/env bats

# Tests for fortune_clipboard.sh

setup() {
    # Create a temporary directory for testing
    TEST_DIR="$(mktemp -d)"
    SCRIPT_DIR="$TEST_DIR/scripts"
    mkdir -p "$SCRIPT_DIR"

    # Copy the script to test directory
    cp scripts/fortune_clipboard.sh "$SCRIPT_DIR/"

    # Create a mock fortune command
    cat > "$TEST_DIR/fortune" << 'EOF'
#!/bin/bash
echo "╔═════════════════════════════ 🪄 Fortune Cookie ══════════════════════════════╗"
echo "║                                                                            ║"
echo "║  Test fortune message with multiple lines                                  ║"
echo "║  This is a mock fortune for testing                                       ║"
echo "║                                                                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
EOF
    chmod +x "$TEST_DIR/fortune"

    # Mock pbcopy command
    cat > "$TEST_DIR/pbcopy" << 'EOF'
#!/bin/bash
# Store clipboard content in a file for verification
echo "$@" > "$TEST_DIR/clipboard_content.txt"
EOF
    chmod +x "$TEST_DIR/pbcopy"

    # Set up PATH to use our mocks
    export PATH="$TEST_DIR:$PATH"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "fortune_clipboard.sh runs without error" {
    cd "$SCRIPT_DIR"

    # Create a simple mock pbcopy
    cat > "$SCRIPT_DIR/pbcopy" << 'EOF'
#!/bin/bash
# Just succeed
exit 0
EOF
    chmod +x "$SCRIPT_DIR/pbcopy"

    run ./fortune_clipboard.sh

    [ "$status" -eq 0 ]

    # Check that output contains expected message
    [[ "$output" == *"🪄 Fortune copied to clipboard:"* ]]
}

@test "fortune_clipboard.sh handles fortune command failure" {
    cd "$SCRIPT_DIR"

    # Create a failing fortune command
    cat > "$TEST_DIR/fortune" << 'EOF'
#!/bin/bash
echo "Command failed" >&2
exit 1
EOF
    chmod +x "$TEST_DIR/fortune"

    run ./fortune_clipboard.sh

    # Should still exit successfully even if fortune fails
    [ "$status" -eq 0 ]
}

@test "fortune_clipboard.sh displays cleaned fortune text" {
    cd "$SCRIPT_DIR"

    run ./fortune_clipboard.sh

    # Should show the fortune without box drawing characters
    [[ "$output" == *"Test fortune message with multiple lines"* ]]
    [[ "$output" == *"This is a mock fortune for testing"* ]]

    # Should not contain box drawing characters
    [[ "$output" != *"╔"* ]]
    [[ "$output" != *"║"* ]]
    [[ "$output" != *"╝"* ]]
}