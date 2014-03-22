---
layout: post
title: A Jekyll Plugin to Buffer your Posts
image: https://www.evernote.com/shard/s5/sh/d50a25da-344d-4180-a77e-408c3e477550/90c9130983af1429dd1acbf9498aad84/deep/0/how_automatic_transmission_works.jpg-\(1296-864\).png
date: 2014-04-01
category: "web development"
tags: [jekyll, buffer, blogging, "social media", blogs]
description: "Buffer helps share updates across different social media websites, but you still have to put things in the buffer. This Jekyll plugin does that for you whenever you regenerate your site."
promotion: "Static Blogs + Buffer API = Painless Promotion #buffer #jekyll #blog"
---

I'd say one of my least favorite parts of writing articles is the tedious and necessary task of sharing those articles on social media sites. I just feel a little dirty doing the self promotion, but every so often someone finds an article that way, and finds it valuable, so I continued it until recently.

Now that I'm [publishing posts from a queue]({{site.url}}/queue-jekyll-on-heroku) the last thing I want to do is to have to remember what's being published, and to tweet about it. It would would be better to have something that shared an update on all of my social networks when the post is published.

Well that's the plugin I've built.

##Buffer to the Rescue
[Buffer](https://bufferapp.com) is pretty great. You hook up Twitter, Facebook, LinkedIn and App.net (what is this? does anyone use it?) and then you can make one update that goes to all 4 services. Additionally, [Buffer has helpful ruby library](https://github.com/bufferapp/buffer-ruby) that makes interfacing problematically a snap.

Here is the original code of the plugin, you must excuse the obvious hacky-ness, it is a work in progress:

```ruby
require 'buff'

class Buffer < Jekyll::Generator
  def generate(site)
    post = most_recent_post(site)
    post_date = post.date.strftime('%Y-%m-%d')
    today_date = Date.today.strftime('%Y-%m-%d')
    if post_date == today_date
      message = generate_message(post)
      log "Buffer message: \"#{message}\""
      buffer(message, site)
    else
      log 'Not sending latest promotion because older than today...'
    end
  end

  private

  def generate_message(post)
    promotion_message = post.data['promotion'] || ''
    "#{promotion_message} #{post.location_on_server}"
  end

  def most_recent_post(site)
    site.posts.reduce do |memo, post|
      memo.date > post.date ? memo : post
    end
  end

  def buffer(message, site)
    access_token = ENV['BUFFER_ACCESS_TOKEN'] || site.config['buffer_access_token']
    fail ArgumentError, 'No Buffer access token!' unless access_token
    client = Buff::Client.new(access_token)
    content = { body: { text: message, top: true, shorten: true,
                        profile_ids: site.config['buffer_profiles'] } }
    if site.config['send_to_buffer']
      response = client.create_update(content)
      log("Buffer API Response: #{response.inspect}")
    else
      log 'Not sending latest post promotion to Buffer...'
    end
  end

  def log(message)
    puts "\n\n#{message}\n\n"
  end
end
```

The plugin requires that you:

1. [Register your blog as a Buffer application](https://bufferapp.com/developers/apps/create) to generate an access token.
2. Add the `promotion` field to your YAML front matter for all new posts with a short message, basically what will become your status update.
3. Provide the access token as either an environment variable (`BUFFER_ACCESS_TOKEN`) on your server or in the configuration file (`buffer_access_token`)
4. Provide an array of `buffer_profiles` in your configuration file. These are the IDs of each of your social accounts.

The quickest way to get your profile information is send a GET request to the following end point, replacing the access token with your own:

    https://api.bufferapp.com/1/profiles.json?access_token=YOUR_TOKEN

##Now It's Automatic
With this plugin, every time the site is generated it will grab the `promotion` message out of the latest post, append the url of the post onto it, and create a Buffer update for all of my social profiles, putting it at the top of whatever might be in the buffer already. Also the URL will be shortened by the Buffer shortening service.

If I regenerate the site when the latest post's date is not "today" it will not send an update, allowing me to refresh the build outside of when I might ordinarily publish an article.

This is a pretty good start, and with this plugin my blogging process has been reduced to simply: Write article, proofread, commit, push. Everything else is automatic.
