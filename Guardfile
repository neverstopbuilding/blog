guard :rubocop, all_on_start: false do
  watch /^src\/_plugins/
end

guard 'jekyll-plus', extensions: %w[slim yml scss js md html xml txt], serve: true, rack_config: 'config.ru', config: ['_config.yml', '_development.yml'] do
  watch /.*/
  ignore /^build/
end

guard 'livereload' do
  watch /^src/
end
