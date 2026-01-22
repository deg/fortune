#!/usr/bin/env bats

# Tests for setup_integrations.sh

setup() {
    TEST_DIR="$(mktemp -d)"
    SCRIPT_DIR="$TEST_DIR/scripts"
    mkdir -p "$SCRIPT_DIR"

    # Copy the scripts to test directory
    cp scripts/setup_integrations.sh "$SCRIPT_DIR/"

    # Create test versions of the scripts
    for script in fortune_clipboard.sh fortune_cron.sh fortune_notification.sh fortune_terminal_startup.sh; do
        echo "#!/bin/bash" > "$SCRIPT_DIR/$script"
        echo "echo '$script executed'" >> "$SCRIPT_DIR/$script"
        chmod +x "$SCRIPT_DIR/$script"
    done
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "setup_integrations.sh runs and shows setup information" {
    cd "$SCRIPT_DIR"

    # Create a mock fortune command
    cat > "$SCRIPT_DIR/fortune" << 'EOF'
#!/bin/bash
echo "Mock fortune output"
EOF
    chmod +x "$SCRIPT_DIR/fortune"

    # Create a mock osascript
    cat > "$SCRIPT_DIR/osascript" << 'EOF'
#!/bin/bash
exit 0
EOF
    chmod +x "$SCRIPT_DIR/osascript"

    # Run with input that answers 'n' to all prompts
    run bash -c "echo -e 'n\nn' | ./setup_integrations.sh"

    # The script may exit with non-zero status due to interactive nature
    # but it should produce output
    [[ "$output" == *"🪄 Fortune Integration Setup"* ]]
    [[ "$output" == *"Testing fortune command"* ]]
    [[ "$output" == *"🎉 Setup complete"* ]]
}