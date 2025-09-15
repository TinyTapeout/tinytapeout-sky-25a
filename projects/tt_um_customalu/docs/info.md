<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Credits
We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance.  Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support in facilitating this Tiny Tapeout. SKY25A submission

## How it works
This module implements a **Custom Arithmetic Logic Unit (ALU)** with two operating modes: standard ALU mode and Neural Processing Unit (NPU) mode.

In **ALU mode**, the design performs:
- Standard arithmetic operations: addition, subtraction, multiplication, division
- Bitwise logical operations: AND, OR, XOR, NOT
- Bit rotation (left and right)
- Priority encoder
- Gray code conversion
- Majority function logic
- Comparisons (greater than, equality)

In **NPU mode**, it performs simple neural-inspired computations including:
- Weighted sum with error correction
- ReLU-like activation
- Scaled dot product
- Max/min selection
- Thresholding
- Inverted XOR
- Sigmoid-like output
- Binary classification
- Bitwise weighted sum
- Quadratic neuron function

The operation is selected using a 4-bit opcode and mode bit provided via `uio_in`.
## How to test
- The 8-bit input signal `ui_in` is divided into:
  - **A** = `ui_in[3:0]` (lower 4 bits)
  - **B** = `ui_in[7:4]` (upper 4 bits)

- Operation is selected via:
  - **Opcode** = `uio_in[3:0]` (4-bit opcode for selecting ALU/NPU function)
  - **Mode** = `uio_in[4]`
    - `0`: ALU mode
    - `1`: NPU mode

- The 8-bit output `uo_out` is structured as:
  - `uo_out[3:0]`: ALU/NPU result
  - `uo_out[4]`: Error flag (e.g., divide by zero)
  - `uo_out[5]`: Sign flag (MSB of result)
  - `uo_out[6]`: Carry flag (for addition/subtraction)
  - `uo_out[7]`: Zero flag (result == 0)
 
## Internal Architecture

### Functional Overview

The `tt_um_customalu` is a 4-bit custom Arithmetic Logic Unit (ALU) with two operating modes:

- **ALU Mode (Mode = 0)**: Performs standard arithmetic and logic operations.
- **NPU Mode (Mode = 1)**: Emulates neural processing operations (e.g., thresholding, ReLU, dot product).

Inputs are sampled synchronously on the rising clock edge. Operations are executed based on the selected `Opcode` and `Mode`.

---
On every rising edge of `clk`:

- **A** = `ui_in[3:0]` (Operand A)
- **B** = `ui_in[7:4]` (Operand B)
- **Opcode** = `uio_in[3:0]` (Operation Selector)
- **Mode** = `uio_in[4]` (0: ALU Mode, 1: NPU Mode)
On the next `clk` cycle:

- Depending on the `Mode`, the ALU executes one of 32 possible operations (16 ALU, 16 NPU).
- The result is stored in `ALU_Result`.
- Flags such as `Zero`, `Carry`, `Sign`, and `Error` are updated accordingly.

---

## Operation Modes

### ALU Mode (`Mode_reg == 0`)

Includes basic and advanced operations like:

- **Arithmetic**: `ADD`, `SUB`, `MUL`, `DIV`
- **Logic**: `AND`, `OR`, `XOR`, `NOT`
- **Bitwise**: `ROTATE`, `GRAY CODE`
- **Comparison**: `GREATER`, `EQUAL`
- **Custom**: `PRIORITY ENCODER`, `MAJORITY`, weighted function

### NPU Mode (`Mode_reg == 1`)

Implements lightweight neural functions:

- **Activation**: `ReLU`, `Threshold`, `Sigmoid-like`
- **Neuron computations**: `Base neuron`, `Scaled dot`, `Noisy neuron`, `Quadratic neuron`
- **Classification & logic**: `Equality`, `Max`, `Min`, `Binary classification`, `Inverted XOR`

---

## Reset Behavior

When `rst_n` is low (active low reset):

- All internal registers (`A_reg`, `B_reg`, `Opcode_reg`, `Mode_reg`, `ALU_Result`) are cleared to `0`.
- All flags (`Zero`, `Carry`, `Sign`, `Error`) are reset to `0`.

This ensures safe and deterministic startup and operation.


