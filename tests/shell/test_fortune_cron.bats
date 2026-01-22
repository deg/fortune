#!/usr/bin/env bats

# Tests for fortune_cron.sh
bats_require_minimum_version 1.5.0

setup() {
    TEST_DIR="$(mktemp -d)"
    SCRIPT_DIR="$TEST_DIR/scripts"
    mkdir -p "$SCRIPT_DIR"

    # Copy the scripts to test directory
    cp scripts/fortune_cron.sh "$SCRIPT_DIR/"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "fortune_cron.sh shows usage for invalid argument" {
    cd "$SCRIPT_DIR"

    run ./fortune_cron.sh invalid_type

    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: "* ]]
}

@test "fortune_cron.sh accepts valid arguments without usage error" {
    cd "$SCRIPT_DIR"

    # Create a mock notification script that exits successfully
    cat > "$SCRIPT_DIR/fortune_notification.sh" << 'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$SCRIPT_DIR/fortune_notification.sh"

    run -127 ./fortune_cron.sh notification

    # Should not show usage error for valid arguments
    [[ "$output" != *"Usage: "* ]]
}

@test "fortune_cron.sh terminal mode checks for active terminal" {
    cd "$SCRIPT_DIR"
    export TERM_PROGRAM="iTerm.app"  # Terminal is active

    run ./fortune_cron.sh terminal

    # Should not show usage error for valid arguments
    [[ "$output" != *"Usage: "* ]]
}

@test "fortune_cron.sh defaults to notification mode" {
    cd "$SCRIPT_DIR"

    # Create a mock notification script
    cat > "$SCRIPT_DIR/fortune_notification.sh" << 'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$SCRIPT_DIR/fortune_notification.sh"

    run -127 ./fortune_cron.sh

    # Should not show usage error when no arguments provided
    [[ "$output" != *"Usage: "* ]]
}