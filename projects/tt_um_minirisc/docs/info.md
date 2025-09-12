<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a simple **MiniRISC processor** using an FSM-based control unit.  
- The design fetches an instruction (provided via the `ui_in` pins).  
- The FSM steps through the instruction cycle: **fetch → decode → execute → write-back**.  
- An **accumulator register (ACC)** stores intermediate results.  
- The output pins (`uo_out`) reflect the current ACC value or operation result.  
- Internal state is tracked via a finite state machine, ensuring each instruction executes deterministically across multiple clock cycles.  

The goal is to demonstrate how a minimal RISC-like processor can be built with simple Verilog, synthesized for Tiny Tapeout, and verified through simulation and hardware testing.  

---

## How to test

1. **Simulation** (before fabrication):  
   - Use the provided `tb.v` testbench with Icarus Verilog and cocotb.  
     
2. **On real hardware**   
   - The packaged chip will be mounted on a Tiny Tapeout test PCB with a Raspberry Pi as the host.  
   - Reset the chip using the provided reset control.  
   - Send instructions sequentially via `ui_in` pins from the Raspberry Pi GPIO.  
   - Observe `uo_out` to capture results of operations.  
   - Compare against the expected outputs (the same instruction sequence used in simulation).  

This allows direct validation of the FSM processor on silicon, mirroring the cocotb verification flow.  

---

## External hardware

None
