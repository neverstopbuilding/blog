guard :rubocop, all_on_start: false do
  watch /^src\/_plugins/
end

guard 'jekyll-plus', :serve => true, :config => ['_config.yml', '_development.yml'] do
  watch /^src/
  watch /_config.yml/
end

guard 'livereload' do
  watch /^build\/deploy/
end
