# Experiment 01: RGB LED

An RGB LED has 3 tiny LEDs inside (Red, Green, Blue). By mixing them, you can make ANY color!

## Wiring

| RGB Module | ESP32 Pin |
|------------|-----------|
| R (Red)    | GPIO 0    |
| G (Green)  | GPIO 2    |
| B (Blue)   | GPIO 15   |
| GND (-)    | GND       |

## What the Code Does

- Uses PWM (Pulse Width Modulation) to control brightness
- Each color can be 0 (off) to 1023 (full brightness)
- Mixing colors: RED + GREEN = YELLOW, RED + BLUE = PURPLE, etc.

## Try This!

Change the numbers in `set_color(r, g, b)` to make your own colors!

- `set_color(500, 0, 0)` = dim red
- `set_color(1023, 500, 0)` = orange
- `set_color(0, 500, 500)` = teal
