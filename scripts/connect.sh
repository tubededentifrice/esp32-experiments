#!/bin/bash
# Connect to the ESP32 REPL (interactive Python)
# This lets you type Python commands directly!

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PORT_FILE="$PROJECT_DIR/.esp32-port"

echo "🐍 Connecting to ESP32 Python..."
echo ""

# Get the port
if [ -f "$PORT_FILE" ]; then
    PORT=$(cat "$PORT_FILE")
else
    echo "❌ No port saved! Run ./scripts/find-port.sh first"
    exit 1
fi

# Check if port exists
if [ ! -e "$PORT" ]; then
    echo "❌ Port $PORT not found!"
    echo "   Is the ESP32 connected?"
    echo "   Try running ./scripts/find-port.sh again"
    exit 1
fi

echo "📍 Connecting to $PORT"
echo ""
echo "═══════════════════════════════════════════"
echo " Keyboard shortcuts:"
echo "   Ctrl+C = Stop running code"
echo "   Ctrl+D = Restart the ESP32"
echo "   Ctrl+X = Exit (go back to terminal)"
echo "═══════════════════════════════════════════"
echo ""

# Connect using mpremote
mpremote connect "$PORT" repl
