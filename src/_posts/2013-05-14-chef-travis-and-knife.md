---
layout: post
title: "Chef CI with Travis and Knife Configuration"
date: 2013-05-14 19:43
category: devops
project: chef broiler plate
tags: [opscode chef, chef broiler plate, knife, travis, ci, continuous integration]
---
*This is the third installment of a [series on the development of Chef Broiler Plate]({{ site.url }}/project/chef-broiler-plate) in which we go over setting up a robust, TDD framework for Chef cookbook development.*

In the [last post]({{ site.url }}/setting-up-a-chef-build-system/) we set up a build system using Rake that would let us automate some common tasks. Now we will hook up the beginnings of our continuous integration system: [Travis](https://travis-ci.org/). There is not much to our CI set up at this point, but we are doing it now so as we add things in the future we are constantly testing our commits. Finally, we will dig into the configuration of the Knife tool, used to create and manage cookbooks, setting it up in a flexible and portable way.

To begin, if you have created a repository for the code as part of this series, then go to Travis and create a link between the repository and travis.

##Configuring Travis
Create a new `.travis.yml` file in the root of the project directory with this content:

```ruby
language: ruby
bundler_args: --without development
script: "bundle exec rake build"
rvm:
  - 1.9.3
gemfile:
  - Gemfile
branches:
  only:
    - master
    - develop
```

This tests on the CI server and excludes development gem dependencies to speed things up, it also tests just the master and development branches.

##Update your Gemfile
To ensure that any future development related Gems are correctly excluded, add this to your `Gemfile`:

```ruby
group :development do
end
```

##Update your README.md
Finally, I added the Travis notifications to my `README.md` to indicate the status of the build, for example:

```
Master branch: [![Build Status](https://travis-ci.org/jrobertfox/chef-broiler-platter.png?branch=master)](https://travis-ci.org/jrobertfox/chef-broiler-platter)

Develop branch: [![Build Status](https://travis-ci.org/jrobertfox/chef-broiler-platter.png?branch=develop)](https://travis-ci.org/jrobertfox/chef-broiler-platter)
```

That's it! If you have followed thus far, and even though we aren't testing much yet (or perhaps because we aren't
) when you commit this and push it up, you should shortly see that the build has intact passed!

[This article](http://technology.customink.com/blog/2012/06/04/mvt-foodcritic-and-travis-ci/) buy Nathen Harvey was very helpful in pointing me in the right direction regarding the Travis stuff. Thanks!

##Playing with Knives
The goal here is to configure Knife so that it is universally applicable and can serve as a set of configuration settings for the whole project. Most of the settings will be fetched from data bags once we set up the Chef server, but certain required elements will be captured here.


##Creating your Knife Configuration

Create a `.chef` configuration directory, and `knife.rb` file

    mkdir .chef
    touch .chef/knife.rb

Update `Gemfile` development dependencies to include Chef:

```ruby
group :development do
  gem 'chef', '11.4.4'
end
```

##Determining your Variable Dependencies

There are a few settings that will have to be configured on a per user basis, additionally some of the validation keys will need to be found in a sane location. We will define these in an `environment.sh` file which could be merged into a `.bash_profile` type file. We will also update the `rake check` task to verify that these variables exist. This will serve as a basic "test driven" approach to getting the required variables setup.

I created an `environments.sh` file to hold all the settings as they should be exported:

```bash
export OPSCODE_USER="jrobertfox"
export OPSCODE_ORGNAME="nsb"
export KNIFE_CLIENT_KEY_FOLDER="$HOME/.chef"
export KNIFE_VALIDATION_KEY_FOLDER="$HOME/.chef"
export KNIFE_CHEF_SERVER="https://api.opscode.com/organizations/$OPSCODE_ORGNAME"
export KNIFE_CACHE_PATH="$HOME/.chef/checksums"
export KNIFE_COOKBOOK_COPYRIGHT="Never Stop Building"
export KNIFE_COOKBOOK_LICENSE="none"
export KNIFE_COOKBOOK_EMAIL="jasonrobertfox@gmail.com"
```

Then updated the rake task `check` to loop through a list of the environment variables and report on if they are set or not. (Be sure to check out my [Rakefile](https://github.com/jasonrobertfox/chef-broiler-plate/blob/develop/Rakefile) to see how I'm checking these dependencies.)

##Verify your Keys
We need to make sure the Chef security key files are installed in the right place. Again, I updated the rake `check` task to loop through a list of files and ensure they exist; In this situation I'm defaulting to put my client and validator`.pem` in the same folder, something like:

    /Users/jfox/.chef/

This has been calculated based on the environment variables, which will become important once we configure the `knife.rb` file.

Ensure that the keys you downloaded as part of setting up your Opscode account are in the correct place you specified.

##Setup your Knife Configurations
Configure the `knife.rb` file to use your environment variables. Later the Vagrant file will have dependencies on these environment variables as well. This will allow hard coding of certain variables (perhaps company name) in forks of the project for a specific application.

```ruby
# Configurable Variables (Change these to not depend on environment variables!)
my_orgname              = ENV['OPSCODE_ORGNAME']
my_chef_server_url      = ENV['KNIFE_CHEF_SERVER']
my_cookbook_copyright   = ENV['KNIFE_COOKBOOK_COPYRIGHT']
my_cookbook_license     = ENV['KNIFE_COOKBOOK_LICENSE']
my_cookbook_email       = ENV['KNIFE_CACHE_PATH']


# Configuration
current_dir             = File.dirname(__FILE__)
node_name               ENV['OPSCODE_USER']
client_key              "#{ENV['KNIFE_CLIENT_KEY_FOLDER']}/#{ENV['OPSCODE_USER']}.pem"
validation_client_name  "#{my_orgname}-validator"
validation_key          "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{my_orgname}-validator.pem"
chef_server_url         my_chef_server_url

# Caching
cache_type              'BasicFile'
cache_options( :path => ENV['KNIFE_CACHE_PATH'] )

# Logging
log_level               :info
log_location            STDOUT

# Cookbooks
cookbook_path           ["#{current_dir}/../cookbooks"]
cookbook_copyright      my_cookbook_copyright
cookbook_license        my_cookbook_license
cookbook_email          my_cookbook_email
```

Now if you have actually set up your environment variables, you should be able to run `knife client list` to get a list of your clients from your Chef server. If nothing else you would have a "validator" client, which would tell you this is all working.

Setting up your Knife configuration like this allows your Chef project to be much more portable. As long as contributing developers have their environment variables set up locally, they can seamlessly access the project.

##Coming up…
In the next post we will set up our local virtual machine with Vagrant and have a live server on our hands!


