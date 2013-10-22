---
layout: post
title: "Writing a Useful User Gherkin Feature"
date: 2012-11-05 15:17
comments: true
categories: [behavior driven development]
---

I was in the middle of writing a user epic when the excellent talk on [behavior driven development](http://behaviour-driven.org/) by [@weaverryan](https://twitter.com/weaverryan) from the recent [ZendCon](http://www.zendcon.com/) bubbled to the top of my mind. One of the lessons that he shared is certainly worth repeating and that is: use your collaborative planning process to determine real business value. It is important that you don't over plan features that will never get implemented, or ones that will generate no substantive return on investment. Remember, this isn't a magical time of exploration and experimentation; some times that is justified, but at the end of the day engineers support a business. On the other hand it is important not to under plan features, you don't want to get into a sprint and find everyone asking, "who uses this?", "why are we doing this?", or "is this worth 20 engineering hours?"

Fortunately, there is a structured way to write "features" that can necessitate asking the right questions. It is the same structure that heads the feature files in both the [Behat](http://behat.org/) and [Cucumber](http://cukes.info/) BDD libraries. Here it is:

###In order to A
"A" represents the business value, it is the reason the feature should be built, it is whole point.

    In order to sell cars…

    In order to access my shopping cart…

This is the part of this description that you can go to the big boss and speak in plain language about.

###As a B
"B" is the user of the feature, you must get into their shoes and determine what makes them tick and how they will use the feature. The whole description should be written in language that this person will understand:

    In order to decouple the warp driver
    As a fleet commander…

    In order to sell lemonade
    As a 5 year old girl…

###I need to C
"C" is the feature itself, and the I is the first person of "B". This is where it is quite important that you use the correct language to describe the feature, as it is written as if the user were describing the interaction. It is ok to use technical language if you have a technical user, but try to keep it simple, even as an engineer I don't click on the `<a>` tag with the css class of `.button .submit`, I just click the "Submit Button". Keeping with the previous examples:

    In order to decouple the warp driver
    As a fleet commander
    I need to access the main engine computer system

    In order to sell lemonade
    As a 5 year old girl
    I need a lemonade stand

It is not rocket science! But it is the most important thing because you can get every facet of your team or organization speaking the same language and thinking: "of course we need a lemonade stand!!! how else will sally sell the lemonade!?!"

If you start to hear anyone ask the question of "why" when you are already coding things, then it is time to revisit these feature descriptions, or create them to begin with.
