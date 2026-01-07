#!/bin/bash
# Flash MicroPython firmware to the ESP32
# This puts Python onto your ESP32 so you can run Python code!

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FIRMWARE_DIR="$PROJECT_DIR/firmware"
PORT_FILE="$PROJECT_DIR/.esp32-port"

# MicroPython firmware version
FIRMWARE_VERSION="v1.24.1"
FIRMWARE_FILE="ESP32_GENERIC-$FIRMWARE_VERSION.bin"
FIRMWARE_URL="https://micropython.org/resources/firmware/ESP32_GENERIC-20241129-v1.24.1.bin"

echo "🐍 MicroPython Firmware Flasher"
echo "================================"
echo ""

# Get the port
if [ -f "$PORT_FILE" ]; then
    PORT=$(cat "$PORT_FILE")
    echo "📍 Using saved port: $PORT"
else
    echo "❌ No port saved! Run ./scripts/find-port.sh first"
    exit 1
fi

# Check if port exists
if [ ! -e "$PORT" ]; then
    echo "❌ Port $PORT not found!"
    echo "   Try running ./scripts/find-port.sh again"
    exit 1
fi

# Download firmware if needed
if [ ! -f "$FIRMWARE_DIR/$FIRMWARE_FILE" ]; then
    echo ""
    echo "📥 Downloading MicroPython firmware..."
    mkdir -p "$FIRMWARE_DIR"
    curl -L -o "$FIRMWARE_DIR/$FIRMWARE_FILE" "$FIRMWARE_URL"

    if [ $? -ne 0 ]; then
        echo "❌ Failed to download firmware!"
        exit 1
    fi
    echo "✓ Firmware downloaded!"
fi

echo ""
echo "⚠️  IMPORTANT: When you see 'Connecting...' below,"
echo "   HOLD the BOOT button on your ESP32!"
echo "   (It's the button on the left side of the USB port)"
echo ""
echo "Press Enter when you're ready..."
read

# Erase the flash first
echo ""
echo "🧹 Erasing old firmware..."
esptool.py --chip esp32 --port "$PORT" erase_flash

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Erase failed! Did you hold the BOOT button?"
    echo "   Try again and hold BOOT when you see 'Connecting...'"
    exit 1
fi

echo ""
echo "✓ Flash erased!"
echo ""
echo "⚠️  Hold the BOOT button again for the next step!"
echo "Press Enter when ready..."
read

# Flash the new firmware
echo ""
echo "📝 Writing MicroPython firmware..."
esptool.py --chip esp32 --port "$PORT" --baud 460800 write_flash -z 0x1000 "$FIRMWARE_DIR/$FIRMWARE_FILE"

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Flash failed! Did you hold the BOOT button?"
    exit 1
fi

echo ""
echo "✅ MicroPython installed successfully!"
echo ""
echo "🎉 Your ESP32 now speaks Python!"
echo ""
echo "Next steps:"
echo "  1. Press the RST button (reset) on your ESP32"
echo "  2. Run ./scripts/connect.sh to test it"
echo "  3. Type print('Hello!') and press Enter"
echo ""
