## How it works

This project converts between three formats for representing values from 0 to 999:

* Binary, wherein decimal values 0-999 are encoded respectively as 10-bit binary values 0000000000-1111100111.
* [Binary-Coded Decimal (BCD)](https://en.wikipedia.org/wiki/Binary-coded_decimal), wherein each decimal digit 0-9 is encoded separately as a 4-bit binary value 0000-1001.
* [Densely-Packed Decimal (DPD)](https://en.wikipedia.org/wiki/Densely_packed_decimal), a compressed form of BCD which only occupies 10 bits.

## Asynchronous mode

When `RESET` is LOW, this project functions in *asynchronous mode*. Changes to the input are immediately reflected in the output without the use of a clock signal. Input format and output format are specified separately, and only half the output is available at any moment.

| # | Dedicated Input | Dedicated Output | Bidirectional I/O |
| - | --------------- | ---------------- | ----------------- |
| 0 | Input D8        | Output Q0/Q8     | Input D0          |
| 1 | Input D9        | Output Q1/Q9     | Input D1          |
| 2 | Input D10       | Output Q2/Q10    | Input D2          |
| 3 | DPD input/D11   | Output Q3/Q11    | Input D3          |
| 4 | BCD input       | Output Q4/—      | Input D4          |
| 5 | A0              | Output Q5/—      | Input D5          |
| 6 | DPD output      | Output Q6/—      | Input D6          |
| 7 | BCD output      | Output Q7/ERR    | Input D7          |

* For binary input, set dedicated inputs 4 and 3 LOW, dedicated inputs 1 and 0 to the most significant 2 bits, and bidirectional pins 7 down to 0 to the least significant 8 bits.
* For BCD input, set dedicated input 4 HIGH, dedicated inputs 3 down to 0 to the hundreds digit, bidirectional pins 7 down to 4 to the tens digit, and bidirectional pins 3 down to 0 to the ones digit.
* For DPD input, set dedicated input 4 LOW, dedicated input 3 HIGH, dedicated inputs 1 and 0 to the most significant 2 bits, and bidirectional pins 7 down to 0 to the least significant 8 bits.
* For binary output, set dedicated inputs 7 and 6 LOW. Set `A0` (dedicated input 5) HIGH for the most significant 2 bits and LOW for the least significant 8 bits on the dedicated outputs.
* For BCD output, set dedicated input 7 HIGH. Set `A0` (dedicated input 5) HIGH for the hundreds digit and LOW for the tens and ones digits on the dedicated outputs.
* For DPD output, set dedicated input 7 LOW and dedicated input 6 HIGH. Set `A0` (dedicated input 5) HIGH for the most significant 2 bits and LOW for the least significant 8 bits on the dedicated outputs.

## Synchronous mode

When `RESET` is HIGH, this project functions in *synchronous mode*. Input is latched when `/WE` (dedicated input 7) is LOW and `CLK` is pulsed. Output is driven when `/OE` (dedicated input 6) is LOW. Input format and output format are specified using the same two inputs, and the entire output is available at once.

| # | Dedicated Input     | Dedicated Output | Bidirectional I/O  |
| - | ------------------- | ---------------- | ------------------ |
| 0 | Input D8            | Output Q8        | Input D0/Output Q0 |
| 1 | Input D9            | Output Q9        | Input D1/Output Q1 |
| 2 | Input D10           | Output Q10       | Input D2/Output Q2 |
| 3 | Input D11           | Output Q11       | Input D3/Output Q3 |
| 4 | BCD mode            | —                | Input D4/Output Q4 |
| 5 | DPD mode            | —                | Input D5/Output Q5 |
| 6 | /OE (output enable) | —                | Input D6/Output Q6 |
| 7 | /WE (write enable)  | ERR              | Input D7/Output Q7 |

## Inputting binary format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` and `BCD` (dedicated inputs 5 and 4) LOW.
3. Set dedicated inputs 1 and 0 and bidirectional pins 7 down to 0 to the 10 bits of the binary representation.
4. Set `/WE` LOW and pulse `CLK`.

## Inputting BCD format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` (dedicated input 5) LOW and `BCD` (dedicated input 4) HIGH.
3. Set dedicated inputs 3 down to 0 and bidirectional pins 7 down to 0 to the 12 bits of the BCD representation.
4. Set `/WE` LOW and pulse `CLK`.

## Inputting DPD format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` (dedicated input 5) HIGH and `BCD` (dedicated input 4) LOW.
3. Set dedicated inputs 1 and 0 and bidirectional pins 7 down to 0 to the 10 bits of the DPD representation.
4. Set `/WE` LOW and pulse `CLK`.

## Outputting binary format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` and `BCD` (dedicated inputs 5 and 4) LOW.
3. Read the binary representation from dedicated outputs 1 and 0 and bidirectional pins 7 down to 0.

## Outputting BCD format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` (dedicated input 5) LOW and `BCD` (dedicated input 4) HIGH.
3. Read the BCD representation from dedicated outputs 3 down to 0 and bidirectional pins 7 down to 0.

## Outputting DPD format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` (dedicated input 5) HIGH and `BCD` (dedicated input 4) LOW.
3. Read the DPD representation from dedicated outputs 1 and 0 and bidirectional pins 7 down to 0.

## How to test

The `test.py` file tests conversion in all directions.

## External hardware

Whatever input and output devices you want.
