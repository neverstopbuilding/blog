---
layout: post
title: "Get Array of Arguments with Symfony Console"
date: 2012-12-13 23:13
category: web development
tags:  [symfony, php, symfony console, data transfer object, command line]
---

The [symfony console componentt](https://github.com/symfony/symfony/tree/master/src/Symfony/Component/Console) is a great library for brewing your own cli applications to help you out with development. I'm working on one right now that helps me quickly write well formatted and tested [data transfer objects](http://en.wikipedia.org/wiki/Data_transfer_object). It's called ***DTOx*** and you can check it out [here](https://github.com/jasonrobertfox/DTOx).

If you have looked at the [console documentationn](http://symfony.com/doc/2.0/components/console/introduction.html) it is not immediately apparent how you might pass an arbitrarily long argument list to your command. Why would you want to do that? Well I'd argue if used sparingly it could allow for a cleaner and shorter command. Here is an example that may be familiar to those who know mvc frameworks:

    create model User string:name int:age

The `string:name` and `int:age` are arguments but we would not want to define them for this command, but want to allow for any number of arguments to be parsed. To do so in defining our last argument we must specify the mode constant `IS_ARRAY` as in this code sample:

    //...
    ->addArgument(
        'variables',
        InputArgument::IS_ARRAY,
        'Specify your variables!'
    );

That is all there is to it!
