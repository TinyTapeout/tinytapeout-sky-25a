<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Stochastic Computing (SC) is a method of computing that uses values represented by probabilities. This project uses the bipolar format of stochastic computing to model a neuron based on the Quadratic Integrate and Fire (QIF) equation.

The QIF equation used is $\frac {dx} {dt}\ = x^2 + b$, and in this digital design a rewritten version is used as $x_{(n)} = x_{(n-1)} + a(x_{(n-1)}^2 + b)$.

In a SC bipolar format, the range of values represented by the bitstream becomes [-1,1]. In this format, a XNOR gate functions as a multiplier, a MUX functions as a adder and a up/down counter functions as an integrator. A flip flop is needed to decorrelate the same bitstream coming from the counter so that the XNOR can function as a self-multiplier.

The LFSR in this design generates psuedo random numbers which are used to generate the value carrying random bitstreams in SC, using comparators. The LFSR's generated values were scrambled so that multiple values could be used together without decorrelation issues.

The model here is a feedback loop with only 1 direct input to the neuron, which is the added component 'b' in the equation. The inputs can control the value of b as a 9 bit value. The outputs directly give the value in the integrator, which is the model neuron's current value. 


## How to test
Use the inputs {uio_in [0], ui_in [7:0]} to set the input value of 9 bits for the b value. 
The integrator's value is directly output as the neuron's current value in as 9 bits : {uio_out[7], output [7:0]}. 

## External hardware
Oscilloscope to see the output of the model neuron.

