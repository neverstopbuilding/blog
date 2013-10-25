---
layout: post
title: "How to Integrate Codemirror with Angular UI"
comments: true
date: 2013-02-27 16:24
permalink: /integrate-codemirror-with-angular
categories: [javascript, angular]
twitter: [javascript, angularjs, codemirror, syntax, js]
---
Getting [AngularJS](http://angularjs.org/), [Codemirror](http://codemirror.net/), and [AngularUI](http://angular-ui.github.com/) to play nice with each other is certainly an exercise in patient google searching, poring over cryptic and inadequate documentation, and inspecting various demos. Fortunately I've finished all that so that you don't have to. Here I walk you through the basic set up of Codemirror using the AnuglarUI directives for PHP syntax highlighting.

##It Takes a Village
In this case a village of dependencies. This was the trickiest part of making everything work, ensuring I had included all of the required css and js files. On a high level you will need:

- The AngularJS scripts
- The AngularUI Scripts
- The core Codemirror Scripts
- Codemirror support scripts for your language
- AngularUI Css Scripts
- Codemirror core css
- Codemirror theme css (if you so choose)

I was able to track down all the needed scripts by [inspecting the page](http://codemirror.net/mode/php/index.html) for the language in which I was interested, in this case PHP.

Here is an example of the HTML for the beginning of this adventure:

```html
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="//angular-ui.github.com/angular-ui/build/angular-ui.css">
        <link rel="stylesheet" href="//codemirror.net/lib/codemirror.css">

        <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.5/angular.min.js"></script>
        <script src="//codemirror.net/lib/codemirror.js"></script>
        <script src="//codemirror.net/addon/edit/matchbrackets.js"></script>
        <script src="//codemirror.net/mode/htmlmixed/htmlmixed.js"></script>
        <script src="//codemirror.net/mode/xml/xml.js"></script>
        <script src="//codemirror.net/mode/javascript/javascript.js"></script>
        <script src="//codemirror.net/mode/css/css.js"></script>
        <script src="//codemirror.net/mode/clike/clike.js"></script>
        <script src="//codemirror.net/mode/php/php.js"></script>
        <script src="//angular-ui.github.com/angular-ui/build/angular-ui.js"></script>
    </head>
    <body>
    </body>
</html>
```

##Setting Up the View
The easiest part of this process is setting up your view with the directive. You can pretty much copy what they have on the AngularUI site. The code below ignores the theme and should be added in our example's body:

```html
<div ng-app="myApp">
    <div ng-controller="codeCtrl">
        <textarea ui-codemirror ng-model="code"></textarea>
    </div>
</div>
```

##Polishing Your Codemirror
The final step is to update your application javascript (which you could include as another linked file) with the appropriate directions to set up your code mirror directive and in this case pass some data to the view:

```js
var myApp = angular.module('myApp', ['ui']);

myApp.value('ui.config', {
    codemirror: {
        mode: 'text/x-php',
        lineNumbers: true,
        matchBrackets: true
    }
});

function codeCtrl($scope) {
    $scope.code = '<?php echo "Hello World"; ?>';
}
```

The Angular part of this is very simple, simply update the model with a string of PHP. Note the use of the `ui.config` to pass Codemirror specific settings along.

##That's All Folks
That's really all there is too it. It took a good while to figure all of this out and get it working, but there wasn't much in the way of answers floating around on the internet. Now you should have clean looking output like this:

![Example of codemirror output.](/images/post-content/code-mirror-output.png)

If you would like to see this working live, check out a [fiddle of the same thing](http://jsfiddle.net/jrobertfox/RHLfG/2/).
