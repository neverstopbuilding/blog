---
layout: post
title: "Set Up Zend Framework 2 with Behat and Twig"
date: 2012-10-04 15:26
category: test driven development
tags:  [zend framework 2, behat, twig, tdd, bdd, behavior driven development]
---

I'll be documenting some interesting set up of a robust ZendFramework 2 based web application, integrating some cool helper libraries and discussing best practices!

##Installing the Skeleton App

To start with you would want to clone [this skeleton app repository](https://github.com/zendframework/ZendSkeletonApplication) and then make modifications as you see fit.

I updated the `composer.json` file to have my own settings and also changed the framework version explicitly to `2.0.2`:

    "zendframework/zendframework": "2.0.2"

Remove the `composer.phar` file assuming you already have it installed (you should.)

Then create the 'ol virtual host file:

    <VirtualHost *:80>
        DocumentRoot "/Users/jason/Development/test-app/public"
        ServerName dev.test-app.domain.com

        SetEnv APPLICATION_ENV development

       <Directory "/Users/jason/Development/test-app/public">
           DirectoryIndex index.php index.html
           Options Indexes MultiViews FollowSymLinks
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
    </VirtualHost>


And added a record to my `/etc/hosts` file:

    127.0.0.1 dev.lighthouse-trotter.naviance.com

And OMG it works!

##Installing Behat
Now how the hell am I supposed to mess around with this sample app without first having some TESTS!

Let's start by installing the mega pimp behavior driven framework: [behat.](http://behat.org/)

You'll want to add this section to your `composer.json`:

    "config":{
        "bin-dir":"bin/"
    }

and also these to the require block:

    "behat/behat": "2.4.*@stable",
    "behat/mink": "1.4@stable",
    "behat/mink-extension": "*",
    "behat/mink-goutte-driver":"1.0.3",

I like to put my behat tests in a `tests/functional` directory and also have the config in some sensible place so do this:

    mkdir -pv tests/functional/config
    cd tests/functional
    ../../bin/behat --init

And that will initialize your behat features and bootstrap file, now if you run:

    bin/behat tests/functional/

It should indicate that you have no scenarios… so lets create one to verify that we are testing the default view of this skeleton app. First we need to create a basic configuration file in the `tests/functional/config/` folder called `behat.yml`:

    # behat.yml
    default:
      paths:
        features: '%behat.paths.base%/../features'
        bootstrap:  '%behat.paths.features%/bootstrap'
      extensions:
        Behat\MinkExtension\Extension:
          base_url: http://dev.test-app.domain.com
          goutte: ~
      context:
        parameters:
          browser: firefox

And then we can add this basic feature description to the `tests/functional/features/` folder and call it something like `skeleton.feature`:

    Feature: ZendFramework 2 Default Page
        In order ensure my sample app works
        As a developer
        I need to access the default landing page

        Scenario: Accessing the landing page
            Given I am on homepage
            Then I should see "Welcome to Zend Framework 2"
            And I should see "Congratulations! You have successfully installed the ZF2 Skeleton Application. You are currently running Zend Framework version 2.0.2. This skeleton can serve as a simple starting point for you to begin building your application on ZF2."

Finally you must modify your `FeatureContext.php` file, adding an additional required class:

    use Behat\MinkExtension\Context\MinkContext;

And change the context so that it extends `MinkContext`:

    class FeatureContext extends MinkContext

Now when you run this:

    bin/behat --config=tests/functional/config/behat.yml

you should notice that all your basic tests have passed!

Later we can add this directive to a build script to make things quite fast.

##Installing Twig
Now we all know [twig](http://twig.sensiolabs.org/) is the bomb, especially when it can integration with ZendFramework 2 as [this article](http://www.zendexperts.com/2012/04/08/twig-in-zend-framework-2/) indicates.

Here is the package we will be using to integrate the two: [https://github.com/ZF-Commons/ZfcTwig](https://github.com/ZF-Commons/ZfcTwig). It even has example template files for the skeleton application. Which means we can use the test we just created to verify correct installation. Neat!

Add this to your `composer.json` file:

    "zf-commons/zfc-twig": "dev-master"

and update.

Following the instructions from ZfcTwig: Add `ZfcTwig` to your `config/application.config.php` file under the `module`s key. Mine looks like this:

    'modules' => array(
        'Application',
        'ZfcTwig'
    ),

Testing at this point revealed that I had a permissions issue and had to make the daemon owner of the `cache` folder:

    sudo chown daemon data/cache/

At this point you can use the files that are in the `vendor/zf-commons/zfc-twig/examples/` to replace the same ones in your skeleton app. But if you run your tests at this point you will get all sorts of horrible errors, the last thing wee need to do is update the `module/Application/config/module.config.php` to point to the new twig files. Mine looks something like this in the relevant section:

    'layout/layout'           => __DIR__ . '/../view/layout/layout.twig',
    'application/index/index' => __DIR__ . '/../view/application/index/index.twig',
    'error/404'               => __DIR__ . '/../view/error/404.twig',
    'error/index'             => __DIR__ . '/../view/error/index.twig',

I also noticed that the files in the twig library are a little out of date and my tests were failing. I pulled out the "version" call from the template, back into the controller:

    return array('version'=> \Zend\Version\Version::VERSION);

and then referenced it inside the template:

    …Zend Framework version {{ version }}. This skeleton ca…

At this point the original tests should pass indicating we have successfully integrated twig with ZendFramework!

##Up Next!

The plan is to integrate the [assetic](https://github.com/kriswallsmith/assetic) asset management library using this [nifty integration](https://github.com/widmogrod/zf2-assetic-module). I expect some challenges getting it to play nice with twig, but we shall see!
