---
layout: post
title: "Building a Military Spec MacBook Air Case with Long Life Battery"
date: 2013-09-17 14:51
category: hardware hacking
tags:  [laptop case, pelican case, mil spec, battery pack, mobile productivity]
---
![Finished laptop case](/images/post-content/mil-spec-mac/done.jpeg)

One thing that majorly bums me out when I'm working away from home (which is often) is the lack of power outlets. I enjoy working in cafes or coffee shops and there is rarely a place to plug in. My Air usually lasts about 4 or 5 hours with full brightness and the wifi turned on, but sometimes that is not enough. A long flight, train ride, or just a serious coding session is sure to sap my battery.

This led me to consider picking up an external battery, but after reading about all the adapters and power cables a set up would require for a Mac, I decided to make a much more dedicated solution. And if I was gonna do some custom work, why not make it harsh weather compatible? After all, my computer is my livelihood. Might as well protect it!

##Some Rough Requirements
Heres a short list of the "engineering constraints" I came up for this project:

- I can be away from a power outlet for at least 24 hours with no change in computer usage behavior.
- The computer is secure while in the case.
- All cables, batteries, and accessories can fit into a small case (17"x13")
- The whole package should be shock proof, waterproof and resistant to temperature swings.

For some reason I thought that moving to Buenos Aires would involve my needing to work on the deck of an Antarctic ice breaker, avoiding huge swells, and having my computer slammed about the cabin…

**Well just in case, I'm ready!**

In fact, since starting this post, I dropped a glass of water on the case, and watched in slow motion as razor sharp shards of glass ricocheted off the case, droplets of water exploding against its impregnable sides, and Jet Lee flying across the frame while doing a round house kick.

##Materials and Supplies
You at home could build a case like this for yourself with some simple tools. Here is a basic list of supplies:

