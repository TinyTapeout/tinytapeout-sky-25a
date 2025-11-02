<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a random number generator... possibly. I'm not sure.

In a latch you are not supposed to set both S and R to 0. If you try to solve what the output Q and ¬Q should be, you'll see why. The idea is to use this instability to generate a random value.

It is quite possible that this won't work for the following reason : if one of the input (S or R) is updated before the other (R or S), we might get some bias toward one outcome. In the worst case, we could even get no random at all but arbitrary constant values, and implement the following https://xkcd.com/221/

Here I did not draw anything by hand so I have no clue what the finale layout will look like. So to maximize chances to get at least one working instance, I added many of them (34 per output pin). The input bits let you select which you want (cf next section).

## How to test

When ui_in[0]=0, you'll get all output pins (hopefully) going crazy (ie both uo_out[*] = NOIIISSEE as well as uio_out[*] = NOIIIISSSEEE).

When ui_in[0]=1, you'll freeze all output pins to whatever values they had. That way you get a change to sample a value.

ui_in[7:1] can be set to wire the output to other instances of number generators. Maybe they don't all have the same behavior !
Valid numbers range from 0 to 34.