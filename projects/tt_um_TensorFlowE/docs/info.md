<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
In computing, the multiply-accumulate (MAC) operation is a common function that calculates the product of two numbers and adds that product to an accumulator. This operation can be represented by the following equation:

```math
a_{next} <= a + (b*c)  \quad (1)
```

Modern computers often include a dedicated MAC unit, which consists of a multiplier implemented in combinational logic, followed by an adder and an accumulator register that stores the result. The output of the register is fed back into one input of the adder. As a result, on each clock cycle, the output of the multiplier is added to the register.

Inspired by Aleksandar Kostovic's Matrix-MAC Unit [1], we develop our own unit for future neural network applications, capable of solving a 2x2 matrix with 4 bits in each space.

## How to test

Use a 10 MHz clock signal to iterate over 4-bit binary input values (i_I_cor) combined with 4-bit selection signals (select), which are defined as follows:

- Bit 0: Ena_write (enable write)
- Bit 1: Ena_read (enable read)
- Bit 2: clear (reset the accumulator)
- Bit 3: enable_accu (enable accumulation)

With this in mind, we will first send two matrices:

- A = [[2, 0], [0, 2]]
- B = [[4, 1], [2, 5]]

The expected behavior of TensorFlowE is to multiply two 2x2 matrices, resulting in the product C = A * B. If the enable_accu option is set, the result can be optionally accumulated. The clear signal is used to reset the accumulator. Additionally, the Ena_read bit reads the output in two parts: each part consists of 8 bits, which are divided into two 4-bit numbers. These numbers are then combined to reconstruct a 2x2 result matrix.

![Schematic](TF.png)

## Summary of test cases 
test_tensorflow_e:

Multiplies identity matrix A by matrix B and reads the result.

test_tensorflow_e2:

Multiplies scaled identity matrix A (factor 2) by matrix B and reads the result.

test_tensorflow_e3:

Pulses enable_accu (but then clears it) and then does two multiplications: first identity times B, then scaled identity (2) times B. Then reads the result.

test_tensorflow_e4:

Pulses enable_accu, then does two multiplications (identityB and scaled identityB), then pulses clear, then does a multiplication with a different A ([[2,0],[0,0]]) and B, then reads the result.

test_tensorflow_e5:

Pulses enable_accu, then does 6 multiplications (mostly identity and scaled identity with ones and scaled ones matrices). Then reads the result (which should be the accumulated result of all 6 multiplications if enable_accu was set during these operations? But note: the test pulses enable_accu only at the beginning and then sets it to 0. So unless the DUT latches the enable_accu signal, it might not accumulate. The exact behavior of the DUT is not clear from the test.)

test_tensorflow_e6:

Similar to test_tensorflow_e5, but after the 6 multiplications, it pulses clear and then does one more multiplication (with A=[[2,0],[0,0]] and B=[[4,1],[2,5]]). Then reads the result.

test_tensorflow_e7:

Similar to test_tensorflow_e6, but after the clear and one multiplication, it does an additional multiplication (with A=[[0,0],[0,1]] and B=[[4,1],[2,5]]). Then reads the result.
## External hardware
Personal Computer

## Bibliography 
[1] AleksandarKostovic. (2019). Matrix-MAC-Unit: Matrix Multiply and Accumulate unit written in System Verilog [Codice software]. GitHub. Recuperato il 8 settembre 2025, da https://github.com/AleksandarKostovic/Matrix-MAC-Unit
