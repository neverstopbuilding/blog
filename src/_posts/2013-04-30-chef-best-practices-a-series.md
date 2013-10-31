---
layout: post
title: "Chef Best Practices: Chef Broiler Plate"
date: 2013-04-30 12:24
permalink: /opscode-chef-best-practices
category: devops
project: chef broiler plate
tags: [opscode chef, chef broiler plate, infrastructure management, test driven development, virtual machine]
---
##A Little Background
For those unaware, [Chef](http://www.opscode.com/chef/) is "infrastructure as code." In essence, you specify your software infrastructure (servers, dependencies, configurations) in a declarative fashion and use the Chef software to provision your machines. Here are some possible usage scenarios to give you an idea of what Chef is capable of doing:

> I want to run one command and build a clean development box with my source code for a new developer.

Or:

> I need to spin up 10 production nodes on AWS, deploy my software and swap them to live.

All of this declarative code is built out in "cookbooks", little collections of "recipes" and associated files that provision a system. For example, as we will detail in this series, a recipe might:

> Set a message of the day when anyone ssh'es into the server, showing my company name.

It is with the development and testing of these cookbooks that this and the next few posts will concern themselves.

##Where do I start?
I recently took an excellent class by Chef community manager [Nathen Harvey](http://www.nathenharvey.com/). The class really ironed out a lot of confusion I had over developing cookbooks for Chef and introduced a litany of best practices and community tools. I left pumped up about Chef and ready to attack my infrastructure projects.

However, when I actually sat down to start working on a real Chef infrastructure, I was still asking: "where do I start?" Sure I could build sample cookbooks, and sure I could use some of the tools introduced; but after scouring the internets, I failed to find a consistent end-to-end process that unifies all the tools in one package. Thus I tempered my excitement to start hacking and instead started to build out a methodical, opinionated "framework" that joins all the tools related to Chef in one repository.

**My goal: clone this repo and start building high quality, test driven cookbooks, for any client or project.**

It may not be everyone's cup of tea, but I thought it would be best to take a stand and say "yeah, this is how we should be building out this infrastructure, this will make for the best development experience."

Over the next several blog posts I will detail my journey so that you can follow along and learn about these tools. The project is already available on Github at [Chef Broiler Plate](https://github.com/jasonrobertfox/chef-broiler-plate). I encourage you to fork it, modify it, submit pull requests and call me out if something is strange or not working.

##The "Menu"
Chef is really awesome at keeping the cooking metaphor going, so in that spirit, let's take a look at the menu of topics that I'd like to cover:

- Basic requirements
- Project creation and "readme driven development"
- A sane build system with Rake
- Continuous integration with Travis
- Knife configuration
- Vagrant configuration
- TDD with Chefspec
- Quality with Foodcritic
- Cookbook testing with Knife
- Workflow with Spork
- Dependency management with Berkshelf
- Verification with Minitest

This 12 course tasting menu looks really good. Let's get started!

##Getting Started: Basic Requirements
This and the posts to follow will be written in an instruction/guide style. You should be able to follow along and end up with the same type of framework that is finished here: [Chef Broiler Plate](https://github.com/jasonrobertfox/chef-broiler-plate)

These are the prerequisites for starting the project:

- Installation of [Virtual Box](https://www.virtualbox.org/)
- [Knife CLI Utility](http://docs.opscode.com/install_workstation.html)
- [Ruby](http://www.ruby-lang.org/en/)
- A [free account](https://community.opscode.com/users/new) for Opscode Chef Server
- Creation of your security keys.

##Create a new Project
Everything should be source controlled here. I created a Github [repo](https://github.com/jasonrobertfox/chef-broiler-plate) for all of my code, and you can actually look at the [commit history](https://github.com/jasonrobertfox/chef-broiler-plate/commits/develop) to see every step of development (and mistakes). Do the same for your project:

    git init

##Source Code Management

Run the following command to use [git flow](https://github.com/nvie/gitflow) (if you aren't using git flow, you should be) to manage features:

    git flow init

Select all the default settings.

##Readme Driven Development
Start with the `README.md` file. Why? Because it focuses your mind and causes you to think like a user.

> What am I doing here, how do I want people to use this thing?

At a bare minimum I want to describe how to install and use the most basic version of the package, I'll be using [Rake](http://rake.rubyforge.org/) for a build system so these are the tasks that seem to make sense first off:

- rake check (checks for other dependencies)
- rake build (runs the test suites)
- rake start (a wrapper for vagrant up)

Write a readme file that describes the project dependencies, how to get started on development and usage, and the basic tasks.

##Coming up…
In the next post we will dive into the creation of a basic Rake build system and setting up a basic continuous integration system.




