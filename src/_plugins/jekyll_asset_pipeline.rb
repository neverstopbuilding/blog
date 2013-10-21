# Encoding: utf-8

require 'jekyll_asset_pipeline'
require 'compass'
require 'zurb-foundation'

module JekyllAssetPipeline

  # process SCSS files
  class SassConverter < JekyllAssetPipeline::Converter

    Compass.sass_engine_options[:load_paths].each do |path|
      Sass.load_paths << path
    end

    def self.filetype
      '.scss'
    end

    def convert
      Sass::Engine.new(@content, syntax: :scss).render
    end
  end
end
