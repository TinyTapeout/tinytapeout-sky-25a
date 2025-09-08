## How it works

The player reads in encoded video and audio data from an external flash memory, buffering it before decoding and outputting the corresponding pixel colours and audio signals to play the video. The player will continue playing the video before receiving a stop signal which will cause it to reset and restart the video.

### Run Length Encoding

Run Length Encoding (RLE) is used to compress the video data to reduce the memory usage improve the read speed of the player. It works by encoding consecutive horizontal pixels of the same colour into a single instruction, specifying both the colour and also the length of the strip. For example, a sequence of red pixels like RRRRRRRRRRRR would be stored as 12R.

**RLE Requirements**

- Every pixel run must be at least 3 pixels long (Limitation of the design)
- A pixel run cannot be more than 640 pixels long (The length of the VGA display row)
- The sum of every 6 consecutive pixel runs in the same row must be at least 36 pixels (So that buffer doesn't become empty)

### Instruction Format:

All RLE instructions are 3 bytes (18 bits of data + 6 bits of padding). 
The padding is discarded once the instruction is transferred into the chip from the external memory.

**Pixel Instruction:**

The pixel instruction stores the colour of the pixel and the number of consecutive pixels in the run.

| padding [23:18] | run_length [17:8] | colour [7:0] |
|-----------------|-------------------|--------------|  

The 8 bit colour is stored as:

| red [7:5] | green [4:2] | blue [1:0] |
|-----------|-------------|------------|

Example: A 40 red pixel run would be `0x0028E0`

**Audio Instruction:**

For audio samples, the run_length of the instruction is set to the max value of 0x3FF or 1023. Since pixel runs are at most 640 pixels, the audio instructions will not conflict with pixel instructions. Instead of storing colour, the audio instruction stores an 8-bit sample value in the form: `0x03FF00 + sample`

Example: An audio sample of value 127 would be `0x03FF7F`

**Stop Instruction:**

The stop instruction is stored as `0x030000` which has a run length of 768 which will not conflict with pixel instructions.

### Audio

The audio output uses 8-bit PWM with a carrier frequency of ~98.3kHz. Audio instructions are sent at the end of each VGA scanline to avoid interfering with the visual data, resulting in a sample rate of ~31.5kHz. 

### QSPI 

We designed the project to use the W25N02KV Flash IC which has a large memory size but requires loading a page buffer to be able to read the data. On startup, the player loads the beginning of the memory into the page buffer with the `13h` command. After waiting for ~300us, it then uses the quad read command `6Bh` in sequential read mode to allow the player to utilize QSPI and read out the entire memory with only a single instruction. This startup should be compatible with other flash memory IC's that also have the `6Bh` command but do not use a page buffer, as long as the `13h` command is ignored by the IC.

## How to test

Note: It is recommended to test only on small inputs (only a few frames) to avoid long simulation times and large output files (such as `output.bin` and `tb.vcd`).

Before running the simulation, make sure there is a valid `data.bin` file in the resources folder, this is the RLE video and audio data that will be tested.

RLE files can be generated with this tool:
https://github.com/JonathanThing/ECE298A-RLE-Tool

Run the cocotb test script in the `test` folder using `make -B`. The timing test results will be shown in the console log.

Once the test has been successfully completed, an `output.bin` file will be created in the resources folder that logs every pixel outputted by the player. The `vga_converter.py` script can be used to convert the output data so that it can be visually checked.

## External hardware

The design will require a custom PCB to handle the 8-bit VGA output, PWM audio, and also the external memory.
