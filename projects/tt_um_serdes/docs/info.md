<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25A submission.

## How it works

This project implements a Secure SERDES Encryptor that takes two serial input bit streams (a_bit and b_bit), combines them into 8-bit words, and encrypts them using a predefined 128‑bit key.
The encryption works as follows:

1] Serially shift in 8 bits for A and B.

2] Perform an XOR operation between A, B, and the least‑significant byte of the key.

3] Shift the encrypted result out bit‑by‑bit on the output line (uo_out[0]).

4] Once the full encrypted byte is transmitted, the done signal (uo_out[1]) goes high.

This design demonstrates a lightweight encryption method in a serial‑in serial‑out format, suitable for resource‑constrained hardware.

## Functional Description

**Input and Output Ports**

**Inputs**

* ui_in (8 bits):
  * ui_in[0] – start: Initiates the serial data capture and encryption process when high.
  * ui_in[1] – a_bit: Serial data input bit for operand A (MSB-first).
  * ui_in[2] – b_bit: Serial data input bit for operand B (MSB-first).
  * ui_in[3] to ui_in[7] – Unused; ignored in logic.
* uio_in (8 bits): General-purpose I/O input (not used in this design).
* clk – Clock signal for all sequential logic and FSM transitions.
* rst_n – Active-low asynchronous reset.

**Outputs**

* uo_out (8 bits):
  
   * uo_out[0] – cipher_bit: Serial output bit from the encrypted byte (MSB-first).
   
   * uo_out[1] – done: High for one cycle after all 8 encrypted bits have been output.
   
   * uo_out[2] to uo_out[7] – Unused; set to zero.
  
* uio_out (8 bits): Not used; tied to zero to act as high-impedance inputs.
  
* uio_oe (8 bits): Not used; tied to zero to maintain high-impedance state.

## Internal Architecture

**Finite State Machine (FSM)**

The FSM in secure_serdes_encryptor_core controls the serial data capture, encryption, and output process with the following states:

1. **IDLE:**
   
     Waits for start signal to go high.
     
     When start is high, clears internal registers A, B, and bit_cnt.
     
     Transitions to the SHIFT state.

2. **SHIFT:**
   
     Serially shifts in a_bit into register A and b_bit into register B (MSB-first).
     
     Increments bit_cnt each clock cycle.
     
     When bit_cnt reaches 7 (8 bits captured), transitions to the ENCRYPT state.

3. **ENCRYPT:**
   
     Performs bitwise XOR of A, B, and key[7:0] to produce encrypted_byte.
     
     Resets bit_cnt to 0.
     
     Transitions to the OUTPUT state.

4. **OUTPUT:**
   
     Shifts out encrypted_byte one bit at a time through cipher_out (MSB-first).
     
     Increments bit_cnt each cycle.
     
     When bit_cnt reaches 7 (all 8 bits output), sets done high and returns to IDLE.

**Encryption Logic**

Encryption is a simple byte-wise XOR:

  encrypted_byte = encrypted_byte=A⊕B⊕key[7:0]
  
Both A and B are captured serially over 8 clock cycles before encryption.

Output is serialized in the OUTPUT state, matching the input bit order.

**Reset Behavior**

When rst is high:

1. FSM state is forced to IDLE.
   
2. Internal registers A, B, bit_cnt, encrypted_byte, cipher_out, and done are cleared.
   
Guarantees a deterministic startup sequence and prevents spurious outputs.

**Unused Logic Handling**

* All unused inputs (ui_in[3] to ui_in[7], uio_in) are ignored.

* All unused outputs (uo_out[2] to uo_out[7], uio_out, uio_oe) are tied to zero.

## How to test

1] Apply a reset by driving rst_n low and then high again.

2] Set ui_in[0] = 1 for one clock cycle to start encryption.

3] Provide 8 bits serially on ui_in[1] (a_bit) and ui_in[2] (b_bit), MSB first, one per clock cycle.

4] After 8 bits are loaded, the encryption logic computes the XOR result with the key.

5] The encrypted byte is then shifted out on uo_out[0] (1 bit per cycle).

6] When all 8 bits are output, uo_out[1] asserts high to indicate completion.

7] In simulation, you can monitor tb.vcd (waveform) or check the reconstructed byte from uo_out[0].

## External hardware

1] No external hardware is required.

2] For demo purposes, the cipher_out can be connected to an LED or serial interface to observe the bitstream.

3] The done signal can also be mapped to an LED to indicate completion of one encryption cycle.
