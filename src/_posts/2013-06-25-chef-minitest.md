---
layout: post
title: "Verify your Chef Infrastructure with Minitest"
comments: true
date: 2013-06-25 12:12
categories: ['chef', 'chef broiler plate', 'devops']
twitter: [opschef, devops, chefsurvivalguide, minitest]
---

*This is the tenth and final post in a [series on the development of Chef Broiler Plate]({{ site.url }}/blog/categories/chef-broiler-plate/) in which we go over setting up a robust, ted framework for Chef cookbook development.*

The last adventure on this journey will be to set up the mini test suite to verify our cookbooks on a real server, not just the specs in a vacuum. We will do this with minitest by way of the mini test handler that we set up in our [last post]({{ site.url }}/berkshelf/) by using the Berkshelf cookbook manager.

##Put your Files Somewhere!
The files need to be in the right place so let's add the defaults to our existing cookbook:

    mkdir -p cookbooks/motd/files/default/tests/minitest
    touch cookbooks/motd/files/default/tests/minitest/default_test.rb

In order to prevent ever having to do this heinous act again, let's modify the `new_cookbook` rake task to make this part of the cookbook buildout:

```ruby
desc "Creates a new cookbook."
task :new_cookbook, :name do |t, args|
  sh "bundle exec knife cookbook create #{args.name}"
  sh "bundle exec knife cookbook create_specs #{args.name}"
  minitest_path = "cookbooks/#{args.name}/files/default/tests/minitest"
  mkdir_p minitest_path
  File.open("#{minitest_path}/default_test.rb", 'w') do |test|
    test.puts "require 'minitest/spec'"
    test.puts "describe_recipe '#{args.name}::default' do"
    test.puts "end"
  end
end
```

This now creates a basic minitest that can be modified to your hearts content.

##Building the Test
Our test is pretty simple for this cook book, I just want to assert that the file was created:

```ruby
require 'minitest/spec'
describe_recipe 'motd::default' do
    it 'creates motd.tail' do
        file('/etc/motd.tail').must_exist
    end
end
```


##Deploying the Cookbook and Testing
I bump the version of my cookbook and provision the server. Turns out it works like a charm.

    recipe::motd::default#test_0001_creates_motd_tail =
    0.00 s =
    .



    Finished tests in 0.007227s, 276.7214 tests/s, 138.3607 assertions/s.


    2 tests, 1 assertions, 0 failures, 0 errors, 0 skips

Not only do these act as integration tests, ensuring you have built cookbooks that really work when used on the servers, but they also act as a safety net as they are run whenever the server is provisioned. If for any reason some other cookbook conflicts or an error occurs, you will know about it.

##Conclusion
I hope that those who followed this series have learned a bunch on how to build cookbooks in a true, test-driven way. I encourage you to check out the [Chef Broiler Plate](https://github.com/jasonrobertfox/chef-broiler-plate) repository, and also the book: [The Chef Survival Guide](https://leanpub.com/chef-survival-guide). I'll summarize the ways to test Chef Cookbooks in a future post. Best of luck with your automated infrastructure adventures.



