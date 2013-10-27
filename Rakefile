# Encoding: utf-8

require 'rubocop/rake_task'

task default: 'assets:precompile'

task :local do
  sh 'bundle exec jekyll build --config _config.yml,_development.yml'
end

task build: [:clean, :prepare, :quality]

desc 'Runs quality checks.'
task quality: [:rubocop]

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf 'build'
end
desc 'Adds the build tmp directory for test kit creation.'
task :prepare do
  FileUtils.mkdir_p('build')
end



task :deploy do
  system "git push origin master"
  system "git push heroku master"
end



Rubocop::RakeTask.new

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end
