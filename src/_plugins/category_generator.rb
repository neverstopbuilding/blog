module Jekyll
  module Categories
    class CategoryPage < Page
      def initialize(site, base, dir, category, image = nil)
        @site = site
        @base = base
        @dir = dir
        @name = 'index.html'

        process(@name)
        read_yaml(File.join(base, '_layouts'), 'category_page.slim')
        data['image'] = image if image
        data['category'] = category
        data['has_feed'] = true
        data['description'] = "Articles related to #{category.titlecase}, from Never Stop Building."
        data['tags'] = [category]
        self.ext = 'slim'
        data['title'] = category.titlecase
      end
    end

    class CategoryFeed < Page
      def initialize(site, base, dir, category)
        @site = site
        @base = base
        @dir = dir
        @name = 'atom.xml'

        process(@name)
        read_yaml(File.join(base, '_layouts'), 'category_feed.xml')
        data['category'] = category
        data['description'] = "A Feed of articles related to #{category.titlecase}, from Never Stop Building."
        data['title'] = category.titlecase
      end
    end

    class CategoryGenerator < Generator
      safe true

      def generate(site)
        if site.layouts.key? 'category_page'
          dir = site.config['category_dir'] || 'categories'
          site.categories.keys.each do |category|
            image = nil
            site.categories[category].each do |post|
              image = post.data['image'] if post.data['image']
            end
            write_category_page(site, File.join(dir, category.gsub(/\s/, '-').gsub(/[^\w-]/, '').downcase), category, image)
          end
        end

        if site.layouts.key? 'category_feed'
          dir = site.config['category_dir'] || 'categories'
          site.categories.keys.each do |category|
            write_category_feed(site, File.join(dir, category.gsub(/\s/, '-').gsub(/[^\w-]/, '').downcase), category)
          end
        end
      end

      def write_category_page(site, dir, category, image)
        index = CategoryPage.new(site, site.source, dir, category, image)
        index.render(site.layouts, site.site_payload)
        index.write(site.dest)
        site.static_files << index
      end

      def write_category_feed(site, dir, category)
        index = CategoryFeed.new(site, site.source, dir, category)
        index.render(site.layouts, site.site_payload)
        index.write(site.dest)
        site.static_files << index
      end
    end

    # Returns a correctly formatted category url based on site configuration.
    #
    # Use without arguments to return the url of the category list page.
    #    {% category_url %}
    #
    # Use with argument to return the url of a specific catogory page.  The
    # argument can be either a string or a variable in the current context.
    #    {% category_url category_name %}
    #    {% category_url category_var %}
    #
    class CategoryUrlTag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @category = text
      end

      def render(context)
        base_url = context.registers[:site].config['base-url'] || '/'
        category_dir = context.registers[:site].config['category_dir'] || 'categories'

        category = context[@category] || @category.strip.tr(' ', '-').downcase
        category.empty? ? "#{base_url}#{category_dir}" : "#{base_url}#{category_dir}/#{category.gsub(/\s/, '-').gsub(/[^\w-]/, '').downcase}"
      end
    end
  end
end

Liquid::Template.register_tag('category_url', Jekyll::Categories::CategoryUrlTag)
