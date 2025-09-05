# Tiny Tapeout UART Module Documentation

## Project Overview

This project implements a full-featured UART (Universal Asynchronous Receiver-Transmitter) controller designed specifically for the Tiny Tapeout platform. The UART enables bidirectional serial communication with configurable parameters and includes interrupt generation capabilities.

## How it works

### UART Theory and Fundamentals

UART (Universal Asynchronous Receiver-Transmitter) is a hardware communication protocol that enables serial data transmission between devices without requiring a shared clock signal. Unlike synchronous protocols, UART relies on predefined timing agreements between communicating devices.

**Core UART Principles:**

1. **Asynchronous Communication**: No shared clock line between devices. Each device maintains its own clock and relies on precise timing synchronization based on agreed baud rates.

2. **Serial Data Format**: Data is transmitted one bit at a time in a specific frame structure:
   ```
   [START] [D0] [D1] [D2] [D3] [D4] [D5] [D6] [D7] [PARITY] [STOP]
   ```
   - **Start Bit**: Logic '0' signals beginning of data frame
   - **Data Bits**: 5-9 bits of actual data (typically 8 bits)
   - **Parity Bit**: Optional error detection bit
   - **Stop Bit(s)**: Logic '1' signals end of frame (1 or 2 bits)

3. **Baud Rate**: Transmission speed measured in bits per second (bps). Common rates include 9600, 19200, 38400, 57600, 115200 bps.

4. **Oversampling**: Internal clock runs at 16x baud rate for precise bit timing and noise immunity. This allows accurate detection of bit transitions and sampling at optimal points.

### Implementation Architecture

The UART module (`tt_um_uart`) serves as a wrapper around a more comprehensive `uart_top` module, mapping its functionality to Tiny Tapeout's standardized 8-bit I/O interface.

**Internal Structure:**
- **Transmit Path**: Parallel-to-serial converter with FIFO buffering
- **Receive Path**: Serial-to-parallel converter with frame detection
- **Baud Rate Generator**: Clock divider creating precise timing signals
- **Control Logic**: State machines managing TX/RX operations and interrupts

### Key Components

**Input Mapping (`ui_in[7:0]`):**
- `ui_in[0]`: `tr_en` - Transmitter enable
- `ui_in[1]`: `mode_osl` - Mode/operational select 
- `ui_in[2]`: `clk_sel` - Clock selection (0 = 16x oversampling, 1 = full rate)
- `ui_in[3]`: `tx_data_w_en` - TX data write enable
- `ui_in[4]`: `tr_data_load` - Transmit data load signal
- `ui_in[5]`: `rx_data_read_en` - RX data read enable

**Bidirectional I/O (`uio_in[7:0]` / `uio_out[7:0]`):**
- `uio_in[7:1]`: `tr_fifo_data_w` - 7-bit transmit data input
- `uio_in[0]`: `rx_data_in` - Serial receive data input
- `uio_out[0]`: `tx_line` - Serial transmit data output
- `uio_out[1]`: `tx_i_int` - TX input interrupt
- `uio_out[2]`: `rx_i_int` - RX input interrupt  
- `uio_out[3]`: `tx_o_int` - TX output interrupt
- `uio_out[4]`: `rx_o_int` - RX output interrupt
- `uio_out[5]`: `tr_busy` - Transmitter busy flag
- `uio_out[7:6]`: Reserved (tied to 0)

**Output (`uo_out[7:0]`):**
- `uo_out[7:0]`: `rx_data` - 8-bit received data

### Operational Flow

**State Machine Operation:**

The UART operates through several interconnected state machines:

1. **TX State Machine**:
   - **IDLE**: Waiting for data to transmit
   - **START**: Transmitting start bit (logic '0')
   - **DATA**: Shifting out data bits (LSB first)
   - **STOP**: Transmitting stop bit(s) (logic '1')

2. **RX State Machine**:
   - **IDLE**: Monitoring for start bit detection
   - **START**: Validating start bit timing
   - **DATA**: Sampling incoming data bits
   - **STOP**: Verifying stop bit and frame validity

**Detailed Operation Sequence:**

1. **Initialization**: Reset the module using `rst_n` (active low)
2. **Baud Rate Setup**: Fixed at `dlh_dll = 16'h0020` creating a divisor for the input clock
3. **Configuration**: Set operational parameters via `ui_in` control bits
4. **Transmission Process**: 
   - Load 7-bit data into `uio_in[7:1]` (MSB alignment)
   - Assert `ui_in[3]` (tx_data_w_en) to load data into TX FIFO
   - TX state machine automatically begins frame transmission
   - Monitor `uio_out[5]` (tr_busy) for completion status
   - TX interrupts signal various transmission events
5. **Reception Process**:
   - RX state machine continuously monitors `uio_in[0]` for start bit
   - Oversampling (16x) ensures accurate bit detection
   - Received byte appears on `uo_out[7:0]` when frame completes
   - Assert `ui_in[5]` (rx_data_read_en) to acknowledge receipt
   - RX interrupts indicate data availability and errors
6. **Error Detection**: Frame errors, overrun conditions trigger interrupt flags
7. **Flow Control**: Busy signals prevent data loss during active transmission

