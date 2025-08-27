<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25A submission.

## How it works

This project integrates SERDES functionality with an FIR filter to process serial input data and generate parallel output.

* Incoming serial data is first processed through a small **Finite Impulse Response (FIR) filter** implemented in the RTL.  
* The filtered bitstream is then shifted into an **8-bit serial-to-parallel (SIPO) register**.  
* Once 8 filtered samples have been collected, the full byte is latched onto the output bus `uo_out`.  

This design demonstrates both **signal processing (digital FIR filtering)** and **data reformatting (SERDES)** in a compact TinyTapeout-friendly implementation.


## Functional Description

### Input and Output Ports

**Inputs**

* `ui_in[7:0]`:
  * `ui_in[0]` – raw serial data input (before filtering).  
  * `ui_in[1]` to `ui_in[7]` – unused.  
* `uio_in[7:0]`: Not used in this design.  
* `clk` – Global clock for sequential logic.  
* `rst_n` – Active-low asynchronous reset.  
* `ena` – Global enable; logic only updates when high.  

**Outputs**

* `uo_out[7:0]`: Latched 8-bit word from the **filtered serial stream**.  
* `uio_out[7:0]`: Not used; tied to zero.  
* `uio_oe[7:0]`: Not used; tied to zero.  

## Internal Architecture
**Finite State Machine (FSM)**

The design includes a dedicated FSM to control the SERDES (serializer/deserializer), FIR filter feeding, and parallel output generation. The FSM ensures correct sequencing of reset, bit-shifting, filtering, and word reassembly.

### States and Transitions

1. **RESET**
   - Asserted when `rst_n = 0`.
   - Clears all internal registers, counters, and FIR pipeline.
   - Transitions to **IDLE** once reset is released.

2. **IDLE**
   - Waits for `ena = 1` (design enable).
   - Serializer/deserializer are held inactive.
   - Transition: `ena = 1 → LOAD`.

3. **LOAD**
   - Captures the next serial input bit into the shift register.
   - Maintains bit counter (`bit_cnt`) for alignment.
   - Transition: After each clock cycle → **SHIFT**.

4. **SHIFT**
   - Shifts in serial bits (`ui_in`) LSB-first.
   - Updates the shift register until 8 bits (one byte) are collected.
   - Transition: 
     - If `bit_cnt < 7 → LOAD` (continue shifting).  
     - If `bit_cnt == 7 → FILTER`.

5. **FILTER**
   - Assembles 8-bit word from shift register.
   - Applies FIR filter (N-tap design, coefficients as per RTL).
   - FIR result stored in pipeline register.
   - Transition: Once FIR completes → **OUTPUT**.

6. **OUTPUT**
   - Places FIR-filtered word on parallel output bus (`uo_out`).
   - Asserts valid output for one cycle.
   - Transition: Automatically returns to **LOAD** to capture next byte if `ena = 1`; otherwise → **IDLE**.
   
- **Counters**: A bit counter (`bit_cnt`) tracks input bits; a word counter may track multiple bytes if needed.  
- **Handshake**: FIR stage only receives data after a complete word is deserialized.  
- **Sync Word Handling**: FSM ignores or filters special sync words (e.g., `0x7E`) if configured in RTL.  
- **Glitch Safety**: FSM prevents partial/invalid data propagation by gating FIR input until a full byte is collected.

**FIR Filter**

* The serial input `ui_in[0]` is passed through a **discrete FIR filter**.  
* Implemented as a **shift register of taps** and **coefficients (multiply-accumulate)**.  
* Produces a **filtered single-bit/sample output** each clock cycle.  
* This stage cleans up or shapes the input stream before serialization.  

**Serial-to-Parallel Capture**

* Filtered bits are shifted into an **8-bit shift register**.  
* A **3-bit counter (`bit_cnt`)** tracks how many filtered bits have been received.  
* When the counter reaches 7 (i.e., 8 bits collected), the register contents are latched into `uo_out`.  

**Reset / Enable Behavior**

* On reset (`rst_n=0`): FIR filter state, shift register, counter, and outputs are cleared.  
* With enable (`ena=1`): FIR filter runs, serial data is captured and converted to bytes.  
* With enable low (`ena=0`): Circuit holds state; no new data is processed.  


## How to test

1. Apply reset (`rst_n=0` for 20 cycles), then release (`rst_n=1`).  
2. Keep `ena=0` for a few cycles, then set `ena=1`.  
3. Drive serial test patterns on `ui_in[0]`.  
4. Observe `uo_out` after 8 cycles: it reflects the **filtered** version of the last 8 input bits.  
5. Use the provided `tb.v` and `test.py` to simulate:
   * Check both waveform filtering in `tb.vcd`.  
   * Log `uo_out` values in cocotb logs.  


## External hardware

* No external hardware is required.  
* For demo purposes:
  * Connect `uo_out[7:0]` to LEDs → filtered 8-bit pattern visualized.  
  * Drive `ui_in[0]` from switches, UART TX, or FPGA I/O.  
