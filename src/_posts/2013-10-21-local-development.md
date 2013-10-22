---
layout: post
title: "A Local Development Environment Worth Having"
date: 2013-10-21 13:28
comments: true
categories: [productivity, devops]
twitter: [localdevelopment, devops, baseline]
---

*Thanks goes out to [Dave Haeffner](https://twitter.com/TourDeDave) for contributing this post. He runs the top-notch consulting outfit, [Arrgyle](http://arrgyle.com/), and is quite active in the Selenium community. Be sure to check him out!*

---

So I bought a new MacBook Air recently and thought it would be a good time to revamp my local development environment. Perhaps something more resilient and cutting edge that leveraged automated provisioning tools like Puppet or Chef.

After a recommendation to use an open source provisioning framework (thanks for the recommendation [Corey Haines!](https://twitter.com/coreyhaines)) I was able to get up and running quickly. I had a little bit of a time sink in getting everything customized just so, but even that was pretty minimal. And now it is repeatable!

Here's a breakdown of what I ended up with:

##Part 1 - Basic Setup
My new philosophy for this machine was to not install any development dependencies locally. But rather, to use Vagrant and install everything on an image that it controlled -- ideally through automated provisioning.

To do this, I ended up leveraging a simple open source framework called [baseline](https://github.com/bltavares/baseline) that leveraged Vagrant and controlled it with Puppet. It made things really simple since it came pre-loaded with all of the manifests needed to install a programming language -- in my case, Ruby. You can see a full list of supported programming language setups [here](https://github.com/bltavares/vagrant-baseline#current-environments).

Here are the initial steps I took to get up and running:

+ Installed [Vagrant](http://docs.vagrantup.com/v2/installation/index.html)
+ Installed [git](http://git-scm.com/downloads)
+ Cloned the baseline repo locally and added it to my path -- as shown [here](https://github.com/bltavares/baseline#installation).
+ Initialized the image with `baseline init`
+ Launched the image with `baseline up ruby193`
+ Connected to the image through SSH with `baseline ssh`

##Part 2 - Configuration

After I had the initial machine up and running I realized that I didn't have any of my custom dotfiles (e.g. .vimrc, .irbrc, .bashrc, etc) that made the machine mine and helped me be productive. But fortunately, baseline makes including these into the machine setup process pretty simple.

You just need to put your dotfiles into a GitHub repo (along with a shell script that will move these files into the correct place for you) and then tell baseline where this repo is and reload the baseline machine, stating the dotfiles as an environment option. You can see my dotfiles repo [here](https://github.com/tourdedave/dot-files). And an example of my install shell script [here](https://github.com/tourdedave/dot-files/blob/master/install.sh).

Here are the example commands needed:

```
baseline down # if your machine is running
baseline dotfiles https://github.com/tourdedave/dot-files
baseline up dots ruby193
baseline ssh
```

##Part 3 - Adding a New Programming Language

I was working on a project that required the use of Python in addition to Ruby. Rather than spin up a new box in tandem (which baseline supports) I was able to quickly provision my Ruby environment to also have Python installed on it through the use of baseline's provision functionality.

```
provision python # while SSH'd into the machine
```

##Part 4 - Forwarding X

Since I'm building web properties and testing web applications with Selenium I would prefer to have access to a browser on the development machine. This makes things easier than dealing with forwarded ports and again baseline comes to the rescue. With it forwarding an X session over SSH was pretty straightforward. The only tricky part was getting my Mac to actually receive and render the session.

In order to do that I had to:

+ Install [XQuartz](http://xquartz.macosforge.org/landing/)
+ SSH with some additional paramters -- `baseline ssh -- -X`
+ Install Firefox if it's not present -- `sudo apt-get install firefox`
+ Launch Firefox in a background process -- `firefox &`

This will launch a Firefox browser window in an X window within OSX.

Here's a screenshot:

![Firefox in an X Window in OSX](/images/post-content/local-dev-shot.png)

##Part 5 - Leftovers

Anything that wasn't installed I was able to get through the use of Unbuntu's `apt` command (e.g. `apt-search`, `apt-get install`, etc).

The default memory allocation seemed fast enough but I increased it just to be safe (and since I have more room to breath with this new crazy fast machine). I ended up doing this by editing the Vagrantfile by hand in my .baseline directory to include the following:

```
Vagrant.configure("2") do |config| # this line should already be present
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
```

##Closing Thoughts

Now that I've been using this setup for some time now, I am really glad to have made the switch. It just makes things so much easier and if something goes kablooey I feel confident that it will be simple and quick to recover.
