---
layout: post
title: "How to Setup Behat with Sahi Testing on OSX"
comments: true
date: 2013-01-16 22:54
categories: [behat, sahi, behavior driven development]
---
Behavior driven development (BDD) really takes the ideas of Test Driven Development (TDD) to the next level. By using popular libraries like [Cucumber](http://cukes.info/) or the PHP focused [Behat](http://behat.org/) you can expand your acceptance criteria into a set of executable acceptance scenarios. Using one of these libraries will let your run your integration tests automatically, which is good for everyone!

This article is about setting up Behat to us the Sahi extension so that you can automate a browser interaction in your tests. This is important because out of the box the Behat / Mink web application test combination can't execute javascript. And of course many a modern web application relies on javascript for key parts of the user interaction; and these need to be tested! Below you will set up a sample project that tests part of this very blog! Cool.

Things you will need:

- PHP 5.3 (of course)
- Composer (install from [here](http://getcomposer.org/doc/00-intro.md))
- A Java Runtime Environment (Check with `java --version`)

##1. Create a test project.

    mkdir behat-sahi
    cd behat-sahi

##2. Install dependencies.
Create a `composer.json` file in the root of your `behat-sahi` directory with these contents:

    {
        "name": "behat-sahi",
        "description": "Behat and Sahi Example",
        "require": {
            "behat/behat": "2.4.*",
            "behat/mink": "1.4@stable",
            "fabpot/goutte": "1.0.x-dev",
            "behat/mink-extension": "dev-master",
            "behat/mink-goutte-driver":"dev-master",
            "behat/mink-sahi-driver": "*"
        },
        "config": {
            "vendor-dir": "vendor/",
            "bin-dir": "bin/"
        }
    }

Then use composer to install the dependencies:

    composer install

You should see a slew of downloading information and then have a `bin` and `vendor` directory in your project, plus a `composer.lock` file. Moving on...

##3. Initialize Behat.

    bin/behat --init

This will create a `features` directory structure.

##4. Set up Sahi
Taking a break from the sample project setup, let's set up the Sahi server. Head on over to [http://sourceforge.net/projects/sahi/files/](http://sourceforge.net/projects/sahi/files/) and download the latest version.

###Installing Sahi
Double click the file to run the installer, which let's you select which location you want to place the files. I put mine in `/usr/local/share/sahi/`

###Important Configuration
You will want to edit the file located at `/usr/local/share/sahi/config/ff_profile_template/pref.js` adding this line to the bottom:

    user_pref("toolkit.startup.max_resumed_crashes", 999999999);

What this does is up the limit of how many times Firefox can crash before it complains and askes you to start it in safe mode. As Narayan explains [here](http://sahi.co.in/forums/discussion/3967/cant-run-multiple-tests-in-firefox-version-13/p1): "Sahi force kills a browser, and Firefox sees it as a crash." This way you will be able to run you Sahi tests with no problems using firefox.

###Starting the Server
Navigate to `/usr/local/share/sahi/userdata/bin` and run this:

    ./start_sahi.sh

And the server should start!

##5. Configure Behat.
First create your configuration file in the root of your sample project:

    touch behat.yml

Now add this information to your `behat.yml` file:

    default:
      paths:
        bootstrap:  '%behat.paths.features%/bootstrap'
      extensions:
        Behat\MinkExtension\Extension:
          base_url: {{ site.url }}
          javascript_session: sahi
          browser_name: firefox
          goutte: ~
          sahi: ~

And finally add this line under the "use" statements in your `features/bootstrap/FeatureContext.php` file:

    use Behat\MinkExtension\Context\MinkContext;

And change that class to extend the `MinkContext` instead:

    class FeatureContext extends MinkContext
    {
        ...
    }

At this point if you run:

    bin/behat

From the root of your sample project you should see:

    No scenarios
    No steps
    0m0.002s

Let's change that!

##6. Create a sample test.
First create a file `features/test-feature.feature` and add this to it:

    Feature: Test Behat with Sahi
        As a developer
        I want to see behat work with sahi
        So I can test my javascript web application, like a pro

    Scenario: Go to my blog and check something static
        Given I am on "/"
        Then I should see "{never stop building}"

###Adding a javascript test
When you run this (again `bin/behat`) it should pass. Cool! Now let's add a specific javascript test, add this to the bottom of your feature file:

    @javascript
    Scenario: go to my blog and click on the side bar toggle
        Given I am on "/"
        When I click on the ".toggle-sidebar" element
        Then the sidebar should be collapsed

Make sure to include the `@javascript` annotation as it tells the test runner to use the Sahi component for this test.

###Extending your context file
If you run the tests now you should see the Sahi spawn a browser but the tests will fail because you have not implemented the custom functions we are using in this scenario. Add these inside your `Feature Context` class:

        /**
         * @When /^I click on the "([^"]*)" element$/
         */
        public function iClickOnTheElement($cssQuery)
        {
            $session = $this->getSession();
            $page = $session->getPage();
            $element = $page->find('css', $cssQuery);
            $element->click();
        }

        /**
         * @Then /^the sidebar should be collapsed$/
         */
        public function theSidebarShouldBeCollapsed()
        {
            $session = $this->getSession();
            $page = $session->getPage();
            $element = $page->find('css', "body");
            $class = $element->getAttribute("class");
            if ($class != "collapse-sidebar") {
                throw new \Exception('Side bar is not collapsed!');
            }
        }

NOW, when you run Behat you should see a browser be spawned and work through the simple test you have defined, showing all the tests having passed.

##OMG a Screencast!
I got so excited by this project I made a screencast to walk you through it:

<iframe src="http://player.vimeo.com/video/57569755?title=0&amp;byline=0&amp;portrait=0" width="640" height="360" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>

If you are interested in a source code for this tutorial, check it out [here](https://github.com/jasonrobertfox/blog-behat-sahi).

##Next up: Off with their head!
My ultimate goal is to have all this run through a headless browser, likely PhantomJS. When that starts to work there will for sure be a post about it.



