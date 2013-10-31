---
layout: post
title: "Finishing the RoboGarden Frame"
date: 2013-10-01 17:41
category: hardware hacking
project: robo garden
tags:  [stepper motor, led mounts, carriage back, 3d printing, prototyping, garden hacking]
---
##Finishing the Carriage Back
After experimenting with a first iteration of the carriage back I proceeded to trim down the design to improve print speed and simplicity.

One thing I learned after having printed the first prototype was that the indentations for the smooth aluminum rails to sit in were sufficient to constrain the carriage and act as linear bearings. The linear precision of the carriage is hardly a concern and the stepper motor and bely will be more than sufficient to handle the X axis travel between plants.Furthermore, the frequency and speed of the travel will be quite low so I'm not too concerned with friction between the rails that the carriage.

![Print of the carriage back](https://lh3.googleusercontent.com/-Gzwwj61Uh84/Uksya5PrH_I/AAAAAAAAIk0/OENviY4S_YY/w949-h712-no/13+-+7)

As a result, I decided to abandon the small washer wheels that would act as linear bearings and rely solely on the indentations in the carriage sliding against the rails.

Making this change allowed me to remove some additional material from the design, but also required I provide another facility to join the two sides of the carriage together. This would be accomplished with two pockets that would hold a small screw nut. Though it would require some bridging in the printing, it was a compromise I was willing to accept.

A consideration for future prints of pockets, or even just "nut holes" generally, is to pause the print at the layer just before the bridging operation, and place the nuts in the hole or pocket where they are supposed to be. Essentially entombing them in the printed part. This might help with post assembly clean up.

By adding a single raft layer (probably unnecessary) and more importantly increasing the heat of my print bed, I was able to print the second prototype to completion without warping. The water spout ended up working quite well; I had been worried about deformation due to the small size and height, but dialing back the temperature during this part of the print seemed to help.

##Designing the Carriage Front
This was a rather simple part to design and build, especially having learned of the "derived part" feature of Autodesk Inventor. With this feature, you build one part based on another, either using the original part as a base for the new one or as a work surface. In this case I used the carriage back as a work surface to dimension the front, leaving the perfect space for the rails. This part also has mating  matching holes for the screws as well as a slot to allow the spout to protrude.

The final feature was a tab for joining the belt to the carriage. The original intention was to rotate the belt at the point of connection so that the belt could be affixed to the carriage "flatly." However, it does not appear to matter as I could design the belt clamp to hold the belt without a bend. Ultimately I decided to prototype it this way, as that would avoid any potential issues with the belt rotating so close to the pulleys at far ends of carriage travel.

![Print of the carriage front](https://lh4.googleusercontent.com/-j1_5nExbJaY/Uksv4I6mu5I/AAAAAAAAIiw/5zCxNm0Kg1s/w816-h712-no/13+-+6)

The small belt clamp turned out great, and by projecting the teeth of the belt onto the clamp, the part cleanly locks the belt to the carriage without needing to any clamping force at all.

![Belt clip attached to the drive belt](https://lh3.googleusercontent.com/-a8e1JoHLJFs/Uksv4DrgD6I/AAAAAAAAIhI/5cd3j0e88pI/w534-h712-no/13+-+10)

##Motor and Idler Mounts
With the design of the carriage complete, two important dimensions had been determined:

- The location of the belt relative to the carriage and thus the rails.
- The location of the rails relative to each other.

Knowing these two constraints along with the dimensions of the motor, idler bearing, belt and pulleys allowed me to design the motor mount and idler mount. The final dimensions that I needed to decide on were:

- At what height should the water spout sit below the lights.
- At what distance from the light or "plant" center should the water spout sit.

For these I made some rough guesses, but perhaps some knowledge about the plant pot size and plant in general could have informed them. I'd have the water spout sit rather far from the pot center to clear any leaves, and give myself about 200mm of distance between the spout and the lights. Although this distance would prove to be adjustable.

With the carriage and rails positioned relative to the lights the motor mounts could incorporate mounts for the carriage rails, the motor or idler, as well as an angled mount for the rail that would hold the lights aloft.

![Print of the stepper motor mount](https://lh3.googleusercontent.com/-H0OF15rtyU0/Uksv4Hdu-EI/AAAAAAAAIkE/Dzus3PlTjjo/w949-h712-no/13+-+2)

Once the motor mount was designed the idler mount was a cinch. All that I needed to do was derive a part from the motor mount but mirror it across the Z axis and change the mounting geometry to hold the bearing. One feature I added to this was a set of pockets that allowed the bearing to be adjusted around one of its screw holes. This would let me adjust the tension on the belt.

![Print of the idler mount](https://lh5.googleusercontent.com/-DQr4JZV-nnY/Uksv4Ams7MI/AAAAAAAAIjo/x9vZS5BrMC8/w949-h712-no/13+-+4)

##Uprights and Feet
The motor and idler mounts were the more complicated parts of the build, but once they were designed, their geometries influenced the rest of the parts, which came together quickly. The Upright mounts simply joined the light rails to the uprights with angled mounts.

![Print of the upright to cross member bracket](https://lh3.googleusercontent.com/-OfuG_Pt5h7Y/Uksv4C4yePI/AAAAAAAAIjw/i_PouR98xSA/w534-h712-no/13+-+3)

The uprights are simply shorter sections of the same rods used elsewhere, and because there is no stopper on the upright mounts, they can protrude through to any degree. Thus the height of the lights relative to the ground and carriage can be adjusted simply by sliding the rails through the upright mounts.

The final prototype was the feet, just bases with the same angle and pads to stand against the ground.

![Print of the upright feet](https://lh4.googleusercontent.com/-1shLVIsVAbw/Uksv4Lhz7NI/AAAAAAAAIjY/6y82dU9Y3H8/w949-h712-no/13+-+1)

I printed four of the feet and then realized there would be some asymmetry in the final construction, even though I designed the feet to be universal. This was not the case but they will still work. Future designs would have them work regardless of orientation.

##Improvements to the LED Mount
After designing the upright mounts, it was clear that the rails would be very ridged, even without any light mounts attached. The previous design of the light mounts had a bit too much material, and given that I'd need to print 7 more I opted to strip down the material usage considerably. The resulting design still solidly holds the LED heat sink and clips easily to the rails.

![Print of the initial and final LED mounts](https://lh6.googleusercontent.com/-F37a2yL9KsE/Uksv4A4pdiI/AAAAAAAAIh0/jZLoc8fpWaU/w949-h712-no/13+-+8)

##Getting Real
That basically finishes up the bulk of the frame work. The next step will involve building the frame and hooking all the components together. Then I'll have to get down to the nitty gritty of programming the beast. Here is a picture of the assembled model:

![Computer 3D rendering of the RoboGarden frame](/images/post-content/robo-garden/frame-model.png)

And the majority of the parts awaiting assembly:

![All the frame parts layed out next to each other](https://lh6.googleusercontent.com/-dH8LmxL5w7Y/Uksv4JFXtjI/AAAAAAAAIik/I5ew8oKB7zk/w1118-h629-no/13+-+9)
