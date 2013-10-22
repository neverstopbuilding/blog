---
layout: post
title: "How to Create a Blog with Octopress on Heroku"
date: 2013-04-16 10:39
comments: true
categories: [blogs, heroku]
twitter: [heroku, octopress, deployment]
---

Today I spent some time struggling with the first thing everyone should do when they are starting a new app or project: **the build/deploy system**. Huh? The reason this should be the first thing is that:

- You are going to deploy often, why do anything but make it "one click" or a "one liner."
- You are excited about the project, so channel that excitement into getting things setup correctly before you are miserable and just want to "get the project out."
- Knowing this works right off the bat will save you time in the future.

Enough with my rant. This article will step through the creation of a blog with [Octopress](http://octopress.org/) and how to deploy it onto [Heroku](https://www.heroku.com/). It updates a few of the articles I found during my research, but certainly owes a lot to them. Thanks to [nicholasmott](https://github.com/nicholasmott) and [jgarber](https://github.com/jgarber) for his [helpful article](http://jasongarber.com/blog/2012/01/10/deploying-octopress-to-heroku-with-a-custom-buildpack/).

##Before You Begin
In order to do this you will need a few things in place:

- [Git](https://help.github.com/articles/set-up-git)
- A [Heroku](https://www.heroku.com/) Account and the [Command Line Utility](https://toolbelt.herokuapp.com/)

##Setup Your Project
First clone the Octopress code to make your project:

    git clone https://github.com/imathis/octopress.git YOUR_PROJECT_NAME
    cd YOUR_PROJECT_NAME

Remove the git directory so you can source control the changes we are making:

    rm -rf .git

Remove some of the included files so that you can replace them with your own:

    rm Gemfile.lock README.markdown CHANGELOG.markdown

Initialize a new git repository to track our work:

    git init

##Update Your Gemfile
In order to have Heroku handle your gems correctly you need to make the required dependencies available in production. Update your Gemfile to look like this:

```ruby
source "http://rubygems.org"

gem 'rake', '~> 0.9'
gem 'jekyll', '~> 0.12'
gem 'rdiscount', '~> 1.6.8'
gem 'pygments.rb', '~> 0.3.4'
gem 'RedCloth', '~> 4.2.9'
gem 'haml', '~> 3.1.7'
gem 'compass', '~> 0.12.2'
gem 'sass-globbing', '~> 1.0.0'
gem 'rubypants', '~> 0.2.0'
gem 'stringex', '~> 1.4.0'
gem 'liquid', '~> 2.3.0'
gem 'sinatra', '~> 1.4.2'

group :development do
  gem 'rb-fsevent', '~> 0.9'
end
```

##Update Your .slugignore
The directories that are listed in the `.slugignore` file are required by Heroku. So simply clear out the file and leave it blank. (It still must exist however.)

##Setup the Blog
This is optional but you could set up the basic settings in your `_config.yml` file.

Next install the dependencies:

    bundle install

And install the base theme:

    rake install

If you want to see how things will look you can preview it:

    rake preview

##Let's Deploy!
Add everything to source code:

    git add .
    git commit -m 'Initial commit of my blog!'

Now the fun part, use the following command to create a new Heroku app that references a custom build back that has been updated to run your blog application on Heroku. This differs from the standard method of deployment in that you are not deploying the statically generated site, but rather the whole application:

    heroku create --buildpack https://github.com/nicholasmott/heroku-buildpack-octopress.git

And now push that bad boy to the cloud:

    git push heroku master

And with this final command you can open your blog, already hosted on Heroku. Enjoy!

    heroku open

