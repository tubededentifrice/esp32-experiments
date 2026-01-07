#!/bin/bash
# Upload experiment code to the ESP32
# Usage: ./scripts/upload.sh experiments/01-blink

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PORT_FILE="$PROJECT_DIR/.esp32-port"

if [ -z "$1" ]; then
    echo "📤 ESP32 Code Uploader"
    echo ""
    echo "Usage: ./scripts/upload.sh <experiment-folder>"
    echo ""
    echo "Example: ./scripts/upload.sh experiments/01-blink"
    echo ""
    echo "Available experiments:"
    if [ -d "$PROJECT_DIR/experiments" ]; then
        ls -d "$PROJECT_DIR/experiments"/*/ 2>/dev/null | while read dir; do
            name=$(basename "$dir")
            echo "  - experiments/$name"
        done
    else
        echo "  (none yet - create your first experiment!)"
    fi
    exit 0
fi

EXPERIMENT="$1"

# Handle relative paths
if [[ ! "$EXPERIMENT" = /* ]]; then
    EXPERIMENT="$PROJECT_DIR/$EXPERIMENT"
fi

# Check if experiment folder exists
if [ ! -d "$EXPERIMENT" ]; then
    echo "❌ Folder not found: $EXPERIMENT"
    exit 1
fi

# Check for main.py
if [ ! -f "$EXPERIMENT/main.py" ]; then
    echo "❌ No main.py found in $EXPERIMENT"
    echo "   Your code should be in a file called main.py"
    exit 1
fi

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
    exit 1
fi

echo "📤 Uploading to ESP32..."
echo "   From: $EXPERIMENT"
echo "   To: $PORT"
echo ""

# Upload all .py files from the experiment folder
for pyfile in "$EXPERIMENT"/*.py; do
    if [ -f "$pyfile" ]; then
        filename=$(basename "$pyfile")
        echo "   📄 $filename"
        mpremote connect "$PORT" cp "$pyfile" ":$filename"
    fi
done

echo ""
echo "✅ Upload complete!"
echo ""
echo "🔄 Resetting ESP32 to run your code..."
mpremote connect "$PORT" reset

echo ""
echo "💡 To see what's happening, run: ./scripts/connect.sh"
echo ""
