<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A user turns on the chip by pressing the START button. Between 0 to ~5 seconds an LED will light up, this LED marks the active window to then press the REACT button. The time between the LED first lighting up and the button pressed will be recorded. After the press, the light turns off and a 7 segment display will output the time in milliseconds (shown between 0 to 9999 ms). If the REACT button was pressed before the LED turns on, the 7-segment display will display "Err" (Error). The time accumulates everytime a successful trial has been performed, only pressing the RESET button will the time displayed reset.

## How to test

(Work in Progress)

There are 3 moving parts to test:

- The START button is where where the program randomly decides how long to wait before turning on the LED. This will be done by turning on the program and observing the turn on interval to make sure it is random.
- The timer to track how it has been since the LED turns on. This will be done through verifying the 7-segment LED display correctly tracks the time.
- The final press on the REACT button where the LED turns off and the stopwatch pauses, indicating the final time of the test. This will be done through completing the trial as shown in "How it works".
- Resetting the time is done through the RESET button.

## External hardware

- a button
- an LED
- a 4-digit 7 segment display
