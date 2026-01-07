# Experiment 01: RGB LED (WS2812 / NeoPixel)

This module has **4 smart RGB LEDs** in a row! Each LED has a tiny chip inside that controls its color. You only need ONE data wire for all of them!

## Wiring

| LED Pin | Expansion Board |
|---------|-----------------|
| S (Signal) | IO15 |
| V (Voltage) | 3.3V (next to IO15) |
| G (Ground) | GND (next to IO15) |

## What the Code Does

- Uses the `neopixel` library (built into MicroPython)
- Colors are 0-255 for Red, Green, Blue
- `led.write()` sends the color to the LED

## Cool Thing About WS2812

You can chain many of these LEDs together! They each get their own color. Just change the `1` to however many LEDs you have:
```python
led = NeoPixel(Pin(15), 5)  # 5 LEDs!
led[0] = (255, 0, 0)  # First LED = red
led[1] = (0, 255, 0)  # Second LED = green
led.write()
```

## Try This!

- Make it dimmer: use smaller numbers like `set_color(50, 0, 0)`
- Make orange: `set_color(255, 100, 0)`
- Make pink: `set_color(255, 50, 50)`
