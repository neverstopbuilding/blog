# Encoding: utf-8

require 'rubocop/rake_task'

task default: :build

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

Rubocop::RakeTask.new

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end
