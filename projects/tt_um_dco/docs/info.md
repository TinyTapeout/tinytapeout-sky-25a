> ## 📌 Credits  
>  
> We sincerely acknowledge the **Center of Excellence in Integrated Circuits and Systems (CoE-ICAS)** and the **Department of Electronics and Communication Engineering, RV College of Engineering, Bengaluru**, for their invaluable support in providing us with the necessary knowledge and training.  
> 
> We extend our special gratitude to **Dr. Ravish Aradhya H V (HoD, ECE)**, **Dr. K S Geetha (Vice Principal)** and **Dr. K N Subramanya (Principal)** and **Rashtreeya Shikshana Samithi Trust** for their continuous encouragement and support, enabling us to achieve **TAPEOUT** in **Tiny Tapeout TTSKY25A**.  
>  
> We are also deeply grateful to **Mahaa Santeep G (RVCE Alumni)** for his mentorship and invaluable guidance throughout the completion of this project.  
  
## How it works

The tt_um_dco module is a digitally controlled oscillator (DCO) that generates a frequency-adjustable clock signal based on an 8-bit control input (ui_in). The control input determines the oscillation period using a priority-based selection, where the highest active bit sets the period between 3 and 50 clock cycles. A fast clock is derived from the main clock (clk) using a 4-bit divider, toggling every four cycles. A counter increments on each clock edge, and when it reaches the selected period, dco_out toggles, generating the output waveform. The reset (rst_n) initializes the oscillator, and unused outputs are assigned zero to prevent warnings.

## How to test

To verify the functionality of the tt_um_dco module, a testbench (tb) has been provided. The testbench simulates different input scenarios and observes the output behavior of the tt_um_dco module to ensure that it works correctly.

**Inputs and Clock Frequency**

**u_in** is used to receive dco_code.

**rst_n** is the active-low reset signal.

**clk** operates at a 50 MHz frequency.

| **Time (ns)** | **ui_in**           | **Reset** | **ena** | **uo_out (Output)** | **Clock** |
|---------------|---------------------|-----------|---------|---------------------|-----------|
| 0             | `00000001`          |  1        | 1       | `00000000`          | 1         |
| 10            | `00000001`          |  1        | 1       | `00000000`          | 0         |
| 20            | `00000001`          |  0        | 1       | `00000000`          | 1         |
| 30            | `00000001`          |  0        | 1       | `00000000`          | 0         |
| 40            | `00000001`          |  0        | 1       | `00000000`          | 1         |
| 50            | `00000001`          |  0        | 1       | `00000000`          | 0         |
| 60            | `00000001`          |  0        | 1       | `00000000`          | 1         |
| 70            | `00000001`          |  0        | 1       | `00000000`          | 0         |
| 80            | `00000001`          |  0        | 1       | `00000000`          | 1         |
| 90            | `00000001`          |  0        | 1       | `00000000`          | 0         |
| 100           | `00000001`          |  0        | 1       | `00000001`          | 1         |
| 110           | `00000001`          |  0        | 1       | `00000001`          | 0         |
| 120           | `00000001`          |  0        | 1       | `00000001`          | 1         |
| 130           | `00000001`          |  0        | 1       | `00000001`          | 0         |
| 140           | `00000001`          |  0        | 1       | `00000001`          | 1         |
| 150           | `00000001`          |  0        | 1       | `00000001`          | 0         |
| 160           | `00000001`          |  0        | 1       | `00000001`          | 1         |
| 170           | `00000001`          |  0        | 1       | `00000001`          | 0         |
| 180           | `00000001`          |  0        | 1       | `00000001`          | 1         |
| 190           | `00000001`          |  0        | 1       | `00000000`          | 0         |
| 200           | `00000001`          |  0        | 1       | `00000000`          | 1         |
| 210           | `00000001`          |  0        | 1       | `00000000`          | 0         |
Table: Test cases for DCO

| **ui_in**    | **Output Frequency** |
|-------------|----------------------|
| `00000000`  | 20 MHz               |
| `00000001`  | 6.25 MHz             |
| `00000010`  | 5 MHz                |
| `00000100`  | 4.166 MHz            |
| `00001000`  | 3.57 MHz             |
| `00010000`  | 3.125 MHz            |
| `00100000`  | 2.77 MHz             |
| `01000000`  | 2.5 MHz              |
| `10000000`  | 2.27 MHz             |
Table: Input vs Output Frequency

## External hardware

During the simulation, you can monitor the console or waveform outputs for detailed step-by-step results. The testbench uses $monitor to display real-time updates of the inputs and the resulting output.
