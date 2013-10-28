---
layout: post
title: "I Got the Bower! UI Dependency Management with Bower"
date: 2012-11-28 23:18
category: web development
tags:  [bower, dependency management, ui assets, node, package management]
---

I have been getting my learn on of late, recently reaching a milestone on a CRM tool for the Ovarian Cancer National Alliance, I now have all this free time to explore new and fascinating things. Enter [Research Bug](http://researchbug.tumblr.com/), a web app my buddy and I are working on to streamline the white hot UX research process.

Enough back story! This post is about using [Bower](http://twitter.github.com/bower/) to manage the dependencies of the UI assets. I may change this as I explore rapid deployment options, but for now it works well. Here is how you can use it in a clean way:

##Install Bower
Make sure you have [node](http://nodejs.org/).

    npm install bower -g

##Create a component.json file
This file will store all your dependencies, here is mine as an example:

    {
      "name": "Research Bug",
      "main": [
        "./public/stylesheets/main.css",
        "./public/javascripts/main.js"
      ],
      "dependencies": {
        "jquery": "~1.8.3",
        "jquery-ui": "~1.9.2",
        "bootstrap.css": "~2.1.1"
      }
    }



##Create a .bowerrc file
I have a `public` directory for my web-root, and typically bower would put your ui dependencies in a `components` folder in the project root. If you want to change that create a `.bowerrc` file in the project root. For example:

    {
      "directory" : "public/components",
      "json"      : "component.json"
    }


Now all my dependencies are in `public/components` where I want them. Hot.

##Install your dependencies!
This one is simple:

    bower install


Now you can just throw something like this bad boy in your file/template/layout and you are rock and role:

    <link rel="stylesheet" type="text/css" href="/components/bootstrap.css/css/bootstrap.min.css" />


##Bonus: Travis this to the hilt.
I was pleasantly surprised at how clean this integrated with [travis ci](https://travis-ci.org/), all I had to do was add these relevant items into my `travis.yml` file:

    before_script:
        - npm install bower -g
        - bower install
