---
layout: post
title: "Designing the RoboGarden Frame and Watering Carriage"
date: 2013-09-25 10:12
comments: true
categories: ["robo garden"]
twitter: [RoboGarden, 3dprinting]
---

##RoboGarden Build Log: September 25, 2013

##Parts Discussed
- Light holders
- Frame
- Carriage

##Working on the Frame and Carriage
I had hemmed and hawed quite extensively and failed to move forward on the project since I had prototyped the stepper motor driver and the LED circuit. Perhaps it was because I was embroiled in my motorcycle restoration project. Perhaps it was the workload of a new consulting gig.

One reason, perhaps, was the difficulty in figuring out how I would build the frame of this beast. Researching laser cutting wood was expensive, and there was no TechShop near me. The project kept being pushed aside for other pressing endeavors, until packing for my travels overseas and cleaning out my old apartment I spied my girlfriend's empty shoe racks, awaiting a trip to the trash.

These were just two plastic ends that held thin, light aluminum tubs, about the same width as my planned garden project. Suddenly a torrent of ideas fluttered through my head. I perceived clearly, and finally, the LED heat sinks sitting on two of the tubes; how I might use the same tubs in a different place as rails for the sliding carriage, and also for the uprights of frame; joined together with little 3D printed push-in connectors.

![LED heat sink next to aluminum cross members](/images/post-content/robo-garden/rails-heat-sink.jpeg)

Fanatically, I gathered them up, cast aside the plastic bits and crammed yet another item into the large duffel bag that held my girlfriend's expansive wardrobe.

Fast-forward a few weeks and I'm settled in an apartment in Buenos Aires, having repaired my printer which was damaged in transit, and ready to start getting this frame together.

The top of the frame will hold the eight LED heat sinks with their respective LEDs over the plants. The same bits of frame that hold the heat sinks will also hold together the two top frame rails. I began with a prototype of the LED holder, a large inset circle with two places on each side to clip fit onto the rails. The prototype was a success and only needed slight tolerance adjustments for future versions.

![Printed LED mount on 3D printer bed](/images/post-content/robo-garden/finished-led-mount.jpeg)

Having assembled a model of the top in an Autodesk Inventor assembly, the next part of the puzzle involved positioning the watering carriage rails. These rails are in turn constrained by the design of the water carriage which slides back and forth watering each plant as needed.

Designing parts for 3D printing is an interesting challenge, as with any mode of manufacture really. Limiting overhangs requires that one think topographically, but there are opportunities to include limited overhangs depending on the angle and "bridging" distance. My preference is to limit support material due to the required post operation cleaning. Additionally, the better tolerances and finish quality appear to be in the XY plane, so cylinders, screw holes, and fitting curves are best printed in that plane.

Conversely, 3D printing allows for some unique solutions to otherwise tricky machining problems. With the back of the water carriage I needed to consider these constraints:

- There must be two constraining troughs for the rails to slide through.
- A tall spout must ascend upward out of the "back", so as to protrude through the "front."
- A place to attach the water hose tube must connect to the spout.
- Two holes and small bosses are required to affix the little wheels.

The resulting design incorporated an external nipple which leads through an internal cylindrical passage way at an angle to the vertical path of a rectangular water spout. I embellished the spout slightly for aesthetics, so the user can see the little fountain pour down onto the plants. This designs allows all key tolerance areas to be printed, with the nipple sticking out of the bottom of the carriage when mounted to the rails, and the long spout to stick through a corresponding slot in the mating carriage front.

The first print of the carriage back was not ideal but provided some good lessons regarding the required raft material under the nipple. It also appears that the nipple will require some post processing to smooth it out and make it leak proof. One alternative might be to simply print a hole and glue in a higher precision nipple.

![Carriage back prototype](/images/post-content/robo-garden/carriage-beta.jpeg)

In the next iteration of the design I'll also remove much more of the extraneous material in the carriage back, as well as reducing fill density to speed up print time and material usage. Less than ideal is the holes for the wheel screws, which due to the design and direction of print, will require rather long screws. This may be one location where I'll use support.
