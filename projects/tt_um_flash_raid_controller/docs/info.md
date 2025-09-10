# Flash RAID Controller

A dual SPI flash controller ASIC that acts between hosts and flash memory chips, providing address-based routing and runtime configuration for flash redundancy and load balancing.

## How it works

The Flash RAID Controller sits transparently between SPI hosts and two SPI flash chips, intelligently routing read operations based on programmable address ranges while maintaining complete SPI protocol compatibility.

### Key Features

- **Dual Host Support**: Accepts SPI commands from either main or secondary host interfaces
- **Dual Flash Routing**: Routes operations to main flash, secondary flash, or both simultaneously  
- **Address Range Detection**: Programmable 24-bit address ranges determine flash selection for read operations
- **Runtime Configuration**: SPI management interface allows real-time configuration changes
- **Transaction Safety**: All switching operations are transaction-safe to prevent data corruption

### Operating Modes

1. **MAIN Mode**: All operations route to main flash only (single flash operation)
2. **SECONDARY Mode**: All operations route to secondary flash only (failover operation)  
3. **SHARE Mode**: Both flashes receive identical commands, MISO selection based on address ranges

### Address Range Routing

In SHARE mode, the controller analyzes SPI read commands (0x03, 0x0B) and compares the 24-bit address against two programmable ranges:

- **Range 0**: Configurable start/end addresses → selectable flash (main or secondary)
- **Range 1**: Configurable start/end addresses → selectable flash (main or secondary)
- **Default**: Addresses outside ranges use default flash selection

Write operations always use the default flash selection to prevent data corruption from misconfigured ranges.

### Management Interface

A dedicated SPI slave interface provides runtime configuration through 14 registers (0x00-0x0D):

- Address range configuration (start/end for each range)
- Mode control (MAIN/SECONDARY/SHARE)
- Range enable/disable and flash selection
- Host selection (main/secondary)
- Status monitoring

The management interface uses a 14-register map accessed via SPI commands 0x02 (write) and 0x03 (read):

  | Address | Register | R/W | Description | Default |
  |---------|----------|-----|-------------|---------|
  | 0x00 | ADDR0_START_H | R/W | Range 0 Start Address [23:16] | 0x00 |
  | 0x01 | ADDR0_START_M | R/W | Range 0 Start Address [15:8] | 0x00 |
  | 0x02 | ADDR0_START_L | R/W | Range 0 Start Address [7:0] | 0x00 |
  | 0x03 | ADDR0_END_H | R/W | Range 0 End Address [23:16] | 0xFF |
  | 0x04 | ADDR0_END_M | R/W | Range 0 End Address [15:8] | 0xFF |
  | 0x05 | ADDR0_END_L | R/W | Range 0 End Address [7:0] | 0xFF |
  | 0x06 | ADDR1_START_H | R/W | Range 1 Start Address [23:16] | 0x00 |
  | 0x07 | ADDR1_START_M | R/W | Range 1 Start Address [15:8] | 0x00 |
  | 0x08 | ADDR1_START_L | R/W | Range 1 Start Address [7:0] | 0x00 |
  | 0x09 | ADDR1_END_H | R/W | Range 1 End Address [23:16] | 0xFF |
  | 0x0A | ADDR1_END_M | R/W | Range 1 End Address [15:8] | 0xFF |
  | 0x0B | ADDR1_END_L | R/W | Range 1 End Address [7:0] | 0xFF |
  | 0x0C | CONTROL_REG | R/W | Control Register | 0x00 |
  | 0x0D | STATUS_REG | R | Status Register | 0x00 |

  #### Control Register (0x0C) Bit Definitions
  - **Bits [1:0]**: Flash Mode
    - `00`: MAIN - Only main flash active
    - `01`: SECONDARY - Only secondary flash active
    - `10`: SHARE - Both flashes active, address-based MISO selection
    - `11`: Reserved
  - **Bit [2]**: Range 0 Enable (0=disabled, 1=enabled)
  - **Bit [3]**: Range 1 Enable (0=disabled, 1=enabled)
  - **Bit [4]**: Range 0 Flash Select (0=main flash, 1=secondary flash)
  - **Bit [5]**: Range 1 Flash Select (0=main flash, 1=secondary flash)
  - **Bit [6]**: Host Select (0=main host, 1=secondary host)
  - **Bit [7]**: Reserved

  #### Status Register (0x0D) Bit Definitions
  - **Bit [0]**: SPI Transaction Active (management interface busy)
  - **Bit [1]**: Last Command was Read (0x03 detected)
  - **Bit [2]**: Last Command was Write (0x02 detected)
  - **Bits [7:3]**: Reserved

  #### SPI Protocol
  - **Write Command**: 0x02 [Address] [Data]
  - **Read Command**: 0x03 [Address] → [Data]
  - **SPI Mode**: Mode 0 (CPOL=0, CPHA=0)
  - **Clock Speed**: Up to 1 MHz recommended

