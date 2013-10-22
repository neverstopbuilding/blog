---
layout: post
title: "RoboGarden Manual Testing Circuit Development"
date: 2013-10-14 19:54
comments: true
categories: ["robo garden"]
twitter: [RoboGarden, Arduino, 7Segment]
---

##RoboGarden Build Log: October 14, 2013

##Parts Discussed
- Manual Testing Circuit
- Driving a 7 Segment LED with a decoder and shift register via Arduino

Now that I have the carriage moving a number of centimeters based on serial input, I want to add a testing circuit that will let me cycle to a specific position on the garden, or rather a "specific plant."

I want the following behavior:

- Start the carriage from a home position "0"
- Press a button to cycle through available positions (1-8)
- After a time the carriage will move to that position
- I should be able to see the chosen position on a segment display.
- Pressing the button while the carriage is moving should have no effect.
- If I want to get fancy, the display will show a "spinny" motion during the move.

##Circuit Considerations

The most simple way to wire up a seven segment display is just to hook it up to ground and 7 digital pins of the Arduino. The disadvantage of this is of course that it consumes 7 digital pins. I already have 4 for the stepper, so 7 is a lot to devote to just a display, especially given the other inputs I'll need.

A better way is to use a chip like the the CD4511 Latch Decoder to drive the  display, this chip takes 4 control pins to power as you are passing a binary number which the chip translates into the signals for the display:

- 1100 Would show up as 3 (1+2+0+0)
- 0010 Would show up as 4 (0+0+4+0)
- 1001 Would show up as 9 (1+0+0+8)

And so fourth.

This is great, I get 3 pins back.

But I think we can do better than that. Enter the shift register, 74HC595. With a shift register you only need to use 3 pins of the Arduino to "shift" bits into the register. The result is you can get 8 bits of state out of the register. So I can use 4 of them to control the LED driver chip and the other 4 for whatever I want. This could be another display chip, or simply high/low pin outs for other devices like relays.

##Building the Circuit

Ok, so we will need:

- 1x 74HC595 Shift Register ([Datasheet](http://datasheet.octopart.com/MM74HC595N-Fairchild-datasheet-12735.pdf))
- 1x CD4511BE Latch Decoder ([Datasheet](http://pdf1.alldatasheet.com/datasheet-pdf/view/26904/TI/CD4511BE.html))
- 1x ELS-321HDB 7 Segment Display Common Cathode ([RadioShack Model Datasheet](http://www.digchip.com/datasheets/parts/datasheet/158/ELS-321HDB-pdf.php))
- 7x 220 Ohm Resistors

The basic operation is to connect 4 of the output bits of the shift register to the 4 input bits of the decoder, and the output pins of the decoder to the inputs of the display.

![Circuit diagram with decoder and shift register](https://lh5.googleusercontent.com/-64wc4ot3Ar4/Ulx4B9bIOaI/AAAAAAAAI7o/CY2DmmjoGdA/w1102-h516-no/testing.png)

###Hooking up the 7 Segment

Starting with the 7 Segment display, we need to determine the proper current limiting resistors. The voltage supplied will be 5 and the typical forward voltage listed on the data sheet is 2 volts. The forward current is rated at 15 mA so some quick Ohm's law:

- R = V / I
- R = (5v - 2v) / 0.015A
- R = 200 Ohms (Red Black Brown)

I'll use the 220 Ohm resistors that I have available. For initial tests I put in a dip switch array to pick the bits adding 10k Ohm resistors to pull down to ground on the 4 bit inputs, as shown in this schematic:

![Correct decoder wiring](https://lh5.googleusercontent.com/-okfQTFNJCsA/UlymBmNE5ZI/AAAAAAAAI8c/fAUU4Jd2yvM/w600-h362-no/7-Segment-schematic.jpg)

Here is the resulting, albeit messy, initial prototype:

![7 Segment display on breadboard](https://lh4.googleusercontent.com/-wTSwZyL3gjo/Ulx3a9DrfUI/AAAAAAAAI7U/kmUmD_ezzv8/w949-h712-no/IMG_1700.JPG)

###Adding the Shift Register
The next step will be to add the shift register in place of the dip switches. I found that [this article](http://bildr.org/2011/02/74hc595/) was quite helpful in learning about the shift register chip, as well as the above data sheet. The wiring was simple and only three pins of the Arduino were used for the connection.

![Full prototype breadboards and circuits](https://lh3.googleusercontent.com/-cHFID2Vz2gM/Ulx3ax2KwsI/AAAAAAAAI7U/LLA0iuDq7ko/w501-h668-no/IMG_1702.JPG)

##Programming
I started with this simple code, which causes the display to count up to 9 in order:

```c
int sr_serial = 4;
int sr_clock = 5;
int sr_register = 6;

for (int j = 0; j < 10; j++) {
  digitalWrite(sr_register, LOW);
  shiftOut(sr_serial, sr_clock, MSBFIRST, j);
  digitalWrite(sr_register, HIGH);
  delay(1000);
}
```

##Adding a Cycling Button
Now that I could display the value I wanted, I needed to add a button that will cycle up through the positions, and after the button is no longer being pressed, adjust the carriage to that location.

![Cycle button circuit diagram](https://lh4.googleusercontent.com/-jZ8C7se2pDw/Ulx43bbwVFI/AAAAAAAAI78/q_T6decg0S8/w388-h189-no/switch.png)

For this we just have a button pulled low and read by the Arduino. I added a delays and logic in the code such that a timer is reset each time the button is pressed, if the timer has run out, *and* the location number is different than the previous number we fire a move command. What is nice about the stepper movement routine is that it is locking, so pressing the button during the carriage movement doesn't do anything. This will also come in handy so I don't spray water by accident when moving between plants.

##Good Progress
Pretty soon though I won't need to worry about manual manipulation as moisture sensors and a stop micro switch will provide feedback to the system.

Here is a picture of the completed circuit, much more cleaned up, replacing the jumpers with small wires:

![Improved breadboard with cleaned up wires](https://lh5.googleusercontent.com/-pnKm0-2BhC8/Ulx3a3pY0YI/AAAAAAAAI7U/27Q8H4bWhEQ/w501-h668-no/IMG_1703.JPG)

And a nice video of the operation:

<iframe width="640" height="480" src="//www.youtube.com/embed/UE_E2tOH2CY" frameborder="0" allowfullscreen></iframe>