- [Pelican 1470 Hardcase](http://www.amazon.com/gp/product/B00152KDBI/ref=oh_details_o03_s00_i00?ie=UTF8&psc=1)
- [Hyperjuice 150Wh Battery Pack](http://www.hypershop.com/HyperJuice/External-Battery-for-MacBook-iPad-iPhone-USB-150Wh/MBP-150.html)
- MIL Spec Connector, Male Receptacle, 3 Pole
- MIL Spec Connector, Female Plug, Internal Thread, 3 Pole
- Closure Cap for Receptacles, 2 & 3 Pole, MIL Spec Connector
- MIL Spec Connector Gasket
- Harsh-Environment Expandable Mesh Sleeving, PTFE, 1/4" ID, 1/4" to 5/16" Bundle Diameter
- Moisture-Seal Polyolefin Heat-Shrink Tubing, 0.8" ID Before, .2" ID After, 9" L, Black
- EPDM Rubber Washer, No. 6 Screw Size, 1/4" OD, .062" Thick,
- M3 Machine Screws and Nuts
- Various wires, and heat shrink tubing
- A sacrificial Mac power supply

Most of the supplies can be sourced from [McMaster-Carr](http://www.mcmaster.com/), but leave a comment if you are having trouble finding something. Tooling was pretty easy:

- Wire stripper
- Soldering Iron
- Solder
- Allan Keys
- Heat gun
- Drill / Bits
- Razor blades

##The Build

###1. Cut the Foam
This was one of the rather hard parts of the build actually, because the pick-apart foam that comes with Pelican cases can only be picked apart top to bottom. I thought that the block of foam was a matrix of cubes. **This is not the case.** It is rather a matrix of little office buildings that you can separate. Cubes would let you have multiple pockets of varying depths, this only allows one depth.

And so, in order to get the cuts I wanted, I first made separate interlocking blocks, then used a razor blade to more or less cut / shave off the bottom until the correct height was achieved. The foam was cut in order to store the battery pack, charger, various accessories and the cord, and then the laptop on top.

![Case with foam cut to size](/images/post-content/mil-spec-mac/foam.jpeg)

If I were to make these en masse, I'd think the best strategy would be to laser cut foam of various thicknesses and then put the blocks together. Or have the foam molded in one piece.

###2. Install the Charging Plug
The next step involves taking a waterproof, dust-proof case and drilling a massive hole in it. The reason we do this is, of course, to provide a connector for the charging cable. Doing this will let the whole kit be charged while closed and locked. Here is the whole assembly, a Mil-spec 3 pin connector with gasket and dust cover:

![Layout of all the military spec connector parts](/images/post-content/mil-spec-mac/connector.jpeg)

I used the gasket to mark where the hole would be as well as the screw holes. **Note! I did not think too hard and placed the connector on the bottom of the case. This is dumb!** Why? Well Pelican has intelligently made it so that this case can be set down and stand upright on little bases. For example when you set it down at an airport kiosk or something. Adding the connector makes the bottom unbalanced, and likely to fall over. A better location would be the side of the case.

I used a multi step drill bit to get the right size:

![Drilled hole for military spec connector](/images/post-content/mil-spec-mac/hole.jpeg)

![Connector placed in hole](/images/post-content/mil-spec-mac/connector2.jpeg)

Next attach the connector and dust cover to the case with little machine screws and rubber washers to ensure all possible joints were protected against evil water. (Be sure to get your finger partially in front of the lens while documenting this.)

![Connector bolted in with dust cap attached](/images/post-content/mil-spec-mac/cover.jpeg)

And lastly, I cut off the standard electrical plug from the Hyperjuice charger, soldered the leads to the inside of the connector, and finished with heat shrink tubing:

![Internal wires heatshinked against the connector](/images/post-content/mil-spec-mac/wiring.jpeg)

###3. Build a Serious Charging Cable
The irony that one end of this cable is a water proof military grade connector and the other is a standard 3 prong wall plug is not lost on me. This cable was partially an experiment in building such a harsh-elements cable, and also needed to interface with its mating plug anyway. You might imagine an alternative cable with weather proof connectors at both ends.

The starting point was the flexible Mac power cable from the charger donated to this project. I began by sliding on a highly abrasion resistant plastic sleaving:

![Abrasion resistant sleaving on power cord](/images/post-content/mil-spec-mac/sleave.jpeg)

And then heat shrinking the wall end with a "high shrink ratio, glue lined, heat shrink tubing." This is not your father's heat shrink tubing, unless, of course, he worked 3M. It firstly is quite thick, and shrinks to a third or more of its original size. Secondly, it is lined with a heat activated glue, that fills all the nooks and crannies, sealing the bond against the elements:

![Heat shrink tubing on plug end of cord](/images/post-content/mil-spec-mac/plug.jpeg)

Turning to the the other side of the cable, I painstakingly soldered the leads to the connector. Then assembled the mil spec connector locking it against the wire. Finally, I applied the same heat shrink tubing to the connection:

![Heat shrink tubing on connector end of cord](/images/post-content/mil-spec-mac/heat-shrink.jpeg)

This cable is no joke.

###4. Wiring the Battery
The last part of this build required some careful splicing of the standard Mac magnetic charger plug and the output cable of the battery pack. Simply strip off the two leads, splice, solder and heat shrink. While it is possible to use a "[Magic Box](http://www.hypershop.com/MBP-BOX.html)" or an assortment of various cables to do this in a plug-and-play fashion. I opted for the more customized approach so that things could be routed cleanly and I could save some money.

![Building the power wire](/images/post-content/mil-spec-mac/power-wire.jpeg)

Once it's all done, the charger has a clean and short connector with another short cable to charge the laptop:

![Charger plugged in to battery pack](/images/post-content/mil-spec-mac/charger.jpeg)

##The Final Product
As the image at the beginning of the articles shows, all the parts can be neatly tucked away in the case. The whole thing works quite well, I did a full stint on the train from Washington, DC to Connecticut without using any external power. There were no problems on the trip down to Argentina either. It also works flawlessly at coffee shops, or really anywhere without power, it will last about 2 days of standard working usage.

Doing it over again, I might:

- Place the charging plug in a better location.
- Have an external LED to indicate the charging status.
- Improve the foam cuts to hold more accessories.

If you decide to make one for yourself, please share your experience in the comments!
