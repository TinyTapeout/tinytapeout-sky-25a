<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A peg solitaire simulator. Inputs are:
- The x co-ordinate of the peg to move
- The y co-ordinate of the peg to move
- The direction to move the peg in
  - LEFT is 0b00
  - RIGHT is 0b01
  - UP is 0b10
  - DOWN is 0b11

Outputs are:
- The number of pegs remaining
- A bit to indicate game over, i.e. no remaining legal moves.

If the x/y coordinates are outside of the usable grid,
or does not contain a peg, the state stays the same.

Starting state of the board:
```
    0 1 2 3 4 5 6
 0      x x x
 1      x x x
 2  x x x x x x x
 3  x x x 0 x x x
 4  x x x x x x x
 5      x x x
 6      x x x
```

## How to test

Create a player, try to clear the board by taking other pieces.

Read the rules of peg solitaire online:
https://en.wikipedia.org/wiki/Peg_solitaire

We use the English rules, as is proper.

The solitaire game outputs the number of remaining pieces on the board.

Your goal is to get to one remaining piece.
