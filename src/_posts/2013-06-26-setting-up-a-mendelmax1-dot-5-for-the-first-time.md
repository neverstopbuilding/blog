---
layout: post
title: "Setting up a MendelMax1.5 for the First Time"
comments: true
date: 2013-06-26 10:51
categories: [mendelmax, 3dprinting]
twitter: [mendelmax, 3dprinting, 3dprinter, maker]
---

Recently I finished the construction and calibration of my first 3D printer. It's a MendelMax1.5 that I purchased from [3D Factory](http://store.makea3dfactory.com/) in kit form. Here is a pic of its "beta" state:

{% img https://lh4.googleusercontent.com/-L88VJFmOztw/Uci42nQ2ITI/AAAAAAAAHlw/mGiyi2P-PZM/w554-h738-no/Photo+Jun+24%252C+2+45+18+PM.jpg %}

 DON'T JUDGE! I need to clean up the wiring and, as anyone who knows me can attest, I take extreme pride in clean wiring. It was a pretty fun project to build, however it confirmed my assumptions about some of the current 3D printer designs; namely that they:

- Are overcomplicated to support reproducibility.
- Tricky to construct.
- Lack adequate documentation.
- Have too many parts.

Don't get me wrong. I love this new MendelMax and think it's amazing and very useful. However I hope that this post, and my future work on developing a low cost simple 3D printer will help improve the hobby as a whole and make it accessible to more and more people.

I'd like to walk through some of the nuances of my adventure in setting up this printer to run off of my Mac Air:

- Configuring the firmware
- Calibrating the printer
- Setting up the required software
- Printing a test object

##Setting up the required software
This set up generally requires 6 pieces of software; all free! Each is part of a process from design to fabrication, they are listed below in the order that they should be installed, but once everything is working you use them in reverse order.

###Arduino IDE 023
This was used to load the firmware onto the Arduino Mega board as well as make adjustments. Apparently newer versions of the IDE cause problems and so the recommendation is to use this older version 023. It can be downloaded [here](http://arduino.cc/en/Main/Software) (scroll down.)

###Marlin (Firmware)
Marlin is the firmware package that lets your computer communicate with the printer and translate the GCode into usable instructions. Out of the box I had some issues setting up the version available on [Github](https://github.com/ErikZalm/Marlin) but the guy who makes my printer was nice enough to send his version along. My current firmware file can be accessed at [this link](https://www.dropbox.com/sh/oxr5ew20xnmarok/0KPmFfXyG_). I fully intend to figure out how to use the latest version as there are some nice advanced configurations.

###Printrun (Pronterface)
This is the main control unit of your printer. I think of it as the big box that is attached to CNC milling machines. You can grab the version for your system [here](https://github.com/kliment/Printrun). Setting this up was simply a matter of selecting the right serial port for your Arduino/Ramps and a matching baud rate as that configured in your firmware file and pressing connect. Here are some things to check:

- I turned on the temperature gauges in the options menu as well as the "watch" mode to see the graphs of the bed and hot end temperature.
- You can manually enter a GCode like `G1 X100 Y100 Z150 F3000` to send the printer head to those coordinates at the speed 3000. This can be helpful for moving around the bed when calibrating.
- You can manually enter a GCode like `G92 Z0` to "zero" the Z Axis. Use this when you jog down onto the bed until a slip of paper is snug, then set your Z zero point.
- If you are looking at the front of the printer, +X should move the head to the **RIGHT**, and -X to the **LEFT**.
- +Y should move the head **AWAY FROM YOU**, and -Y should move the head **TOWARD YOU**.
- +Z should move the head **AWAY FROM THE CENTER OF THE EARTH, UP TO THE SKY**, and -Z should move the head **STRAIGHT TOWARD HELL**, as you can tell, confusing this in the settings will assure you slam your printer head into your bed.

###Slic3r
[Slic3r](http://slic3r.org/) is software that takes your STL file and generates the GCode for the print run, taking into account all sorts of settings that will determine your print quality. I switched to Expert mode so that I could see all the settings that I had to deal with, plus you can save presets which will come in handy if you switch filaments or print settings. Some things to note:

- Under **Printer Settings** set your bed size. I did this as extents from a home position which was about 5mm x 5mm in from the front, left of my bed. As a result, you will want to set your bed size slightly smaller than the actual dimensions of your bed.
- Similarly, set the print center to the actual center of your bed. That is where your part origin will be. This can usually be determined by just halving the bed size numbers.
- For **Filament Settings** I set the diameter to the actual measured diameter of my filament averaged over its length. (For example 2.92mm for a 3mm filament.)
- Also set the appropriate bed and extruder temperatures for your type of filament, I kept the first layer about 10 degrees hotter than the rest to promote adhesion. So 205C and 195C for PLA with a bed of 65C and 60C. Save this as a "PLA" setting.
- Under **Print Settings** I set the *Layer Height* to 0.2mm and first layer to 0.35mm for my 0.35mm tip.

###Netfabb
Netfabb should be used to take the STL files that your modeling program produces an run them through a repair process to assure they are ready to be sliced and printed. Download the "Basic Version" form [here](http://www.netfabb.com/). All you need to do is:

1. Open your STL file
2. Go to **Extras** -> **Repair Part**
3. Go to **Repair** -> **Automatic Repair**
4. Click Automatic repair then default repair
5. Click Apply repair (I replace the part.)
6. The go to **Part** -> **Export part** as an STL (I just overwrite the one I started with.)

Depending on the quality of the model, you might notice red "surfaces" in place of where some desired holes are. I found that in SketchUp this seems to be correlated with having surface cutting two other surfaces. Particularly if I made two extrusions, then lofted between their outlines. The fix was to "go inside" the model and delete any surfaces that prevented the whole model from being one, continuos, hollow shell.

###SketchUp (or Similar)
I started with [SketchUp](http://www.sketchup.com/) to create simple 3d objects for printing. I love the software and it is really easy to use. Use [this plugin](https://github.com/SketchUp/sketchup-stl) to export the file as an STL. Note that when I installed the plugin I had some problems that were solved by changing the permissions on the plugin directory. 

Also, the plugin [Curviloft](http://sketchupdate.blogspot.com/2012/01/organic-modeling-made-simple-with.html) is quite useful for making nice organic manifolds, like for [fan ducts](http://www.thingiverse.com/thing:108972).

###Workflow
With all this software installed I moved on to the configurations. But just to summarize the workflow for creating a 3d object:

1. Create your model and export the STL with SketchUp (or grab an STL from [Thingiverse](http://www.thingiverse.com/))
2. Load the model into Netfabb and repair any problems with it.
3. Load the repaired STL into Slic3r to generate the GCode.
4. Load the GCode into Printrun and begin your print!

##Configuring the firmware
In order to configure the firmware I loaded it into the Arduino IDE and made modifications to `Configuration.h`. I had to make the following adjustments:

- Changing the `TEMP_SENSOR_0` to 1 to match the specs for my sensor.
- Set `DISABLE_Z` to true to not have the stepper go into "hold" mode between layers.
- I had to set `INVERT_Z_DIR` to true as my z was moving the wrong way.
- I did NOT have to invert my Y direction as the firmware comments indicate.
- Set the `X_MAX_POS` and `Y_MAX_POS` to the bed dimensions, 225mm and 275mm respectively.
- Set the `Z_MAX_POS` and `Z_MIN_POS` to 150mm and -200mm respectively (allowing for jogging down to zero the head.)
- Configured the `DEFAULT_AXIS_STEPS_PER_UNIT` variable specific to this printer as detailed below.

##Calibrating the printer
The three main things you need to calibrate on the printer are the feed rates, the level-ness of the bed, and the extrusion rate.

###Feed Rates
For each of the x, y and z axes you need to do the following steps:

1. Rig up a high precision caliper in such a way that you can set the origin on a known distance. For example, for the x axis, between one of the liner bearings and the side bracket.
2. Instruct the machine to move 100mm (ideally) so you can increase your measurement. 
3. Increase the opening of the calipers to get the new measurement, it likely will not be 100mm.
4. In the firmware there is a feed number for each axis in the `DEFAULT_AXIS_STEPS_PER_UNIT` variable. My X is `80.0960288` for example. If you take the existing number, divided by the found number, multiplied by the desired number, you will have the new rate to input in this file. For example: `(80.0960288 / 95.6) * 100 = 83.78245690`. 
5. Update the variable with your new number.
6. Reload the firmware.
7. Go back to 1 and repeat this process until the distance moved is the same as the distance specified.

###Level-Ness
Depending on how your printer is constructed, your bed could be out of level for a variety of reasons. Make sure your glass is in place before calibrating the bed. To determine what needs to be adjusted:

1. Zero your z at home position, you should barely be able to slide a sheet of paper under the head.
2. Set your Z zero with `G92 Z0` GCode command.
3. Back Z off the bed by 1mm.
4. Start to move in the positive X direction, paying attention to if the head moves up or down toward the bed.
5. Using your hand adjust the right side lead screw until the head is clearly above where you stared back at home.
6. When you get to the other side of the bed, go back down 1mm and your head should be slightly off the bed. 
7. Turn the lead screw in the other direction, repeating the paper process until you have the same effect: snug paper sliding.
8. Now you should move back toward home and notice that the head should slide perfectly level just above the bed.

At this point your X Axis is level with your bed, but you still could have problems with the Y axis. Repeat the process outlined above but for the Y direction. If your bed is far out of level as mine was you may need to add a washer or two to the spacers on one side of the bed. If only a small adjustment is required, you could adjust the linear rod brackets slightly up or down.

###Extrusion Rate
Finally, calibrating the extrusion rate is very similar to the axes; you have to measure how much filament is fed into your head versus how much you instruct the head to feed. I measured out 30mm of filament after straightening the filament as much as possible. Then I marked the distance with a marker. 

After instructing the head to feed 30mm, I recorded the difference between the top of the head and the mark and used these measurements along with the same formula as the directional axes to determine the new feed rate number. 

##Printing a Test Object
Finally having calibrated the printer, and crashed the carriage into the side of the machine more than once, it was time for a test print. I started out with [this test block](http://www.thingiverse.com/thing:24809) that I found on on Thingiverse:

{% img https://lh5.googleusercontent.com/-98R-VHQrjYw/Uci42ri8IJI/AAAAAAAAHls/5BJpkfGYAI4/w984-h738-no/Photo+Jun+24%252C+1+46+13+PM.jpg %}

The print went better than expected:

{% img https://lh6.googleusercontent.com/-SsaTSA1-4M0/Uci42QpdfdI/AAAAAAAAHlo/_dC19ceW6LI/w554-h738-no/Photo+Jun+24%252C+1+43+10+PM.jpg %}

Some small warping at the corners due to heat, but I was pleased with the general dimensions. The main problem was that the holes included in the model were too small to test fit the 3mm fastener. And so I set out building another test object with some various hole sizes:

{% img https://lh3.googleusercontent.com/-h0_l6ZVI-aM/Uci43vSSVBI/AAAAAAAAHl8/d7t0gLGLuIo/w984-h738-no/Photo+Jun+24%252C+2+59+20+PM.jpg %}

According to this test, it seems a 3mm machine screw needs a minimum hole of 3.4mm for a snug fit and 3.6 or maybe even 3.8 for a clearance hole. One of the problems I ran into when building my printer was that the fastener holes were too small, requiring cleaning and filing to get things to fit. Even the nut hole I printed with a 6.2mm of clearance was too tight. 

Armed with this I though I'd print a little gauge to test various clearance levels:

{% img https://lh5.googleusercontent.com/-LadW1HmKvyE/Uci44NWOA-I/AAAAAAAAHmA/Yfy7Giv9CRg/w984-h738-no/Photo+Jun+24%252C+4+24+12+PM.jpg %}

In this test I created 5 bolt holes, 5 nut slots and 5 nut recesses to simulate the possible configurations when joining 3d printed parts with external hardware. The idea is that once I have this gauge I should know how to spec my fittings holes in the models. The dimensions are as follows:

- Nut Recesses (top row): 6.4mm to 7.2mm in 0.2mm increments (vertex to vertex)
- Not Slots (second row): 2.5mm to 2.9mm in 0.1mm increments, thickness, with a width from 5.5mm to 6.2mm depending on the nut size. (depth the same as above) as with the depth)
- Holes (bottoms row): 3.4mm to 4.2mm in 0.2mm increments

###Results
**Bolt Hole** - This worked out well on all counts, the smallest size worked with a 3mm screw with just a little force and had zero play. All the other holes the screw just dropped in.

**Nut Recess** - The middle recess with a vertex-to-vertex distance of 6.8mm worked perfectly for a finger press fit. Both larger sizes worked well for removable nuts.

**Nut Slots** - From a thickness perspective, the 2.6mm and up sizes had a drop in fit, while the 2.5mm size was quite snug, but it still fit in. As far as the width is concerned, the middle slot seemed to have the right snugness and easy fit, any larger and the nut would start to turn. The 5.7mm width would work but it was much more snug.

##Next Steps
The initial tests and calibration went well. At this point there are a few things I'd like to do in the short term:

- Get a proper bed set up: full sized glass with kapton tape.
- Build a container for the Ramps and Electronics
- Attach the End Stops and configure them.
- Clean up this insane wiring.
- Update the firmware to the latest version.

To that end I've ordered a big role of PLA and Kapton tape as well as a set of **long tweezers** these will come in handy for cleaning away test plastic from the tip without burning your fingers. 

I hope to post more details of the build out soon!


