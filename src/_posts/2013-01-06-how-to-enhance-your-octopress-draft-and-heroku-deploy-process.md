---
layout: post
title: "How to Enhance your Octopress Draft and Heroku Deploy Process"
comments: true
date: 2013-01-06 17:56
category: software engineering
tags: [blogs, automation, productivity, build system, deploy, ruby, octopress, heroku]
---
One of the things I am enjoying about my recent switch to [Octopress](http://octopress.org/) is that it really is a "blogging framework for hackers." Specifically, when I find things that are less than ideal, it is not too hard to whip up some rake tasks to fix them. Here were my requirements:

- I want to create a draft separate from a post, so that I can compose when inspired and not worry about flooding the internet with many posts at once.
- I want to quickly publish a draft so that I can release posts during appropriate times.
- I want to very quickly deploy to heroku to save time.

To solve these problems I referenced the work on [this post](http://blog.yangmeyer.de/blog/2012/05/28/octopress-drafts) and [this gist](https://gist.github.com/3933525). The result are three new rake tasks:

##rake new_draft['Post Title']
This task does basically what the `new_post` task does except it:

- Puts the file in a `_drafts` directory.
- Eliminates the date from both the file name and the yaml front matter.
- Adds `published: false` to the front matter.

```ruby
# usage rake new_draft[my-new-draft] or rake new_draft['my new draft']
desc "Begin a new draft in #{source_dir}/#{drafts_dir}"
task :new_draft, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  mkdir_p "#{source_dir}/#{drafts_dir}"
  filename = "#{source_dir}/#{drafts_dir}/#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new draft: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "    post.puts "published: false"
    post.puts "category: nil
tags:  "
    post.puts "---"
  end
  system "open #{filename}"
end
```


##rake publish_draft
This task lists all of the draft posts, prompting you to select one. After you select one it:

- Adds the current date to the file name and front matter.
- Removes the `published: false` item.
- Moves the post to the `_posts` directory.

This way you can compose draft posts at will. Then when you are ready you can publish them and they will appear that you "released them" on that day.

```ruby
# usage rake publish_draft
desc "Select a draft to publish from #{source_dir}/#{drafts_dir} on the current date."
task :publish_draft do
  drafts_path = "#{source_dir}/#{drafts_dir}"
  drafts = Dir.glob("#{drafts_path}/*.#{new_post_ext}")
  drafts.each_with_index do |draft, index|
    begin
      content = File.read(draft)
      if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
        data = YAML.load($1)
      end
    rescue => e
      puts "Error reading file #{draft}: #{e.message}"
    rescue SyntaxError => e
      puts "YAML Exception reading #{draft}: #{e.message}"
    end
    puts "  [#{index}]  #{data['title']}"
  end
  puts "Publish which draft? "
  answer = STDIN.gets.chomp
  if /\d+/.match(answer) and not drafts[answer.to_i].nil?
    mkdir_p "#{source_dir}/#{posts_dir}"
    source = drafts[answer.to_i]
    filename = source.gsub(/#{drafts_path}\//, '')
    dest = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{filename}"
    puts "Publishing post to: #{dest}"
    File.open(source) { |source_file|
      contents = source_file.read
      contents.gsub!(/^published: false$/, "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}")
      File.open(dest, "w+") { |f| f.write(contents) }
    }
    FileUtils.rm(source)
  else
    puts "Index not found!"
  end
end
```

##rake deploy_heroku
Finally this task just automates the deployment process to heroku by:

- Generating your blog.
- Committing all the files.
- Pushing both to master and heroku.

```ruby
# usage rake deploy_heroku
desc "Commits all source changes and pushes to master and heroku"
task :deploy_heroku do
  Rake::Task[:generate].execute
  system "git add ."
  message = "Updated Never Stop Building at #{Time.now.utc}"
  system "git commit -am '#{message}'"
  system "git push origin master"
  system "git push heroku master"
end
```

Now my writing and publishing process is much quicker and more organized. A next step might be to use an automatic job to publish drafts, or specifically tagged drafts, per a set cadence. This would be similar to the tumblr "queue."
