#!/usr/bin/env bats

# Tests for fortune_terminal_startup.sh

setup() {
    TEST_DIR="$(mktemp -d)"
    SCRIPT_DIR="$TEST_DIR/scripts"
    mkdir -p "$SCRIPT_DIR"

    # Copy the script to test directory
    cp scripts/fortune_terminal_startup.sh "$SCRIPT_DIR/"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "fortune_terminal_startup.sh runs without error" {
    cd "$SCRIPT_DIR"

    # Create a mock bc that always succeeds
    cat > "$SCRIPT_DIR/bc" << 'EOF'
#!/bin/bash
echo "1"
EOF
    chmod +x "$SCRIPT_DIR/bc"

    # Create a mock fortune
    cat > "$SCRIPT_DIR/fortune" << 'EOF'
#!/bin/bash
echo "Test fortune"
EOF
    chmod +x "$SCRIPT_DIR/fortune"

    run ./fortune_terminal_startup.sh

    [ "$status" -eq 0 ]
}

@test "fortune_terminal_startup.sh handles bc failure" {
    cd "$SCRIPT_DIR"

    # Create a mock bc that always fails
    cat > "$SCRIPT_DIR/bc" << 'EOF'
#!/bin/bash
echo "0"
EOF
    chmod +x "$SCRIPT_DIR/bc"

    run ./fortune_terminal_startup.sh

    [ "$status" -eq 0 ]
    # Should not output anything when probability fails
    [[ "$output" == "" ]]
}