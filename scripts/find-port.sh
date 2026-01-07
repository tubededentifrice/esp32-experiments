#!/bin/bash
# Find which USB port your ESP32 is connected to
# Run this if you're not sure which port to use!

echo "🔍 Looking for ESP32..."
echo ""

# Look for CP210x devices (the USB chip on the ESP32)
PORTS=$(ls /dev/cu.* 2>/dev/null | grep -E "(usbserial|SLAB|CP210)" || true)

if [ -z "$PORTS" ]; then
    # Try a broader search
    PORTS=$(ls /dev/cu.usbserial* 2>/dev/null || true)
fi

if [ -z "$PORTS" ]; then
    echo "❌ No ESP32 found!"
    echo ""
    echo "Things to check:"
    echo "  1. Is the USB cable plugged in?"
    echo "  2. Is it a DATA cable? (some cables only charge)"
    echo "  3. Try a different USB port"
    echo "  4. Try unplugging and plugging back in"
    echo ""
    echo "All available ports:"
    ls /dev/cu.* 2>/dev/null || echo "  (none found)"
    exit 1
fi

echo "✅ Found ESP32 at:"
echo ""
for PORT in $PORTS; do
    echo "   $PORT"
done
echo ""

# Save the first port found to a config file for other scripts
FIRST_PORT=$(echo "$PORTS" | head -n 1)
echo "$FIRST_PORT" > "$(dirname "$0")/../.esp32-port"
echo "📝 Saved '$FIRST_PORT' as your default port"
echo "   (Other scripts will use this automatically)"
echo ""
