# Encoding: utf-8
# Title: Responsive YouTube embed tag for Jekyll
# Author: Brett Terpstra <http://brettterpstra.com>
# Description: Output a simple YouTube embed tag with code to make it responsive
#
# Syntax {% youtube video_id [width height] %}
# Syntax {% vimeo video_id [width height] %}
#
# Example:
# {% youtube B4g4zTF5lDo 480 360 %}
# {% youtube http://youtu.be/2NI27q3xNyI %}
# {% vimeo https://vimeo.com/70065325 480 360 %}

module Jekyll
  class YouTubeTag < Liquid::Tag
    @videoid = nil
    @width = ''
    @height = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ %r{(?:(?:https?://)?(?:www.youtube.com/(?:embed/|watch\?v=)|youtu.be/)?(\S+)(?:\?rel=\d)?)(?:\s+(\d+)\s(\d+))?}i
        @videoid = $1
        @width = $2 || '480'
        @height = $3 || '360'
      end
      super
    end

    def render(context)
      super
      if @videoid
        %Q{<div class="flex-video"><iframe width="#{@width}" height="#{@height}" src="http://www.youtube.com/embed/#{@videoid}?rel=0" frameborder="0" allowfullscreen></iframe></div>}
      else
        'Error processing input, expected syntax: {% youtube video_id [width height] %}'
      end
    end
  end

  class VimeoTag < Liquid::Tag

    @videoid = nil
    @width = ''
    @height = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ %r{(?:(?:https?://)?vimeo.com(?:/video)?/)?(\w+)(?:\s+(\d+)\s(\d+))?}i
        @videoid = $1
        @width = $2 || '640'
        @height = $3 || '480'
      end
      super
    end

    def render(context)
      super
      if @videoid
        %Q{<div class="flex-video vimeo"><iframe src="//player.vimeo.com/video/#{@videoid}?title=0&amp;byline=0&amp;portrait=0" width="#{@width}" height="#{@height}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>}
      else
        'Error processing input, expected syntax: {% vimeo video_id [width height] %}'
      end
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::YouTubeTag)
Liquid::Template.register_tag('vimeo', Jekyll::VimeoTag)
