# EV Motor Control System

A comprehensive electric vehicle motor control system implemented on Tiny Tapeout, featuring dual-mode operation (PLC/HMI), motor speed control with PWM, temperature monitoring, and various vehicle subsystems control.

## How it works

This EV motor control system provides a complete solution for managing electric vehicle operations through a single ASIC. The design implements:

### Core Architecture

The system operates on a **state-machine based architecture** with an 8-operation selector that controls different subsystems:

- **Operation 000**: Power Control System
- **Operation 001**: Headlight Management  
- **Operation 010**: Horn Control
- **Operation 011**: Right Indicator Control
- **Operation 100**: Motor Speed Calculation
- **Operation 101**: PWM Generation for Motor Drive
- **Operation 110**: Temperature Monitoring
- **Operation 111**: System Reset/Status

### Dual Control Interface

The system supports **dual-mode operation**:
- **PLC Mode** (mode_select = 0): Industrial control via Programmable Logic Controller
- **HMI Mode** (mode_select = 1): Human-Machine Interface for direct operator control

All control signals use **XOR logic** between PLC and HMI inputs, ensuring only one source can control each function at a time, preventing conflicts.

### Motor Control System

**Speed Calculation**: 
- Takes 4-bit accelerator and brake inputs
- Calculates speed as: `speed = max(0, accelerator - brake)`
- Scales result to 8-bit motor speed output
- Implements safety cutoff when brake > accelerator

**PWM Generation**:
- Generates variable duty cycle PWM based on calculated speed
- PWM frequency derived from main clock through divider
- Automatic shutdown during temperature faults
- 8-bit resolution for smooth motor control

### Safety Systems

**Temperature Monitoring**:
- Simulates realistic temperature rise during motor operation
- Triggers fault at 110°C with 5°C hysteresis (clears at 105°C)
- Automatic speed reduction (50%) during overheating
- Real-time temperature tracking with cooling simulation

**Fault Protection**:
- System-wide shutdown capability
- Temperature-based motor protection
- Power-off safety for all subsystems

### Input/Output Mapping

**Dedicated Inputs (ui_in[7:0])**:
- `[2:0]`: Operation selector (8 operations)
- `[3]`: PLC power control
- `[4]`: HMI power control  
- `[5]`: Mode selector (PLC/HMI)
- `[6]`: PLC headlight control
- `[7]`: HMI headlight control

**Bidirectional I/O (uio_in[7:0] input, uio_out[7:0] output)**:
- `uio_in[0]`: PLC horn control
- `uio_in[1]`: HMI horn control
- `uio_in[2]`: PLC right indicator
- `uio_in[3]`: HMI right indicator
- `uio_in[7:4]`: 4-bit accelerator/brake data (time-multiplexed)
- `uio_out[7:0]`: 8-bit motor speed output

**Dedicated Outputs (uo_out[7:0])**:
- `[0]`: Power status LED
- `[1]`: Headlight output
- `[2]`: Horn output  
- `[3]`: Right indicator output
- `[4]`: Motor PWM signal
- `[5]`: Overheat warning LED
- `[7:6]`: System status LEDs (enable, fault)

## How to test

### Basic Functionality Test

1. **Power-Up Sequence**:
   ```
   - Set ena = 1, rst_n = 0
   - Wait 10 clock cycles
   - Set rst_n = 1
   - Set operation_select = 3'b000
   - Set either power_on_plc = 1 OR power_on_hmi = 1 (not both)
   - Verify uo_out[0] = 1 (power status)
   ```

2. **Headlight Test**:
   ```
   - Ensure system is powered on
   - Set operation_select = 3'b001
   - Set headlight_plc = 1, headlight_hmi = 0
   - Verify uo_out[1] = 1 (headlight on)
   ```

3. **Motor Speed Test**:
   ```
   - Set operation_select = 3'b100
   - Set uio_in[7:4] = 4'd12 (accelerator)
   - Wait 2 clock cycles for data_select toggle
   - Set uio_in[7:4] = 4'd4 (brake)  
   - Wait 5 clock cycles
   - Verify uio_out = 8'd128 (expected: (12-4)<<4 = 128)
   ```

4. **PWM Generation Test**:
   ```
   - Set operation_select = 3'b101
   - Monitor uo_out[4] for multiple clock cycles
   - Verify PWM signal toggles between 0 and 1
   - Duty cycle should correspond to motor speed
   ```