## How to test

### Basic Functionality Test

1. **Connect Hardware**: Wire SPI host, two SPI flash chips, and management controller according to pinout
2. **Default Operation**: Power on - controller defaults to MAIN mode routing all operations to main flash
3. **Verify Passthrough**: Read/write operations from host should work transparently through main flash

### Advanced Configuration Test

1. **Management Setup**: Connect SPI master to management interface (pins: mgmt_sclk, mgmt_cs_n, mgmt_mosi, mgmt_miso)

2. **Configure Address Ranges**:
   ```
   # Example: Split 16MB flash - first 8MB to main, second 8MB to secondary
   Write 0x00-0x02: 0x00, 0x00, 0x00  (Range0 start: 0x000000)
   Write 0x03-0x05: 0x7F, 0xFF, 0xFF  (Range0 end: 0x7FFFFF) 
   Write 0x06-0x08: 0x80, 0x00, 0x00  (Range1 start: 0x800000)
   Write 0x09-0x0B: 0xFF, 0xFF, 0xFF  (Range1 end: 0xFFFFFF)
   Write 0x0C: 0x2E                    (SHARE mode + both ranges enabled + Range1→secondary)
   ```

3. **Test Address Routing**:
   - Read from 0x400000 → should return data from main flash
   - Read from 0x900000 → should return data from secondary flash

### Host Switching Test

1. **Configure Secondary Host**: Connect second SPI host to secondary interface
2. **Switch Host**: Use management interface to set bit 6 of control register (0x0C)
3. **Verify Switching**: Operations from secondary host should now control the flashes


## External hardware

### Required Components

1. **SPI Flash Chips (2x)**:
   - JEDEC-compatible SPI NOR flash (e.g., W25Q128, MX25L12835E)
   - Minimum 16MB (128Mbit) recommended for address range testing
   - 3.3V operation, SPI Mode 0 (CPOL=0, CPHA=0)

2. **SPI Host Controller**:
   - Microcontroller with SPI master capability (e.g., Arduino, Raspberry Pi)
   - Or dedicated SPI host device
   - 3.3V I/O levels

3. **Management Controller** (Optional but recommended):
   - Second SPI master for runtime configuration
   - Can be same microcontroller with multiple SPI interfaces
   - Or separate microcontroller/SPI bridge device

  ### Wiring Connections

  Main Host Interface:
    ui[0] (main_host_sclk)     → Host SPI Clock
    ui[1] (main_host_cs_n)     → Host SPI Chip Select#
    ui[2] (main_host_mosi)     → Host SPI MOSI (Data Out)
    uo[0] (main_host_miso)     → Host SPI MISO (Data In)

  Secondary Host Interface:
    ui[3] (secondary_host_sclk) → Secondary Host SPI Clock
    ui[4] (secondary_host_cs_n) → Secondary Host SPI Chip Select#
    ui[5] (secondary_host_mosi) → Secondary Host SPI MOSI (Data Out)
    uo[1] (secondary_host_miso) → Secondary Host SPI MISO (Data In)

  Management Interface:
    ui[6] (mgmt_sclk)          → Management SPI Clock
    ui[7] (mgmt_cs_n)          → Management SPI Chip Select#
    uio[0] (mgmt_mosi)         → Management SPI MOSI (Data Out)
    uo[2] (mgmt_miso)          → Management SPI MISO (Data In)

  Main Flash Connection:
    uo[3] (main_flash_sclk)    → Main Flash SPI Clock
    uo[4] (main_flash_cs_n)    → Main Flash SPI Chip Select#
    uo[5] (main_flash_mosi)    → Main Flash SPI MOSI (Data In)
    uio[1] (main_flash_miso)   → Main Flash SPI MISO (Data Out)

  Secondary Flash Connection:
    uo[6] (secondary_flash_sclk) → Secondary Flash SPI Clock
    uo[7] (secondary_flash_cs_n) → Secondary Flash SPI Chip Select#
    uio[3] (secondary_flash_mosi) → Secondary Flash SPI MOSI (Data In)
    uio[2] (secondary_flash_miso) → Secondary Flash SPI MISO (Data Out)
    uio[4] (secondary_flash_wp_n) → Secondary Flash Write Protect# (tied high)

### Example Test Setup

A complete test setup might include:
- MCU as primary host and management controller, can have additional host to act as secondary
- Two 128Mbit SPI flash chips (different manufacturers for diversity testing)  
- Logic analyzer connected to monitor all SPI buses
- LED indicators for visual status feedback
- Push buttons for manual mode switching tests