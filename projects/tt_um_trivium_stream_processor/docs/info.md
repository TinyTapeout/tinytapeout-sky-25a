## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25a submission.

---

## How it works

This design implements *Trivium-lite*, a minimalistic variant of the Trivium stream coder using three 64-bit shift registers (`s1`, `s2`, `s3`) as internal state. The coder produces a keystream by iteratively updating these registers with a custom linear feedback shift register (LFSR) logic and XORing the output with the plaintext.

---

## Internal State

- `s1`, `s2`, `s3`: 64-bit registers acting as LFSRs.
- `temp_keystream`: 8-bit buffer to collect keystream bits.
- `step`: 3-bit counter to track cycles (0–7 per byte).
- FSM states: `IDLE`, `RUN`, `RESET`.

---

## Process Overview

1. **Seeding Phase (IDLE)**  
   When `uio_in` is a valid 8-bit seed (≠ 0x00, ≠ 0xFF), the FSM transitions to `RUN`. The seed is expanded into initial values for the 64-bit registers via concatenation and bitwise transformations:
   - `s1 = {48'd0, seed, seed}`
   - `s2 = {48'd0, seed, ~seed[3:0], seed[7:4]}`
   - `s3 = {48'd0, seed, seed ^ 8'hA5}`

2. **Encryption/Decryption (RUN)**  
   On every clock edge, for 8 cycles:
   - Registers are updated using fixed LFSR-like feedback:
     - `s1 <= {s1[62:0], s2[0] ^ s3[1] ^ s1[5] ^ s2[7] ^ s3[13] ^ s1[31] ^ s2[47] ^ s3[60]}`
     - `s2 <= {s2[62:0], s3[3] ^ s1[1] ^ s2[2] ^ s3[19] ^ s1[23]}`
     - `s3 <= {s3[62:0], s1[5] ^ s2[2] ^ s3[4] ^ s1[17] ^ s2[29] ^ s3[63] ^ s1[10] ^ s2[40]}`
   - A single keystream bit is generated per cycle as `s1[0] ^ s2[0] ^ s3[0]`.
   - After 8 bits, the `temp_keystream` is XORed with `ui_in` to yield `uo_out`.

3. **Reset Phase (RESET)**  
   If `uio_in == 0xFF`, internal state is reset to default constants and FSM returns to `IDLE`.

A single keystream bit is generated each cycle as `s1[0] ^ s2[0] ^ s3[0]` and shifted into an 8-bit buffer (`temp_keystream`). After eight cycles, `temp_keystream` is XOR-ed with `ui_in` to produce `uo_out`. A three-state FSM (`IDLE`, `RUN`, `RESET`) coordinates seeding, byte-wise code generation, and reset under an active-low `rst_n`.

---

## Internal State

- `s1`, `s2`, `s3` (64 bits each): linear-feedback shift registers  
- `temp_keystream` (8 bits): accumulates keystream bits  
- `step` (3 bits): counts cycles 0–7 per output byte  
- `state` (2 bits): FSM state (`IDLE = 0`, `RUN = 1`, `RESET = 2`)  

---

## Inputs

- `ui_in[7:0]`: data byte (plaintext or coded text)  
- `uio_in[7:0]`:  
  - `!= 0x00` & `!= 0xFF`: 8-bit seed to initialize `s1`, `s2`, `s3`  
  - `0x00`: normal operation (no reseed)  
  - `0xFF`: force reset  
- `clk`: system clock  
- `rst_n`: active-low asynchronous reset  
- `ena`: global enable (tied high)  

---

## Outputs

- `uo_out[7:0]`: coded and decoded byte  
- `uio_out[7:0]`, `uio_oe[7:0]`: unused (tied to zero)  

---

## Symmetry and Reuse

Due to the symmetric nature of the design, applying the same seed followed by the same encoded text reproduces the original plaintext.

---

## How to test

You can test this design either using a Verilog testbench or via a Cocotb Python-based test. See: [How to test](https://github.com/RVCE-ECE/TT10_TSC/tree/main/test/README.MD)

All inputs/outputs are internal to the digital logic and tested in simulation. The design is fully self-contained and does not require external PMODs, displays, or peripherals. 

---

## How to use

Modify the test.py to test the cipher by passing textfiles or images. Decode the files using same seed as used for ecncryption.
