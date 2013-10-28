# Encoding: utf-8

require 'rubocop/rake_task'

#Settings

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

task default: 'assets:precompile'

namespace :build do
  task :local do
    Rake::Task[:clean].invoke
    Rake::Task[:prepare].invoke
    Rake::Task[:quality].invoke
    sh 'bundle exec jekyll build --config _config.yml,_development.yml'
  end
end

namespace :posts do

  namespace :categories do
    task :list do
      categories = []
      get_posts_data.each do |path, data|
        categories += data['categories'] if data['categories']
        categories += [data['category']] if data['category']
      end
      puts categories.uniq.sort
    end

    task :validate do

      errors = { total: 0, no_category: [], categories_found: [], not_in_list: []}
      get_posts_data.each do |path, data|
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
        display_errors errors, :no_category, "The following posts lack a single category:"
        display_errors errors, :categories_found, "The following posts have multiple categories listed:"
        display_errors errors, :not_in_list, "The following have a unapproved category:"
        raise "There were #{errors[:total]} errors found!"
      else
        puts "No errors found!"
      end
    end

  end

  namespace :tags do

    task :list do
      tags = Hash.new(0)
      get_posts_data.each do |path, data|
        if data['tags']
          data['tags'].each do |tag|
            tags[tag] +=1
          end
        end
      end
      tags.sort_by { |key, value| value }.reverse.each do | key, value|
        puts "#{value} - #{key}\n"
      end
    end

    task :search, :query do |t, args|
      get_posts_data.each do |path, data|
        if data['tags'].include? args.query
          system "subl #{File.join(Dir.pwd, path)}"
        end
      end
    end

    task :validate do
      errors = { total: 0, no_tags: [], few_tags: [], overlap: [] }
      get_posts_data.each do |path, data|
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
        display_errors errors, :no_tags, "The following posts are untagged:"
        display_errors errors, :few_tags, "The following posts don't have enough tags:"
        display_errors errors, :overlap, "The following posts have a tag that is the same as the category:"
        raise "There were #{errors[:total]} errors found!"
      end
    end

  end

end

desc 'Runs quality checks.'
task quality: [:rubocop]
Rubocop::RakeTask.new

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf 'build'
  FileUtils.rm_rf [".pygments-cache/**", ".sass-cache/**"]
end

desc 'Adds the build tmp directory for test kit creation.'
task :prepare do
  FileUtils.mkdir_p('build')
end

task :deploy do
  system "git push origin master"
  system "git push heroku master"
end

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end

# Helper functions

def get_posts_data
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
