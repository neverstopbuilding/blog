# Encoding: utf-8
# Sitemap.xml Generator is a Jekyll plugin that generates a sitemap.xml file by
# traversing all of the available posts and pages.
#
# How To Use:
#   1) Copy source file into your _plugins folder within your Jekyll project.
#   2) Change modify the url variable in _config.yml to reflect your domain name.
#   3) Run Jekyll: jekyll --server to re-generate your site.
#
# Variables:
#   * Change SITEMAP_FILE_NAME if you want your sitemap to be called something
#     other than sitemap.xml.
#   * Change the PAGES_INCLUDE_POSTS list to include any pages that are looping
#     through your posts (e.g. "index.html", "archive.html", etc.). This will
#     ensure that right after you make a new post, the last modified date will
#     be updated to reflect the new post.
#   * A sitemap.xml should be included in your _site folder.
#   * If there are any files you don't want included in the sitemap, add them
#     to the EXCLUDED_FILES list. The name should match the name of the source
#     file.
#   * If you want to include the optional changefreq and priority attributes,
#     simply include custom variables in the YAML Front Matter of that file.
#     The names of these custom variables are defined below in the
#     CHANGE_FREQUENCY_CUSTOM_VARIABLE_NAME and PRIORITY_CUSTOM_VARIABLE_NAME
#     constants.
#
# Notes:
#   * The last modified date is determined by the latest from the following:
#     system modified date of the page or post, system modified date of
#     included layout, system modified date of included layout within that
#     layout, ...
#
# Author: Michael Levin
# Site: http://www.kinnetica.com
# Distributed Under A Creative Commons License
#   - http://creativecommons.org/licenses/by/3.0/
#
# Modified for Octopress by John W. Long
#
require 'rexml/document'
require 'fileutils'
require 'git'

