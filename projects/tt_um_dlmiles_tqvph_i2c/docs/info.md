<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

The peripheral index is the number TinyQV will use to select your peripheral.  You will pick a free
slot when raising the pull request against the main TinyQV repository, and can fill this in then.  You
also need to set this value as the PERIPHERAL_NUM in your test script.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# TinyQV I2C Controller Device

Author: Darryl Miles

Peripheral index: Standalone TinyTapeout Project (no index TinyQ Peripheral ID)

## What it does

This is a CPU peripheral based on TinyQV bus interface.

TODO

## Register map

Document the registers that are used to interact with your peripheral

| Address | Name       | Access | Description                                                               |
|---------|------------|--------|---------------------------------------------------------------------------|
| 0x00    | DATA[7:0]  |   W    | Write 8bit data into FIFO.  Will trigger TXE_OVERRUN on FIFO usage error. |
|         |            | R      | Read 8bit data from FIFO                                                  |
|         |            |        | Lower 8bit are data as you would expect.                                  |
|         | DATA[8]    |   W    | Data direction (0=TX, 1=RX)                                               |
|         | DATA[8]    | R      | DATA is_valid (indicates if DATA[7:0] valid from received data, no readback of tx data) |
|         | DATA[9]    |        | ACKNACK value latching edge (valid only when DATA[9]==1)                  |
|         | DATA[10]   | RC     | ACKNACK is_valid indicator (indicates not yet seen data in DATA[8])       |
|         | DATA[11]   |        | Send/Recvd START, can be used to enforce start of transaction boundary    |
|         | DATA[11]   |        | Send/Recvd STOP, used to indicate end of transaction boundary             |
| 0x04    | STAT       | R/W    | Status register                                                           |
|         | STAT[0]    | R W1C  | RX_EMPTY (UVM:W1C will clear RX fifo)                                     |
|         | STAT[1]    | R      | RX_FULL (FIFO full)                                                       |
|         | STAT[2]    | R      | RXE_OVERRUN (issue FSM_RESET to clear)                                    |
|         | STAT[3]    | R W1C  | TX_EMPTY (UVM:W1C will clear TX fifo)                                     |
|         | STAT[4]    | R      | TX_FULL (FIFO full)                                                       |
|         | STAT[5]    | R      | TXE_OVERRUN (issue FSM_RESET to clear)                                    |
|         | STAT[6]    | R/W    | Interrupt Edge (W1c to clear)                                             |
|         | STAT[7]    | R/W    | Interrupt Enable (cleared on hardware reset)                              |
|         | STAT[8]    | R      | Interrupt Raw (aka level)                                                 |
|         | STAT[9]    | R      | Error Generic (catch all condition)                                       |
|         | STAT[10]   | R      | Error IO (bus in use)                                                     |
|         | STAT[11]   | R      | Error Timeout (maybe no needed now)                                       |
| 0x08    | CTRL       | R/W    | Control register, transaction related                                     |
|         | CTRL[0]    | R      | FSM_RUN (is running)                                                      |
|         | CTRL[0]    |   W    | FSM_START (write only command, when CTRL[1:0]==2'b01)                     |
|         | CTRL[1]    | R      | NEED_START (indicates when not inside a current bus transaction)          |
|         | CTRL[1]    |   W    | FSM_STOP (write only command, when CTRL[1:0]=2'b10)                       |
|         | CTRL[1:0]  |   W    | FSM_RESET (write only command, when CTRL[1:0]=2'b11)                      |
|         | CTRL[2]    | R/W    | SEND_START (bitbang plus, allows START without write to REG_DATA)         |
|         | CTRL[3]    | R/W    | SEND_STOP (only on FIFO drain, allows STOP without write to REG_DATA)     |
|         | CTRL[4]    | R/W    | FORCE_STOP (immediately issues STOP condition to bus)                     |
|         |            |        | Maybe check TX_EMPTY first ?                                              |
|         |            |        | Can be used to emit STOP condx on bus outside any transaction             |
|         | CTRL[5]    |        | unused (Always 0)                                                         |
|         | CTRL[6]    | R      | ACKNACK (value, 0=ACK, 1=NACK)                                            |
|         | CTRL[7]    | R      | ACKNACK_VALID (non-destructive read, unlike REG_DATA)                     |
|         | CTRL[11:8] | R      | FSM_STATE (debug only, subject to change)                                 |
| 0x0c    | CONF       | R/W    | Configuration register, only writable when FSM_RUN==0                     |
|         | CONF[8:0]  | R/W    | CLKDIV prescaler 10=STANDARD 11=SLOW 01=FAST 00=FASTPLUS                  |
|         |            |        | 39=STANDARD 100Khz 399=SLOW 10KHz 9=FAST 3=FASTPLUS 1MHz                  |
|         |            |        | Note only these fixed values work, this is not general purpose            |
|         |            |        | The value is for zero-based prescaler, so counts are actual minus one     |
|         |            |        | Fixed based on 64MHz master clock, resets to STANDARD                     |
|         | CONF[?]    | R/W    | FIXME NOTIMPL Multiple I2C BUS controller mode enable/disable             |
|         | CONF[?]    | R/W    | FIXME NOTIMPL I2C BUS monitor abort enable/disable                        |
|         | CONF[?]    | R/W    | FIXME NOTIMPL Clock Stretch acknack disable                               |
|         | CONF[?]    | R/W    | FIXME NOTIMPL Clock Stretch data disable                                  |
|         | CONF[?]    | R      | FIXME NOTIMPL timer_count_idle_scl status monitor (debug?)                |
| 0x10    | CMUX[11:0] | R/W    | Controller MUX (controls external I2C interface pins)                     |
|         |            |        | Take a look at module tqvp_dlmiles_i2c_io.v for full docs                 |
|         |            |        | Must be initialized at reset                                              |
|         |            |        | Value 0x000 will result in SCL_PIN= SDA_PIN= output to match I2C0 RP2040, OE open-drain external |

TODO better UVM style register info

## How to test

Well....

Resolve the CMUX setting you need, maybe you need a NPN transistor and
external pull-up resistor (try 10k ohm, or 6k8 ohm but at least 1k ohm)
for each I2C bus line, SCL and SDA.
Maybe you can get away with direct wiring SCL (still with pull-up).
The RP2040 internal pull-up is probably too weak to use with faster I2C
but rates.

TODO

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any


## TODO on next design iteration

Work through CPU register interface to optimize better.
Think through error indications to confirm the grouping makes sense.
Error timeout condition might be optional ?  Allowing CPU to manage and
FSM_RESET when needed.
Merge the FIFOs, try to have a single FIFO resource both sides can use and
reclaim the space as bigger FIFO.

I did not expect to have Clock Stretch feature on initial version, so
hopefully this works, but it has enable/disable that needs configuration.

