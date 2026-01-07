# WS2812 RGB LED Test - Make colorful lights!
#
# This is a "smart" LED - it only needs 1 wire for data!
#
# Wiring (keep wires close together!):
#   S (Signal) -> IO15
#   V (Voltage) -> 3.3V (next to IO15)
#   G (Ground)  -> GND (next to IO15)

from machine import Pin
from neopixel import NeoPixel
import time

# Set up the LEDs on GPIO 15
# We have 4 LEDs!
led = NeoPixel(Pin(15), 4)

# This function sets ALL 4 LEDs to the same color
# Each color goes from 0 (off) to 255 (brightest)
def set_color(r, g, b):
    for i in range(4):       # Loop through all 4 LEDs
        led[i] = (r, g, b)   # Set each one
    led.write()              # Send it to the LEDs!

# Turn off the LED
def off():
    set_color(0, 0, 0)

print("RGB LED Test Starting!")
print("Watch the LED change colors...")
print("Press Ctrl+C to stop")
print()

try:
    while True:
        # RED
        print("RED")
        set_color(255, 0, 0)
        time.sleep(1)

        # GREEN
        print("GREEN")
        set_color(0, 255, 0)
        time.sleep(1)

        # BLUE
        print("BLUE")
        set_color(0, 0, 255)
        time.sleep(1)

        # YELLOW (red + green)
        print("YELLOW")
        set_color(255, 255, 0)
        time.sleep(1)

        # PURPLE (red + blue)
        print("PURPLE")
        set_color(255, 0, 255)
        time.sleep(1)

        # CYAN (green + blue)
        print("CYAN")
        set_color(0, 255, 255)
        time.sleep(1)

        # WHITE (all colors!)
        print("WHITE")
        set_color(255, 255, 255)
        time.sleep(1)

except KeyboardInterrupt:
    print("\nStopping...")
    off()
    print("Done!")
