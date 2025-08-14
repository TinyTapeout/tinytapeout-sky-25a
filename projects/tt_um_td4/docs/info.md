<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A 4bit toy CPU "TD4".

This chip has a program memory and a CPU.  
It has three modes; "Load", "Read" and "Execution"
The mode can be selected with input[7].

Please check the detail of pin assignments by pinouts.

## How to test

```
cd test/
make -B
```

## External hardware

- Some LED or an Arduino for read or write data
