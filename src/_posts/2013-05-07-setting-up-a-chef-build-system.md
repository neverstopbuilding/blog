---
layout: post
title: "Setting up a Chef Build System with Rake"
date: 2013-05-07 10:04
comments: true
categories: ['chef', 'chef broiler plate', 'devops']
twitter: [chef, devops, chefsurvivalguide, rake]
---
*This is the second in a [series on the development of Chef Broiler Plate](http://neverstopbuilding.net/blog/categories/chef-broiler-plate/) in which we go over setting up a robust, TDD framework for Chef cookbook development.*

A mentor of mine once said:

> Always start with the build system.

Having already set up or project in the [last post](http://localhost:4000/chef-best-practices-a-series/) we are ready to do exactly that. The build system is important as it allows us to collect commonly executed tasks which will save us time. Right now we are just fleshing out the task placeholders, in future posts we will implement these and add new ones. These are the steps I took.

##Set Ruby Version
Create a `.rvmrc` and `.rbenv-version` files to set the ruby version for the project.

##Create a Gemfile
Make a Gemfile to set the project dependencies:

{% codeblock lang:ruby %}
source "http://rubygems.org"

ruby '1.9.3'

gem 'rake', '10.0.4'
{% endcodeblock %}

##Install the Dependencies

    bundle install

##Create Rakefile
Create a new `Rakefile` with place holder task per those that we outlined in our Readme file:

{% codeblock lang:ruby %}
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
{% endcodeblock %}

Great! Now we have the beginnings of a build system for the project.
#Coming up…
In the next post we will flesh out the build system with a task that checks for dependencies and implement our Knife configuration.

{% c2a icon:"K" title:"Hungry for more? Get the Book!" action:"Check it out!" link:"https://leanpub.com/Chef-survival-guide?utm_source=nsb&utm_medium=blog&utm_campaign=Setting+up+a+Chef+Build+System+with+Rake" label:"Chef Survival Guide" %}
This and future posts related to the build out of Chef Broiler Plate are being consolidated in "The Chef Survival Guide." The book will include more detail and examples.
{% endc2a %}