### Advanced Testing

**Temperature Fault Testing**:
- Run motor at high speed (accelerator = 15, brake = 0) for extended time
- Monitor uo_out[5] for overheat warning
- Verify automatic speed reduction during fault

**Mode Switching**:
- Test both PLC mode (mode_select = 0) and HMI mode (mode_select = 1)
- Verify XOR logic prevents simultaneous control from both sources

**Edge Cases**:
- Test brake > accelerator (should result in zero speed)
- Test power-off behavior (all outputs should be disabled)
- Test system reset (operation_select = 3'b111)

### Test Sequence Example

```python
# Complete test sequence in cocotb
await reset_sequence()
await test_power_control()
await test_headlight_control()  
await test_horn_control()
await test_motor_speed_calculation()
await test_pwm_generation()
await test_temperature_monitoring()
await test_mode_selection()
await test_edge_cases()
```

## External hardware

The following external hardware components are recommended for a complete EV motor control implementation:

### Required Components

**Motor Drive Circuit**:
- **3-Phase BLDC Motor** (rated for vehicle application)
- **Motor Driver IC** (e.g., DRV8305, DRV8323) - connects to PWM output (uo_out[4])
- **Gate Driver Circuit** for high-current switching
- **Current Sense Resistors** (0.01Ω, 2W) for overcurrent protection

**Power Supply**:
- **12V/24V Vehicle Battery** connection
- **5V Regulator** (LM7805 or switching regulator) for logic power
- **Power MOSFETs** (IRFZ44N or similar) for high-current switching

**Interface Connectors**:
- **DB9 or DB15 Connector** for PLC interface connection
- **Touch Screen HMI Panel** (7" recommended) for operator interface
- **CAN Bus Interface** (MCP2515 + MCP2551) for vehicle network communication

### Recommended PMODs

**PMOD Connectors for Easy Integration**:

1. **PMOD Motor** - PWM motor control board
   - Connects to uo_out[4] (PWM signal)
   - Provides buffered outputs for motor drivers

2. **PMOD LED8** - Status indicator array
   - Connects to uo_out[7:0] for visual status display
   - Shows power, headlight, horn, indicator, PWM, fault, and system status

3. **PMOD Switch** - Manual input controls
   - Connects to ui_in[7:0] for manual operation mode
   - Provides physical switches for testing

4. **PMOD Thermocouple** - Real temperature sensing
   - Can replace simulated temperature monitoring
   - Provides actual motor temperature feedback

### Vehicle Integration Hardware

**Lighting Systems**:
- **Headlight Relays** (12V automotive relays) - controlled by uo_out[1]
- **Horn Relay** and **Horn Assembly** - controlled by uo_out[2]  
- **LED Indicator Lights** - controlled by uo_out[3]

**Sensors and Feedback**:
- **Hall Effect Accelerator Pedal** - provides analog input for uio_in[7:4]
- **Brake Pressure Sensor** - provides brake input data
- **Temperature Sensors** (DS18B20 or thermistors) for motor and controller monitoring

**Safety Systems**:
- **Emergency Stop Switch** - hardware override for immediate shutdown
- **Cooling Fan** - controlled by overheat warning (uo_out[5])
- **Fuses and Circuit Breakers** for overcurrent protection

### Connection Diagram

```
TinyTapeout Chip
├── ui_in[7:0] → Input switches/PLC interface
├── uo_out[7:0] → LED indicators/Relays/PWM output
├── uio_in[7:4] → Accelerator/Brake sensors
├── uio_out[7:0] → Motor speed display/CAN interface
└── Power: 5V regulated, GND

External Power: 12V/24V vehicle battery
Motor: 3-phase BLDC + driver circuit
HMI: 7" touchscreen panel
PLC: Industrial controller interface
```

### Safety Considerations

- **Isolated Power Supplies** for logic and motor circuits
- **Optical Isolation** for PLC/HMI interfaces  
- **Emergency Stop Circuits** with hardware override capability
- **Thermal Management** for high-power motor control
- **EMI Filtering** for automotive electromagnetic compatibility

This hardware setup provides a complete, production-ready EV motor control system suitable for small electric vehicles, e-bikes, or prototype electric car applications.
