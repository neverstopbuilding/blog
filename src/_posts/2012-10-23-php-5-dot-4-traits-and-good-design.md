---
layout: post
title: "PHP 5.4 Traits and Good Design"
date: 2012-10-23 15:21
comments: true
categories: [php, design patterns]
---

As a follow up to [my first](http://jasonrobertfox.com/post/34175643593/zendcon-2012-cool-little-features-of-php-5-4) post on the small improvements in php 5.4, this article will go deeper into one of the cooler features of the release: [traits](http://us3.php.net/traits). Much of this was inspired by a great talk I went to at [ZendCon](http://zendcon.com/) by [Ilia Alshanetsky](https://twitter.com/iliaa).

##What is a Trait?
A trait is PHP 5.4's solution to the lack of multiple inheritance in the language and a way to avoid hierarchical inheritance chains. Another way to think of it is that including traits in your classes is a clean way to keep your code dry without breaking good design principles.

An even more simple way to think about it is:

> Hey, all that boiler plate code that you copied and pasted everywhere but now you want to change something? well replace it with a trait and call it a day.

##An Example for Discussion
Let's use for the purposes of discussion two domain classes that are relatively simple, a `Person` and a `Car`:

    class Person{
        private $id;
        private $name;

        public getId(){
            return $this->id;
        }

        public getName(){
            return $this->name;
        }
    }

    class Car{
        private $id;
        private $model;

        public getId(){
            return $this->id;
        }

        public getModel(){
            return $this->model;
        }
    }

In this case both of these are entities so both have an `id` property. Although this code is a little damp because of the repetition.

##Doing it Wrong
In order to hasten development of a lot of entities, or keep the code dry some bozo might implement this (and I have been this bozo at times.):

    class Entity{
        protected $id;

        public getId(){
            return $this->id;
        }
    }

    class Person extends Entity{
        private $name;

        public getName(){
            return $this->name;
        }
    }

    class Car extends Entity{
        private $model;

        public getModel(){
            return $this->model;
        }
    }

Why is this wrong? Well for one thing these child classes could very well violate the [Liskov substitution principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle) should the `getId()` method be overridden. Also suddenly to begin a trend of coupling you domain model in some monolithic class hierarchy that may not reflect the true nature of your problem space. It really is a misuse of inheritance for the purposes of dry code.

##Traits to the Rescue!
The reason I am so amped about traits is that it will be a good way to answer the constant wining I hear about the verbosity of a well constructed domain model.

> "There is too much code!", "Why do we need so many objects?"

Cram it. You are going to have repeated code as you refactor toward a highly decoupled design. Yeah, your `User` domain object and `UserDto` will both have a `getEmail` method. Sorry deal with it.

But now, like pacifiers, we have traits to keep the whining at bay and prevent the incorrect use of monolithic inheritance! So this is how it should be:

    trait IsEntity{
        protected $id;

        public getId(){
            return $this->id;
        }
    }

    class Person{
        use IsEntity;

        private $name;

        public getName(){
            return $this->name;
        }
    }

    class Car{
        use IsEntity;

        private $model;

        public getModel(){
            return $this->model;
        }
    }

Here I created the trait `IsEntity` and had both of my domain classes "use" it. I have kept the code dry and at the same time kept the objects decoupled. Right now the naming convention "Is…" seems good because the traits are further describing the object with additional functionality.

Another more real world example might be the need to implement a often similar `serializable()` method in your DTO objects. You could simple create a trait for the necessary code, but easily exclude it if a custom implementation is needed.

So the next time you are about to refactor common code out to a parent class, pause, maybe reread your [Eric Evans](http://books.google.com/books/about/Domain_Driven_Design.html?id=hHBf4YxMnWMC), and think if it makes sense to do that or just use a trait.

Thanks a lot for a great presentation [@iliaa](https://twitter.com/iliaa), and see this [phpmaster article](http://phpmaster.com/using-traits-in-php-5-4/) for more discussion of traits!
