<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Error-Correcting FIFO Buffer with SECDED and ARQ (TinyTapeout)

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal), and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25a submission.

## How it works

The **tt_um_tx_fsm** module is a Tiny FIFO-based transmitter with error detection and retransmission support, implemented with a TinyTapeout wrapper. Its primary function is to buffer input data and provide reliable communication using **Single Error Correction and Double Error Detection (SECDED)** principles along with **Automatic Repeat reQuest (ARQ)** mechanisms. 

Data can be written into the FIFO and later read out with different modes of operation, including normal transmission, corrupted transmission (for testing error detection), and retransmission of the last valid word. The design generates `ack` and `nack` signals to indicate successful transmission or request for retransmission.

The entire module runs synchronously with the input clock (`clk`) and uses an asynchronous active-low reset (`rst_n`) for safe initialization.

## Functional Description

The module accepts its control through the dedicated input bus **ui_in**:

- `ui_in[7]` → **wr_en** (write enable)  
- `ui_in[6]` → **rd_en** (read enable)  
- `ui_in[5:2]` → **data_in[3:0]** (4-bit input data)  
- `ui_in[1:0]` → **err_mode** (error handling mode)  

The output port **uo_out** provides both status and data:  

- `uo_out[7]` → **ack** (acknowledge successful transmission)  
- `uo_out[6]` → **nack** (request retransmission)  
- `uo_out[5:2]` → **data_out[3:0]** (transmitted data)  
- `uo_out[1:0]` → reserved (unused, tied to 0)  

Other wrapper signals:  

- `ena` is always high when powered.  
- `uio_in`, `uio_out`, and `uio_oe` are unused.  

## Internal Architecture

The design combines a FIFO buffer with error-handling logic:  

- **FIFO Buffer**:  
  - Depth = 4 words  
  - Width = 4 bits  
  - Controlled by write (`wr_en`) and read (`rd_en`) enables.  

- **Error Handling via err_mode**:  
  - `00` → Normal transmission: data is read from FIFO, ACK asserted.  
  - `01` → Corrupted transmission: data is output with injected error, ACK asserted.  
  - `10` → Retransmission: last valid word is re-sent, NACK asserted.  
  - Default → Acts as normal transmission.  

- **FSM & Control Logic**:  
  - Maintains `last_data` for retransmission.  
  - Updates read/write pointers.  
  - Generates `ack`/`nack` based on error mode.  

This ensures reliable data delivery with SECDED + ARQ principles.

## Reset Behavior

When the reset signal (`rst_n`) is asserted low:  

- FIFO pointers (`wr_ptr`, `rd_ptr`) are reset to 0.  
- Output registers (`data_out`, `last_data`, `ack`, `nack`) are cleared.  
- FIFO contents are reset.  

This guarantees a deterministic startup and safe behavior after power-up or reset.  

## Unused Logic Handling

Unused inputs (`uio_in`) are consumed using a reduction operation, while `uio_out` and `uio_oe` are tied to zero, preventing synthesis warnings.  

## How to Test

The design is verified using a **Cocotb testbench**. Multiple scenarios are covered:  

1. **Normal Transmission**  
   - Data written to FIFO and read back with `err_mode=00`.  
   - Expect `ack=1` and correct data output.  

2. **Corrupted Transmission (Error Injection)**  
   - Data read with `err_mode=01`.  
   - Output word represents corrupted transmission.  
   - `ack=1` still indicates transaction completion.  

3. **Retransmission (ARQ)**  
   - Data re-sent with `err_mode=10`.  
   - Last valid word output again.  
   - `nack=1` indicates retransmission request.  

4. **Sequential Reads**  
   - Mix of normal, corrupted, and retransmission reads.  
   - Validates FIFO operation, SECDED error detection, and ARQ retransmission logic.  

Simulation logs and waveforms confirm correct behavior of FIFO, SECDED, and ARQ mechanisms.
