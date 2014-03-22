---
layout: post
title: Simple Queuing of Jekyll Posts with Heroku
image: https://www.evernote.com/shard/s5/sh/3bdec4ee-1d7a-4fed-94a5-19123a7cfaad/7c00b8639fac8fe524fa83cfe1234c5a/deep/0/Oslo_queue_ww2.jpg-\(4568-3256\).png
date: 2014-03-25
category: "web development"
tags: [jekyll, heroku, productivity, blogging, queuing, blogs]
description: "A static site is great for a lot of reasons, but it can be a pain if you want to write up a bunch of posts and have them trickle out into the internet. Here is how I automated the process for Jekyll on Heroku."
promotion: "Simple Queuing of Jekyll Posts with Heroku, Automate all the things! #jekyll #heroku"
---

If you are reading this fresh off the presses, then my hope is that it is March 25, 2014 and its around 8 in the morning, EST. Why? Well because this post is the first published automatically from a post queue on this Jekyll powered blog.

##A Problem of Inspiration
Something which I missed, ever since converting this site from Tumblr to Jekyll, was the little scheduling feature that [I raved about in a previous post]({{site.url}}/how-to-promote-and-publish-your-blog-with-tumblr). Often I would get inspired and write a couple of articles, and then with this scheduling feature they would be published regularly, and automatically. Ah, those were the days.

Jekyll does not do this out of the box, I'd have to resort to drafts, but more annoyingly if I wanted to keep a strict posting schedule, of let's say, early Tuesday morning, then I'd have to get up and deploy the site at that horrendous hour. This was not going to fly.

The key here is that I'd rather write when I'm inspired, excited, and productive, and let software help with the busywork of publishing and promoting the posts. And so I hacked a little process together to make that happen.

##A Two Pronged Attack
The solution to this problem is to leverage the `future` option in Jekyll and a recurring job on Heroku, as well as a few Rake tasks to stitch everything together.

###Automating the Post Queue for Jekyll
By default, when you generate your Jekyll blog, it will not include posts that have a date in the future. Essentially, my post queue becomes all the articles that I've given future dates.

By setting `future: false` in my production settings and `future: true` in my development settings I can build out all the posts I like, and when I generate the site only those with a date in the past will get sucked into the static site generation process.

In order to achieve an even spacing of posts in the queue, it's just a matter of creating them with evenly spaced dates. To this end I modified my `new` Rake task to follow two rules:

- If the most recent article is dated in the past, create the new one with the date of "next Tuesday."
- If the most recent article is already in the future, create the new one with a date of Tuesday following that future date.

The choice of Tuesday is arbitrary and configurable, I've been told this is a good day to post things, although [Thursday might be a better day to post blogs](http://www.huffingtonpost.com/belle-beth-cooper/a-scientific-guide-to-pos_b_4262571.html) so I might change it in the future.

Here is the Rake task:

```ruby
desc 'Create a new article'
task :new, :slug do |t, args|
  fail 'Enter a slug for your post!' unless args.slug
  post_date = calculate_next_post_date(posting_weekeday)
  slug = args.slug.gsub(/\s/, '-').gsub(/[^\w-]/, '').downcase
  filename = File.join('src', '_posts', "#{post_date}-#{slug}.md")
  fail "#{filename} already exists!" if File.exist?(filename)
  puts "Creating new article: #{filename}"
  open(filename, 'w') do |file|
    file.puts '---'
    file.puts 'layout: post'
    file.puts 'title: '
    file.puts 'image: '
    file.puts "date: #{post_date}"
    file.puts 'category: '
    file.puts 'tags: []'
    file.puts 'description: ""'
    file.puts 'promotion: ""'
    file.puts '---'
  end
end

def calculate_next_post_date(posting_weekeday)
  latest_post_date = posts_data.to_a.last[1]['date']
  today = Date.today
  if latest_post_date > today
    return latest_post_date + 7
  else
    date  = Date.parse(posting_weekeday)
    delta = date > Date.today ? 0 : 7
    return date + delta
  end
end
```

Now I don't have to think about dates. I just make a new post. Simple. The dates are all handled by the Rake task.

###Automating Post Publishing on Heroku
I already have a [Heroku ready setup for this blog]({{site.url}}/jekyll-slim-compass-blog) so to finish the automation I needed to add a scheduled task that would rebuild this site in production at the time I desired posts to be published.

Let's consider how this works. Whenever `jekyll build` is run, whatever posts that are not in the future will be used for site generation. If I schedule a job to run this task 8:10 Tuesday morning, then the a post dated for that Tuesday would no longer be "in the future," and so it would be effectively published.

This is just standard queuing, my Rake task is putting people at the back of the line, and Heroku is calling "next, next, next."

To do this I added the [Heroku Scheduler Add-on](https://devcenter.heroku.com/articles/scheduler) and scheduled the following Rake task to run every hour, at 10 minutes past:

```ruby
task :refresh do
  if Date.today.wday == Date.parse(posting_weekeday).wday && Time.now.hour == post_window_start_hour
    puts "It's Tuesday around 8AM, let's rebuild the site!"
    sh 'bundle exec jekyll build'
  end
end
```

This checks if it is Tuesday and if the hour is 8, and if so rebuilds the site.

##Automate Your Way to Freedom
It's rather amazing how something like a post queue can make you feel more free with your time. I can keep content flowing regularly even if I'd likely not get the chance to write weekly. With a little adjustment I could have the posts publish more or less frequently.

The lesson here is that sometimes there are tedious task that get in your way, but using the **power of software**, you can automate them so you can have more time to do things you like!
