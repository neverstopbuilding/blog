---
layout: post
title: "Composer with Behat: Initial Setup"
date: 2012-06-21 15:42
category: test driven development
tags:  [behat, behavior driven development, bdd, tdd, composer, php]
---

As you might have noticed, I have been getting really into [Composer](http://getcomposer.org/) for php dependency management. This post details the set up for automated [BDD](http://en.wikipedia.org/wiki/Behavior_Driven_Development) testing using [Behat](http://behat.org/).

To start add these guys to your `composer.json` file:

    {
      "require":{
        "behat/behat":"*",
        "behat/mink":"*",
        "behat/mink-extension":"*",
        "behat/mink-sahi-driver": "*",
        "behat/mink-goutte-driver":"*"
      },
      "config":{
        "bin-dir":"bin/"
      }
    }

Now update or install the libraries:

    composer install

This will install all the dependencies, creating a `vendor` directory and provide a local instance for running behat: `bin/behat` If you run that at this point you should get something like this:

> RuntimeException
> Context class not found.

###Customizing the Setup

Now we should set up the rest of the application to be in a position to write tests (first, of course) and build out the application. I start off with utilities for configuring and setting up the application.

Build a folder structure:

    mkdir -pv application/config
    build-deploy/config-templates

Create the necessary files:

    touch build-deploy/config-templates/behat.yml

And add this basic configuration:

    # behat.yml
    default:
      paths:
        features: '%behat.paths.base%/../../features'
        bootstrap:  '%behat.paths.features%/bootstrap'
      extensions:
        Behat\MinkExtension\Extension:
          base_url: '<YOUR_LOCALHOST_URL>'
          goutte: ~

Obviously replacing the `base_url` with that of your local host url, assuming this is local development.

Now run `bin/behat --init` to create the feature folders that you can use to build your BDD tests. At this point running the standard command `bin/behat` should yield something like the following:

> No scenarios
> No steps
> 0m0.002s

I prefer to use Ant to script common processes in the application, so you can follow suit and do the same, create a `build.xml` file in your `build-deploy` directory with these contents:

    <?xml version="1.0" encoding="UTF-8"?>
    <project name="Build" default="help" basedir="../">
        <target name="help" description="Display detailed usage information">
            <echo>Type "ant -p" to see a list of targets</echo>
        </target>
        <target name="behat" description="Runs BDD tests with Behat">
            <exec dir="${basedir}" executable="bin/behat" failonerror="true">
                <arg value="--config" />
                <arg value="${basedir}/application/config/behat.yml" />
            </exec>
        </target>
        <target name="configure" description="Configure application.">
            <copy file="${basedir}/build-deploy/config-templates/behat.yml" tofile="${basedir}/application/config/behat.yml" overwrite="true" />
        </target>
    </project>

This should be it! From the `build-deploy` directory run:

    ant configure behat

Which will run the configuration script and put your `behat.yml` file in the right place, and then run the behat test suite using your configuration file. In the future just use:

    ant behat

GO and have fun building your `.feature` files and a nice BDD driven application!
