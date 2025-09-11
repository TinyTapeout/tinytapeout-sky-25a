# Choreo8
An 8-LED visual effects controller with multiple animated patterns, speed control, and pause functionality implemented in Verilog for ASIC fabrication.

## What it does
This project creates an engaging LED display controller that generates 8 different animated lighting patterns. From classic Knight Rider effects to random sparkle patterns, it provides a versatile platform for visual displays, status indicators, or decorative lighting applications.

## How it works
The LED Pattern Generator operates on a **5MHz system clock** and uses a built-in clock divider to create two speed modes:
- **Fast Mode (speed_sel = 0)**: Patterns update at **4Hz** for dynamic effects
- **Slow Mode (speed_sel = 1)**: Patterns update at **1Hz** for relaxed viewing

### Clock Architecture
The system uses a **5MHz input clock** that gets divided internally:
- **5MHz → 4Hz**: Division ratio of 1,250,000 for fast mode
- **5MHz → 1Hz**: Division ratio of 5,000,000 for slow mode

This clock division provides precise timing control for smooth pattern animations while maintaining synchronization across all LED effects.

### Core Architecture
1. **Pattern Selection**: A 3-bit input (`pat_sel`) selects from 8 different patterns
2. **Clock Division**: Internal divider creates timing references for pattern updates from the 5MHz base clock
3. **Pattern Registers**: Each pattern uses dedicated registers to track position and direction
4. **Output Logic**: Combinatorial logic generates the 8-bit LED output based on current pattern state

### Pattern Descriptions
| Pattern | Description | Visual Effect |
|---------|-------------|---------------|
| **Knight Rider** | Two LEDs start at opposite ends, meet in middle, return | Symmetric converging/diverging LED effect |
| **Walking Pairs** | Adjacent LED pair walks left-to-right and back | Bidirectional pair movement with direction reversal |
| **Expand/Contract** | LEDs expand from center outward, then contract | Breathing effect from middle |
| **Blink All** | All 8 LEDs flash simultaneously | Simple synchronized blinking |
| **Alternate** | Checkerboard pattern alternates | 10101010 ↔ 01010101 pattern |
| **Marquee** | 3-LED group rotates around the strip | Theater marquee chasing lights |
| **Random Sparkle** | Pseudo-random twinkling using LFSR | Unpredictable sparkle effects |
| **All Off** | All LEDs disabled | System standby mode |

### Key Features
- **Pause Control**: Freeze current pattern state while maintaining position
- **Enable Control**: Module can be disabled while preserving internal state
- **Asynchronous Reset**: Clean initialization of all pattern states
- **Low Resource Usage**: Efficient design suitable for ASIC implementation
- **Precise Timing**: 5MHz base clock ensures accurate pattern timing

## How to test

### Basic Operation
1. **Power On**: Assert `rst_n` (active low reset) to initialize the system
2. **Enable**: Set `ena` high to activate pattern generation
3. **Pattern Selection**: Use `pat_sel[2:0]` to choose desired pattern (000-111)
4. **Speed Control**: Toggle `speed_sel` for fast (4Hz) or slow (1Hz) operation
5. **Pause**: Assert `pause` to freeze current pattern state

### Input Pin Configuration
| Input | Pin | Function | Values |
|-------|-----|----------|---------|
| `ui_in[2:0]` | Pattern Select | Choose active pattern | 000-111 |
| `ui_in[3]` | Speed Select | Control update rate | 0=Fast (4Hz), 1=Slow (1Hz) |
| `ui_in[4]` | Pause | Freeze pattern | 0=Run, 1=Pause |
| `ui_in[5]` | Enable | Module enable/disable | 0=Disable, 1=Enable |
| `ui_in[7:6]` | Unused | Reserved for future use | Don't care |

### Clock Requirements
- **Input Clock**: 5MHz 
- **Pattern Update Rates**: 
  - Fast mode: 4Hz (250ms per update)
  - Slow mode: 1Hz (1000ms per update)

### Output Verification
The 8-bit `uo_out[7:0]` directly drives the LED array. Each bit corresponds to one LED:
- `uo_out[0]` → LED 0 (leftmost)
- `uo_out[7]` → LED 7 (rightmost)

### Expected Behavior
- **Knight Rider**: Should see two LEDs moving inward, meeting, then separating
- **Walking Pairs**: Adjacent LED pair should smoothly traverse the strip
- **Expand/Contract**: LEDs should grow from center, then shrink back symmetrically
- **Random Sparkle**: Should display unpredictable but continuous twinkling
