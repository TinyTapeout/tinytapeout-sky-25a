

<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->
# Posit <8,0> Division
  
## How it works

This project is a <8,0> Posit division circuit. Posits are a format for representing fractional numbers similar to floats. More information about the posit format can be found [here](https://posithub.org/docs/BeatingFloatingPoint.pdf). The <8,0> means, 8 bits wide with _es_=0. The circuit functions by breaking down the division operation into the following stages. First, it decodes the posit inputs into [fixed point](https://en.wikipedia.org/wiki/Fixed-point_arithmetic) numbers and a scaling factor. Then it aligns the two fixed point numbers based on their relative scales. Following this it re-scales and rounds their product. Finally it re-encodes the fixed point number back into the posit format.  

## Optimizations 

In this project I focused on reducing the critical path of the calculation. This was done through the following optimizations:
TODO
<!-- 1) For large multi-bit multiplications implementing [SQRT CSA](https://en.wikipedia.org/wiki/Carry-select_adder). 
2) For multiplication of constants using "+" in the code. This is because in synthesis constants are optimized down.x
3) When possible calling the skywater [ha](https://sky130-unofficial.readthedocs.io/en/latest/contents/libraries/sky130_fd_sc_hd/cells/ha/README.html) and [fa](https://sky130-unofficial.readthedocs.io/en/latest/contents/libraries/sky130_fd_sc_hd/cells/fa/README.html) directly in the RTL.  
4) For cases where it there were branching multiplication paths, multiple parallel multiplication circuits were generated with their outputs muxed. 
5) When possible reducing multiplication operations to as few bits as possible.
6) Focusing only on the <8,0> posit. In the case that _es_ was variable, parts of the circuit would be require more logic, and there would need to be one more stage to handle the posit's exponent.
 -->

Things I would be interested in optimizing in the future:
1) Updating the logic such that there is no need to convert using two's compliment on the input and the output. 
2) Selecting gate sizing (or number of gate fingers) based off of the logical effort, fanout, and electrical effort.
3) Investigating adding inverters in the case it will make the path's delay any better.
4) Hand routing portions of the chip to reach higher density.
5) Converting a RCA subtraction near the start of the logic into a SQRT CSA.


## How to test

Prefabrication this project was tested by using software <8,0>posit division to generate a table of correct outputs for all possible inputs. Then the project was simulated using the same inputs and it's output was compared against the correct output. A user can replicate this by following the readme instructions in the [test/README.md](test/README.md).

Postfabrication to test this project the user needs to do the following. First the user needs to supply the ui[7:0] with input posit A and supply uio[7:0] with input posit B. Following this the resulting sum of A+B should be output on uo[7:0]. I intend to test the tt-chip with a micro-controller connected to the tt-chip on a PCB designed by my coworker. Another possible way to supply inputs to the pins could be a DIP switch. 
