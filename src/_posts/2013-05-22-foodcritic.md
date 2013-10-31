---
layout: post
title: "Chef Cookbook Code Quality with Foodcritic"
date: 2013-05-22 12:34
category: devops
project: chef broiler plate
tags: [opscode chef, chef broiler plate, foodcritic, test driven development, tdd, code quality]
---

*This is the sixth section of a [series on the development of Chef Broiler Plate]({{ site.url }}/project/chef-broiler-plate) in which we go over setting up a robust, TDD framework for Chef cookbook development.*

[Last time]({{ site.url }}/chefspec/) we created a sample "Message of the Day" cookbook in a test driven way. In this short chapter we will add [Foodcritic](http://acrmp.github.io/foodcritic/) to test the code quality of our cookbooks. More subtle than outright functionally tests, Foodcritic will reference some leading best practice rules to ensure your cookbooks are squeaky clean.

##Add the Foodcritic Gem
We'll start by adding a line to our `Gemfile`:

    gem "foodcritic", "2.1.0"

Use `bundle update` to update our gems.

##Creating a Rake Task
Lets add a rake task to execute the Foodcritic against any of our cookbooks:

```ruby
desc "Runs foodcritic against all the cookbooks."
task :foodcritic do
  sh "bundle exec foodcritic -f any cookbooks"
end
```

##Follow the Rules!
I like the idea of adding the Custom Ink and Etsy rule repositories as detailed [here](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/). We should do that by adding some git submodules and updating our 'README.md file (to add clear install instructions):

    git submodule add git://github.com/customink-webops/foodcritic-rules.git test/foodcritic/customink
    git submodule add git://github.com/etsy/foodcritic-rules.git test/foodcritic/etsy

Next update the one command line in the `foodcritic` Rake task to add the delectably stricter rules!

    bundle exec foodcritic -I test/foodcritic/* -f any cookbooks

Lastly, we would need to add a line to our travis file to support the submodules:

    before_install:
      - git submodule update --init --recursive

Now whenever we push code to our repository, Travis will kick off a review of our cookbook quality. Many thanks to the guys over at Custom Ink for writing a [great article](http://technology.customink.com/blog/2012/06/04/mvt-foodcritic-and-travis-ci/) that helped me write this one.

##Coming up…
In the next installment we will use Knife to continue testing our cookbooks and building out the framework.


