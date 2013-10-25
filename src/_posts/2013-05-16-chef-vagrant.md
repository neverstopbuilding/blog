---
layout: post
title: "Configuring Vagrant for Chef"
comments: true
date: 2013-05-16 17:31
categories: ['chef', 'chef broiler plate', 'devops']
twitter: [chef, devops, chefsurvivalguide, vagrant]
---

*This is the fourth installment of a [series on the development of Chef Broiler Plate]({{ site.url }}/blog/categories/chef-broiler-plate/) in which we go over setting up a robust, TDD framework for Chef cookbook development.*

Having prepared our CI system and configured our Knife tool in the [last post]({{ site.url }}/chef-travis-and-knife/) its now time to finish or basic setup procedures by setting up a virtual machine with [Vagrant](http://www.vagrantup.com/). This will give us a local server in which to develop and test our sample cookbook.

##Creating a Vagrant Configuration
First we need to upgrade to the latest version of [vagrant](http://downloads.vagrantup.com/) ([1.2.2](http://downloads.vagrantup.com/tags/v1.2.2) at the time of writing.) This, of course, assumes you have the older version of Vagrant. This 1.1+ version can no longer be installed as a Gem so we must add it to our dependency list, checking for it with our Rake `check` task.

Next run:

    vagrant init

to create the configuration file.

Following along with [this article](https://coderwall.com/p/dt1idw) we will build out our Vagrant file to access the environment variables we specified when we set up Knife. This is necessary because we can no longer access the Chef gem from the Vagrant file due to the recent upgrades to the system. (as the article suggests) As of this writing there are some pull requests in process that could add more interactivity between chef settings and Vagrant. I'm using a [bentobox](https://github.com/opscode/bento) that is configured from Opscode to be ready to roll with Vagrant. Our Vagrant file should look something like this:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.2.0.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.synced_folder "shared", "/shared"

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = ENV['KNIFE_CHEF_SERVER']
    chef.validation_key_path = "#{ENV['KNIFE_VALIDATION_KEY_FOLDER']}/#{ENV['OPSCODE_ORGNAME']}-validator.pem"
    chef.validation_client_name = "#{ENV['OPSCODE_ORGNAME']}-validator"
    chef.node_name = "#{ENV['OPSCODE_USER']}-vagrant"
    chef.run_list = [
    ]
  end
end
```

##Set up the Project Location
The files that will be shared between your virtual machine and local machine should be located in a `shared` folder, this way you can "develop locally."

    mkdir shared
    touch shared/.gitkeep

##Launching the Virtual Box
I added a simple task to start the Vagrant server, `rake start` which really just wraps `vagrant up`.

Running either command will start your server, hook it into your Chef Server account and, well, do nothing right now because our `run_list` is empty.

##Coming up…
Next up we will (finally) start building a sample cookbook and in the process begin outfitting our framework with great TDD tools (like "Chefspec".)


