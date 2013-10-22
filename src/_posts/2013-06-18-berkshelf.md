---
layout: post
title: "Chef Dependency Management with Berkshelf"
comments: true
date: 2013-06-18 10:31
categories: ['chef', 'chef broiler plate', 'devops']
twitter: [opschef, devops, chefsurvivalguide, berkshelf]
---

*This is the ninth installment of a [series on the development of Chef Broiler Plate](http://neverstopbuilding.net/blog/categories/chef-broiler-plate/) in which we discuss setting up a robust, ted framework for Chef cookbook development.*

[Recently](http://neverstopbuilding.net/spork/) we discussed using spark to manage the workflow, versioning, and environments while developing cookbooks. In this article we will integrate the "[Berkshelf](http://berkshelf.com/)" utility. Berkshelf is basically a package manager for community cookbooks. We can leverage some of the great work of the Chef community by adding in cookbooks that already solve our problems. Specifically, we are going to add the [mini test handler](https://github.com/btm/minitest-handler-cookbook) community cookbook to our project for verification and testing purposes of the real provisioned server.

What we aren't going to do is download the cookbook and plop it all willy-nilly in this repository. That is where Berkshelf comes in!

##Update your Gemfile
Update the Gemfile and dependencies; this is also in the development block because the CI will not need it: 

{% codeblock lang:ruby %}
group :development do
  gem "knife-spork", "1.0.17"
  gem "berkshelf", "2.0.3"
end
{% endcodeblock %}

##Configure your Cookbook Dependencies
Create a new file `Berksfile` in the root of the project with the following content:

    site :opscode

    cookbook 'minitest-handler', '0.1.7'

This is like your gem file for cookbooks.

##Install the Community Cookbooks
Now we want to install the cookbook dependency:

    bundle exec berks install

Before uploading our community cookbooks to the chef server, we need to override one of the default configurations by creating a `config/berks-config.json` file with the following content:

{% codeblock lang:json %}
{
  "ssl": {
    "verify": false
  }
}
{% endcodeblock %}

When we upload the community cookbooks, Berkshelf will pull the settings from our `knife.rb` file and then the `berks-config.json` file. We could run this command to do so:

    bundle exec berks upload -c config/berks-config.json

But it makes sense to wrap this in a rake task for usability:

{% codeblock lang:ruby %}
desc "Uploads Berkshelf cookbooks to our chef server"
task :berks_upload do
  sh "bundle exec berks upload -c config/berks-config.json"
end
{% endcodeblock %}

##Update the Vagrant File Run List
Finally we modify the run list for in our Vagrant file to support the mini test handler:

{% codeblock lang:ruby %}
...
chef.run_list = [
    'motd',
    'minitest-handler'
]
...
{% endcodeblock %}

Running a `vagrant provision` will now execute our motd cookbook, and then run a blank minitest suite against it.

#Coming up…
Next time we will conclude our series by setting up final verification tests with a post on "Minitest" and making it part of our workflow process.

{% c2a icon:"K" title:"Hungry for more? Get the Book!" action:"Check it out!" link:"https://leanpub.com/Chef-survival-guide?utm_source=nsb&utm_medium=blog&utm_campaign=Chef+Dependency+Management+with+Berkshelf" label:"Chef Survival Guide" %}
This and future posts related to the build out of Chef Broiler Plate are  consolidated in "The Chef Survival Guide." The book includes more detail and examples.
{% endc2a %}
