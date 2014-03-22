#Never Stop Building: The Blog

##Installation

`bundle install`

##Developing

`bundle exec rake new['post-slug']`

Creates a new post with that slug. Sets up meta data and ready for editing. Will date the posts for delivery on Tuesdays. Either the next available Tuesday or the next one after the queued post.


`bundle exec guard`

Starts the development server and starts watching assets to regenerate. Will live reload the browser as assets change in the `build/deploy` directory. Will show all posts with future dates.

##Previewing

`bundle exec jekyll serve`

This will build the site locally with production settings so you may check that everything works correctly.

##Deploying

`git push heroku master`

The default ruby build pack will execute `assets:precompile` which generates the static assets from the the source including all compression and minification.
