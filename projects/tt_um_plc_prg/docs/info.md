<!---
This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a **PLC-PRG (Programmable Logic Controller – Program)** in Verilog.  
It mimics the behavior of a simple PLC by reading digital inputs (`ui[7:0]`), processing the logic, and driving outputs (`uo[7:0]`) based on programmed control rules.  

The design is combinational/sequential depending on the configuration. Inputs can represent push buttons or sensors (e.g., `START`, `STOP`, `RESET`), and outputs can represent actuators such as LEDs, relays, or motors.  

The Verilog code models the basic **scan cycle of a PLC**:
1. **Read Inputs** (ui pins)  
2. **Execute Logic** (ladder/boolean operations implemented in Verilog)  
3. **Update Outputs** (uo pins)  

This makes it possible to prototype small automation tasks directly on silicon.  

---

## How to test

1. Connect input pins (`ui[0]`–`ui[7]`) to switches, buttons, or FPGA I/O signals.  
   - Example:  
     - `ui[0]`: START  
     - `ui[1]`: STOP  
     - `ui[2]`: RESET  
     - Others: user-defined  

2. Observe output pins (`uo[0]`–`uo[7]`).  
   - Example:  
     - `uo[0]`: Motor control (ON/OFF)  
     - `uo[1]`: Status LED  
     - Others: user-defined  

3. Simulation:  
   - Run the provided testbench to verify that the outputs follow PLC-style logic rules.  
   - Example: START sets motor ON until STOP is pressed.  

4. On silicon:  
   - Wire push buttons to inputs.  
   - Observe LEDs or actuators connected to outputs.  

---

## External hardware

- **Optional push buttons / switches** → to drive input pins.  
- **LEDs or relays** → to observe output states.  
- No mandatory external hardware is required; the design works with raw digital inputs and outputs.  

---

## Example use case

- `ui[0]` (START) turns ON `uo[0]` (Motor LED).  
- `ui[1]` (STOP) turns OFF `uo[0]`.  
- `ui[2]` (RESET) clears all outputs.  

This demonstrates how a simple PLC program can be realized directly in Verilog and fabricated with Tiny Tapeout.
