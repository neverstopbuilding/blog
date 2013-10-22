---
layout: post
title: "Building a GQueues Dashboard Widget"
date: 2012-07-16 17:22
comments: true
categories: [osx, gqueues, productivity]
---

Isn't it always the case that when you sit down to "get stuff done", often the first item on the list is "improve to-do list" or something to that effect. I can't tell you how many times I started out on my list of tasks only to have this dialog:

> *Jason*: Hey I need to do this large task.

> **Jason**: Well you should start with this very small part to get going.

> *Jason*: Ok, I'll do that… but wait, I could spend the rest of the day automating this part, and learning something new!

> **Jason**: Oh boy…

And that is what happened while I was poking around with the Dashboard feature of osx (Press F12). I think I needed to log a task into my favorite productivity app: [GQueues](http://www.gqueues.com/), and I think I thought "OH HORRIBLE FATE I WILL HAVE TO OPEN A BROWSER AND CLICK THE EXTENSION, THAT WON'T DO!!!!!!"

And so I spent the next several hours building a Dashboard Widget to do the same thing:

**Front**

![](http://media.tumblr.com/tumblr_m78jecokWd1r1y0wi.png)

**Back**

![](http://media.tumblr.com/tumblr_m78jekA17w1r1y0wi.png)

The source is open and can be found here: [https://github.com/jasonrobertfox/GQueues-Dashboard-Widget](https://github.com/jasonrobertfox/GQueues-Dashboard-Widget)

##Thanks

Obviously a huge thanks goes out to the creator of GQueues, [Cameron Henneke](http://www.gqueues.com/about), the app really nails it and I have used it after trying many others. Soon I'll try to post something about my current setup.

So I'd suggest, if you are interested, to head on over to [GQueues](http://www.gqueues.com/), and get yourself an account!

##Dashcode
To build the app I used Apple's [Dashcode](https://developer.apple.com/downloads/index.action) which was pretty good for designing the user interfaces but did not provide a lot of assistance when I needed to hook everything together with JS. There were a lot of things that seemed like they should be rather simple, but it took sometime to figure out the right syntax. Here are some tips organized by the searches:

###"underline link dashcode widget"
Ok to underline a text label you just gotta use ol' css:

    text-decoration: underline;

![](http://media.tumblr.com/tumblr_m78jffTKl61r1y0wi.png)
To get this little guy to look as fresh as it does required two separate text elements one of which was the actual link that was underlined and did something.

###"make text link to website dashcode mac widget"
This has been detailed before but you just need to add an `onclick` event handler to the text label and have it do this jazz:

    function authorClickHandler(event) {
       var websiteURL = "http://www.jasonrobertfox.com/";
       widget.openURL(websiteURL);
    }

###"dashcode widget set preferences"
Its cool to be able to save some settings in your widget so you can make a function that is called when the widget is flipped back to the front from the back which typically has the settings:

    function saveSettings() {
       if(window.widget) {
          widget.setPreferenceForKey(privateKeyField.value, "private-key");
          }
       }

And then to grab the preference:

    Var privateKeyValue = widget.preferenceForKey('private-key');

###"dashcode set text programmatically"
It's embarrassing how long it took me to figure this one out, this is now you can set the text of any label:

    document.getElementById('connectedStatus').innerText = "Not Connected!";

###"dashcode disable a button"
Got a button that you need to disable? Throw this bad boy at it:

    document.getElementById('saveTask').object.setEnabled(false);

###"dashcode json ajax request widget"
Need to interface with services as part of your widget, save yourself some time and:

- Create a new javascript file in your project called `jquery.js`
- Paste the minified [jQuery](http://jquery.com/) library in there.
- Add this line to your `main.html`:

    <script type="text/javascript" src="jquery.js" charset="utf-8"></script>

Saves you a lot of hassle and you can just use all the jQuery goodness to deal with your requests.

##And So…
I hope you enjoyed the tips, and the widget if you downloaded it. I encourage you to contribute or make suggestions for improvements. I guess the moral of the story is that you can't just ignore that itch to innovate or make something a little bit better. And now that I can add my task, finally, to my task list, I can move on to actually completing it ;)


####Resources
I came across a bunch of articles while trying to figure out building this thing:

- [http://www.dashboardwidgets.com/showcase/index.php](http://www.dashboardwidgets.com/showcase/index.php)
- [http://www.mactech.com/articles/mactech/Vol.24/24.08/CreatingWidgetswithDashcode/index.html](http://www.mactech.com/articles/mactech/Vol.24/24.08/CreatingWidgetswithDashcode/index.html)
- [http://andrew.hedges.name/widgets/dev/](http://andrew.hedges.name/widgets/dev/)
- [http://stackoverflow.com/questions/1238523/dashcode-newbie-question-change-a-buttons-label-programmatically](http://stackoverflow.com/questions/1238523/dashcode-newbie-question-change-a-buttons-label-programmatically)
- [http://www.electrictoolbox.com/using-settimeout-javascript/](http://www.electrictoolbox.com/using-settimeout-javascript/)
- [http://stackoverflow.com/questions/1819878/changing-button-color-programatically](http://www.electrictoolbox.com/using-settimeout-javascript/)
- [http://stackoverflow.com/questions/1818494/dashboard-providing-user-feedback-by-changing-button-label](http://stackoverflow.com/questions/1818494/dashboard-providing-user-feedback-by-changing-button-label)
- [http://forums.macrumors.com/showthread.php?t=657755](http://forums.macrumors.com/showthread.php?t=657755)
- [http://downloadsquad.switched.com/2007/01/08/how-to-make-your-own-dashboard-widget-with-dashcode/](http://downloadsquad.switched.com/2007/01/08/how-to-make-your-own-dashboard-widget-with-dashcode/)
