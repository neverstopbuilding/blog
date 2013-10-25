---
layout: post
title: "10 Crucial Sublime Text 2 Plugins for the PHP Craftsman"
comments: true
date: 2013-01-13 23:25
permalink: /sublime-plugins-for-php
categories: [php, sublime text, craftsmanship]
---

<blockquote>
A determined soul will do more with a rusty monkey wrench than a loafer will accomplish with all the tools in a machine shop.
<cite>Robert Hughes</cite>
</blockquote>
The above, indeed, captures my sentiments on the use of tools. Give Roger Federer a beat up, poorly strung, yard sale racket, and you can bet your shorts he'll crush you; no matter how many hundreds of dollars you spent on a carbon fiber object d'art.

Thus it is with software engineering. Too often we can roll down the rabbit hole of tool optimization to the distraction of learning the ins and outs of our programming language, its standards, or best practices. And yet, we also must allow ourselves, having put in the necessary time to learn "why?", to implement tools that speed our development workflows and process. But make no mistake, your tools should be a natural result of improved skill, not as a means to acquire it.

Now allow me to stop off my soapbox and offer you the 10 plugins that I use in my choice text editor, [Sublime Text 2](http://www.sublimetext.com/2). Each will help improve your efficiency as a PHP code smith! I have ordered them by their usefulness should you feel inclined only to install a few.

##1. Package Control
This one goes without saying. I hope you are not installing Sublime plugins by cloning repos and copying folders!? With Package Control you can quickly install any of the other plugins directly from within Sublime Text 2! Similarly, you can uninstall plugins that you thought were cool, but now are just giving you a headache. You won't find every plugin available through Package Control, but rest assured that all of those mentioned in this article are there.

![Package Control](/images/post-content/package-control.png)

Get [Package Control here](http://wbond.net/sublime_packages/package_control/installation).
##2. Phpcs
If not for Package Control, this would be at the top of the list. Maybe it's the German in me, but I love standards and things being just so. Now that we have a [set of standards](https://github.com/php-fig/fig-standards) governing how PHP code should look, you would be a fool not to keep your code in accordance with them.

The great thing about this plugin is that not only does it flag code that does not conform to the standards you configure, but in doing so it actually teaches you the standards! After the umpteenth time fixing a bracket location, I just developed the habit to do it the right way the first time. And that is what we want, good quality to be a habit.

![PHP CodeSniffer](/images/post-content/phpcs.png)

This plugin leverages a few external libraries you will have to install and configure. Specifically [PHP CodeSniffer](http://pear.php.net/package/PHP_CodeSniffer/redirected), [PHP CodeSniffer Fixer](https://github.com/fabpot/PHP-CS-Fixer), and [PHP Mess Detector](http://phpmd.org/).

I have mine configured for PSR-2 standards and to check both standards and for "messes" and try to fix things on every save.

Learn about [Phpcs here](http://soulbroken.co.uk/code/sublimephpcs).
##3. SublimeLinter
This plugin does a little bit better at preventing syntax errors versus the Phpcs plugin (which I still love) above. The key here is it can be run in background mode, so that as soon as you do something boneheaded, you will know about it. No save required.

![Sublime Linter](/images/post-content/linter.png)

As an added benefit it also does this for nearly all popular programing languages. It is quite configurable but I was more than happy with the stock settings.

Learn more about [SublimeLinter here](https://github.com/SublimeLinter/SublimeLinter).
##4. DocBlockr
In addition to adhering to coding standards, a responsible programer should document their code to a basic level. We don't need novels here, but there are certainly things that can aid other developers and assist with automated documentation generation. PHP has a [great documentor library](http://www.phpdoc.org/) with lots of standard Java Doc style annotations.

I used to avoid documentation because of the tedium and I didn't see the point; after all, if I named my methods well, why document them?

Thankfully there was hope for my poor, wretched soul and I was saved. Automated documentation generation and serving your fellow developer are great reasons to document your functions and classes. If you aren't documenting your code, some day, some other developer is going to say: "I wish this asshole would have documented that." You don't want that do you?

DocBlocker comes to the rescue with some automated documentation macros you might be familiar with if you have experience with a larger IDE like Eclipse. Now there is no excuse!

![Not the best naming of things here…](/images/post-content/docblokr.png)

The above shows the default output after a simple `/**` invocation, now all I need to do is fill in the blanks.

Get your read on about [DocBlocker here](https://github.com/spadgos/sublime-jsdocs).
##5. PHPUnit Completions
As a good PHP Craftsman you are certainly testing your code, and more than likely driving your development with tests first. This plugin adds a slew of nice snippets to help with assertions and other PHPUnit source completion.

This is important because it's hard to remember all the assertions, and you should not always be using `assertTrue()` when there are more descriptive assertions available. Don't take my word for it, [Sebastian Bergmann](http://sebastian-bergmann.de/) said as much to us at the last ZendCon.

Enjoy more info about [PHPUnit Completions here](https://github.com/tkowalewski/phpunit-sublime-completions).
##6. PHPUnit
This plugin is handy if you like to run your unit tests from within Sublime itself versus having to switch back and fourth to the command prompt. I'm still undecided on what I like best, which is why this is so low on the list.

What *IS* cool about this plugin is that it provides a fast way to just run one test, or one class of tests. Usually I am constantly running a whole module's suite of tests in the terminal, this plugin saves me from having to type out the whole terminal command just for a single test.

![PHPUnit Sublime Plugin](/images/post-content/phpunit.png)

Learn about the [PHPUnit plugin here](https://github.com/stuartherbert/sublime-phpunit).
##7. Gist
This one is pretty bad ass. With Gist you can highlight and create GitHub Gists directly from inside sublime. And you can update them, and retrieve them!

Need to send a buddy a that bit of configuration? Well just clip a Gist and shoot it over to him.

Need to pull in that awesome test structure you wrote? Just browse your Gists from Sublime and open it up. Very cool.

![I want to make a Gist out of this function and the preceding bracket!](/images/post-content/gist.png)

**The way I like to use this plugin ** is to create Gists from custom Sublime Text 2 snippet files. This way I can quickly version control and share things like my PHP file head block. All you need to do is:

1. Create the new snippet, save.
2. Use the Gist Plugin to create a Gist from your snippet.
3. Now it's on your GitHub!

Remember though that there is no connection with your local copy of the snippet and the Gist, so should you need to update, make sure to carry over the changes to your local copy of vise versa.

For more than just a "gist" check [here](https://github.com/condemil/Gist).
##8. Goto Documentation
With Goto Documentation you ***literally*** can goto the documentation! Amazing isn't it? I have my set up configured so that when my curser is over a PHP function and I hit the "F1" key, the PHP docs are launched in a browser and that function is detailed in all it's glory.

Basically this is faster than the shift-to-browser-select-url-search-in-google method. You can, of course, configure the hot key to be whatever you like.

Goto the documentation [here](https://github.com/kemayo/sublime-text-2-goto-documentation).

##9. Theme - Phoenix
If Sublime Text 2 is a highly tuned race car, then this plugin is the flashy body work (that also provides down force.) This theme does some minor UI tweaks to the standard Sublime Text layout and lets you configure some things like the tab width. The best feature would be having the folder tree, look, well, like a folder tree. Those little triangles were getting on my nerves!

![Just like a file cabinet.](/images/post-content/phoenix.png)

Details on the [Phoenix Theme](http://netatoo.github.com/phoenix-theme/).

##10. PHP Namespace Command
Last but not least is the "Namespace Command", a cool little utility that quickly inserts the PHP namespace of the file you are developing. It saves a little typing by traversing up the file system till it hits a "src" or "tests" directory, then constructs the namespace and inserts it.

Get the low down on the [Namespace Command here](http://alexandre-salome.fr/blog/SublimeText-2-Insert-PHP-namespaces).

##Keep Crafting!

I hope some of these tools will help improve your code quality and your development workflow. If there are other interesting ones you have tried, please let me know!

For more information on my sublime set up, including the specific configurations of some of these plugins, check out the source controlled settings in my [dotfiles](https://github.com/jasonrobertfox/dotfiles) repository.


