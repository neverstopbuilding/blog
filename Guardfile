guard :rubocop, all_on_start: false do
  watch(%r{^src/_plugins/.+\.rb$})
end

guard 'jekyll-plus', :serve => true, :config => ['_config.yml'] do
  watch /^src/
  watch /_config.yml/
end

guard 'livereload' do
  watch /^build\/deploy/
end
