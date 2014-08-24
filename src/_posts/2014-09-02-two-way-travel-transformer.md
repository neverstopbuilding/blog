---
layout: post
title: Building a Two Way Travel Transformer
image: /images/post-content/two-way-travel-transformer/two-way-travel-transformer.jpg
date: 2014-09-02
category: "build logs"
tags: ["travel transformer", "two way transformer", electricity, electronics, soldering, "project box", dpdt]
description: "What do you do with a 220 volt Argentine face clipper when you are back in the land of 110 volt mains? Well I built a little two way transformer so that I could keep my beard under control!"
promotion: "Electricity is cool! Checkout this simple project to step up or step down your #voltage."
---
The back story to this build goes something like this: I lived in Buenos Aires for almost a year and as you can imagine over that time my face went from looking like the barren lands of Patagonia to resembling the dense jungle surrounding Iguazu Falls. I bit the bullet and purchased a heavy duty clipper because I like the rough look it gives to the old beard.

The rub here is that in Argentina everything runs on 220 volts, and so if you plug the clipper into a US plug it just kind of hums, but does no clipping. Fortunately, I had also picked up a 220 to 110 volt step down transformer to run some of gear while in Argentina. By rigging up the same transformer in reverse, I'd be able to run my clipper back in the States.

In an effort to make something a little more universal and with a reasonable build quality I came up with a plan to build a reversible transformer that would allow me to step up the voltage or step it down, depending on what country in which I was traveling. Here is the basic schematic:

![Schematic of transformer circuit](https://www.evernote.com/shard/s5/sh/a601b36d-1318-4e21-a8b8-de8e8074f555/9362f680c741c21c27d5ea7deeaaab38/deep/0/CircuitLab---Editing-"Welcome-to-CircuitLab".png)

The operation is simple. The double poll, double throw switch directs the input AC current to either side of the transformer, the output of the transformer is then routed to one of the two outlet plugs (in this diagram represented by voltage meters.) In one mode the outlets will supply input and stepped up voltage, and in the other mode they will supply input and a stepped down voltage.

##Materials
To build this project yourself you would need:

- Project box to fit transformer
- Panel mount DPDT switch
- Transformer with a winding ratio of 2 (this one is rated to 200 watts)
- Normal wall outlet
- Wire
- Fork lugs for wire ends
- Heat shrink tubing
- A cord for input voltage
- Small rubber grommet to fit input cord
- Two small machine screws with nuts to affix outlet

A thorough overview of the build process is detailed in the video below. Enjoy!

{% youtube https://www.youtube.com/watch?v=SNS5xkFDJEQ %}
