<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->
## How it works
This AFM-based LIF neuron model implementation features:
- 16-bit membrane potential
- Fully customizable parameters
- 8 pipline stages
- 8-bit current input
- 8 neurons in one structure

The equition of AFM based LIF neuron model is:

$$V[t+1] = AFM\!\left(e^{-\frac{1}{\tau}}, v[t]-E_{rest}\right) + E_{rest} + I$$
$$\text{if } V[t] \leq V_{th}, \text{ then } V[t+1] = E_{rest}$$

The execution of this architecture consists of three phases:
1. Parameter initialization  
2. Neuron initialization  
3. Normal operation  

## How to test

1. Reset (Low to reset, rst_n = 0)
    - All the parameter and membrane potential reset to 0.

2. Parameter initialization  
    1. **E_REST** requires two cycles of input.  
    2. **e_tau** requires one cycle of input.
    3. **v_th** requires two cycles of input.  

3. Neuron initialization  
    - The initial membrane potentials of 8 neurons are input in sequence.  
    - After waiting for **2.5 clock cycles**, the initial currents are input sequentially.
    - Each neuron requires **1 clock cycle** for initialization.

4. Normal operation
    - Input currents sequentially  
    - Each neuron computation takes **1 clock cycle**  
    - 8 neurons require **8 clock cycles** in total
