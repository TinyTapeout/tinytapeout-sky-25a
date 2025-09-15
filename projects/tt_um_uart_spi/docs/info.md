<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project contains two commumication blocks - UART and SPI.
Pins have been assigned such that both UART and SPI can be operated simultaneously.
A loopback feature is implemented which allows the input register to be connected to the output register, which helps in testing. The serial output will be the same as the serial input when loopback is set to 1.

This code represents a top-level module (uart_spi_top) that integrates both UART and SPI communication interfaces, allowing them to operate independently or in tandem within a larger system, such as an FPGA design. The module acts as a wrapper, instantiating sub-modules for UART (uart_rx_tx) and SPI (spi_master_slave_v3_clk_crtl), and exposes shared controls like clock (clk), reset (reset), and frequency control (freq_control). A key feature is the loopback input, which enables a testing mode where input data is directly routed back as output, bypassing normal processing paths. This is particularly useful for verification, debugging hardware connections, or simulating data flow without external devices.

Key Components and Functionality

Inputs and Outputs:
Shared: clk (system clock), reset (active-low reset), freq_control (2-bit select for clock division, affecting baud rate in UART or SCLK frequency in SPI, e.g., 25MHz, 5MHz, 1MHz).
UART-specific: uart_rx_d_in (serial input), uart_tx_start (trigger to start transmission), uart_tx_d_out (serial output), uart_rx_valid (flag for valid received data), uart_tx_ready (flag indicating transmitter is ready).
SPI-specific: cs_bar (chip select, active-low), mosi (master-out-slave-in serial data), spi_start (start SPI transfer), slave_rx_start/slave_tx_start (start RX/TX in slave mode), sclk (SPI clock output), miso (master-in-slave-out serial data), spi_rx_valid (RX valid flag), spi_tx_done (TX complete flag).
loopback: A control signal (likely active-high) passed to both sub-modules to enable loopback mode.

UART Sub-Module (dut_uart):
Handles asynchronous serial communication.
In normal mode, receives data on uart_rx_d_in and transmits on uart_tx_d_out.
When loopback is asserted, the module internally connects the transmitter to the receiver, so any data sent for transmission is immediately "received" back.
This allows testing the UART logic without external wiring or devices—e.g., send a byte and verify it's received correctly.
Flags like uart_rx_valid and uart_tx_ready help synchronize with external logic.

SPI Sub-Module (dut_spi):
Manages synchronous serial communication in slave mode (based on inputs like slave_rx_start/slave_tx_start).
In normal mode, data is shifted in on mosi (sampled on SCLK edges) and out on miso.
When loopback is asserted, it bypasses the shift registers by directly assigning the output register to the input register.
This means serial data driven on mosi appears directly on miso after the transfer, ignoring actual shifting. It's ideal for loopback testing: drive data on mosi, trigger a transfer, and sample miso to confirm mirroring.

Loopback Feature in Detail
The loopback signal is propagated to both sub-modules, enabling independent testing:

Purpose: Simplifies verification by creating a "short circuit" between input and output paths. No external cables or masters/slaves needed—data sent is echoed back internally.
Implementation: In the sub-modules (not shown in this top-level code but inferred from typical designs), it's a mux select. For UART, it routes TX to RX internally. For SPI, it assigns the received data register directly to the transmit register.


## How to test

Set loopback = 1.
For UART: Assert uart_tx_start with data; check uart_rx_valid and received data matches sent.
For SPI: Assert slave_tx_start/slave_rx_start; drive serial bits on mosi; sample miso to see the same bits echoed.


## External hardware

None
