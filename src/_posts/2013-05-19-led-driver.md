---
layout: post
title: "Building an LED Driver Array"
date: 2013-05-19 12:57
category: robo garden
tags:  [led driver, voltage regulator, lm317, super bright leds, circuit design]
---
##RoboGarden Build Log: May 18, 2013

My awesome  Chinese 10 Watt LEDs arrived in the mail Friday, so I was clearly excited to test them out. Some cursory research had revealed this schematic:

![Simple regulator schematic](http://www.instructables.com/files/deriv/F82/HRUF/G7CN3O7V/F82HRUFG7CN3O7V.SMALL.jpg)

Which I then adapted into a rough prototype:

![Example regulator wired up on the breadboard](https://lh6.googleusercontent.com/-ZwzJAaU-49s/UZggG6bMioI/AAAAAAAAHZY/BqQXj-wTQ_4/w1147-h860-no/0ABF1BE3-5D1D-4621-92BC-D9CA39CED504.JPG)

Which was powered by a very simple hacked 12V 1.0 Amp wall wart that I found in a parts box. According to the LED specs (Which I grabbed off [ebay](http://www.ebay.com/itm/390477389011?ssPageName=STRK:MEWNX:IT&_trksid=p3984.m1497.l2649)) The forward current should be 900mA at 12V DC. The regulator has a control voltage of 1.25V which according to this [article](http://www.instructables.com/answers/Please-help-me-with-my-LM317-T-LED-driver/) could be used to calculate the required resistor for the power regulator:

`V = IR` or Voltage = Current * Resistance

Rearranged it is `V/I = R` or in my case `1.25V / 0.900mA = 1.3889 Ohms`.

I opted for a 1.4 Ohm resistor, but realized I probably shouldn't have picked a single resistor because the only ones available had a lower tolerance of 5%. If it turns out to be an issue, it would seem I could add an additional resistor to fine tune each of the larger one.

As you can see below, it worked, and it's hella bright:

![Very bright regulator test](https://lh3.googleusercontent.com/-hU1PuHzctk4/UZggJ53N0fI/AAAAAAAAHZo/kO2j7X95wEA/w645-h860-no/3D28F54E-3608-4787-AD24-B545AD51D202.JPG)

So the proof of concept worked. Now it was time to neatly organize all of the power regulators (LM317) on a bread board. Each of the power leads could be cleanly bent back into the power busses.  Similarly, with a little cajoling, so too could the resistors:

![Eight regulator circuits wired up on a breadboard](https://lh4.googleusercontent.com/-xcwHn1mW1C4/UZgrVhvv2rI/AAAAAAAAHZ0/YKHM6m7A4_U/w645-h860-no/4D8880D4-7B9A-4619-8CE1-F5BAD168D3B7.JPG)

##Figuring Out the Relay
I got a [SainSmart](http://www.amazon.com/gp/product/B0057OC6D8/ref=oh_details_o00_s00_i01?ie=UTF8&psc=1#productDescription) 2-Channel Relay Module with the thought that I would use it to control both the light array and the little water pump. Figuring out how it was suppose to work was a little tricky until I found the link to the instructions for the relay:

![Relay schematic](https://lh6.googleusercontent.com/-t0Pj2QOJY1o/UZgrrdPCx3I/AAAAAAAAHZ4/WyhUJHhisOk/w789-h485-no/2%25E8%25B7%25AF%25E7%25BB%25A7%25E7%2594%25B5%25E5%2599%25A8.JPG)

This certainly is not what I thought of when I was getting a relay; rather something like "oh you just put some small volts here to get large volts here…". Thankfully the Amazon reviews provided more help:


> The connections to your Arduino (or whatever) are:
> VCC - supply voltage. 5V from my Arduino.
> IN1 - set to HIGH to set the relay to its "default" state, set to LOW to switch the relay to its alternate state
> IN2 - same as IN1, but controls the second relay on the board
> GND - ground


I decided that for now pins 1 and 2 from the Arduino would control the relays, which would switch main power to the breadboard busses. Here is a picture of the stuff loosely patched together with a little more order:

![Arduno, relay, and LED regulators all hooked together](https://lh4.googleusercontent.com/-s1iwujREh5g/UZkCRNUpIQI/AAAAAAAAHcQ/v8xxFT-PxLY/w519-h692-no/4514C772-48CC-4EA1-83F5-654B78AC1FB5.JPG)

After verifying this worked. I needed to affix the LEDs to their respective heat sinks and solder on the main leads. Here is one:

![10 Watt LED on large heat sink](https://lh3.googleusercontent.com/-Pxl2cr-xUqs/UZgzZjWfAbI/AAAAAAAAHa0/iH5GKs9dQ3Y/w519-h692-no/CAEB17A3-A166-456E-BE77-E3D123A363D6.JPG)

Then I soldered all the main leads together joining all the grounds in one series, while keeping the power leads separate so that each could go to a driver circuit. It occurred to me that maybe it is over kill to have a driver for each LED, I could probably get away with either one or a few drivers. I'll experiment with that in the future. Here is the array of the grow lights:

![Eight LEDs wired together with heatsinks](https://lh3.googleusercontent.com/-41wm4Rxr1Ks/UZkCRI8AXGI/AAAAAAAAHcQ/H8f9sZN_zOY/w519-h692-no/3992741C-376E-43FD-BD61-787A462EFB6A.JPG)
Notice the bourbon glass in the background…

Finally it was time to wire everything up to the power supply. I'm using a Mean Well 12V x 8.4 Amp or so model which appeared on paper to have enough juice. But when I tested all the lights they were noticeably dimmer than when I had simply jammed in a wall wart at 12V and seemingly 10A (even with the regulator.) More surprising was that running just one LED off of the Mean Well was still rather dim. I think I may source a 150 Watt supply for the final build or further experiment with the driver circuits. Here is the array on:

![All eight LEDs turned on for test](https://lh4.googleusercontent.com/--e_iSuAeROA/UZkCRO1iOrI/AAAAAAAAHcQ/RCB079qR70E/w923-h692-no/B188413F-52B2-40E9-8C55-EB9ECD32D90E.JPG)

REALLY COOL! I'm excited about the build progress. Next up I'm going to be building a rough prototype frame, hopefully fabricating some mounds for the watering carriage and finishing up the electronics testing.

