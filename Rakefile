# Encoding: utf-8

require 'rubocop/rake_task'
require 'levenshtein'
require 'yaml'

# Settings
valid_categories = [
  'robo garden',
  'web development',
  'devops',
  '3d printing',
  'productivity',
  'test driven development',
  'management',
  'software engineering',
  'hardware hacking'
]
minimum_tags = 5
posting_weekeday = 'Tuesday'

task default: 'assets:precompile'

namespace :build do
  task :local do
    Rake::Task[:clean].invoke
    Rake::Task[:prepare].invoke
    Rake::Task[:test].invoke
    sh 'bundle exec jekyll build --config _config.yml,_development.yml'
  end

  task :staging do
    Rake::Task[:clean].invoke
    Rake::Task[:prepare].invoke
    Rake::Task[:test].invoke
    sh 'bundle exec jekyll build --config _config.yml,_staging.yml'
  end
end

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

task :queue do
  posts_data.each do |path, data|
    # puts data.inspect
    post_date =  Date.parse(data['date'].to_s) if data['date']
    if post_date && post_date > Date.today
      puts "#{data['date']} - #{data['title'] || 'No Title'}"
    end
  end
end

task :social do
  posts = Dir.glob(File.join('src', '_posts', '*.md')).sort.reverse
  if posts[0] =~ /\d{4}-\d{2}-\d{2}-(.*)\.md/i
    slug = $1
    path = 'http://www.neverstopbuilding.com/' + slug
  end
  content = File.read(posts[0])
  data = YAML.load($1) if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m

  puts "\nThe title is:\n"
  puts "#{data['title']}"

  links = {
    'Hacker News' => 'hacker_news',
    'Buffer' => 'buffer',
    'Google Plus' => 'google_plus',
    'Reddit' => 'reddit'
  }
  links.each do |type, source|
    puts "\n#{type}\n"
    puts path + "?utm_source=#{source}&medium=share&utm_campaign=#{slug}"
  end
end

namespace :posts do

  namespace :categories do
    task :list do
      categories = []
      posts_data.each do |path, data|
        categories += data['categories'] if data['categories']
        categories += [data['category']] if data['category']
      end
      puts categories.uniq.sort
    end

    task :validate do

      errors = { total: 0, no_category: [], categories_found: [], not_in_list: [] }
      posts_data.each do |path, data|
        title = data['title']

        unless data['category']
          errors[:no_category] << title
          errors[:total] += 1
        end

        if data['categories']
          errors[:categories_found] << title
          errors[:total] += 1
        end

        if data['category']
          unless valid_categories.include? data['category']
            errors[:not_in_list] << "#{title} -- #{data['category']}"
            errors[:total] += 1
          end
        end
      end

      if errors[:total] > 0
        display_errors errors, :no_category, 'The following posts lack a single category:'
        display_errors errors, :categories_found, 'The following posts have multiple categories listed:'
        display_errors errors, :not_in_list, 'The following have a unapproved category:'
        fail "There were #{errors[:total]} errors found!"
      else
        puts 'No category errors found!'
      end
    end

  end

  namespace :tags do

    desc 'Lists all the used tags ordered by frequency with amount used.'
    task :list do
      unique_tags.sort_by { |key, value| value }.reverse.each do | key, value|
        puts "#{value} - #{key}\n"
      end
    end

    desc 'Lists all the tags that are similar to other tags by letter match'
    task :similar do
      tags = unique_tags.keys
      flagged = []
      tags.each do |tag_a|
        tags.each do |tag_b|
          pair = [tag_a, tag_b].sort.join
          unless tag_a == tag_b || flagged.include?(pair)
            lnd = Levenshtein.normalized_distance(tag_a, tag_b, nil)
            if lnd < 0.2
              puts "#{tag_a} and #{tag_b}: #{(lnd * 100).round(2)}%"
              flagged << pair
            end
          end

        end
      end
    end

    desc 'Searches for the query tag and opens the post.'
    task :search, :query do |t, args|
      posts_data.each do |path, data|
        if data['tags'].include? args.query
          system "subl #{File.join(Dir.pwd, path)}"
        end
      end
    end

    task :validate do
      errors = { total: 0, no_tags: [], few_tags: [], overlap: [] }
      posts_data.each do |path, data|
        title = data['title']
        unless data['tags']
          errors[:no_tags] << title
          errors[:total] += 1
        end

        if data['tags'].count < minimum_tags
          errors[:few_tags] << "#{title} only has #{data['tags'].count} tags!"
          errors[:total] += 1
        end

        if data['tags'].include? data['category']
          errors[:overlap] << title
          errors[:total] += 1
        end

      end
      if errors[:total] > 0
        display_errors errors, :no_tags, 'The following posts are untagged:'
        display_errors errors, :few_tags, 'The following posts don\'t have enough tags:'
        display_errors errors, :overlap, 'The following posts have a tag that is the same as the category:'
        fail "There were #{errors[:total]} errors found!"
      else
        puts 'No tag errors found!'
      end
    end

  end

end

desc 'Runs quality checks.'
task test: [:rubocop, 'posts:tags:validate', 'posts:categories:validate']
Rubocop::RakeTask.new

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf 'build'
  FileUtils.rm_rf ['.pygments-cache', '.sass-cache']
end

desc 'Adds the build tmp directory for test kit creation.'
task :prepare do
  FileUtils.mkdir_p('build')
end

task deploy: [:clean, :prepare, :test] do
  system 'git push origin master'
  system 'git push heroku master'
  Rake::Task[:social].execute
end

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end

# Helper functions

def posts_data
  posts = Dir.glob(File.join('src', '_posts', '*.md'))
  data = {}
  posts.each do |path|
    content = File.read(path)
    if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
      data["#{path}"] = YAML.load($1)
    end
  end
  data
end

def display_errors(errors, key, prompt)
  if errors[key].count > 0
    puts "\nERRORS: #{prompt}\n\n"
    puts errors[key].sort
  end
end

def unique_tags
  tags = Hash.new(0)
  posts_data.each do |path, data|
    if data['tags']
      data['tags'].each do |tag|
        tags[tag] += 1
      end
    end
  end
  tags
end
