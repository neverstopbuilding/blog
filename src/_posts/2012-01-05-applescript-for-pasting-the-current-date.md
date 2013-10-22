---
layout: post
title: "AppleScript for Pasting the Current Date"
date: 2012-01-05 15:51
comments: true
categories: [quick tips]
---

I'm a big fan of taking notes with [Evernote](http://evernote.com) and wanted a way to **paste the current date time** into the note, or for that matter into anything I was working on.

##Installation
The basic instructions for getting this setup can be found [here.](http://blog.fosketts.net/2010/08/09/assign-keyboard-shortcut-applescript-automator-service/)

##Making the workflow
Create a simple service in Apple Automator that **receives no input** in **any application**, save it as something like ``"paste_date"``:

![Apple automator script window](http://media.tumblr.com/tumblr_lxc0wp5UEJ1r1y0wi.png)

##The Code
Here is the code I used:

    set newTxt to ((current date) as string)
    set the clipboard to newTxt
    tell application "System Events" to keystroke "v" using {command down}


##Creating the Shortcut
In the **Keyboard Preferences** create a new shortcut for this service:

![Keyboard shortcut command window](http://media.tumblr.com/tumblr_lxc15nSDUK1r1y0wi.png)


That's it! Now in any application you can just press **command-shift-d** and paste the date:

``Thursday, January 5, 2012 10:47:22 AM``
