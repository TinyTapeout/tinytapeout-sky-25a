<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a random number generator... possibly. I'm not sure.

In a latch you are not supposed to set both S and R to 0. If you try to solve what the output Q and ¬Q should be, you'll see why.

## How to test

When ui_in[0]=0, you'll get all output pins going crazy (ie both uo_out[*] = NOIIISSEE as well as uio_out[*] = NOIIIISSSEEE).

When ui_in[0]=1, you'll freeze all output pins to whatever values they had. That way you get a change to sample a value.

Well at least that's what I hope, I can't test this in software.
I bet this could be biased toward 0 or 1, or maybe show correlation between bits... or worse, it could be not random at all !

## External hardware

No external hardware required !