module Jekyll

  # Change SITEMAP_FILE_NAME if you would like your sitemap file
  # to be called something else
  SITEMAP_FILE_NAME = 'sitemap.xml'

  # Any files to exclude from being included in the sitemap.xml
  EXCLUDED_FILES = ['atom.xml', '404.slim']

  # Any files that include posts, so that when a new post is added, the last
  # modified date of these pages should take that into account
  PAGES_INCLUDE_POSTS = ['index.slim']

  # Custom variable names for changefreq and priority elements
  # These names are used within the YAML Front Matter of pages or posts
  # for which you want to include these properties
  CHANGE_FREQUENCY_CUSTOM_VARIABLE_NAME = 'change_frequency'
  PRIORITY_CUSTOM_VARIABLE_NAME = 'priority'

  class Post
    attr_accessor :name

    def full_path_to_source
      File.join(@base, @name)
    end

    def location_on_server
      "#{site.config['url']}#{url}"
    end
  end

  class Page
    attr_accessor :name

    def full_path_to_source
      File.join(@base, @dir, @name)
    end

    def location_on_server
      location = "#{site.config['url']}#{url}"
      location.gsub(/\/index.html$/, '')
    end
  end

  class Layout
    def full_path_to_source
      File.join(@base, @name)
    end
  end

  # Recover from strange exception when starting server without --auto
  class SitemapFile < StaticFile
    def write(dest)
      begin
        super(dest)
      rescue
        false
      end
      true
    end
  end

  class SitemapGenerator < Generator

    # Valid values allowed by sitemap.xml spec for change frequencies
    VALID_CHANGE_FREQUENCY_VALUES = %w[always hourly daily weekly monthly yearly never]

    # Goes through pages and posts and generates sitemap.xml file
    #
    # Returns nothing
    def generate(site)
      sitemap = REXML::Document.new << REXML::XMLDecl.new('1.0', 'UTF-8')

      if site.config['sitemap']['local']
        puts 'Building sitemap from local repository.'
        root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      else
        puts 'Building sitemap from fresh cloned repository.'
        root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'build', 'clone.git'))
        Git.clone(site.config['sitemap']['repo'], 'build/clone.git')
      end

       @git = Git.open(root)

      urlset = REXML::Element.new 'urlset'
      urlset.add_attribute('xmlns', 'http://www.sitemaps.org/schemas/sitemap/0.9')

      @last_modified_post_date = fill_posts(site, urlset)
      fill_pages(site, urlset)

      sitemap.add_element(urlset)

      # File I/O: create sitemap.xml file and write out pretty-printed XML
      FileUtils.mkdir_p(site.dest) unless File.exists?(site.dest)
      file = File.new(File.join(site.dest, SITEMAP_FILE_NAME), 'w')
      formatter = REXML::Formatters::Pretty.new(4)
      formatter.compact = true
      formatter.write(sitemap, file)
      file.close

      # Keep the sitemap.xml file from being cleaned by Jekyll
      site.static_files << Jekyll::SitemapFile.new(site, site.dest, '/', SITEMAP_FILE_NAME)
    end

    # Create url elements for all the posts and find the date of the latest one
    #
    # Returns last_modified_date of latest post
    def fill_posts(site, urlset)
      last_modified_date = nil
      site.posts.each do |post|
        unless excluded?(post.name)
          url = fill_url(site, post)
          urlset.add_element(url)
        end

        path = post.full_path_to_source
        date = get_modified_date(path)

        last_modified_date = date if last_modified_date.nil? || date > last_modified_date
      end

      last_modified_date
    end

    # Create url elements for all the normal pages and find the date of the
    # index to use with the pagination pages
    #
    # Returns last_modified_date of index page
    def fill_pages(site, urlset)
      site.pages.each do |page|
        unless excluded?(page.name)
          path = page.full_path_to_source
          if File.exists?(path)
            url = fill_url(site, page)
            urlset.add_element(url)
          end
        end
      end
    end

    # Fill data of each URL element: location, last modified,
    # change frequency (optional), and priority.
    #
    # Returns url REXML::Element
    def fill_url(site, page_or_post)
      url = REXML::Element.new 'url'

      loc = fill_location(page_or_post)
      url.add_element(loc)

      lastmod = fill_last_modified(site, page_or_post)
      url.add_element(lastmod) if lastmod

      if page_or_post.data[CHANGE_FREQUENCY_CUSTOM_VARIABLE_NAME]
        change_frequency =
          page_or_post.data[CHANGE_FREQUENCY_CUSTOM_VARIABLE_NAME].downcase

        if valid_change_frequency?(change_frequency)
          changefreq = REXML::Element.new 'changefreq'
          changefreq.text = change_frequency
          url.add_element(changefreq)
        else
          puts "ERROR: Invalid Change Frequency In #{page_or_post.name}"
        end
      end

      if page_or_post.data[PRIORITY_CUSTOM_VARIABLE_NAME]
        priority_value = page_or_post.data[PRIORITY_CUSTOM_VARIABLE_NAME]
        if valid_priority?(priority_value)
          priority = REXML::Element.new 'priority'
          priority.text = page_or_post.data[PRIORITY_CUSTOM_VARIABLE_NAME]
          url.add_element(priority)
        else
          puts "ERROR: Invalid Priority In #{page_or_post.name}"
        end
      end

      url
    end

    # Get URL location of page or post
    #
    # Returns the location of the page or post
    def fill_location(page_or_post)
      loc = REXML::Element.new 'loc'
      loc.text = page_or_post.location_on_server
      loc
    end

    # Fill lastmod XML element with the last modified date for the page or post.
    #
    # Returns lastmod REXML::Element or nil
    def fill_last_modified(site, page_or_post)
      path = page_or_post.full_path_to_source

      lastmod = REXML::Element.new 'lastmod'
      date = get_modified_date(path)
      latest_date = find_latest_date(date, site, page_or_post)

      if @last_modified_post_date.nil?
        # This is a post
        lastmod.text = latest_date.iso8601
      else
        # This is a page
        if posts_included?(page_or_post.name)
          # We want to take into account the last post date
          final_date = greater_date(latest_date, @last_modified_post_date)
          lastmod.text = final_date.iso8601
        else
          lastmod.text = latest_date.iso8601
        end
      end
      lastmod
    end

    # Go through the page/post and any implemented layouts and get the latest
    # modified date
    #
    # Returns formatted output of latest date of page/post and any used layouts
    def find_latest_date(latest_date, site, page_or_post)
      layouts = site.layouts
      layout = layouts[page_or_post.data['layout']]
      while layout
        path = layout.full_path_to_source
        date = get_modified_date(path)
        latest_date = date if date > latest_date
        layout = layouts[layout.data['layout']]
      end

      latest_date
    end

    # Which of the two dates is later
    #
    # Returns latest of two dates
    def greater_date(date1, date2)
      if date1 >= date2
        date1
      else
        date2
      end
    end

    # Is the page or post listed as something we want to exclude?
    #
    # Returns boolean
    def excluded?(name)
      EXCLUDED_FILES.include? name
    end

    def posts_included?(name)
      PAGES_INCLUDE_POSTS.include? name
    end

    # Is the change frequency value provided valid according to the spec
    #
    # Returns boolean
    def valid_change_frequency?(change_frequency)
      VALID_CHANGE_FREQUENCY_VALUES.include? change_frequency
    end

    # Is the priority value provided valid according to the spec
    #
    # Returns boolean
    def valid_priority?(priority)
      begin
        priority_val = Float(priority)
        return true if priority_val >= 0.0 && priority_val <= 1.0
      rescue ArgumentError
        false
      end
      false
    end

    # Given a path will check to see if there is a git modified date for the path
    # if not found uses the modified date
    #
    # Returns date
    def get_modified_date(path)
      relative_path = path.gsub(/^.+src\//, 'src/')
      date = @git.log.object(relative_path).last.date
      if date
        date
      else
        File.mtime(path)
      end
    end

  end
end
