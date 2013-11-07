# Encoding: utf-8
# Title: Orbit Tag
# Author: Jason Fox
# Description: Transform a list of images into a Zurb Foundation Orbit slideshow
#
# Syntax
# {% orbit %}
#   - ![Caption text](image/url/file.jpg)
# {% endorbit%}
#

module Jekyll
  class OrbitTag < Liquid::Block
    # def initialize(tag_name, markup, tokens)
    # end
    def render(context)
      content = super
      source = '<div class="slideshow-wrapper"><div class="preloader"></div><ul data-orbit>'
      slide_number = 1
      content.split('- !').each do |image|
        if image.chop =~ /\[(.+)\]\((.+)\)/
          caption = $1
          file = $2
          source += "<li data-orbit-slide=\"slide-#{slide_number}\"><img alt=\"#{caption}\" src=\"#{file}\" /><div class=\"orbit-caption\">#{caption}</div></li>"
          slide_number += 1
        end
      end
      source += '</ul></div>'
      source
    end
  end
end

Liquid::Template.register_tag('orbit', Jekyll::OrbitTag)
