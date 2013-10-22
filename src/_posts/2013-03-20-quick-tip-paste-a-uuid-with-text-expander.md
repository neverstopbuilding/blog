---
layout: post
title: "Quick Tip: Paste a UUID with Text Expander"
date: 2013-03-20 11:32
comments: true
categories: [productivity, quick tips]
twitter: [hacks, uuid, textexpander]
---
I often like to get a [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier), an "universally unique identifier" for tagging things like receipts. In general I add the UUID to a picture of a receipt or invoice in Evernote, then add the same to whatever accounting/google doc I'm using to track expenses. There is a great website to get a UUID:

[http://www.famkruithof.net/uuid/uuidgen](http://www.famkruithof.net/uuid/uuidgen)

However before today I had to do this:

1. Open a browser… (UGHHHHHG!)
2. Type a url… (Uhhhhhhhhhhhhgggggg)
3. Copy the UUID (Sigh…)
4. Switch back to my application. (I want to die.)
5. Paste it. (AHHHHHHH!!!)

Needless to say this could not go on forever. Fortunately one of my favorite apps [Text Expander](http://smilesoftware.com/TextExpander/index.html) can support shell scripts. So it is kind of like having a command line "alias" for everything.

Now whenever I type:

    ;uuid

It gets replaced with something like this:

    8be746c0-9174-11e2-9e96-0800200c9a66

YES! (And because of the way Text Expander can be set up, it is still in the clipboard awaiting my next paste.)

You can do it too by adding this simple script to the snippet:

{% codeblock lang:bash %}
#!/bin/bash
curl -s http://www.famkruithof.net/uuid/uuidgen | grep -o '<h3>\([0-9a-z\-]\+\)</h3>' | sed 's/<h3>\(.*\)<\/h3>/\1/'
{% endcodeblock %}

Enjoy.