### Baud Rate Configuration and Timing Analysis

The module uses a fixed baud rate configuration with `dlh_dll = 16'h0020` (32 decimal), which acts as a clock divider for the internal baud rate generator.

**Timing Calculations:**
- **Base Clock**: Tiny Tapeout typically operates at 50MHz
- **Baud Divisor**: 32 (0x0020)
- **16x Oversampling**: Internal clock = Base Clock / (Divisor × 16)
- **Effective Baud Rate**: 50MHz / (32 × 16) = ~97,656 bps

**Bit Timing Precision:**
- Each bit period = 1/97,656 ≈ 10.24 μs
- Oversampling provides 16 sample points per bit
- Sample resolution = 10.24 μs / 16 ≈ 640 ns
- This precision ensures reliable communication even with ±5% clock tolerance

**Clock Selection Impact:**
- `ui_in[2] = 0`: Standard 16x oversampling mode (recommended)
- `ui_in[2] = 1`: Direct clock mode (advanced applications only)

### Advanced Features and Design Considerations

**FIFO Implementation:**
- Internal buffering prevents data loss during burst communications
- TX FIFO allows queuing multiple bytes for transmission
- RX FIFO stores received data until software can process it
- Interrupt-driven operation enables efficient CPU utilization

**Interrupt System:**
- **TX Input Interrupt** (`uio_out[1]`): Triggered when TX FIFO has space
- **RX Input Interrupt** (`uio_out[2]`): Triggered when RX FIFO has data
- **TX Output Interrupt** (`uio_out[3]`): Transmission completion events
- **RX Output Interrupt** (`uio_out[4]`): Reception completion and error events

**Error Handling:**
- **Framing Errors**: Invalid stop bit detection
- **Overrun Errors**: Data received faster than software can process
- **Buffer Overflow**: FIFO capacity exceeded
- All error conditions generate appropriate interrupt signals

**Power and Resource Optimization:**
- Designed for minimal silicon area on Tiny Tapeout
- Clock gating reduces power consumption during idle periods
- Configurable operation modes balance functionality vs. resource usage

### Prerequisites
- Cocotb testbench environment
- Icarus Verilog or compatible simulator
- Python 3.x with cocotb installed

### Running the Test

1. **Setup the environment**:
   ```bash
   pip install cocotb
   ```

2. **Execute the test**:
   ```bash
   make
   ```

### Test Procedure

The provided test (`test.py`) performs the following sequence:

1. **Clock and Reset Setup**:
   - Generates 100 MHz clock (10ns period)
   - Applies reset sequence

2. **Configuration**:
   - Enables transmitter and receiver: `ui_in = 0b00000011`
   - Sets up operational mode

3. **Loopback Test**:
   - Transmits test byte `0xA5` via `uio_in[7:1]`
   - Simulates serial reception on `uio_in[0]`
   - Verifies received data matches transmitted data

4. **Verification**:
   - Compares transmitted vs received data
   - Reports success/failure with detailed output

### Expected Results

The test should output:
```
TX sending byte: 0xA5
RX received byte: 0xA5
```

### Waveform Analysis

The testbench generates `tb.vcd` for waveform viewing. Key signals to monitor:
- Clock and reset behavior
- Control signal transitions
- TX/RX data flow
- Interrupt flag states
- Busy signal timing

## External hardware

### Required Connections

**For basic UART communication:**
- **TX Line**: Connect `uio_out[0]` to receiving device's RX input
- **RX Line**: Connect external transmitter to `uio_in[0]`
- **Ground**: Common ground reference between devices

### Recommended External Hardware

1. **USB-to-Serial Converter**:
   - FTDI FT232R/FT234X based modules
   - CP2102/CP2104 based modules
   - For PC connectivity and debugging

2. **RS-232 Level Shifter** (if needed):
   - MAX3232 or similar
   - Required for true RS-232 voltage levels (±12V)
   - Most modern devices use 3.3V/5V TTL levels

3. **Microcontroller Interface**:
   - Arduino boards (3.3V/5V compatible)
   - Raspberry Pi GPIO pins
   - ESP32/ESP8266 modules

4. **Test Equipment**:
   - Logic analyzer for signal debugging
   - Oscilloscope for timing analysis
   - Breadboard and jumper wires for connections

### Connection Example

```
Tiny Tapeout UART    ←→    External Device
─────────────────          ────────────────
uio_out[0] (TX)     ──→    RX Input
uio_in[0]  (RX)     ←──    TX Output
GND                 ──→    GND
```

### Pin Configuration Summary

| Pin | Direction | Function | External Connection |
|-----|-----------|----------|-------------------|
| `uio_out[0]` | Output | TX Data | → External RX |
| `uio_in[0]` | Input | RX Data | ← External TX |
| `uio_out[5:1]` | Output | Status/Interrupts | → Status LEDs (optional) |
| `ui_in[5:0]` | Input | Control | ← Control switches/MCU |

### Notes

- Ensure voltage level compatibility (3.3V TTL for Tiny Tapeout)
- Add pull-up resistors on communication lines if experiencing reliability issues
- Consider adding decoupling capacitors for stable operation
- The fixed baud rate configuration may require adjustment based on your target communication speed
