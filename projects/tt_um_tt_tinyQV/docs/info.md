<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is the Tiny Tapeout collaborative competition Risc-V SoC.

The CPU is a small Risc-V CPU called TinyQV, designed with the constraints of Tiny Tapeout in mind.  It implements the RV32EC instruction set plus the Zcb and Zicond extensions, with a couple of caveats:

* Addresses are 28-bits
* Program addresses are 24-bits
* gp is hardcoded to 0x1000400, tp is hardcoded to 0x8000000.

Instructions are read using QSPI from Flash, and a QSPI PSRAM is used for memory.  The QSPI clock and data lines are shared between the flash and the RAM, so only one can be accessed simultaneously.

Code can only be executed from flash.  Data can be read from flash and RAM, and written to RAM.

The peripherals making up the SoC are contributed by the Tiny Tapeout community, with prizes going to the best designs!

### Address map

| Address range | Device |
| ------------- | ------ |
| 0x0000000 - 0x0FFFFFF | Flash |
| 0x1000000 - 0x17FFFFF | RAM A |
| 0x1800000 - 0x1FFFFFF | RAM B |
| 0x8000000 - 0x8000033 | DEBUG  |
| 0x8000040 - 0x800007F | GPIO |
| 0x8000080 - 0x80000BF | UART  |
| 0x80000C0 - 0x80003FF | User peripherals 3-15 |
| 0x8000400 - 0x80004FF | Simple user peripherals 0-15 |
| 0x8000600 - 0x80007FF | User peripherals 16-23 |
| 0xFFFFF00 - 0xFFFFF07 | TIME |

#### DEBUG

| Register | Address | Description |
| -------- | ------- | ----------- |
| ID       | 0x8000008 (R) | Instance of TinyQV: 0x41 (ASCII A) |
| SEL      | 0x800000C (R/W) | Bits 6-7 enable peripheral output on the corresponding bit on out6-7, otherwise out6-7 is used for debug. |
| DEBUG_UART_DATA | 0x8000018 (W) | Transmits the byte on the debug UART |
| STATUS   | 0x800001C (R) | Bit 0 indicates whether the debug UART TX is busy, bytes should not be written to the data register while this bit is set. |

See also [debug docs](debug.md)

#### TIME

| Register | Address | Description |
| -------- | ------- | ----------- |
| MTIME_DIVIDER | 0x800002C | MTIME counts at clock / (MTIME_DIVIDER + 1).  Bits 0 and 1 are fixed at 1, so multiples of 4MHz are supported. |
| MTIME    | 0xFFFFF00 (RW) | Get/set the 1MHz time count |
| MTIMECMP | 0xFFFFF04 (RW) | Get/set the time to trigger the timer interrupt |

This is a simple timer which follows the spirit of the Risc-V timer but using a 32-bit counter instead of 64 to save area.
In this version the MTIME register is updated at 1/64th of the clock frequency (nominally 1MHz), and MTIMECMP is used to trigger an interrupt.
If MTIME is after MTIMECMP (by less than 2^30 microseconds to deal with wrap), the timer interrupt is asserted.

#### GPIO

| Register | Address | Description |
| -------- | ------- | ----------- |
| OUT | 0x8000040 (RW) | Control for out0-7 if the GPIO peripheral is selected |
| IN  | 0x8000044 (R) | Reads the current state of in0-7 |
| AUDIO_FUNC_SEL | 0x8000050 (RW) | Audio function select for uo7 |
| FUNC_SEL | 0x8000060 - 0x800007F (RW) | Function select for out0-7 |

| Function Select | Peripheral |
| --------------- | ---------- |
| 0               | Disabled   |
| 1               | GPIO       |
| 2               | UART       |
| 3 - 15          | User peripheral 3-15 |
| 16 - 31         | User byte peripheral 0-15 |
| 32 - 39         | User peripheral 16-23 |

| Audio function select | Peripheral |
| --------------------- | ---------- |
| 0-7                   | PSRAM B enabled |
| 8                     | 33 PWL Synth out 7 |
| 9                     | 11 Pulse Transmitter out 7 |
| 10                    | 20 PWM out 0 |
| 11                    | 21 Matt PWM out 7 |
| 12                    | 08 Prism out 7 |
| 13                    | 11 Analog toolkit out 7 |
| 14                    | 33 PWL Synth out 6 |
| 15                    | 15 Tiny Tone out 7 |

#### UART

| Register | Address | Description |
| -------- | ------- | ----------- |
| TX_DATA | 0x8000080 (W) | Transmits the byte on the UART |
| RX_DATA | 0x8000080 (R) | Reads any received byte |
| TX_BUSY | 0x8000084 (R) | Bit 0 indicates whether the UART TX is busy, bytes should not be written to the data register while this bit is set. Bit 1 indicates whether a received byte is available to be read. |
| DIVIDER | 0x8000088 (R/W) | 13 bit clock divider to set the UART baud rate |
| RX_SELECT | 0x800008C (R/W) | 1 bit select UART RX pin: `ui_in[7]` when low (default), `ui_in[3]` when high |

### Contributed Peripherals

