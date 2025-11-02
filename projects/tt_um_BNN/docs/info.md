<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.

-->

## How it works

This project implements a 2-layer Binary Neural Network (BNN) in-order classify an 8-bit binary input. The goal is to demonstrate a simple neural computation network, using minimal digital logic. This means no multipliers or floating-point operations, and using XNOR/Popcount operations instead. This BNN should classify inputs into 4 discrete categories: turn left, turn right, stop, and U-turn (depending on external training). Each neuron is assigned to detect a feature based on thresholded similarity with its input.

The first layer consists of 8 neurons, each performing an 8-bit XNOR popcount operation with its respective 8-bit weight vector and threshold activation. The second layer takes the 4-bit output from the first layer as input to another 4 neurons, similarly applying 4-bit XNOR popcount and thresholding to produce the final 4-bit classification output. The other 4-bits of the output is used for debugging the results from the first layer.

The design supports real-time programmable weight loading using 4 bits of the bidirectional `uio` interface at a time. A load enable signal (`uio_in[3]`) and a simple internal load state loop performs the loading process. For example, it takes 2 clock cycles to load an 8-bit weight into a neuron.

This compact BNN core is designed for educational and demonstrational purposes and can serve as a proof-of-concept for implementing simple ML on-chip without CPUs or RAM. For example, simple feature detections could all use this design.

## How to test

Testing is done using CocoTB. Please refer to the description in `test/readme.MD`.

The testbench stimulates the `ui_in` lines with various binary inputs and simulates weight loading through the `uio_in` interface. Specifically, we perform 14 constant weight tests to test our pre-calculated weights, and 5 tests to test weight-loading operations. The results are verified by checking output `uo_out` to see if the correct classification was made.

Note that due to the nature of a small-sized BNN, the accuracy for tests won't be very high throughout all tests. However, cocotb tests demonstrate its potential when more hardware is incorporated into the system.

Verilog simulations and waveform viewer will be available via commands `make sim` and `gtkwave dump.vcd`.
