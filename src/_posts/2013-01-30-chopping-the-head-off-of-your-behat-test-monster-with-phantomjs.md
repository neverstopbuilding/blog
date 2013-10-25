---
layout: post
title: "Chopping the Head off of your Behat Test Monster with PhantomJS"
comments: true
date: 2013-01-30 11:09
categories: [behat, sahi, phantomjs, behavior driven development]
---

Recently, I posted about [how to set up Behat with Sahi on OSX]({{ site.url }}/how-to-setup-behat-with-sahi-testing-on-osx/) to automate your web application testing including javascript. Today we will chop the head off this operation by swapping out a spawned browser instance with the open source, headless browser: [phantomjs](http://phantomjs.org/).

This post is was helped along quite a bit by first [this article](http://shaneauckland.co.uk/2012/11/headless-behatmink-testing-with-sahi-and-phantomjs/) by Ryan Grenz, but ultimately [this one](http://shaneauckland.co.uk/2012/11/headless-behatmink-testing-with-sahi-and-phantomjs/) by Shane.

##1. Get a basic test project running.

This post relies heavily on the work completed in the [last one]({{ site.url }}/how-to-setup-behat-with-sahi-testing-on-osx/). My suggestion is that you work through that one quickly, as I'll assume:

- You have the prerequisites for php and sahi testing.
- You have installed sahi and know how to start the server.
- You have a sample project configured to use Sahi.
- You can run all the tests in the sample project and they pass.

##2. Install PhantomJS.

You can grab the headless browser over at their [website](http://phantomjs.org/download.html) or, if you are running [homebrew](http://mxcl.github.com/homebrew/) as you should, just run:

    brew install phantomjs

This will install phantomjs which you can verify afterwards by typing:

    phantomjs -v

Which will display a version number.

##3. Create a PhantomJS access file.
Next we need to create a file that will tie Sahi to PhantomJS. This file will be used when we are configuring sahi to use PhantomJS as an alternative browser. You can put it wherever you like but it probably makes sense to place it somewhere close to the phantomjs installation. I put mine here:

    /usr/local/Cellar/phantomjs/phantom-sahi.js

And the contents of the file should be:

    if (phantom.args.length === 0) {
        console.log('Usage: phantom-sahi.js <Sahi Playback Start URL>');
        phantom.exit();
    } else {
        var address = phantom.args[0];
        console.log('Loading ' + address);
        var page = new WebPage();
        page.open(address, function(status) {
            if (status === 'success') {
                var title = page.evaluate(function() {
                    return document.title;
                });
                console.log('Page title is ' + title);
            } else {
                console.log('FAIL to load the address');
            }
        });
    }

##4. Add the PhantomJS Browser to Sahi
The browsers for Sahi are defined in a `browser_types.xml` file, which if you followed the previous sahi installation would be located at `/usr/local/share/sahi/userdata/config/browser_types.xml` edit that file, adding the following to the bottom, inside the main tag:

    <browserType>
		<name>phantomjs</name>
		<displayName>PhantomJS</displayName>
		<icon>safari.png</icon>
		<path>/usr/local/Cellar/phantomjs/1.8.1/bin/phantomjs</path>
		<options>--debug=yes --proxy=localhost:9999 /usr/local/Cellar/phantomjs/phantom-sahi.js</options>
		<processName>"PhantomJS"</processName>
		<capacity>100</capacity>
		<force>true</force>
	</browserType>

This adds a new browser type, `phantomjs` using the same icon as safari, points to your homebrew installation of phantomjs and sets basic options as well as points to the script that we made earlier.

You can verify that you have added this additional browser by running the `start_dashboard.sh` script at `/usr/local/share/sahi/userdata/bin/start_dashboard.sh` which will open the Sahi dashboard allowing you to see the additional browser:

![Sahi browser launch dashboard.](/images/post-content/sahi-dash.png)

##5. Modify behat.yml
Using the [sample source code](https://github.com/jasonrobertfox/blog-behat-sahi) from last time you need to make one modification to the existing `behat.yml` file, changing the browser you are using from "firefox" to "phantomjs". You updated file should look like this:

    default:
      paths:
        bootstrap:  '%behat.paths.features%/bootstrap'
      extensions:
        Behat\MinkExtension\Extension:
          base_url: {{ site.url }}
          javascript_session: sahi
          browser_name: phantomjs
          goutte: ~
          sahi: ~

##6. Make sure it all works!
Make sure you start Sahi first, but running:

    bin/behat

From the root of the sample project should execute all the tests, and they should pass, but this time a browser instance will not spawn! Rather all the testing goes on in the background in the headless PhantomJs browser.
