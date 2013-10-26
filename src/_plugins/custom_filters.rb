module CustomLiquidFilters
  # Condenses multiple spaces and tabs into a single space
  def condense_spaces(input)
    input.gsub(/\s{2,}/, ' ')
  end

  # Replaces newlines with spaces
  def strip_breaks(input)
    input.gsub(/\n/, ' ')
  end

  # Improved version of Liquid's truncate, from Octopress
  # - Doesn't cut in the middle of a word.
  # - Uses typographically correct ellipsis (…) insted of '...'
  def truncate(input, length)
    if input.length > length && input[0..(length-1)] =~ /(.+)\b.+$/im
      $1.strip + '&hellip;'
    else
      input
    end
  end

  #Returns a cleaned array of keywords, free of duplicates and extraneous comma
  def clean_keywords(input)
    keywords = input.split(',').map! { |i| i.chomp.strip.downcase }.compact.uniq.keep_if{ |i| i != "" }
    if keywords.empty?
      nil
    else
      keywords.join(', ')
    end
  end
end

Liquid::Template.register_filter CustomLiquidFilters
