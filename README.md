# 8-bit UART-to-TeraTerm

![](https://i.imgur.com/YR28lGL.gif)

**Simple 8-bit UART transmitter module developed in Verilog.**

Operates on 1 byte of serial data, including a start and stop bit. Includes a debouncer module designed to generate a single pulse, implemented by generating
a clock enable signal to drive debouncing flip-flops. 

## What is UART?
UART stands for Universal Asynchronous Reciever-Transmitter and is responsible for implementing serial communication. Instead of a clock signal, the transmitting UART adds start and stop 
bits to the data packet being transfered. **These bits define the beginning and end of the packet, allowing the receiving UART to know when to start and stop receiving bits.**
The bits in between these are then sampled at the "mid-bit" of each high signal received. In this iteration, the parity bit is ommitted. 

<img src="https://i.imgur.com/m33SQvV.png" width="500">

## Why debounce?
When we press or release a button or a switch, two metal parts come into contact to short the supply. However, they do not connect instantly and form a partial connection multiple times before a stable connection is made.
**Debouncing is the best way to handle unpredictable bounces in signals when toggling between buttons/switches in circuits.** In order to solve this issue, I implemented a
**multi-flop synchronizer which allows sufficient time for oscillations to settle down** and ensure a more-stable output is obtained to transmit data through the button.

<img src="https://media.geeksforgeeks.org/wp-content/uploads/20191113173218/Switch_Debounce_2.jpg" width="600">


## Specifications
The module is set at a baud-rate of 9600. To achieve and accurate counter for my transmitter module and my internal clock:

```1000MHZ / 9600 BR = 10415```

## How to use
I configured my .xdc file for use with a Nexys 4 DDR. 
1. Drive the data pins to any onboard switches. 
2. Drive your onboard clk
3. Assign these pins as followed:
    - Assign ```reset``` and ```transmit``` to any buttons you have on your FPGA.
    
    - Assign ```txd``` to ```UART_RXD_OUT```.

    - Assign ```JA[3]``` to ```txd_debug```

    - Assign ```JA[4]``` to ```transmit_debug```

    - Assign ```JA[5]``` to ```btn_debug```

    - Assign ```JA[6]``` to ```clk_debug```
    
## TO-DO
- Testbench
- Optimize debouncing

## Useful references
[UART Basics](https://cs140e.sergio.bz/notes/lec4/uart-basics.pdf)

[Switch Debouncing](https://my.eng.utah.edu/~cs5780/debouncing.pdf)

[Understanding clock domain crossing issues](http://www.gstitt.ece.ufl.edu/courses/spring11/eel4712/lectures/metastability/EEIOL_2007DEC24_EDA_TA_01.pdf)
