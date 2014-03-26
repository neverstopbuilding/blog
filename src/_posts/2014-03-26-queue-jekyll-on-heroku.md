---
layout: post
title: Simple Queuing of Jekyll Posts with Heroku
image: https://www.evernote.com/shard/s5/sh/3bdec4ee-1d7a-4fed-94a5-19123a7cfaad/7c00b8639fac8fe524fa83cfe1234c5a/deep/0/Oslo_queue_ww2.jpg-\(4568-3256\).png
date: 2014-03-26
category: "web development"
tags: [jekyll, heroku, productivity, blogging, queuing, blogs]
description: "A static site is great for a lot of reasons, but it can be a pain if you want to write up a bunch of posts and have them trickle out into the internet. Here is how I automated the process for Jekyll on Heroku."
promotion: "Simple Queuing of Jekyll Posts with Heroku, Automate all the things! #jekyll #heroku"
---

This post might also be titled:

#How to Have Heroku push to Heroku
Oh the trials and tribulations of getting a static Jekyll blog to automatically redeploy and in doing so release an article from a queue...

Originally, I had naively assumed that I could simply call a Rake task from a scheduled process to regenerate the Jekyll blog on Heroku. Note, you **can't do this!** Once the code is deployed you can't have Rake tasks modify it on the Heroku filesystem. You have to redeploy the blog. [The Code Whisperer's article](http://blog.thecodewhisperer.com/2012/12/06/publish-posts-later-with-jekyll-slash-octopress/) helped me along to finally cracking the problem, which required one little Heroku app pushing code to another.

##A Problem of Inspiration
Something which I missed, ever since converting this site from Tumblr to Jekyll, was the little scheduling feature that [I raved about in a previous post]({{site.url}}/how-to-promote-and-publish-your-blog-with-tumblr). Often I would get inspired and write a couple of articles, and then with this scheduling feature they would be published regularly, and automatically. Ah, those were the days.

Jekyll does not do this out of the box, I'd have to resort to drafts, but more annoyingly if I wanted to keep a strict posting schedule, of let's say, early Tuesday morning, then I'd have to get up and deploy the site at that horrendous hour. This was not going to fly.

The key here is that I'd rather write when I'm inspired, excited, and productive, and let software help with the busywork of publishing and promoting the posts. And so I hacked a little process together to make that happen.

##A Two Pronged Attack
The solution to this problem is to leverage the `future` option in Jekyll and a recurring job for a "deployer" app on Heroku, as well as a few Rake tasks to stitch everything together.

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

The tricky part is that in order to rebuild the site I need to push updated source code to the Heroku repository. I don't want to do the pushing, nor do I want to set up a server to do the pushing. I'd rather have Heroku do it, which presents some interesting SSH key problems. This image best explains how it's all wired together:

![Heroku App to Push to Heroku App](https://www.evernote.com/shard/s5/sh/392faf47-b0b5-4e8f-bf92-2a19d7444a64/d06da60465fff6fcc696941072d5f913/deep/0/Untitled.png)

The process is as follows:

1. I manage the site normally, using the previously discussed tasks and simply push my updates to Github where the code is hosted.
2. Everyday at 8am a Rake task on **nsb-deployer** is run that will start by checking if it is Tuesday, if it is then it will:
3. Clone the latest copy of the source from Github
4. Add an "update commit" so that when the code is pushed a re-deploy will be triggered.
5. Finally, pushing the code to the production Heroku site to re-deploy.

The nuance of this set up is that the **nsb-deployer** app must have a way to securely push to an Heroku repository (lemme tell you that was a pain to figure out.) Let's it up.

###The Deployer App
To implement this solution you will need to create a second Heroku app, I called mine **nsb-deployer** which contains:

####git.sh

```bash
#!/bin/bash

# The MIT License (MIT)
# Copyright (c) 2013 Alvin Abad

if [ $# -eq 0 ]; then
    echo "Git wrapper script that can specify an ssh-key file
Usage:
    git.sh -i ssh-key-file git-command
    "
    exit 1
fi

# remove temporary file on exit
trap 'rm -f /tmp/.git_ssh.$$' 0

if [ "$1" = "-i" ]; then
    SSH_KEY=$2; shift; shift
    echo "ssh -o \"StrictHostKeyChecking no\" -i $SSH_KEY \$@" > /tmp/.git_ssh.$$
    chmod +x /tmp/.git_ssh.$$
    export GIT_SSH=/tmp/.git_ssh.$$
fi

# in case the git command is repeated
[ "$1" = "git" ] && shift

# Run the git command
git "$@"
```

This script by [Alvin Abad](http://alvinabad.wordpress.com/2013/03/23/how-to-specify-an-ssh-key-file-with-the-git-command/) let's you run a git command by specifying the ssh private key. Note the `-o \"StrictHostKeyChecking no\"` which prevents you from having to approve the host addition when this command is used to push to your production Heroku app.

####Rakefile

```ruby
namespace :refresh do
  task :weekly do
    if Date.today.tuesday?
      puts "It's Tuesday around 8AM, let's rebuild the site!"
      Rake::Task['refresh:manual'].invoke
    else
      puts "It's not Tuesday, doing nothing..."
    end
  end
  task :manual do
    puts 'Refreshing site...'
    app = 'neverstopbuilding'
    remote = "git@heroku.com:#{app}.git"
    system "rm -rf blog"
    system "git clone https://github.com/neverstopbuilding/blog.git -b master "
    system "cd blog; git commit --allow-empty -m 'Force rebuild'; /app/git.sh -i /app/heroku_private.pem git push #{remote} master --force"
  end
end
```

This is the task that will be scheduled, cloning the code and pushing it to the Heroku remote. Note the `git commit --allow-empty -m 'Force rebuild'` command. This is required because in general, all that will change between queued post releases is the time, not source code will change so Heroku won't rebuild. This commit ensures a rebuild occurs.

Also you will note reference to a `heroku_private.pem` file. This file contains an SSH private key specifically created for this deployment process. It's probably a security sin to have committed it and pushed it to the nsb-deployer remote, alternatively I could have stored it as a Heroku config parameter and written it out to a file.

I generated the key pair and added the private key to this app (nsb-deployer), and then added the public key to the actually production Heroku remote (in this case neverstopbuilding) here is an example:

    % cd neverstopbuilding/blog
    % heroku keys:add ../nsb-deployer/heroku_public.pem

Finally, I added the [Heroku Scheduler Add-on](https://devcenter.heroku.com/articles/scheduler) to the nsb-deployer app and scheduled the `refresh:weekly` Rake task to run once a day at 8AM (12PM UTC). I can also run a `refresh:manual` task to force a redeploy for manual posting or updating purposes.

##Automate Your Way to Freedom
It's rather amazing how something like a post queue can make you feel more free with your time. I can keep content flowing regularly even if I'd likely not get the chance to write weekly. With a little adjustment I could have the posts publish more or less frequently, or leverage this technique to build some fun CI/CD solutions.

The lesson here is that sometimes there are tedious task that get in your way, but using the **power of software**, you can automate them so you can have more time to do things you like!
