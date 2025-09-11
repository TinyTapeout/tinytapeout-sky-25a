## How it works

This project implements a **3-bit Mod-6 synchronous counter**.  
- The counter increments on every rising edge of the input clock (`clk`).  
- When it reaches 5, it wraps around back to 0, creating a modulo-6 counting sequence.  
- The current counter value is output on `uo_out[2:0]`. Higher bits (`uo_out[7:3]`) are tied to 0.  
- No external inputs affect the counting; `ui_in` and `uio_in` are unused in this design.  
- `rst_n` is an active-low asynchronous reset. When asserted low, the counter resets to 0 immediately.  
- The IO outputs `uio_out` and `uio_oe` are tied to 0 since no bidirectional functionality is used.  

## How to test

You can test the design using either:

1. **Cocotb simulation**:  
   - Run the provided `test_project.py` testbench.  
   - Observe the `uo_out[2:0]` waveform in GTKWave or another waveform viewer.  
   - The counter should increment from 0 → 1 → 2 → 3 → 4 → 5 and then wrap to 0.

2. **Verilog simulation**:  
   - Use the included `tb.v` testbench.  
   - It generates a clock and asserts reset, allowing you to monitor outputs.  
   - You can dump signals to a VCD file (`tb.vcd`) for visualization in GTKWave.

## External hardware

This project **does not require any external hardware**. It is purely digital and designed to run on-chip in the Tiny Tapeout framework.  
