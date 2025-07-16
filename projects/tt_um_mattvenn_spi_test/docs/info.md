<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

SPI test design based from https://github.com/calonso88/tt07_alu_74181
See that design's docs for information about the SPI peripheral.

It has been configured with 2 read/write 8 bit registers and 2 read only 8 bit status registers.

The first read/write register also drives the 7 segment display.

## How to test

## How to test

Use SPI1 Master peripheral in RP2040 to start communication on SPI interface towards this design. Remember to configure the SPI mode using the switches in DIP switch (if you'd like to have CPOL=1 and CPHA=1). Alternatively, don't use the DIP switches and use the RP2040 GPIOs to configure the SPI mode in the desired mode.

Example code to initialize SPI in REPL:
```txt
spi_miso = tt.pins.pin_uio3
spi_cs = tt.pins.pin_uio4
spi_clk = tt.pins.pin_uio5
spi_mosi = tt.pins.pin_uio6
spi_miso.init(spi_miso.IN, spi_miso.PULL_DOWN)
spi_cs.init(spi_cs.OUT)
spi_clk.init(spi_clk.OUT)
spi_mosi.init(spi_mosi.OUT)
spi = machine.SoftSPI(baudrate=10000, polarity=0, phase=0, bits=8, firstbit=machine.SPI.MSB, sck=spi_clk, mosi=spi_mosi, miso=spi_miso)
spi_cs(1)
```

Example code to write 0xA5 to address[0]:
```txt
spi_cs(0); spi.write(b'\x80\xa5'); spi_cs(1)
```

This should set the 7 segment LED to 0xA5.

Example code to read from address[0]:
```txt
spi_cs(0); spi.write(b'\x00'); spi.read(1); spi_cs(1)
```

The result should be 0xA5 or whatever you wrote to address[0].

## External hardware

Not required.
Write to the first register to set the LEDs on the demoboard.

## External hardware

Nothing required.
