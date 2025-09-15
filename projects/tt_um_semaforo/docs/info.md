<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
This project was developed as part of the course **IEE2713-1: Digital Systems** at **Pontificia Universidad Católica de Chile**, under the guidance of **Prof. Cristian Tejos**. 

It implements a **finite state machine (FSM)** combined with a counter to simulate the operation of a traffic light controller for two perpendicular streets: **Street A** and **Street B**.  

- **Normal mode**: Street A has priority. If cars are detected on Street A (sensor TA), its light stays green. When there are no more cars, Street A changes to yellow for a fixed time, then to red, allowing Street B to turn green. The cycle then repeats with Street B.  
- **Parade mode (P)**: When the button *P* is pressed, Street B stays green indefinitely, regardless of sensors.  
- **Exit parade mode (R)**: Pressing *R* exits parade mode, and the system returns to normal operation.  
- A synchronous **counter** is used to generate the fixed timing for the yellow phases.  

The FSM starts from Street A in green after reset.  


## How to test


1. Provide a clock signal to the module (`clk`) and assert reset (`rst_n = 0 → 1`).  
2. Use the input pins to simulate the presence of cars and mode changes:  
   - `ui_in[0]` → TA (car sensor Street A)  
   - `ui_in[1]` → TB (car sensor Street B)  
   - `ui_in[2]` → P (parade mode button)  
   - `ui_in[3]` → R (reset parade mode button)  
3. Observe the outputs:  
   - `uo_out[1:0]` → LA (traffic light Street A: 00=Red, 01=Yellow, 10=Green)  
   - `uo_out[3:2]` → LB (traffic light Street B: 00=Red, 01=Yellow, 10=Green)  
   - `uo_out[4]`   → `on` (counter finished flag, active during yellow phase).  

You can run the simulation using **cocotb** and `make SIM=icarus` or test directly on FPGA with buttons and LEDs.  

---Refer to the image in the img folder to view the state machine diagram.


## External hardware

- **6 LEDs** to display the two traffic lights (Red, Yellow, Green for each street).  
- **5 push-buttons**:  
  - 1 for TA (Street A sensor)  
  - 1 for TB (Street B sensor)  
  - 1 for P (activate parade mode)  
  - 1 for R (exit parade mode)  
  - 1 for Reset  

---