**Testing can be done** by providing various combinations of `ui_in` and `uio_in`, then observing the result and status flags on `uo_out`.

## Opcode Table

### ALU Mode (`Mode_reg == 0`)

| Opcode (bin) | Opcode (hex) | Operation         | Description                                               |
|--------------|--------------|-------------------|-----------------------------------------------------------|
| `0000`       | `0x0`        | ADD               | `A + B`, with carry, zero, and sign flags                 |
| `0001`       | `0x1`        | SUB               | `A - B`, with carry, zero, and sign flags                 |
| `0010`       | `0x2`        | MUL               | `A * B`, lower 4 bits, with zero and sign flags           |
| `0011`       | `0x3`        | DIV               | `A / B`, handles divide-by-zero with error flag           |
| `0100`       | `0x4`        | ROTL              | Rotate `A` left by 1 bit                                  |
| `0101`       | `0x5`        | ROTR              | Rotate `A` right by 1 bit                                 |
| `0110`       | `0x6`        | PRIORITY ENCODER  | Encodes position of most significant set bit in `A`       |
| `0111`       | `0x7`        | GRAY CODE         | Converts `A` to Gray code                                 |
| `1000`       | `0x8`        | MAJORITY FUNCTION | `(A & B) | (A & 0xA) | (B & 0x5)`                         |
| `1001`       | `0x9`        | WEIGHTED FUNC     | `((A * 3) + 2) % 17`                                      |
| `1010`       | `0xA`        | AND               | Bitwise AND of `A` and `B`                                |
| `1011`       | `0xB`        | OR                | Bitwise OR of `A` and `B`                                 |
| `1100`       | `0xC`        | NOT               | Bitwise NOT of `A`                                        |
| `1101`       | `0xD`        | XOR               | Bitwise XOR of `A` and `B`                                |
| `1110`       | `0xE`        | GREATER THAN      | `1` if `A > B`, else `0`                                  |
| `1111`       | `0xF`        | EQUALITY          | `1` if `A == B`, else `0`                                 |

---

### NPU Mode (`Mode_reg == 1`)

| Opcode (bin) | Opcode (hex) | Operation               | Description                                                      |
|--------------|--------------|-------------------------|------------------------------------------------------------------|
| `0000`       | `0x0`        | BASE NEURON             | `((A * 3) + 2) % 17`                                              |
| `0001`       | `0x1`        | RELU(A - B)             | `A - B` if `A > B`, else `0`                                      |
| `0010`       | `0x2`        | SCALED DOT              | `(A * B) >> 2`                                                    |
| `0011`       | `0x3`        | MAX                     | Maximum of `A` and `B`                                            |
| `0100`       | `0x4`        | MIN                     | Minimum of `A` and `B`                                            |
| `0101`       | `0x5`        | THRESHOLD               | `0xF` if `A > 4`, else `0x0`                                      |
| `0110`       | `0x6`        | INVERTED XOR            | Bitwise `~(A ^ B)`                                                |
| `0111`       | `0x7`        | NOISY NEURON            | `(A + B + 3) % 10`                                                |
| `1000`       | `0x8`        | EQUALITY NEURON         | `0xF` if `A == B`, else `0x0`                                     |
| `1001`       | `0x9`        | NO-OP / NULL            | Always returns `0x0`                                              |
| `1010`       | `0xA`        | SIGN BIT AGREEMENT      | `1` if `A[3] ^ B[3]` is `1`, else `0`                             |
| `1011`       | `0xB`        | SIGMOID-LIKE            | Returns `0x8` if `2 < A < 13`, else `0x0`                         |
| `1100`       | `0xC`        | FIRE ON DIFFERENCE      | `0xF` if `A > B` and `(A - B) > 2`, else `0x0`                    |
| `1101`       | `0xD`        | BITWISE WEIGHTED SUM    | Weighted sum: `A[3]*4 + A[2]*3 + A[1]*2 + A[0]*1`                 |
| `1110`       | `0xE`        | QUADRATIC NEURON        | `(A * A + B) % 16`                                                |
| `1111`       | `0xF`        | BINARY CLASSIFICATION   | `1` if `A > B`, else `0`                                          |



## External hardware


List external hardware used in your project (e.g. PMOD, LED display, etc), if any
