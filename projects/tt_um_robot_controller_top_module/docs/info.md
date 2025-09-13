
## How it works

This project is an experimental controller for an autonomous robot, enabling sensor communication and path tracking.

## How to test

Connect the external sensors as specified in the pinout. Connect the gyro via I2C at 100 kHz and UART at 9600 baud. Then power on and set `robot_enable` to 1.

## External hardware

Connect the gyro sensor to I2C SDA and SCL.  
Connect the proximity sensor to echo_rx and trig_tx.
