## What's RISCY?

RISCY - a Reduced Instruction Set Computer, You know - is a project by nitelich to create a CPU/MCU architecture from first principles. Originally, the RISCY architecture was designed using [Hneemann's Digital](https://github.com/hneemann/Digital). After a first pass of designing an 8-bit ALU, a 32-bit ALU, and a single precision FPU, the project was translated to Verilog. In Verilog, using [Icarus Verilog](https://steveicarus.github.io/iverilog/) as a compiler and simulator tool, the project was extended to cover an N-bit ALU (N > 1) and an N-bit FPU (N > 3). After building N-bit peripherals such as register files, serial-parallel communication primitives, and timers, it was time to do something. Two CPU/MCU architectures were defined.

The first of these was RISCY Jr. CPU. This was designed as a super simple 8-bit CPU that could reasonably fit on a Tiny Tapeout shuttle. Along with a small smattering of peripherals, a full MCU was designed, explicitly targeting TT.

The second of these was the (Full) RISCY CPU. This was designed as a full-feature 32-bit CPU, including integer multiplication and division and a built-in FPU. A MCU targeting the [MiSTer FPGA platform](https://mister-devel.github.io/MkDocs_MiSTer/) is/was also designed, though this is still a work in progress as of this writing, and is not currently planned for a public release.

## Documentation Note

The code author routinely documents code with Doxygen in mind as a documentation generator. In-code documentation should be considered final, where this readme and the in-code documentation disagree.

## RISCY Jr. CPU

The RISCY Jr. CPU is a scratch-built 8-bit CPU architecture. It contains 16 instructions, allowing for basic logic, signed/unsigned integer arithmetic, program flow control, memory access, and interrupt handling. It supports 4 registers, $R0 through $R3, which is just enough to do useful work.

In general, an instruction is broken down in bits as follows:
- Bits 7 to 4: Instruction code
- Bits 3 to 2: First operand register
- Bits 1 to 0: Output register
Where a second operand exists, it is fixed as $R0.

Six instructions include some exception to this structure:
- Load Immediate Lower and Upper use bits 3 to 0 as an immediate value
- Control Process uses bits 3 to 0 as a high-level control mask, described later
- Control Memory uses bits 3 to 2 as a register for memory page control, and bits 1 to 0 as a Boolean value of whether to return from any active interrupt
- Relative Jump uses bits 1 to 0 as a second operand register, rather than an output.
- Absolute Jump uses the second operand ($R0) as the memory page indicator, and then writes the return page to $R0 in addition to the normal use of the first operand and output for the target and memory addresses, respectively.

The special option for the Control Process instruction is a 4-bit action mask for the processor, where the higher bit actions take precedence over the lower bits. Utilizing no flags is equivalent to a "no op" instruction.
- 8: Halt
- 4: Wait for Interrupt
- 2: Disable Interrupts
- 1: Enable Interrupts

The full instruction set is as follows. The instruction code, 4-character assembly mnemonic, and instruction name are given. The assembly mnemonic is fixed to 4 characters as part of an effort to minimize the difficulty in writing an assembler.
- 0x0 AND_ Non-inverting Logical And
- 0x1 NAND Inverting Logical And
- 0x2 SLL_ Shift Left Logical
- 0x3 SRL_ Shift Right Logical
- 0x4 UADD Unsigned Integer Add
- 0x5 SADD Signed Integer Add
- 0x6 USUB Unsigned Integer Subtract
- 0x7 SSUB Signed Integer Subtract
- 0x8 RJMP Relative Jump on Zero
- 0x9 AJMP Absolute (Preserving) Jump
- 0xA LDIL Load Immediate Lower
- 0xB LDIU Load Immediate Upper
- 0xC SAVE Register to Memory
- 0xD LOAD Memory to Register
- 0xE CTLP Control Process
- 0xF CTLM Control Memory

The CPU is written to access program and data memories separately. In practice, both a separated (Harvard) or combined (von Neumann) architecture may be used at higher levels (e.g., the MCU), but in practice the CPU module does not care as long as both memories can be accessed "simultaneously." Either memory source (or both sources) may request a hold in the case that data is not ready immediately.

No structure is placed on memory at the CPU level. Utilizing memory paging via the Control Memory instruction, at most 64kiB of memory may be accessed. In a Harvard architecture, this implies 64kiB of RAM and 64kiB of ROM. The only well-defined memory address is address 0x0000, which is where program execution begins upon reset. 

## RISCY Jr. MCU Targeting Tiny Tapeout

The RISCY Jr. MCU builds peripherals on the core CPU and targets the pinout of the Tiny Tapeout project.

### Memory Access

Importantly, the MCU is designed for use with external memory, utilizing the RP2040 on the Tiny Tapout PCB for SPI RAM emulation. In practice, 64kiB of SPI RAM is emulated, with the lower 32kiB being treated as ROM and the upper 32kiB being treated as RAM. To keep the two truly separate, memory accesses are forced to a Harvard architecture, with data wrapping where appropriate. The RP2040 should be programmed to serve those regions appropriately. Design and loading of programs is an exercise left to the reader.

Memory accesses occur only when needed; no preemptive data loading is performed. For minimum latency of program data, the next address (for standard instructions) is loaded while the current instruction is executed. Latency only occurs on a "cache miss" when an RJMP branch is taken, on AJMP instructions, and on interrupt requests.

Access of SPI RAM is performed without CPU intervention. Data is always read most significant bit first. The behavior is to prioritize cache misses, then memory read/write, and finally predictive ROM read, signaling delay if any of these stages is pending or active. The behavior of the memory manager is as follows:
1. Assert hold to the CPU core, and the SPI chip select
2. Send the appropriate command for read or write
3. Send the target memory address
4. Send the memory value (in the case of writes) or read the memory value (in the case of reads)
5. Deassert SPI chip select for one clock cycle
6. Deassert the hold to the CPU core.

### Memory Layout

The ROM layout is as follows:
- 0x0000 to 0x003F - Interrupt table. Each interrupt gets 8 instructions, given the limited instruction set, to generate a valid paged jump. An efficient set of operations is: Load Immediate of the handler address, AND to copy the address to $R1, Load Immediate of the handler page, AJMP to the handler, and CTLM to return from the interrupt request. This gives one extra instruction slot for arbitrary use.
- 0x0040 to 0x7FFF - Normal program data.
- 0x8000 to 0xFFFF - Address wrap of ROM data due to ROM/RAM address sharing.

The RAM layout is as follows:
- 0x0000 to 0x7FFF - Address wrap of RAM data due to ROM/RAM address sharing. Note that peripheral control memory is not wrapped, and so the last bytes of pure RAM can only be accessed here.
- 0x8000 to 0xFFEF - Normal RAM, with undefined default values.
- 0xFFF0 to 0xFFFF - Peripheral control memory.

And the peripheral control memory words are as follows:
- 0xFFF0 - R/W - Peripheral Enable and Error
   - (Bit 0) PWM 0 enable, active high, default disabled
   - (Bit 1) PWM 1 enable, active high, default disabled
   - (Bit 2) PSRNG enable, active high, default disabled
   - (Bit 3) UART HW flow control enable, active high, default disabled
   - (Bits 5 to 4) UART stop and parity bit setting, from: 00 = 1 stop no parity, 01 = 2 stop no parity, 10 = 1 stop even parity, 11 = 1 stop odd parity; default 1 stop no parity
   - (Bit 6) RESERVED
   - (Bit 7) UART parity error, active high. Writing this bit clears any pending error.
- 0xFFF1 - R/W - GPIO Values
   - (Bits 3 to 0) GPI values. Writing to this nybble has no effect.
   - (Bits 7 to 4) GPO values, default to all low
- 0xFFF2 - R/W - PWM0 half period divider. Actual frequency is (system clock / (2 \* half period)), default of 0x10 (clk / 32).
- 0xFFF3 - R/W - PWM0 half duty divider. Percentage duty is (half duty / half period), default of 0x08 (50% for period of 0x10).
- 0xFFF4 - R/W - PWM1 half period divider. Actual frequency is (system clock / (32 \* half period)), default of 0x20 ((clk / 16) / 64).
- 0xFFF5 - R/W - PWM1 half duty divider. Percentage duty is (half duty / half period), default of 0x10 (50% FOR PERIOD OF 0X20).
- 0xFFF6 - RO - PSRNG most recent data. May give default data if PSRNG is disabled.
- 0xFFF7 - R/W - PSRNG key 1, default value 0xE1
- 0xFFF8 - R/W - PSRNG key 2, default value 0x36
- 0xFFF9 - R/W - PSRNG key 3, default value 0xFA
- 0xFFFA - R/W - PSRNG initial value 1, default value 0x23. This value is used for the first LFSR of the PSRNG. The other initial values are chosen by (initial_2 = initial_1 XOR 0x44) and (initial_3 = initial_1 XOR 0xCC). The values 0x00, 0x44, and 0xCC should be avoided here to avoid collapsing one of the LSFR values to zero.
- 0xFFFB - R/W - UART last transmitted data. Writing to this location starts a one-byte transmission.
- 0xFFFC - RO - UART last received data.
- 0xFFFD - R/W - UART half period divider. Actual frequency is (system clock / (2 \* half period)), default of 0x1 (clk / 2).
- 0xFFFE - R/W - IRQ enables. Bits 0 and 7 are always active and writing to them has no effect.
- 0xFFFF - WO - IRQ invoke. Writing an active value in a bit invokes the corresponding IRQ.

### Interrupts

The MCU supports 8 interrupts. Interrupts are as follows:
- IRQ0 = Reset
   - Invoking this reset is the equivalent of jumping to ROM address 0x0000. The CPU is reset, but memory retains its last values.
- IRQ1 = System Tick
   - If enabled, this interrupt is called once every second, assuming a master clock rate of 256kHz (e.g., every 256000 clock cycles).
- IRQ2 = UART Transmit Complete
   - If enabled, this interrupt triggers when a UART transmission is completed.
- IRQ3 = UART Receive Complete
   - If enabled, this interrupt triggers when a UART receive is completed.
- IRQ4 = EXT 0 Rising Edge
   - If enabled, this interrupt triggers on the rising edge (buffered by a few clock cycles) of GPI 0/EXT 0.
- IRQ5 = EXT 1 Rising Edge
   - If enabled, this interrupt triggers on the rising edge (buffered by a few clock cycles) of GPI 1/EXT 1.
- IRQ6 = Trap on Overflow
   - If enabled, this interrupt will trigger when addition or subtraction results in an overflow.
- IRQ7 = Processing Fault
   - Always enabled. This interrupt will trigger when an internal fault condition occurs. It is suggested that the IRQ table entry for this interrupt halt the CPU core.

### Pinout

All I/O of the standard Tiny Tapeout pinout are allocated.

Dedicated inputs are utilized as follows:
- User Input 0 = GPI 0/EXT 0
   - General purpose input, readable in peripheral memory.
   - May be set as an external interrupt signal.
- User Input 1 = GPI 1/EXT 1
   - General purpose input, readable in peripheral memory.
   - May be set as an external interrupt signal.
- User Input 2 = GPI 2
   - General purpose input, readable in peripheral memory.
- User Input 3 = GPI 3
   - General purpose input, readable in peripheral memory.
- User Inputs 4 and 5 = SPI Clock to CPU Clock Divider
   - By default, the SPI clock is run 36x faster than the CPU clock. These two inputs allow the SPI clock to increase to 38x, 40x, or 42x faster than the CPU (i.e., by dividing the effective speed of the CPU further).
- User Input 6 = External Hold
   - Active high. When asserted, the CPU core acts as though held by the memory manager, and only progresses on the rising edge of the external step signal. Note that peripherals will still update at the system clock rate.
- User Input 7 = External Step
   - When an external hold is active, acts as a single step for the CPU core, essentially a manual clock signal.

Dedicated outputs are utilized as follows:
- User Output 0 = GPO 0
   - General purpose output, accessible in peripheral memory.
- User Output 1 = GPO 1
   - General purpose output, accessible in peripheral memory.
- User Output 2 = GPO 2
   - General purpose output, accessible in peripheral memory.
- User Output 3 = GPO 3
   - General purpose output, accessible in peripheral memory.
- User Output 4 = PWM 0
   - PWM output, channel 0. If not enabled, a low output is given. This PWM channel targets fast signal generation given the default system clock of 256kHz.
- User Output 5 = PWM 1
   - PWM output, channel 1. If not enabled, a low output is given. This PWM channel targets audio frequency generation given the default system clock of 256kHz.
- User Output 6 = PSRNG
   - Current least significant bit of the pseudo-random number generator, if enabled.
- User Output 7 = CPU Activity Indicator
   - Active high. Indicates when the CPU is active. The CPU is considered inactive when halted, waiting for an interrupt, waiting for memory access, or signaled by a peripheral to wait.

Bi-directional pins are configured and utilized as follows:
- User I/O 0 = SPI RAM CS (Output)
   - The SPI chip select for the SPI RAM.
   - On a Tiny Tapeout PCB, this corresponds to RP2040 GPIO21.
- User I/O 1 = SPI RAM COPI (Output)
   - The SPI controller-out, peripheral-in for the SPI RAM.
   - On a Tiny Tapeout PCB, this corresponds to RP2040 GPIO22.
- User I/O 2 = SPI RAM CIPO (Input)
   - The SPI controller-in, peripheral-out for the SPI RAM. Data is latched on the rising edge of the SCK signal.
   - On a Tiny Tapeout PCB, this corresponds to RP2040 GPIO23.
- User I/O 3 = SPI RAM SCK (Output)
   - The SPI clock for the SPI RAM.
   - On a Tiny Tapeout PCB, this corresponds to RP2040 GPIO23.
- User I/O 4 = UART CTS (Input)
   - UART clear-to-send input from the DCE. Optional.
- User I/O 5 = UART TxD (Output)
   - UART transmit output from the DTE to the DCE, based on the current baud rate configuration.
   - Note that transmitted data is clock aligned to the CPU.
- User I/O 6 = UART RxD (Input)
   - UART receive input from the DCE to the DTE, based on the current baud rate configuration.
- User I/O 7 = UART RTS (Output)
   - UART ready-to-send output from the DTE. Optional.

Notes about SPI RAM and Tiny Tapeout SPI RAM emulation:
- The max speed for SPI RAM access, considering all operations, is RP2040 MCLK / 10. The base RP2040 MCLK is 12MHz, so the maximum SPI operating frequency should be 1.2MHz. Note that different maximum frequencies (up to 12MHz) may be valid if a PLL is used for faster internal RP2040 clocking.
- To reach the target clock of the MCU, 256kHz, and requiring 4 bytes (32 bits) to be transmitted over SPI for each data read/write + 4 control clock cycles, requires a SPI clock speed of 9.216MHz to read a memory location in one clock cycle, allowing any non-RJMP, non-memory access instruction, non-IRQ to be predictively read from ROM "just in time."
- The external hold signal from the memory manager will hold execution in the case of speed mismatch.

### Primary Control Signals

As per any Tiny Tapeout module, the following primary control signals are included:
- Enable
   - Active high, indicates when the module is active compared to other modules.
   - In normal operation for a Tiny Tapeout IC, this value is active any time the module is powered.
- Reset
   - Active low master reset signal.
- Clock
   - Master clock.
   - For a Tiny Tapeout IC, any value between 3Hz and 50MHz may be generated for this signal.
   - While the project options compiles with the maximal IC frequency as an operational target, a value of 9.216MHz should be used to allow for proper clocking of the SPI peripheral (uses the master clock directly) and the CPU (by default, divides the master clock by 36, giving 256kHz).
   - Other clock rates may be used, bounded by a 12MHz maximum SPI speed, though peripherals and memory accesses may not work as intended. Of particular note, a CPU clock rate of 256kHz was chosen to allow for generation of a 128kbaud UART, as 128kbaud is a well-defined baud rate.
   - The system tick timer assumes a clock rate of 256kHz, so the "one second" interrupt and other interpretation of wall time will be scaled corresponding to any changes of the CPU clock rate.

## Testing

To utilize the RISCY Jr. MCU:
1. Develop a program. No assembler or higher-level tools (compiler, etc.) are provided, so binary files must be manually assembled.
2. Program the RP2040 to emulate SPI RAM, loading the developed program as the low 32kB and using the high 32kB as RAM.

## External hardware

The RISCY Jr. MCU utilizes the following Tiny Tapeout [external hardware](https://tinytapeout.com/specs/pinouts/):
- RP2040, in [SPI RAM emulation mode](https://github.com/MichaelBell/spi-ram-emu/)
- UART with optional hardware flow control
   - Uses BOTTOM ROW pinout!
