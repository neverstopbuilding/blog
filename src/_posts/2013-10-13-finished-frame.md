---
layout: post
title: "Assembling the RoboGarden Frame and Starting on the Electronics"
date: 2013-10-13 12:08
comments: true
categories: ["robo garden"]
twitter: [RoboGarden, arduino, gardenhack]
---

##RoboGarden Build Log: October 13, 2013

I've been busy hacking on the electronics for the RoboGarden and though it was time to post an update lest I move further down the rabbit hole. The frame is completely assembled, and putting it together went rather well but there were a few minor issues to bring up that could be improved in future iterations. Here is a run down of the frame assembly:

##Parts Discussed
- Frame
- Stepper Motor
- Stepper Driver Circuit
- Arduino Control

##Assembling the Frame

The frame is completely assembled, and putting it together went rather well but there were a few minor issues to bring up that could be improved in future iterations. Here is a run down of the frame assembly:

###Attaching the Feet

![Printed feet attached to aluminum uprights](https://lh4.googleusercontent.com/-12LdMufsG6Y/UlWIHBeVhrI/AAAAAAAAIws/X3PmK7bjbx4/w534-h712-no/IMG_1653.JPG)

As I mentioned before, future iterations of the feet would be universal, you can't really tell here but the rear feet point one way and the front feet point another. They also were quite tight in assembly and required some sanding down. This dimension should be enlarged a bit.

###Basic Frame Assembly

![LED heat sink mounts attached to cross members](https://lh6.googleusercontent.com/-5AecY_ACxI4/UlWIKFCbJlI/AAAAAAAAIws/oQbzfMwvyjg/w534-h712-no/IMG_1654.JPG)

![Assembled frame](https://lh5.googleusercontent.com/-VqCmS-H50GA/UlWIRHWOKdI/AAAAAAAAIws/UPueYK3DNQY/w534-h712-no/IMG_1656.JPG)

Both the LED heat sink holders and the support components of the frame snapped together easily. I was really happy with the tightness of the connections, although I think they could still be a little looser and still have everything tightly held together.

Another future improvement would be to dimension everything for more readily available copper plumbing tube or even wooden dowels, provided they are sufficiently straight. A switch to this material would make the item more repeatable, so to speak, as I wouldn't have to hijack a girl's shoe rack.

###Attaching the Motor

![Mounted stepper motor on motor mount](https://lh3.googleusercontent.com/-5hvLj-iSwx0/UlWIUBCETdI/AAAAAAAAIws/05SJe16tf6k/w534-h712-no/IMG_1657.JPG)

The motor mount is a little flimsy with the motor hanging off the back, some additional support could be used. Also while putting this together I realized I had forgotten to build a place to add the micro switch for preventing carriage over travel. This will be easy to add with a little snap on bracket to the travel tubes in the short term. A longer term solution would be to integrate the part in with the motor mount.

###Carriage Assembly

![Assembled carriage on rails](https://lh5.googleusercontent.com/-cSP3kIKYgGg/UlWIXV_JXFI/AAAAAAAAIws/EQ5oUTleLN4/w534-h712-no/IMG_1658.JPG)

The carriage went together well but I need slightly longer screws so that I can use lock nuts. In testing one of the nuts already vibrated off and I can't tighten them down too much or else the carriage won't move! One way to solve this in the near term would be printing head recesses into the carriage front. On the other hand, I needed some shorter screws for the belt mount, but this isn't anything that would hurt operation.

###Idler Assembly

![Idler bearing on mount with shaft](https://lh5.googleusercontent.com/-vcXp8rz06Uo/UlWIedcVPQI/AAAAAAAAIws/IrJF6T5SCJM/w534-h712-no/IMG_1660.JPG)

The idler was an area that could use a lot of improvement. Not only were the holes a little tight and the part just as flimsy as the motor mount, but the geometry while the belt was installed caused bad flexing:

![Idler pully with belt](https://lh3.googleusercontent.com/-KAN1EHQZJOE/UlWIlFjMPpI/AAAAAAAAIws/jgqg9ssvo1o/w949-h712-no/IMG_1662.JPG)

Ultimately, I ended up just having the belt ride on the collar of the pulley, as it otherwise was too tight and strained the stepper motor operation.

- motor mount is a little flimsy hangs out the back and could be weak
- forgot to make a mount for the micro switch, this can be a little clip on adjustable number, but ultimatly should be part of the motor mount
- the screws need to be longer for the carriage connection, but could also work with a recess for the screw heads.
- the screws should be shorter for the belt mount
- holes for the idler bearing mount could be a littler larger

###Completed Frame

And here we have it, the completed RoboGarden frame:

![Complete frame](https://lh6.googleusercontent.com/-mRv7b_ZcqMc/UlWIrUuWAoI/AAAAAAAAIws/Sr2SPWueKLc/w949-h712-no/IMG_1664.JPG)

Here is another shot which shows the big 10 watt grow LED:

![Looking up at the underside of the frame](https://lh3.googleusercontent.com/-UejBppCf4hk/UlWIu3gF87I/AAAAAAAAIws/U20BNqHW0PA/w534-h712-no/IMG_1665.JPG)

##Electronics Design

While I still have to design and print the micro switch mount, I was eager to start on the electronics. Here is the ideal operation:

1. Soil moisture falls below a certain level for a specific plant
2. Carriage moves to plant location
3. Motor turns on the water the plant a preset amount
4. Carriage returns home

Also, plant lights would be switchable, with a future upgrade of control based on a photo sensor.

These operations boil down into a few specific circuit modules:

- Circuit to power the Arduino controller
- Power driver and relay for the lights
- Control circuit for the pump which could either be electrically adjustable to control flow, or just a relay and a clip on the tube to control flow.
- A circuit to control the stepper motor
- Sensor input circuit from the eight moisture sensors
- Sensor input from micro switch
- Testing and control circuit (see below)

Before building the moisture sensors, I thought it would make sense to provide a manual control first, as this could help me test the operation without waiting for dirt to dry. I'm thinking it would be a simple two button control with numerical indicator, each press would cycle through the plants and a second button would turn on the pump.

Some of the parts I started out with:

![Power supply, arduino, breadboards and relays](https://lh3.googleusercontent.com/jlszbDGZf1uaLAV7RMDb1pOYEySvFRtszDPRlJDRQq0=w1009-h712-no)

###Powering the Arduino

To power the Arduino from the large power supply I built a small and simple voltage regulator to drop down the voltage to about 7 Volts, something the Arduino likes as input. This also ended up being the supply voltage for the stepper controller, as the raw 12 was a bit to high. Here is the schematic which also includes a power on indicator LED:

![Basic lm317 power regulator schematic](https://lh6.googleusercontent.com/-n2X-Z3UhIcA/UlsKzxzscdI/AAAAAAAAI2I/X7SNT6Iqw0Y/w314-h310-no/power-supply.png)

And the resulting prototype on the breadboard:

![Power regulator prototype on breadboard](https://lh5.googleusercontent.com/-YYZp2jk1cTg/UlgUMekGsiI/AAAAAAAAIzE/ep4nxLvvO2Q/w534-h712-no/IMG_1668.JPG)

On this breadboard the "bottom" rail as shown in the photo are the raw power supply and the "top" rail is the regulated voltage which I supply to the `Vin` pin on the Arduino. I've confirmed that this set up works even with the USB connector in place.

###Testing the Stepper Motor

Driving the stepper motor is nearly the same circuit that I detailed back in [this post](http://neverstopbuilding.net/robogarden/). The few changes I made include using the regulated voltage to drive the motor rather than the Arduino `+5V` and also adding a trigger pin to the enable pins of the H Bridge. The reason I did this was so that I would not need to keep the stepper energized after it moved. I could "turn it on," move the carriage to a new location, and then, "turn it off."

There is not much to show on the breadboard, the schematic is more useful here:

![H bridge to arduino wiring diagram](https://lh3.googleusercontent.com/-GD1ItqhPRFo/UlsPpsWfL7I/AAAAAAAAI2g/3jYbHnOj81s/w435-h452-no/stepper-h-bridge.png)

The color codes indicate the wire colors of the specific stepper motor I'm using, a [Pololu Bipolar](http://www.pololu.com/catalog/product/1206). And the numbered lines indicate the Arduino pins I'm using.

The final part of this test was some basic code to play around with the stepper. Modifying the example code for a stepper resulted in this:

```c
#include <Stepper.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution
const float mmPerStep = 0.31;        // carriage travel per step

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8,9,10,11);

int enable = 7;

void setup() {

  pinMode(enable, OUTPUT);
  digitalWrite(enable, LOW);
  // set the speed at 60 rpm:
  myStepper.setSpeed(80);
  // initialize the serial port:
  Serial.begin(9600);
}

void loop() {


if (Serial.available())
{
  int cm = Serial.parseInt();
    Serial.println(cm);
    int steps = round((cm * 10) / mmPerStep);
    Serial.println(steps);

    digitalWrite(enable, HIGH);
    delay(20);
    myStepper.step(steps);
    delay(20);
    digitalWrite(enable, LOW);
}
```

What this code will do is listen for input on the serial terminal, when you enter a number of centimeters the program converts that to the number of steps required to move the carriage that far.

##Onward!

The most sensible modules to tackle next are the testing/control circuit and the micro switch input. All the code and schematics are now available in the [github repository for this project](https://github.com/neverstopbuilding/robo-garden). Enjoy!
