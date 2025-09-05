# 16-bit MIPS Single Cycle Processor

A complete implementation of a 16-bit MIPS single-cycle processor designed for TinyTapeout.

## Overview

This project implements a simplified 16-bit MIPS processor that executes a predefined program stored in instruction memory. The processor supports 8 different instruction types and demonstrates fundamental computer architecture concepts in silicon.

## Features

- **16-bit data path** - All registers and ALU operations are 16-bit
- **Single-cycle execution** - Each instruction completes in one clock cycle
- **8 instruction types** supported:
  - ADD (Register addition)
  - SUB (Register subtraction) 
  - ADDI (Add immediate)
  - LW (Load word from memory)
  - SW (Store word to memory)
  - XOR (Bitwise XOR)
  - OR (Bitwise OR)
  - JUMP (Unconditional jump)

## Architecture Components

### 1. Program Counter (PC)
- 16-bit counter that tracks the current instruction address
- Supports jumping and automatic wraparound at program end
- Increments by 2 each cycle (16-bit instructions)

### 2. Instruction Memory
- Contains 16 pre-programmed instructions
- Demonstrates various processor operations
- Read-only memory implemented as ROM

### 3. Instruction Decoder
- Decodes 16-bit instructions into control fields
- Extracts opcode, register addresses, and immediate values
- Supports both R-type and I-type instruction formats

### 4. Control Unit
- Generates all control signals based on instruction opcode
- Controls ALU operation, register writes, memory access
- Implements the processor's control logic

### 5. Register File
- 16 registers (R0-R15), each 16 bits wide
- Dual read ports, single write port
- R0 protection (cannot be overwritten)
- Pre-initialized with test values

### 6. ALU (Arithmetic Logic Unit)
- Performs arithmetic and logical operations
- Supports addition, subtraction, XOR, OR operations
- Handles both register and immediate operands

### 7. Data Memory
- 256 words of 16-bit data memory
- Supports load and store operations
- Pre-initialized with test data

## Pin Configuration

### Outputs (uo_out[7:0])
- **uo_out[7:0]**: Lower 8 bits of ALU output

### Bidirectional Pins (uio_out[7:0])
- **uio_out[7:0]**: Upper 8 bits of ALU output

The complete 16-bit ALU result can be observed by combining both output buses:
```
ALU_Result[15:0] = {uio_out[7:0], uo_out[7:0]}
```

## Test Program

The processor runs a predefined test program that exercises all instruction types:

```assembly
ADD  R1, R2, R3    # R1 = R2 + R3
SUB  R2, R3, R4    # R2 = R3 - R4  
ADDI R3, R4, #5    # R3 = R4 + 5
LW   R4, 3(R5)     # R4 = Memory[R5 + 3]
SW   R5, 3(R4)     # Memory[R4 + 3] = R5
XOR  R4, R3, R3    # R4 = R3 XOR R3
OR   R0, R0, R3    # R0 = R0 OR R3
ADDI R2, R2, #15   # R2 = R2 + 15
# ... (continues with more instructions)
JUMP 0             # Jump back to start
```

## How to Use

1. **Power on**: The processor starts executing automatically
2. **Observe ALU output**: Monitor the 16-bit ALU result on the output pins
3. **Reset**: Pull rst_n low to restart the program from the beginning
4. **Clock**: Runs at up to 10 MHz (configurable)

## Educational Value

This processor demonstrates:
- **Computer Architecture**: Complete CPU design with all major components
- **Digital Design**: Complex sequential and combinational logic
- **Assembly Programming**: Machine code execution and instruction formats
- **Memory Systems**: Instruction and data memory organization
- **Control Logic**: How opcodes control datapath operations

## Technical Specifications

- **Technology**: Synthesized for TinyTapeout (SKY130 PDK)
- **Clock Frequency**: Up to 10 MHz
- **Power**: Low power CMOS design
- **Area**: Fits in 1x1 TinyTapeout tile
- **I/O**: 16 output pins for ALU observation

## Author

**Kishore Netheti**

This project showcases a complete working processor implementation suitable for educational purposes and silicon demonstration.