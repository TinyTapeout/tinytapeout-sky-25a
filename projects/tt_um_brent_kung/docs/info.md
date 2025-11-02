## How it works
3 input
 - 4bit input_A
 - 4bit input_B
 - 1bit Cin

1 output
 - 5bit out

## How to test
```bash
iverilog brent-kung.v test.v && ./a.out && gtkwave signal_brent_kung.vcd
```
