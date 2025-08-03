<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## Credits

We gratefully acknowledge the Center of Excellence (CoE) in Integrated Circuits and Systems (ICAS) and the Department of Electronics and Communication Engineering (ECE) for providing the necessary resources and guidance.
Special thanks to Dr. K R Usha Rani (Associate Dean - PG), Dr. H V Ravish Aradhya (HoD-ECE), Dr. K S Geetha (Vice Principal) and Dr. K N Subramanya (Principal) for their constant encouragement and support in facilitating this TTSKY25a submission. 

## How it works

This project implements a **Weighted Majority Voter / Trend Detector** in digital logic. It observes a stream of binary input bits and uses a configurable sliding window (default: last 4 bits). Each bit is multiplied by a fixed weight, with more recent bits having higher weight. The weighted sum is compared to upper and lower thresholds with hysteresis:

- If the weighted sum is above the upper threshold, the output bit (`uo_out`) indicates the input stream is trending toward ‘1’.
- If the sum is below the lower threshold, the output indicates a trend toward ‘0’.
- If the sum is between these thresholds, the output holds its state (prevents flicker).

This structure acts as a **digital debouncer, noise filter, and simple pattern/trend detector**, filtering out short input glitches and providing robust, stable output. The operation is entirely digital and works synchronously with the clock input.

## How to test

**Minimal usage:**

- Connect your binary input signal to `ui_in` (all other bits can be left at 0).
- Bring the `ena`, `clk`, and `rst_n` signals as per standard Tiny Tapeout harness.
- The trend output is available on `uo_out`. It will be ‘1’ if recent input samples are trending high, and ‘0’ if they are trending low.

**Simulation:**

- Use the provided `tb.v` for Verilog simulation or `test.py` for cocotb/Python simulation.
- Drive a sequence of bits on `ui_in` and observe the output `uo_out`. For example, sending several consecutive ‘1’ bits after a series of ‘0’s will trip the output high after a short delay, and vice versa.

**Expected behavior:**

- Fast, isolated bit flips on the input will be ignored.
- Only sustained runs of ‘1’ or ‘0’ values—outweighing the hysteresis—will change the output trend.

## External hardware

No special external hardware is required. The module is fully digital and receives its input directly from the IC pins. You may connect any external device producing binary signals (e.g., pushbuttons, sensors, digital sources) to `ui_in`. An LED, logic analyzer, or test equipment may be attached to `uo_out` to observe the filtered trend output.
