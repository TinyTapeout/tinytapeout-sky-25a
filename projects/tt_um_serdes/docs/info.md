<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25A submission.

## How it works

This project demonstrates a compact serial data pipeline that combines SERDES (serializer/deserializer), a digital FIR filter, and a lightweight encryption stage.

* Serial input (ui_in[0]) is deserialized into 8-bit words (LSB-first).

* Each received byte is passed through a 4-tap FIR filter.

* The filtered output is XOR-encrypted with a fixed 8-bit key.

* The encrypted byte is then shifted out serially (MSB-first) on uo_out[0].

* A one-cycle done pulse appears on uo_out[1] after each full byte is transmitted.

This pipeline highlights both signal processing (FIR) and secure data formatting (SERDES + XOR encryption).

## Functional Description
### Input and Output Ports

**Inputs**

* ui_in[0]: Serial data input (LSB-first).

* ui_in[7:1]: Unused.

* uio_in[7:0]: Not used.

* clk: Global system clock.

* rst_n: Active-low reset.

* ena: Global enable. Logic halts if low.

**Outputs**

* uo_out[0]: Serial encrypted data output (MSB-first).

* uo_out[1]: “Done” pulse, asserted for one cycle after 8 bits are sent.

* uo_out[7:2]: Constant zero.

* uio_out[7:0]: Unused, tied low.

* uio_oe[7:0]: Unused, tied low.

## Internal Architecture
**Finite State Machine (FSM)**

The design uses a small FSM to coordinate the receiver → filter → encrypter → transmitter pipeline:

1. **IDLE**

    Waits for ena=1.
    
    Resets counters and clears shift registers.

2. **RX**

    Shifts serial input (ui_in[0]) into an 8-bit register, LSB-first.
    
    After 8 bits are received → transition to FIR.

3. **FIR**

    Updates the FIR delay line (d1, d2, d3).
    
    Computes the 4-tap FIR output (fir_out).
    
    Advances to ENC.

4. **ENC**

    XORs fir_out with key (KEY = 0xA5).
    
    Loads result into transmit shift register.
    
    Moves to TX.

5. **TX**

    Shifts out 8 bits MSB-first on uo_out[0].
    
    After last bit → goes to DONE.

6. **DONE**

    Pulses uo_out[1] high for one cycle.
    
    Immediately transitions back to RX for next byte.

**FIR Filter**

Implements:

y[n] = (x0 + 2·x1 + 2·x2 + x3) >> 2

x0: newest sample (current byte).

x1, x2, x3: previous 3 samples.

Provides simple low-pass smoothing.

**Encryption**

Lightweight XOR with constant key (KEY = 8’hA5).

Demonstrates integrating cryptographic primitive into SERDES pipeline.

**Reset / Enable Behavior**

rst_n=0: Clears all registers, counters, delay lines, and outputs.

ena=0: FSM holds in safe IDLE state, outputs forced low.

ena=1: Normal operation proceeds.

## How to test

* Hold rst_n = 0 for several clock cycles, then release (rst_n = 1).

* Set ena = 1.

* Drive input bytes serially on ui_in[0], LSB-first.

* After 8 bits are captured, the DUT performs encryption and FIR filtering.

* The processed byte is shifted out on uo_out[0], MSB-first.

* A one-cycle “done” pulse appears on uo_out[1] after transmission.

* Use tb.v for waveform inspection.

## External Hardware

No external hardware required.

Demo setups:

* Connect uo_out[0] to a logic analyzer or LED (slow clock) to see encrypted bitstream.

* Use uo_out[1] (“done” pulse) as a strobe to sample external hardware.

* Drive ui_in[0] with switch inputs, UART TX, or FPGA I/O pins.
