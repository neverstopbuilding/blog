---
layout: post
title: "DTOx Update: Generate Code on the Web!"
date: 2013-03-01 13:48
category: software engineering
project: dtox
tags:  [dtox, dto, data transfer object, design patterns, code generation]
---
A little while back I [wrote about]({{ site.url }}/data-transfer-object) the project [DTOx](https://github.com/jasonrobertfox/DTOx) which you could use on the command line to rapidly generate both the class and the test for a "Data Transfer Object." With the latest release, you can now enter all your information via a web interface.

Check it out here: [http://dtox.pagodabox.com/](http://dtox.pagodabox.com/)

##What's new?
Very little has changed about the actual code generation methods, but some cool front end technologies were employed to bring about this new user interface:

- [AngularJS](http://angularjs.org/) asynchronous updating.
- [AngularUI](http://angular-ui.github.com/) to integrate the [CodeMirror](http://codemirror.net/) editor panes.
- [Pagoda Box](https://pagodabox.com/) for rapid deployment and hosting.
- A fresh UI thanks to [Twitter Bootstrap](http://twitter.github.com/bootstrap/), [Font Awesome](http://fortawesome.github.com/Font-Awesome/), and [Bootswatch](http://bootswatch.com/)

![Dtox Interface Example.](/images/post-content/dtox-capture.png)

##What's next?
Here is a list of things I'm thinking about doing in the short term, in no particular order:

- Integration command line documentation into the main website.
- Adding proper validation to the input fields.
- Updating the generation API to more cleanly serve both the web and the console.
- Adding the ability to save the file made
- Adding ability to also make a DTO builder pattern class.
- Improving the web application testing.

If any of these seem more interesting to you than the others, please let me know!
