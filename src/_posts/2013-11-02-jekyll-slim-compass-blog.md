---
layout: post
title: Integrate Jekyll with Slim, Zurb Foundation, Compass and an Asset Pipeline
image: https://lh4.googleusercontent.com/-8OIQh14Uac8/UnqF7ERPelI/AAAAAAAAJME/9by9fDrALYo/w1118-h336-no/jekyll.png
date: 2013-11-02
category: web development
tags: [jekyll, slim, compass, zurb foundation, asset pipeline, blogging, blogs, ruby]
description: "I recently redesigned and overhauled my blog. Starting from scratch, I wanted a tightly integrated Jekyll blog with fast development using compass, and slim templating, but also a good asset pipeline to improve page speed. This article details the basics of setting up the initial Jekyll framework."
---

If you have been here before, then you will notice that Never Stop Building looks quite different. Having recently learned much more about Ruby through my work on the [ChemistryKit Selenium Framework](https://github.com/chemistrykit/chemistrykit) I thought it was time to go back and clean house. The original blog was a hacked up version of Octopress that worked rather well for my purposes, but I was left wanting a cleaner design, improved html5 semantics, and better SEO. I also found that many of the the pages did not pass validation, and the page speeds were dismal.

So, armed with a full bag of Argentina's finest grind, I set off to rebuild the site, from the ground up, doing things "the right way." By that I mean: methodically putting together the components I want, and at each step of the way ensuring I had a clean and well organized blog.

The driving force behind this project were a few general requirements:

1. I want to develop and write quickly and simply, easily previewing my work.
2. I want to deploy rapidly, and efficiently to Heroku.
3. I want to deliver a highly optimized experience to the users, fast page loading, and simple layout.

##The Core Components
In order to achieve these goals I decided on the following core components. Here I'll just explain the reasons behind selecting them, later we will go, step-by-step, through their integration.

- **Jekyll** - The main static site generator. It made sense to start with this directly rather than hack up Octopress, as Octopress has components which are more generalized, many of which I don't even need.
- **Slim** - In addition to using [Markdown for writing](http://daringfireball.net/projects/markdown/), for custom pages, layouts and includes I picked slim for its dead simple coding style. This is especially useful for the class heavy [Zurb Foundation css framework](http://foundation.zurb.com/) that served as a, well, foundation for the design.
- **Compass** - Speaking of which, to support Zurb Foundation, I chose to integrate it with Compass to speed up the style adjustments and cross browser compatability tweaks. Once you start nesting your CSS selectors with a [framework like Compass](http://compass-style.org/) you will never go back.
- **Jekyll Asset Pipeline** - To handle the messy task of consolidating and rendering the assets, this component fit the bill; beautifully delivering GZipped, minified css and js files to the build directory. Watching the Google Page speed warnings disappear was a sight to behold.
- **Guard** - In addition to general code quality monitoring, the [Guard Gem](https://github.com/guard/guard) can be tightly integrated with Jekyll to re-render the site in the browser, making development a breeze.
- **Heroku Deployment** - To deploy, all I want to do is type, `git push heroku master`. The thought of committing the actual build made me queezy, so we will avoid this and only push the source code.

These are just the core components, which made a good base to build out the rest of the blog. Ultimately, I added a variety of plugins, and lots of little tweaks to get the site to meet the original goals. Fortunately, the [Never Stop Building blog is open sourced on GitHub](https://github.com/neverstopbuilding/blog) so you can check out the final result and adapt to your needs.

##Building out the Framework
And now to the meat and potatoes of this adventure. Let's set up your new blog!

###1. Setup a New Project
Create a directory for your blog, initialize a git repository and create a new Gemfile. I use *rvm* so these steps also show creating the Ruby version and gemset files:

```
% mkdir my-blog
% cd my-blog
% git init
% rvm --create --ruby-version use 2.0@my-blog
% touch Gemfile
```

###2. Install the Gem Dependencies
Next let's update the `Gemfile` to include all the Gem dependencies for the project. Typically, and when I was first building out my own blog, I'd only add the Gems one at a time, as needed. To save time though, we'll install them at once and set them up stepwise.

Update your `Gemfile` to look like this:

```ruby
source 'http://rubygems.org'
ruby '2.0.0'

gem 'jekyll', '~> 1.3.0'
gem 'jekyll-slim'
gem 'jekyll-asset-pipeline'
gem 'compass'
gem 'zurb-foundation'
gem 'yui-compressor'

gem 'rake'
gem 'puma'
gem 'rack-contrib'
gem 'rack-rewrite'

group :development  do
  gem 'guard-jekyll-plus', git: 'https://github.com/imathis/guard-jekyll-plus', branch: 'master'
  gem 'rb-fsevent'
  gem 'guard-livereload'
end
```

Note that **you really should lock down the version number of your Gems** so that future changes to backwards compatibility don't break your app. I left them off here for simplicity, but  as of this writing the `guard-jekyll-plus` Gem was missing some updates that could be attained by grabbing the master.

Now just run a `bundle install` to install all of the dependencies for this project.

###3. Create the Basic Jekyll Site
I am not a fan of the Jekyll convention of storing the generated site inside the same folder as those files which drive the generation. Rather, we will have a `src` directory for all the source files, and a `build` directory for the resulting generated site. This build directory will not be committed. All the configuration and dot files will be stored in the root of the project. These commands will put everything in the right place.

```
% bundle exec jekyll new src
% mv src/_config.yml .
```

Next let's update the `.gitignore` file to to prevent the build directory from getting committed:

```
% echo "build" > .gitignore
% echo ".sass-cache" >> .gitignore
```
(Also including the `.sass-cache` for later.)

And finally, we need to update the basic configuration to point to the correct directories. Change the default `_config.yml` to look like this:

```yaml
name: Your New Jekyll Site
markdown: redcarpet
pygments: true

# We are adding this below:
source: ./src
destination: ./build
```

At this point the basic blog site can be tested, run the command `bundle exec jekyll server` and then go to `localhost:4000` to see the bare bones site.

###4. Integrate Slim Templating
For the purposes of this article I'm going to really trim down the layouts to only the essentials to get this all working. You should certainly remember to add all the expected HTML elements and meta tags to your template as you build it out.

To start, we will create the two slim templates (which won't work) and then install the templating system (so they will.) We will also switch over the home page. This is a rough test driven approach.

First change the two layout files to have slim extensions:

```
% mv src/_layouts/default.html src/_layouts/default.slim
% mv src/_layouts/post.html src/_layouts/post.slim
% mv src/index.html src/index.slim
```

Next update the `default.slim` file to contain:

```html
{% raw %}
doctype html
html
  head
    title
      | {{ page.title }}
  body
    .site
      .header
        h1.title
          a href="/"
          | {{ site.name }}
        a.extra href="/" home
      | {{ content }}
      .footer
        .contact
          p Your Name
{% endraw %}
```

And the `post.slim` file to contain:

```html
{% raw %}
---
layout: default
---
h2
  | {{ page.title }}
p.meta
  | {{ page.date | date_to_string }}
.post
  | {{ content }}
{% endraw %}
```

Finally, update the `index.slim` file to contain:

```html
{% raw %}
---
layout: default
title: Your New Jekyll Site
---
.home
  h1 Blog Posts
  ul.posts
    | {% for post in site.posts %}
    li
      span
        | {{ post.date | date_to_string }} &raquo;
      a href="{ post.url }}"
        | {{ post.title }}
    | {% endfor %}
{% endraw %}
```

Trying to preview the site at this point will result in an error. Good, that's what we want. Now let's install the Slim templating. All we will need to do is to create a simple plugin that loads the `jekyll-slim` Gem. Start by creating the file:

```
% mkdir src/_plugins
% touch src/_plugins/bundler.rb
```

And add the following content to the `bundler.rb` file:

```ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
```

If you don't have any slim templating errors, running the site locally (remember: `bundle exec jekyll server`) should result in a working preview.

Awesome! Slim templates are installed.

###5. Setup the Asset Pipeline

So far, our blog does not look very fresh, so let's add some styling to it. Linking a simple css file would be ok, but not ideal. Integrating it with an asset pipeline allows us a few advantages:

- **Pre processing** - We can write styles more quickly with something like SCSS and the asset pipeline will compile it to CSS.
- **Compression** - The asset pipeline will compress all of our styles (or javascript) into one file and minify it, even gzip it, to improve our page performance.
- **Template integration** - We can universally and easily integrate the styles into our templates.

All we are going to do in this step is change the background of our header and footer and adjust the font to look a little better. All the assets will be stored in an `_assets` folder, so we will start by creating a simple site stylesheet, and removing the default styles:

```
% mkdir -p src/_assets/css
% touch src/_assets/css/app.scss
% rm -rf src/css
```

Add this content to the `app.scss` file:

```css
body {
    font-family: sans-serif;
}
.header, .footer {
    background-color: #eeeeee;
    p {
        font-weight: 100;
    }
}
```

Next add the following block to your `_config.yml` file to prepare the configuration for the asset pipeline:

```yaml
asset_pipeline:
  bundle: true
  compress: true
  output_path: assets
  display_path: nil
  gzip: false
```

This tells the asset pipeline to bundle all the various css files together into one, compress them, minify them, and output them to an `assets` path in the built site. Here we won't gzip the assets.

Before we tie everything together, let's integrate the compiled stylesheet into our template. To do this add the following code into the `head` block of your `default.slim` file:

```html
{% raw %}
    | { % css_asset_tag global_css %}
      - /_assets/css/app.scss
    | { % endcss_asset_tag %}
{% endraw %}
```

This will load the single file we have and consolidate it into  a cache-busting file. You could add any number of css files here, as we will see later.

To finish the installation of the pipeline we will create another small plugin. The plugin will set up the SCSS compiling and also specify how the file will be compressed, in this case with the `yui/compressor` Gem. Create the file:

```
% touch src/_plugins/pipeline.rb
```

And add the following content:

```ruby
require 'jekyll_asset_pipeline'

module JekyllAssetPipeline

  # process SCSS files
  class SassConverter < JekyllAssetPipeline::Converter

    Compass.configuration.sass_dir = 'src/_assets/css'

    Compass.sass_engine_options[:load_paths].each do |path|
      Sass.load_paths << path
    end

    def self.filetype
      '.scss'
    end

    def convert
      Sass::Engine.new(@content, syntax: :scss).render
    end
  end

  class CssCompressor < JekyllAssetPipeline::Compressor
    require 'yui/compressor'

    def self.filetype
      '.css'
    end

    def compress
      YUI::CssCompressor.new.compress(@content)
    end
  end

end
```

Start or restart your local server and you should see some output along these lines:

```
Generating... Asset Pipeline: Processing 'css_asset_tag' manifest 'global_css'
Asset Pipeline: Saved 'global_css-b1d5a3073ad08d4d302e82b7e3900a46.css' to '/path/to/my-blog/build/assets'
done.
```

And when you preview it in the browser, it should look marginally better.

###6. Adding Zurb Foundation and Compass Support
Our site may look a little better, but it's nothing to write your mom about. To take it to the next level we will integrate the sweet [Zurb Foundation css framework](http://foundation.zurb.com/) and support for the great [Compass framework](http://compass-style.org/). This is a rather straight forward modification to our existing plugin and templates.

Add the following to the top of your `pipeline.rb` file:

```ruby
require 'compass'
require 'zurb-foundation'
```

And the following at the beginning of the definition for the `SassConverter` in the same file.

```ruby
    Compass.sass_engine_options[:load_paths].each do |path|
      Sass.load_paths << path
    end
```

These changes will include the Zurb and Compass Gems and add the Compass path to the load paths where the compiler will look for included files. Now you can import any of the interesting [Compass CSS3 mixins](http://compass-style.org/reference/compass/css3/) and what not, as well as the Foundation framework.

Simply add the following line to the top of your `app.scss` file to import all the Zurb Foundation goodness:

```css
@import "foundation";

```

Finally let's update our `default.slim` layout to make our site look a little more reasonable. It's still not going to win any awards, but feel free to play around with the styles all you like in your version. Update the `default.slim` file with this content:


```html
{% raw %}
doctype html
html
  head
    | {% css_asset_tag global_css %}
      - /_assets/css/app.scss
    | {% endcss_asset_tag %}
    title
      | {{ page.title }}
  body
    .header
      .row
        .large-12.columns.text-center
          h1.title
            a href="/"
              | {{ site.name }}
          a.button.small href="/" Home
    .row
      .large-12.columns
      | {{ content }}
    .footer
      .row
        .large-12.columns.text-center
          .contact
            p Your Name
{% endraw %}
```


Again restart your server and you should have something along these lines:

![The default jekyll blog with basic Zurb Foundation styles](https://www.evernote.com/shard/s5/sh/e228771f-3aa9-4542-abc9-a907da534a11/95b219bd3a1f719d19aaaacda70f3f86/deep/0/Your-New-Jekyll-Site.png)

One thing I would recommend is that you also import the standard `_settings.scss` file from Zurb Foundation. A version of the [settings file can be found in the Foundation docs](http://foundation.zurb.com/docs/sass.html). This will let you quickly modify the global variables that drive the framework and very quickly add a theme to your blog.

###7. Integrate Guard for Quick Development

At this point you may have found that you have been restarting the Jekyll server quite a bit to update see your changes. Alternatively, there is the `bundle exec jekyll server -w` command which will watch for changes to the source files and then regenerate your site. This is helpful, but I think we can do better.

By installing the `guard-jekyll-plus` Gem along with `livereload` we can make the development process seamless. Make a change in a source file, and the site will be regenerated and your browser refreshed!

Begin by creating a `Guardfile` in the root of your project:

```
% touch Guardfile
```
And fill it with these contents:

```ruby
guard 'jekyll-plus', extensions: %w[slim yml scss js md html xml txt rb], serve: true do
  watch /.*/
  ignore /^build/
end

guard 'livereload' do
  watch /^src/
end
```

Next ensure you have the [Chrome Livereload extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei) installed. (I believe there is also one for Firefox.)

Now, rather than starting up the server the old fashioned way, let's do it the *new fangled* way:

```
bundle exec guard
```

You should see start up messages and that a browser is connected. Go ahead and change something in your site layout or style sheets, and watch the browser reload automatically!

**It's worth mentioning** that the asset pipeline, especially with the rather large Foundation framework, can slow down this refresh process. Some ways to speed it up include:

- **Only import the bare minimum from your supporting frameworks.** Zurb Foundation lets you import sections relevant to your goals, this cuts down on the payload as well as speeds up the asset processing.
- **Run different development settings.** The Jekyll Guard plugin lets you load multiple configuration files, where the later overrides the former. I use this to turn off most of the asset processing and other time intensive things, during normal development.

###8. Deploying to Heroku Cleanly
Alright! We have the beginnings of a rather nice blog. Quick templating with Slim, rapid styling with Compass and SCSS, a good looking base style with Zurb Foundation, and an asset pipeline to package it all together. All that's left is to deploy and show it off!

Heroku let's us deploy our Jekyll blog very easily. However, there are few adjustments to make first that will improve the process:

1. **Don't commit your builds!** While it is quite simple and commonplace to just "commit everything" and push master to Heroku, it's messy. I don't want my code base cluttered up with various states of a generated site. Here we will push *only the source* to Heroku and let it build our finished product.
2. **Improved middleware.** By adding some Rack extensions we can fix many of the issues page analyzers complain about, speed up the site, and make search engines happy.

To begin we will create the necessary files:

```
% touch config.ru
% touch Procfile
% touch Rakefile
% echo '<h1>404: Page Not Found!</h1>' > src/404.html
% touch src/favicon.ico
```
(I've found there to be errors in the deploy process when Heroko looks for the `favicon.ico` file. Which is why we are creating one.)

I use Rake for all sorts of development related tasks, and you should too; but for now all we will do is add the following to the `Rakefile`:

```ruby
namespace :assets do
  desc 'Build Site'
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end
```

An interesting thing about Heroku, is that by default, it will attempt to run the `assets:precompile` Rake task in its standard Ruby build process. All we are doing here is asking that when it runs this task, it should build our Jekyll site. There's no need to install any custom build process.

The `Profile` is rather straight forward and configures the Puma server for our site:

```ruby
web:     bundle exec puma -p $PORT config.ru
```

And lastly, we will build out the `config.ru` file with the necessary middleware; inline I've added comments about the role of each part:

```ruby
# Set the encoding
Encoding.default_internal = Encoding::UTF_8

require 'bundler/setup'
require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
require 'rack/rewrite'

# Set up asset compression
use Rack::Deflater

Bundler.require(:default)

# Set up redirects
use Rack::Rewrite do
  # There should only be one canonical permalink, and it should not end with index.html
  r301 /(.*)\/index\.html$/i, 'http://canonical-domain.com$1'

  # Redirect any calls to the the canonical domain, unless they are to the canonical domain
  # This prevents accessing the app from the heroku url or your domain
  r301 /.*/, 'http://canonical-domain.com$&', if: proc { |rack_env| rack_env['SERVER_NAME'] != 'canonical-domain.com' }
end

# Ensure the site is served from the correct location and the headers are appropriate
use Rack::TryStatic,
  urls: %w[/],
  root: 'build',
  try: ['index.html', '/index.html'],
  header_rules: [
    ['atom.xml', { 'Content-Type' => 'application/atom+xml' }],
    [['xml'], { 'Content-Type' => 'application/xml' }],
    [['html'],  { 'Content-Type' => 'text/html; charset=utf-8' }],
    [['css'],   { 'Content-Type' => 'text/css' }],
    [['js'],    { 'Content-Type' => 'text/javascript' }],
    [['png'],   { 'Content-Type' => 'image/png' }],
    ['/assets', { 'Cache-Control' => 'public, max-age=31536000' }],
  ]

# 404s should be sent to that simple page we created above
run Rack::NotFound.new('build/404.html')
```

Now, at last, we can deploy our site by committing, creating a Heroku site and pushing master. (Unless you have already associated your own domain with this build, you will want to remove the rewrite stuff from the `config.ru` file. 	Assuming you have already installed the local Heroku tools, just use these commands:

```
% git add .
% git commit -m 'Built out a sweet site.'
% heroku create
% git remote add heroku git@heroku.com:your-site-1234.git
% git push heroku master
```

Now watch the magic happen. You'll notice after the Gems are installed the message `Running: rake assets:precompile`, here we see the standard build process building your site. Then you should also notice the asset pipeline doing its work. And eventually, the deploy process will be complete and you can see your new, fresh blog live and in production.

When I ran YSlow, the site scored a perfect 100.

Although, obviously, there is not much here to slow the site down, at least we have a clean and fast foundation upon which to quickly iterate a Jekyll blog.

Please let me know if you run into any problems while working through this tutorial. The [full source of Never Stop Building](https://github.com/neverstopbuilding/blog) is available on Github for your reference. Best of luck!
