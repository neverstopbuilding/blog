#Never Stop Building: The Blog

##Installation

`bundle install`

##Developing

`bundle exec guard`

Starts the development server and starts watching assets to regenerate. Will live reload the browser as assets change in the `build/deploy` directory.

##Deploying

`git push heroku master`

The default ruby build pack will execute `assets:precompile` which generates the static assets from the the source including all compression and minification.
