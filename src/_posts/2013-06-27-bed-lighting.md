---
layout: post
title: "How to Control a Switched Accessory with Ramps and Marlin"
date: 2013-06-27 22:13
category: 3d printing
tags:  [mendelmax, ramps, marlin firmware, bed lighting, gcode]
---
While setting up my 3D Printer I had quite a tough time finding information on simply extending the Arduino Ramps board to support a simple switched accessory. **I just wanted to control my bed lighting with GCode!** There appears to be information about adding servos, controlling accessory boards, and of course controlling the printing cooling fan, but I really had to dig to find out how to rig up a switch to the bed lighting.

After putting it together it is rather easy. My goal is to use the "start" and "end" GCode to turn on my bed lighting and then turn it off when the print is done.

##Wiring it Up
The way this will work is we will use one of the servo signal pin outs to supply a +5V for the "on" which will engage a small relay that switches the main 12V power supply to the LED strip.

- Connect the ground lead to the Pin 1 of the servo bus on the RAMPS board, which is the lowest, rightmost pin. See the green wire in the picture below.
- Connect the power lead to the top pin, in that same column, specifically the D4 pin on the ramps board.

![Cluster of wires on the Ramps board](https://lh3.googleusercontent.com/-5gUrS4Iw4Ww/UcsgJ_RB1qI/AAAAAAAAHp4/iRzVHsGRV1w/w554-h738-no/13+-+2)

- Next connect both of these leads to the coil of your relay. I had this little one laying around, its a double-pole-double-throw (DPDT) so I only need to use one of the pole/sides (the red wires at the bottom of the picture.)
- Then run the ground of the LED strip to the ground on your power supply, and the power lead to one side of the relay switch.
- Run another power lead from the other side of the switch to the V+ on your power supply.

![Relay on small breadboard](https://lh5.googleusercontent.com/-WF8JoQF9lD4/UcsgJ-qUdGI/AAAAAAAAHqE/ja8tjRPBT_0/w984-h738-no/13+-+1)

##Making it Go
The trick with making this work is understanding the GCode `M42` which lets you manually trigger a pin on the RAMPS. You give it arguments of the pin number, then the voltage amount (0-255). So for this set up I simply issue the following command at the terminal in Printrun/Pronterface:

    M42 P4 S255

So, set pin D4 to full voltage. I confirmed with a multimeter 5V out, and also, of course the lights came on. To turn it off just send:

    M42 P4 S0

And the lights go off.

##Make it Automatic
The last step is updating your custom GCode to turn the lights on or off when you print. Just go into the **Printer Settings** in Slic3r and update your start and end code to do just that:

![Bed lighting installed](/images/post-content/bed-light.png)

Hopefully this will help others get their set up running like they want. You can use the same principles to add additional fans or other doodads.
