# 8-bit Up/Down Counter

## How it works
This project implements an 8-bit up/down counter in Verilog. The counter increments or decrements its value between 0 and 255 based on the `up_down` control signal:  
- `up_down = 1` → counts up  
- `up_down = 0` → counts down  

The counter only updates on the rising edge of the `clk` signal when the `enable` input is high. An active-low reset (`rst_n`) sets the counter to 0. The current counter value is output on the 8-bit `uo_out` bus.

### Summary of signals:
- `ui[0]` = enable  
- `ui[1]` = up/down control  
- `ui[2]` = clock (`clk`)  
- `uo[0..7]` = 8-bit counter output (`q`)  

## How to test
1. Connect the `clk` input to a clock source (or simulation clock).  
2. Drive `ui[0]` high to enable counting.  
3. Drive `ui[1]` high to count up or low to count down.  
4. Optionally, pull `rst_n` low to reset the counter to 0.  
5. Observe the 8-bit output on `uo[0..7]` to verify the counter value.  

Simulation can be performed using any Verilog simulator (e.g., Icarus Verilog, ModelSim, or TinyTapeout simulation environment).  

## External hardware
This project does not require any external hardware. All logic is contained within the TinyTapeout tile.  
Optionally, the output bus `uo_out` can be connected to LEDs, a logic analyzer, or other display modules to visualize the count.
