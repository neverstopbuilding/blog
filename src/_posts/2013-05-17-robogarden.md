---
layout: post
title: "Watering Your Plants is so 2012!"
date: 2013-05-17 14:10
comments: true
categories: ["robo garden", automation]
twitter: [robogarden, arduino]
---

##The Idea
I'm pretty good at some things, not so good at others. One of the things I'm *not* good at is keeping plants alive. I've killed cactus and even those bamboo things you get at Ikea. However, all is not lost. I'll just use technology to fix my shortcomings! Why take care of my plants when I can build a robot to do the same!?

##The Project
And so this post begins the build lot of "RoboGarden," a device that once finished will specifically water the plants I put in it, the right amount, on the right schedule. It will also shine lots of nice light on them. As the build progresses, I'll drip out more of the design. Stay tuned!

##RoboGarden Build Log: 5/16/13
Having just received an Arduino kit I set to work figuring out how all this would work and hacking away.

Following this [article](http://bitbeam.org/2011/09/09/the-next-step/) lead me to the schematic for my stepper motor, a Pololu [Bipolar, 200 Steps/Rev, 28×45mm, 4.5V, 0.67 A/Phase](http://www.pololu.com/catalog/product/1206) or part number #1206.

![H Bridge circuit diagram](http://arduino.cc/en/uploads/Reference/bipolar_stepper_four_pins.jpg)

Here is the corresponding stepper diagram:

![Stepper motor wiring diagram](http://a.pololu-files.com/picture/0J2296.230.jpg?c7e99069fbc52380102527649a55ec76)

I was able to successfully get the thing working by mapping the pins as follows:

- BLK (A) to 1out
- GRN (C) to 2out
- RED (B) to 3out
- BLU (D) to 4out

Here is the assembled test:

![Test of stepper wired to H Bridge](https://lh6.googleusercontent.com/-m9I_EkwiyPs/UZVPivVSofI/AAAAAAAAHYE/UBIk8FhObRQ/w533-h710-no/662B0169-DF2B-4486-86E5-015593EDA70A.JPG)

##Playing with Software
Next I'm interested in controlling this with some Javascript library, namely [johnny-five](https://github.com/rwldrn/johnny-five).

While I did create a repo for this code: [https://github.com/neverstopbuilding/robo-garden](https://github.com/jasonrobertfox/robo-garden) it appears there are two problems with the johnny-five library:

1. I'll need to keep the bot teathered to the machine.
2. There does not appear to be a way to control stepper motors.

Looks like I may just have to raw dog it in Arduino code directly.
