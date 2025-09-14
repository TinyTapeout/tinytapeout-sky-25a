<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# DMA Controller (TinyTapeout)

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance. Special thanks to Dr. H V Ravish Aradhya (HOD-ECE), Dr. K. S. Geetha (Vice Principal) and Dr. K. N. Subramanya (Principal) for their constant encouragement and support to carry out this Tiny Tapeout SKY25a submission.

## How it works

The tt_um_dma module is a simple Tiny DMA (Direct Memory Access) controller designed with a TinyTapeout wrapper. Its function is to transfer data from one memory location to another, either as a single transfer or as a small burst of three words, depending on configuration. The transfer is triggered by input control signals, and once completed, the module produces a dma_done pulse and outputs the last transferred data on uo_out.

The design is organized around a Finite State Machine (FSM) with three states: IDLE, TRANSFER, and DONE. This FSM guarantees that the DMA operates in a predictable and synchronous manner. The design also includes a global asynchronous active-low reset (rst_n) that safely initializes all states and registers. The entire module runs synchronously with the input clock (clk).

## Functional Description

The module accepts its control through the dedicated input bus ui_in. Bit 7 acts as the start signal to initiate a transfer. Bits [6:4] provide the source address, bits [3:1] specify the destination address, and bit 0 selects the transfer mode, where 0 triggers a single-word transfer and 1 triggers a three-word burst transfer. The other inputs include uio_in, which is unused, ena, which is always high when the design is powered, and the system clock and reset signals.

The output port uo_out provides both the DMA status and the data. Bit 7 of this output is the dma_done signal, which pulses high for one cycle once a transfer completes, while bits [6:0] carry the last data word transferred. The other bidirectional IOs, uio_out and uio_oe, are unused and tied to zero.

## Internal Architecture

The FSM manages the DMA transfer process. In the IDLE state, the module waits for the start signal. When asserted, it captures the source and destination addresses as well as the transfer mode, setting up the number of words to move. It then transitions into the TRANSFER state.

In the TRANSFER state, data is copied from the source memory location to the destination. Each time a word is transferred, the data_out register is updated to reflect the value being moved, while both the source and destination pointers are incremented. The word counter decreases with every transfer, and once the final word is handled, the FSM moves into the DONE state.

In the DONE state, the dma_done flag is asserted high for a single cycle to signal completion. After this, the FSM automatically returns to the IDLE state, ready for the next transaction. This sequencing ensures reliable data movement and provides a clean indication when transfers are finished.

The memory used by the DMA is an internal array of eight words, each seven bits wide. On reset, the memory is preloaded with ASCII values a (0x61), b (0x62), c (0x63), and d (0x64) in the first four locations, while the rest are cleared. This preload allows for immediate testing of single or burst transfers. The module always places the last transferred word on the data_out bus for observation.

## Reset Behavior

When the reset signal (rst_n) is asserted low, the FSM returns to the IDLE state. Internal registers such as data_out, dma_done, words_left, src_ptr, and dst_ptr are cleared, and the memory is reinitialized with its default values. This ensures safe startup and predictable behavior after power-up or reset.

## Unused Logic Handling

Unused inputs and outputs are tied off to prevent synthesis warnings. The design consumes uio_in and ena through a reduction operation, while uio_out and uio_oe are tied to zero to act as high-impedance lines.

## How to Test

The design is verified using a Cocotb testbench. Two scenarios are covered: single transfer and burst transfer. In the single transfer case, the test starts a DMA transaction with mode set to zero, moving one word from memory address 0 to address 4. The test then checks that the dma_done signal pulses high and that the value 0x61 (ASCII a) appears on the data output.

In the burst transfer case, the test initiates a transaction with mode set to one, moving three consecutive words starting from memory address 0 to destination address 4. Once complete, the dma_done pulse is observed and the final output value corresponds to 0x63 (ASCII c), the last word transferred. Logging within the testbench monitors the DMA outputs, ensuring that both single and burst modes perform correctly.
