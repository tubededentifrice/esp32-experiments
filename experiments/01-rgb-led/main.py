# RGB LED Test - Make colorful lights!
#
# Wiring:
#   R (Red)   -> GPIO 0
#   G (Green) -> GPIO 2
#   B (Blue)  -> GPIO 15
#   GND (-)   -> GND

from machine import Pin, PWM
import time

# Set up the 3 color pins
red = PWM(Pin(0), freq=1000)
green = PWM(Pin(2), freq=1000)
blue = PWM(Pin(15), freq=1000)

# This function sets the color
# Each color goes from 0 (off) to 1023 (brightest)
def set_color(r, g, b):
    red.duty(1023 - r)    # 1023-r because of how the LED works
    green.duty(1023 - g)
    blue.duty(1023 - b)

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
        set_color(1023, 0, 0)
        time.sleep(1)

        # GREEN
        print("GREEN")
        set_color(0, 1023, 0)
        time.sleep(1)

        # BLUE
        print("BLUE")
        set_color(0, 0, 1023)
        time.sleep(1)

        # YELLOW (red + green)
        print("YELLOW")
        set_color(1023, 1023, 0)
        time.sleep(1)

        # PURPLE (red + blue)
        print("PURPLE")
        set_color(1023, 0, 1023)
        time.sleep(1)

        # CYAN (green + blue)
        print("CYAN")
        set_color(0, 1023, 1023)
        time.sleep(1)

        # WHITE (all colors!)
        print("WHITE")
        set_color(1023, 1023, 1023)
        time.sleep(1)

except KeyboardInterrupt:
    # Clean up when you press Ctrl+C
    print("\nStopping...")
    off()
    red.deinit()
    green.deinit()
    blue.deinit()
    print("Done!")
