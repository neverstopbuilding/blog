---
layout: post
title: "Chef Dependency Management with Berkshelf"
date: 2013-06-18 10:31
category: devops
tags: [opscode chef, chef broiler plate, berkshelf, dependency management, cookbooks, minitest]
---

*This is the ninth installment of a [series on the development of Chef Broiler Plate]({{ site.url }}/blog/categories/chef-broiler-plate/) in which we discuss setting up a robust, ted framework for Chef cookbook development.*

[Recently]({{ site.url }}/spork/) we discussed using spark to manage the workflow, versioning, and environments while developing cookbooks. In this article we will integrate the "[Berkshelf](http://berkshelf.com/)" utility. Berkshelf is basically a package manager for community cookbooks. We can leverage some of the great work of the Chef community by adding in cookbooks that already solve our problems. Specifically, we are going to add the [mini test handler](https://github.com/btm/minitest-handler-cookbook) community cookbook to our project for verification and testing purposes of the real provisioned server.

What we aren't going to do is download the cookbook and plop it all willy-nilly in this repository. That is where Berkshelf comes in!

##Update your Gemfile
Update the Gemfile and dependencies; this is also in the development block because the CI will not need it:

```ruby
group :development do
  gem "knife-spork", "1.0.17"
  gem "berkshelf", "2.0.3"
end
```

##Configure your Cookbook Dependencies
Create a new file `Berksfile` in the root of the project with the following content:

    site :opscode

    cookbook 'minitest-handler', '0.1.7'

This is like your gem file for cookbooks.

##Install the Community Cookbooks
Now we want to install the cookbook dependency:

    bundle exec berks install

Before uploading our community cookbooks to the chef server, we need to override one of the default configurations by creating a `config/berks-config.json` file with the following content:

```json
{
  "ssl": {
    "verify": false
  }
}
```

When we upload the community cookbooks, Berkshelf will pull the settings from our `knife.rb` file and then the `berks-config.json` file. We could run this command to do so:

    bundle exec berks upload -c config/berks-config.json

But it makes sense to wrap this in a rake task for usability:

```ruby
desc "Uploads Berkshelf cookbooks to our chef server"
task :berks_upload do
  sh "bundle exec berks upload -c config/berks-config.json"
end
```

##Update the Vagrant File Run List
Finally we modify the run list for in our Vagrant file to support the mini test handler:

```ruby
...
chef.run_list = [
    'motd',
    'minitest-handler'
]
...
```

Running a `vagrant provision` will now execute our motd cookbook, and then run a blank minitest suite against it.

##Coming up…
Next time we will conclude our series by setting up final verification tests with a post on "Minitest" and making it part of our workflow process.


