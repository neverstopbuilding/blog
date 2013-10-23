---
layout: post
title: "Designing and Building the Micro Switch Mount"
date: 2013-10-17 16:02
comments: true
categories: ["Robo Garden"]
twitter: [arduino, RoboGarden, electronics]
image: https://lh5.googleusercontent.com/-wW-QuP61Z14/UmAuhyOIOjI/AAAAAAAAJAE/DIi571e1KC0/w949-h712-no/IMG_1707.JPG
---
##RoboGarden Build Log: October 17, 2013
###Parts Discussed
- Homing switch
- Homing switch mount
- Schmitt inverter
- Control switch

As I detailed before in a [previous post](http://neverstopbuilding.net/finished-frame/) I had forgotten to print a mount for the homing micro switch on the motor mount. That's not the end of the world as I can just make a little clip on mount and place it perfectly relative to the motor mount and use that to  help drive the improved motor mount design.

Here is the basic operation:

![Carriage in relation to homing switch location](https://lh5.googleusercontent.com/-3of26cFaQ60/Ul63sl8y5HI/AAAAAAAAI80/WOf8imX3340/w620-h487-no/homing.png)

When I run a `home` command, the carriage should move all the way to the right until the micro switch is triggered. This also seems like a great candidate to experiment with Arduino's hardware interrupt feature. But I'll get to that later. First step is building the clip to position the micro switch correctly.

##Modeling the Part
Because the motor mount has the same clip geometry I need it makes sense to use that part as base for the new one. So I projected that profile into a new sketch and extruded it to the size of my clip. The rest of the geometry would be influenced by the position of the micro switch relative to the carriage at "home" position. For this I needed to first model the switch:

![Microswitch model](https://lh6.googleusercontent.com/-WDZLKokOTb4/Ul7FHKARdDI/AAAAAAAAI9Q/-t5C9vwQS6A/w753-h451-no/switch.png)

Then I positioned the switch such that the edge of the carriage would hit it when there was just enough clearance around the rest of the parts:

![Microswitch positioned relative to carriage](https://lh5.googleusercontent.com/-XvPKeMRw6WQ/Ul7gBTQttkI/AAAAAAAAI-c/hY8n-5d3gVA/w675-h616-no/switch-position.png)

The final step would be to add geometry to the switch clip to meet the already positioned switch. So I projected the switch face into the bottom of the clip, joined the two areas together with some arcs and extruded it beyond the switch face:

![Microswitch mounting bracket](https://lh4.googleusercontent.com/-SP9i2pyrYFM/Ul7gA7M4xbI/AAAAAAAAI-Y/qDwIOacU9SA/w741-h492-no/finished-clip.png)

##Printing and Assembly
The printing was a pretty straight forward process, once the part was done, all that was left was attaching the micro switch to the mount, soldering on some lead wires and affixing it to the frame.

![Assembled microswitch and bracket](https://lh6.googleusercontent.com/-6I019RaJhtU/UmAuh7Xp9vI/AAAAAAAAJAE/wEKQZ3x3QL4/w949-h712-no/IMG_1705.JPG)

![Installed microswitch bracket](https://lh5.googleusercontent.com/-J-yEeuODKtU/UmAuh62wLpI/AAAAAAAAJAE/vtR87IvCbHc/w949-h712-no/IMG_1706.JPG)

##Hardware Debouncing

I noticed while testing the micro switch some noise in the switch, using the multimeter as a continuity check, I heard more than one "beep." As such this switch would benefit from a debouncing circuit so that the signal sent to the Arduino is definitely either high or low.

To do this I followed this [great tutorial](http://www.jeremyblum.com/2011/03/07/arduino-tutorial-10-interrupts-and-hardware-debouncing/) which will involve the following parts:

- 1x Schmitt Inverter CD40106BE ([datasheet](http://www.mouser.com/ds/2/405/schs097d-127287.pdf))
- 1x 10k resistor
- 1x 10uF capacitor

##Starting with the Control Button

Because I already have a working button with code backing it in the form of the position cycle button. I'll experiment with the hardware debouncing logic here. If it works I'll carry it over to the microswitch. Let's start with the schematic:

![Debouncing schematic](https://lh6.googleusercontent.com/-Cs4MEURNJtg/UmAvXM9slvI/AAAAAAAAJAQ/S_7rbUTwAu4/w677-h349-no/debounce-schematic.png)

This diagram is rather simplified because it only shows one of the inverters and the power and ground leads for the IC separately. Here is a picture of the parts on the breadboard but it is not that helpful and kind of confusing at the moment.

![Schmitt inverter installed on breadboard](https://lh5.googleusercontent.com/-wW-QuP61Z14/UmAuhyOIOjI/AAAAAAAAJAE/DIi571e1KC0/w949-h712-no/IMG_1707.JPG)

The initial test turned out to be a success, so I thought it would be worth adding the micro switch in place of the button to test that, which also worked just fine. In returning the circuit to the original state, I added debouncing for both the control switch and the home switch.

##Programming the Home Function

There are two ways to think about this operation:

- Home sub-routine.
- Home interrupt with subroutine.

The first, a more simple subroutine would have this basic logic:

1. Start moving toward home, polling the switch.
2. If the switch is high, set the position to zero and wait for input.
3. If the position is low continue to move toward home.


I'm not wild about this because it requires checking a switch for state on each cycle and more often than no the switch would be low. Homing should only really happen when I turn the machine on and when there is a screw up. I'd prefer the home process to occur whenever the button is pressed, this way, if some wise acre moves the carriage in between waterings, the movement will be stopped by the home interrupt.

##Iterating on the Logic
I went through many iterations of the home function logic to understand how interrupts worked and the Arduino loop system. The result is was a near complete refactoring of the existing code. Plus I cleaned up the variable names and comments a bit too.

The result was a multi function button:

- Press for more than a certain threshold I'll trigger a home routine.
- A normal press just increments the number and consequently sets the moves the carriage to that position.

The basic movement logic is captured in this statement:

```c
  //Movement logic sends carriage to a location based on distance in mm and direction (-1 is right, 1 is left)
  if (absoluteDistance > 0) {
    digitalWrite(stepperEnable, HIGH);
    stepperMotor.step(direction); //Move a single step either right or left based on sign
    if (currentPosition >= maxDistance + spoutOffset) {
      absoluteDistance = 0;
    } else {
      currentPosition += (direction * stepLength);
      absoluteDistance -= stepLength;
      if (absoluteDistance <= 0) {
        Serial.print("Current position: ");
        Serial.println(currentPosition);
      }
    }
  }
  digitalWrite(stepperEnable, LOW);
```

So often other parts of the program change and reset the `absoluteDistance` and `direction`. When I hold down the control switch I tell the program to change the "amount to go" to a large value, and the direction to the right. The carriage then moves all the way to the right where it hits the home switch.

The home switch then updates the settings again so that on the next loop it starts to move to the correct position relative to home.

```c
void resetHomePosition(){
  direction = 1;
  currentPosition = - homeOffset;
  absoluteDistance = homeOffset;
  displayNumber = 0;
  oldDisplayNumber = 0;
}
```

Similarly, each time I increment the "position" display, that value is used to fetch the distance and direction needed to go to that location from the `currentPosition`. I also change how the distances were fetched from an absolute list to dimensions driven by some settings:

```c
float getPlantLocation(int plantNumber){
  if (plantNumber == 0){
    return 0;
  }
  float plantWidth = maxDistance / numberOfPlants;
  return ((plantNumber - 1) * plantWidth ) + (.5 * plantWidth);
}
```

The net result is that you would chose to have between 1 and 8 plants, and they would be evenly distributed under the frame. For the full source code, check out the [github repository](https://github.com/neverstopbuilding/robo-garden).

##Next up...
Next I'll be tackling the water and lighting control circuit which will let me test this bad boy on some plants. I was recently able to procure some more parts that should aid in improved LED drivers.

Finally an updated video of the operation:

{% youtube http//www.youtube.com/embed/n8XD46BQcEk %}
