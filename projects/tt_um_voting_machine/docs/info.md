<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Voters press one candidate button (one-hot) and confirm with the confirm button.

Each valid confirm adds a vote to the selected candidate and increments the total vote count.

Modes:

00 → Voting: Store votes only.

01 → Counting: Display the winning candidate (one-hot) + total votes (debug).

10 → Reset: Clear all vote counters.

11 → Test: Show debug vote count only.

## How to test

Reset: Set mode = 10 to clear all votes.

Vote: Switch to mode = 00, press a candidate button + confirm. Repeat for multiple votes.

Count: Switch to mode = 01, check winner output matches the highest-voted candidate, and debug = total votes % 8.

Test: Switch to mode = 11, ensure only debug output shows.

Reset again: Verify all counters clear back to zero.

| Mode (`ui_in[7:6]`) | Action      | Winner Output (`uo_out[3:0]`) | Voting Complete (`uo_out[4]`) | Debug (`uo_out[7:5]`) |
| ------------------- | ----------- | ----------------------------- | ----------------------------- | --------------------- |
| `00` (Voting)       | Store votes | `0000`                        | `0`                           | Total votes % 8       |
| `01` (Counting)     | Show result | One-hot winner                | `1`                           | Total votes % 8       |
| `10` (Reset)        | Clear all   | `0000`                        | `0`                           | `000`                 |
| `11` (Test)         | Debug only  | `0000`                        | `0`                           | Total votes % 8       |


## External hardware

None
