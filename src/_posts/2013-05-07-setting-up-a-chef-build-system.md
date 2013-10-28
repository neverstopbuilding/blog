---
layout: post
title: "Setting up a Chef Build System with Rake"
date: 2013-05-07 10:04
category: devops
tags: [opscode chef, chef broiler plate, rake, build system, automation]
---
*This is the second in a [series on the development of Chef Broiler Plate]({{ site.url }}/blog/categories/chef-broiler-plate/) in which we go over setting up a robust, TDD framework for Chef cookbook development.*

A mentor of mine once said:

> Always start with the build system.

Having already set up or project in the [last post](http://localhost:4000/chef-best-practices-a-series/) we are ready to do exactly that. The build system is important as it allows us to collect commonly executed tasks which will save us time. Right now we are just fleshing out the task placeholders, in future posts we will implement these and add new ones. These are the steps I took.

##Set Ruby Version
Create a `.rvmrc` and `.rbenv-version` files to set the ruby version for the project.

##Create a Gemfile
Make a Gemfile to set the project dependencies:

```ruby
source "http://rubygems.org"

ruby '1.9.3'

gem 'rake', '10.0.4'
```

##Install the Dependencies

    bundle install

##Create Rakefile
Create a new `Rakefile` with place holder task per those that we outlined in our Readme file:

```ruby
require "bundler/setup"

task :default => [:list]

desc "Lists all the tasks."
task :list do
  puts "Tasks: \n- #{(Rake::Task.tasks).join("\n- ")}"
end

desc "Checks for required dependencies."
task :check do
  puts "Nothing to do yet..."
end

desc "Builds the package."
task :build do
  puts "Nothing to do yet..."
end

desc "Fires up the Vagrant box."
task :start do
  puts "Nothing to do yet..."
end
```

Great! Now we have the beginnings of a build system for the project.
##Coming up…
In the next post we will flesh out the build system with a task that checks for dependencies and implement our Knife configuration.


