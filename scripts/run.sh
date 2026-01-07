#!/bin/bash
# Run a Python file directly on the ESP32 without uploading
# Good for quick tests!
# Usage: ./scripts/run.sh experiments/01-blink/main.py

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PORT_FILE="$PROJECT_DIR/.esp32-port"

if [ -z "$1" ]; then
    echo "▶️  ESP32 Quick Runner"
    echo ""
    echo "Usage: ./scripts/run.sh <python-file>"
    echo ""
    echo "Example: ./scripts/run.sh experiments/01-blink/main.py"
    echo ""
    echo "This runs the code directly without saving it to the ESP32."
    echo "Good for quick tests!"
    exit 0
fi

PYFILE="$1"

# Handle relative paths
if [[ ! "$PYFILE" = /* ]]; then
    PYFILE="$PROJECT_DIR/$PYFILE"
fi

# Check if file exists
if [ ! -f "$PYFILE" ]; then
    echo "❌ File not found: $PYFILE"
    exit 1
fi

# Get the port
if [ -f "$PORT_FILE" ]; then
    PORT=$(cat "$PORT_FILE")
else
    echo "❌ No port saved! Run ./scripts/find-port.sh first"
    exit 1
fi

echo "▶️  Running $(basename "$PYFILE") on ESP32..."
echo "   Press Ctrl+C to stop"
echo ""
echo "═══════════════════════════════════════════"

mpremote connect "$PORT" run "$PYFILE"
