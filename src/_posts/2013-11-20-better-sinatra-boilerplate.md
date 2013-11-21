---
layout: post
title: A Better Sinatra Boilerplate
image:
date: 2013-11-20
category: web development
tags: [sinatra, slim, boilerplate, zurb foundation, compass, guard, ruby, rspec, capybarra, test driven development, tdd, rubocop, craftsmanship]
description: "How can the desire to start a restaurant result in an improved Sinatra boilerplate application? It just takes the right mix of obsessiveness and the desire to do things right."

How can the desire to start a restaurant result in an improved Sinatra boilerplate application? It just takes the right mix of obsessiveness and the desire to do things right.

The long and the short of the story is that I wanted to build a simple website for a [small "closed door" restaurant](https://www.facebook.com/casaraposa) some friends and I are starting down here in Buenos Aires. And because I want to cater to both English and Spanish speakers, the website should be easily internationalizable. I toyed with the idea of adapting a staic site generator, given that I had [just built a robust Jekyll foundation]({{site.url}}/jekyll-slim-compass-blog), but that seemed like it could be limiting to future dynamic functionality. Enter Sinatra.

As I started working on the website, I thought, "Hold on. If you are goning to build up a foundation for this app, you might as well generalize it a little. You are always trying out new things. Take the time so you don't have to do rework." Plus, of course, everyone else gets to benefit from forking or adapting this boilerplate. And so I began to build out a "better" Sinatra boilerplate app.

I say "better" not to be arragont, I just wasn't satisfied with the existing boilerplate apps that were out there. And there are many; and many are good. But there were a few things that I wanted that I couldn't easily find:

- **A robust testing framework** - Unit and system tests, as well as some consistant code quality should be part of any software development project. Even a small prototype!
- **Good looks, easy templates** - I prefer the [Slim]() templating language and [Zurb Foundation]() for styling. And all of this should be packaged together with some sort of asset pipeline.
- **Built for real development** - I like using [Guard]() to keep all my tests running, reseting the server when needed, and updating the browser. Development is faster when you are developing and not doing tedious things. Most boilerplates I found would still require tailoring to a more automated development ecosystem.

I set to work, and after a couple of days, I offer, for your consideration a [Sinatra Boilerplate App](https://github.com/neverstopbuilding/sinatra-boilerplate)! While the code and documentation are the best resource, here is a quick list of features:

- Sinatra app with YAML configuration per environment.
- RSpec powered unit and system tests.
- Support for Rack::Test and Capybarra.
- Rubocop code quality verification.
- Compass and Zurb Foundation complication.
- Slim template engine.
- All assets are packaged with an asset pipeline.
- Rake tasks for running various tests.
- All testing and browser refresh powered with Guard.
- Code coverage and test report generation.
- Easy deployment to Heroku.

I think that about covers it. We'll see how fast I can actually build out the website, but there are already other projects that I have that could leverage this, so it's starting to pay dividends.

##A Word on Test Configuration
A detail of this implimentation that is worth discussing is the mannery by which I configure the tests under various conditions. There are the general factors in play:

- During development, I want guard to run the unit tests as fast as possible for quick feedback.
- The system tests require firing up the whole app, which should not slow down the unit tests.
- When I run the tests manually, then I should generate code coverage, which takes a little longer.

In order to achieve these goals, I broke out my RSpec `spec_helper.rb` into separate files for each type of test, and allow environment variables manage the process. The main `spec_helper.rb` file simply loads the additional helper file specific to either unit or system tests:

```ruby
ENV['RACK_ENV'] = 'test'
mode = ENV['TEST_TYPE'] || 'unit'
require "#{mode}/spec_helper"
```

The "sub helper" for system tests, for example, loads the nessesary dependencies, starts the app, and so forth. On the other hand, the sub helper for the unit tests just configures RSpec, and if the `COVERAGE` environment variable is true, configures that. Thus when I run the unit tests with the Rake task, I do "turn on" coverage, but its off by default when Guard runs it.

The faster the tests can run, the faster the feedback and the better your code will be. Too often we can get caught up in an  idea and not take the time to set things up, even though we will need to anyway if we want any scale or reliability. Better to do it first when you are inspired and excited, than later when you are frustrated and on a deadline. It's nice to know that things "just work."

I should not forget to thank fellow GitHub users [l3ck](https://github.com/l3ck/sinatra-boilerplate), [aaandre](https://github.com/aaandre/sinatra-boilerplate) and [rchampourlier](https://github.com/rchampourlier/sinatra-baseapp) for blazing the trail with thier helpful Sinatra boilerplate apps.
