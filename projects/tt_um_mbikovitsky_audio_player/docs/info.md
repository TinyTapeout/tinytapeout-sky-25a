## How it works

Plays raw unsigned 8-bit PCM samples read from an attached SPI flash
through DACs connected to analog pins `ua[0]` and `ua[1]`.

## How to test

### Production mode

The audio data should be stored on the flash chip as a sequence of raw
unsigned 8-bit PCM samples, left channel, then right channel.
A stereo file can be converted into this format using FFmpeg:

```bash
ffmpeg -i /path/to/input/file -c:a pcm_u8 -f u8 /path/to/output/file
```

After flashing this to the chip, do the following:

1. Set `uio[5]` low.
2. Set `ui[0]` high to start playback.
3. Set `ui[0]` low to pause.
   Setting it high it again will resume from the same position.

In this mode, one of the two audio channels is also mirrored
on the `uo` pins: the left channel if `uio[4]` is low, and the right
channel if it is high. Whenever a new sample is sent to the DAC,
it is also mirrored to these pins.

### Test mode

When `uio[5]` is high, the design is in test mode.
The 8-bit value on the `ui` pins is passed directly to the DAC
(`ua[1]` if `uio[4]` is low, `ua[0]` if it is high). This can be used
to test the DACs themselves.

In this mode, the SPI controller is also directly exposed:

- `ui[7:0]` - Address
- `uio[6]`  - Read enable
- `uio[7]`  - Data valid
- `uo[7:0]` - Data output

When the "read enable" pin is asserted, the controller will start
reading from the flash chip starting at the given address.
When a byte has been read, the "data valid" signal will be asserted
for a single clock cycle, and the data presented on the "data output"
pins.

The controller will continue reading bytes from sequential addresses
until the "read enable" bit is deasserted.

(The SPI controller can read from any 24-bit address on the flash,
but we don't have enough input pins to expose the whole address range
for debugging.)

## External hardware

SPI flash connected as follows:

- `uio[0]` - CS#
- `uio[1]` - COPI
- `uio[2]` - CIPO
- `uio[3]` - SCLK

The flash must be configured to accept 24-bit addresses with
the READ command (`0x03`).

Audio amplifiers connected to `ua[0]` and `ua[1]`. Exact specs TBD.