| # | Name | Author(s) | Type | File |
|---:|---|---|---|---|
| 3 | Gamepad Pmod peripheral | Mike Bell | Full | [03_game_ pmod.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/03_game_pmod.md) |
| 4 | Neural Processing Unit (NPU) | Sohaib Errabii | Full | [04_npu.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/04_npu.md) |
| 5 | Baby VGA | htfab | Full | [05_baby_vga.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/05_baby_vga.md) |
| 6 | WatchDog Timer | Niklas Anderson | Full | [06_wdt.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/06_wdt.md) |
| 7 | CAN info | Jesus Arias | Full | [07_CAN_info.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/07_CAN_info.md) |
| 8 | prism | Ken Pettit | Full | [08_prism.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/08_prism.md) |
| 9 | VGA Graphics | Mike Bell | Full | [09_vga_gfx.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/09_vga_gfx.md) |
| 10 | PDM: Pulse Density Modulation Decoder | Jon Nordby, Martin Stensgård | Full | [10_pdm.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/10_pdm.md) |
| 11 | Pulse Transmitter | Han | Full | [11_pulse_ transmitter.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/11_pulse_transmitter.md) |
| 12 | tiny CORDIC | Maciej Lewandowski | Full | [12_cordic.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/12_cordic.md) |
| 13 | VGA character console | Ciro Cattuto | Full | [13_vgaconsole.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/13_vgaconsole.md) |
| 15 | TinyTone PWM Peripheral | pranav0x0112(Pranav) | Full | [15_tinytone.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/15_tinytone.md) |
| 16 | Rotary Encoder | Matt Venn | Simple | [16_encoder.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/16_encoder.md) |
| 17 | Edge Counter | Uri Shaked | Simple | [17_edge_ counter.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/17_edge_counter.md) |
| 18 | LED strip driver | Ciro Cattuto | Simple | [18_ledstrip.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/18_ledstrip.md) |
| 19 | WS2812B impostor | Javier MS | Simple | [19_impostor_ WS2812b.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/19_impostor_WS2812b.md) |
| 20 | PWM | Sujith Kani A. | Simple | [20_pwm.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/20_pwm.md) |
| 21 | 8 bit PWM generator with adjustable frequency | Matt Venn | Simple | [21_matt_pwm.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/21_matt_pwm.md) |
| 22 | Spike_Encoder Pheriphral | Riya & Anoushka | Simple | [22_spike.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/22_spike.md) |
| 23 | Universal Segmented LED Driver | Rebecca G. Bettencourt | Simple | [23_ubcd.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/23_ubcd.md) |
| 24 | Hardware UTF Encoder/Decoder | Rebecca G. Bettencourt | Simple | [24_hardware_ utf8.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/24_hardware_utf8.md) |
| 25 | TinyQV Waveforms | Meinhard Kissich | Simple | [25_waveforms.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/25_waveforms.md) |
| 26 | Analog toolkit peripheral | htfab | Simple | [26_analog_ toolkit.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/26_analog_toolkit.md) |
| 27 | CRC32 Peripheral | Alessandro Vargiu | Simple | [27_crc32.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/27_crc32.md) |
| 28 | Video mode tester peripheral | htfab | Simple | [28_vga_tester.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/28_vga_tester.md) |
| 29 | 8-bit RSA encryption peripheral | Caio Alonso da Costa | Simple | [29_rsa.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/29_rsa.md) |
| 30 | SPI controller | Mike Bell | Simple | [30_spi.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/30_spi.md) |
| 31 | Hamming (7,4) Error Correction Code | Enmanuel Rodriguez | Simple | [31_hamming _7_4.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/31_hamming_7_4.md) |
| 32 | Hal-precision Floating Point Unit (FPU) | Diego Satizanal | Full | [32_fpu.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/32_fpu.md) |
| 33 | PWL Synth | Toivo Henningsson | Full | [33_pwl_synth.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/33_pwl_synth.md) |
| 34 | DWARF Line Table Accelerator | Laurie Hedge | Full | [34_dwarf_ line_table_ accelerator.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/34_dwarf_line_table_accelerator.md) |
| 35 | xoshiro128++ pseudorandom number generator | Ciro Cattuto | Full | [35_prng.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/35_prng.md) |
| 37 | INTERCAL ALU | Rebecca G. Bettencourt | Full | [37_intercal_alu.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/37_intercal_alu.md) |
| 39 | Affinex - Affine Transformation Accelerator | Adam Gebregziaber | Full | [39_affinex.md](https://github.com/TinyTapeout/ttsky25a-tinyQV/blob/main/docs/user_peripherals/39_affinex.md) |

## How to test

Load an image into flash and then select the design.

Reset the design as follows:

* Set rst_n high and then low to ensure the design sees a falling edge of rst_n.  The bidirectional IOs are all set to inputs while rst_n is low.
* Program the flash and leave flash in continuous read mode, and the PSRAMs in QPI mode
* Drive all the QSPI CS high and set SD1:SD0 to the read latency of the QSPI flash and PSRAM in cycles.
* Clock at least 8 times and stop with clock high
* Release all the QSPI lines
* Set rst_n high
* Set clock low
* Start clocking normally

Based on the observed latencies from tt06 testing, at the target 64MHz clock a read latency of 2 is required.  The maximum supported latency is currently 3.

The above should all be handled by some MicroPython scripts for the RP2040 on the TT demo PCB.

Build programs using the [customised toolchain](https://github.com/MichaelBell/riscv-gnu-toolchain) and the [tinyQV-sdk](https://github.com/MichaelBell/tinyQV-sdk), some examples are [here](https://github.com/MichaelBell/tinyQV-projects).

## External hardware

The design is intended to be used with this [QSPI PMOD](https://github.com/mole99/qspi-pmod) on the bidirectional PMOD.  This has a 16MB flash and 2 8MB RAMs.

The UART is on the correct pins to be used with the hardware UART on the RP2040 on the demo board.

It may be useful to have buttons to use on the GPIO inputs.
