## How it works

This is a standalone VGA demo that runs with or without input.

**NOTE** The default VGA timing requires a pixel clock if 25.175 MHz. If you
want to drive higher resolutions, the base clock rate must be adjusted
accordingly with the table below. You must set the two pins, `ui_io[6]` and
`ui_io[7]`, to select your preferred mode.

| `ui_io[7:6]` | VGA Timing Mode                      |
|-------------:|:-------------------------------------|
|            0 | VGA  640 x 480 @ 60 fps (25.175 MHz) |
|            1 | VGA  768 x 576 @ 60 fps (34.96  MHz) |
|            2 | VGA  800 x 600 @ 60 fps (40.0   MHz) |
|            3 | VGA 1024 x 768 @ 60 fps (65.0   MHz) |

It will accept two pins `ui_io[0]` and `ui_io[1]` for palette color selection:

| `ui_io[1:0]` | Palette         |
|-------------:|:----------------|
|            0 | Green (default) |
|            1 | Red             |
|            2 | Blue            |
|            3 | Pride           |

## How to test

Plug into a VGA monitor and select this circuit to test

## External hardware

Requires the [TinyVGA PMOD](https://github.com/mole99/tiny-vga)
