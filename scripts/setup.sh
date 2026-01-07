#!/bin/bash
# Setup script - Run this once to install all the tools you need!
# This installs Python tools to talk to your ESP32

echo "🔧 Setting up ESP32 tools..."
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed!"
    echo "   Please install Python from https://www.python.org/downloads/"
    exit 1
fi

echo "✓ Python3 found!"

# Install required Python packages
echo ""
echo "📦 Installing esptool (for flashing firmware)..."
pip3 install --user esptool

echo ""
echo "📦 Installing mpremote (for uploading code)..."
pip3 install --user mpremote

echo ""
echo "📦 Installing pyserial (for connecting to ESP32)..."
pip3 install --user pyserial

echo ""
echo "✅ All done! Your computer is ready to work with ESP32!"
echo ""
echo "Next steps:"
echo "  1. Connect your ESP32 with a USB cable"
echo "  2. Run ./scripts/find-port.sh to find it"
echo "  3. Run ./scripts/flash-firmware.sh to install MicroPython"
echo ""
