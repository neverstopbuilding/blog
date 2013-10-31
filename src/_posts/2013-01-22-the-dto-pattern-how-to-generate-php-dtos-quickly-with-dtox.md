---
layout: post
title: "The DTO Pattern: How to Generate PHP DTOs Quickly with DTOx"
date: 2013-01-22 20:15
permalink: /data-transfer-object
category: software engineering
project: dtox
tags:  [dtox, design patterns, dto, data transfer object, php, domain driven design]
---

A DTO or Data Transfer Object can be defined as a lightweight and serializable container for data that lacks any business logic, used primarily for delivering data from a service layer.

##Why do I care?
If you follow patterns of [Domain Driven Design](http://en.wikipedia.org/wiki/Domain-driven_design) (DDD) you will build your application around a well defined Domain layer containing business logic. This whole domain will then be surrounded by a service layer providing a clearly articulated public interface to the domain model.

When I say "public" this could be actually public as in the case of some service API like the one Twitter [exposes](https://dev.twitter.com/docs/api), or as is more often the case, public to the rest of an application. Client developers may leverage the service layer to communicate between the presentation layer and the "back end" of the application.

How this communication is achieved is where the DTO becomes important, providing a simple object, with a consistent pattern to be delivered back from the service layer.

**What's great** about this is that you can completely refactor the underlying application but not concern yourself with effecting the presentation layer, as long as the service layer continues to deliver the correct DTOs.

**Additionally,** by allowing the object to be serialized (to a string, json, or whatever) it can be transmitted in a consistent format or saved to a caching mechanism.

Here is a useful graphic taken from this [rather helpful article](http://msdn.microsoft.com/en-us/magazine/ee236638.aspx) on DTOs:

![DTO used as a go between the presentation and business layer.](http://i.msdn.microsoft.com/ee236638.fig03(en-us).gif)

##This sounds like a lot of code...
I hear this gripe a lot. Especially from the PHP crowd where the lack of types make it less simple to use code generation features of an IDE (like you might do with Java).

The fact is, in order to completely compartmentalize and test your architecture, you need to make DTOs and ideally assemblers (for converting from a domain object to a dto), and builders (for building a dto with default arguments). And until you see the benefits of this approach, it just seems like "a lot of code." (As the DTOx tool develops, I'll add posts on assemblers and builders as well!)

Yes you could just return a domain object from the service layer, but refactoring the domain objects would certainly start to bother those parts of the application that depend on the service layer:

    <?php
    class WidgetDomainObject
    {
        __construct($city, $property){ ... }

        public function getCity(){ ... }

        public function getProperty(){ ... }
    }

The above class seems simple enough and you could pass that back to your controller or presentation layer and display the "city" no problem. But what happens if you refactor it to use a City object?

    <?php
    class WidgetDomainObject
    {
        __construct(CityDomainObject $city, $property){ ... }

        ...
    }

Now you can't just grab the name of the city, so you would have to update the presentation layer, and possibly violate the [law of Demeter](http://en.wikipedia.org/wiki/Law_of_Demeter) in the process. It would be better to simply create processes that consistently translates your domain objects into the correct DTO and remove the dependency of the presentation layer on the architecture of the underlying application.

##DTOx to the rescue!
So perhaps now you think: "Ok, DTOs are useful, but it's still more code to write and test." This is where you can leverage [this little library](https://github.com/jasonrobertfox/DTOx) I put together that will **generate both the DTO and the associated test for you!** All you need to do is install it for your project and supply some command line properties and you are on your way. Let's see how it works:

###1. Install with Composer
Create a composer file:

    {
        "require": {
            "jrobertfox/dtox": "dev-master"
       }
    }

Then run:

    composer install

###2. Create a test for your DTO
Test first right? Run this command to make a test for our new dto:

    vendor/bin/dtox react dto-unit "AppNamespace\WidgetDTO" "Walla Walla:city" red:property

This will do a few things:

- Create a directory `AppNamespace` relative to where you ran the command.
- Create a `WidgetDTOTest.php` file in that directory.
- Create a phpUnit test case for the DTO using the supplied `<test data>:<property name>` convention.

COOL!

###3. Create the actual DTO
Now let's use a very similar command to create the DTO object itself:

    vendor/bin/dtox react dto "AppNamespace\WidgetDTO" string:city string:property

This does the same things as the previous command but this time it creates the DTO object including [phpDoc](http://www.phpdoc.org/) tags and a `serialize` and `unserialize` function. Note that in this invocation the variables are supplied in the form: `<type>:<property name>`

How cool is that?

Now something that could take not an unsubstantial amount of time can be accomplished in seconds! Just watch this screencast to see how fast:

{% vimeo 57983345 %}

##Helping Out

The DTOx project is [open sourced](https://github.com/jasonrobertfox/DTOx) on GitHub. I'd love for people to contribute to it and provide feedback. Now that these things are easier to build, you should have no excuse for not using them to keep your applications flexible at clean!
