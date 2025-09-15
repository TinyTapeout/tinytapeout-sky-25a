<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The design is a 2.4 GHz integer-N PLL with a divide by 100 circuit at the output, resulting frequency range of 19.2 - 25.2 MHz. For the reference frequency, internal clock pin is used and it must be set to 20 MHz. The integer divider factor can be controlled by 4-bit digital input (CON_S0 ~ CON_S3). To overcome process variation, the VCO is equipped by discrete control that can be controlled by 4-bit digital input (CON_D0 ~ CON_D3). The output can be observed from an analog pin (FOUT) and two digital pins (DFOUT_HF, DOUT_LF) while another analog pin (VCON) is connected to the control voltage of the VCO.
