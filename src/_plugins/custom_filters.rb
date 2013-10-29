# Encoding: utf-8

class String
  def titlecase
    small_words = %w(a an and as at but by en for if in of on or the to v v. via vs vs.)

    x = split(' ').map do |word|
      # note: word could contain non-word characters!
      # downcase all small_words, capitalize the rest
      small_words.include?(word.gsub(/\W/, '').downcase) ? word.downcase! : word.smart_capitalize!
      word
    end
    # capitalize first and last words
    x.first.to_s.smart_capitalize!
    x.last.to_s.smart_capitalize!
    # small words are capitalized after colon, period, exclamation mark, question mark
    x.join(' ').gsub(/(:|\.|!|\?)\s?(\W*#{small_words.join('|')}\W*)\s/) { "#{$1} #{$2.smart_capitalize} " }
  end

  def titlecase!
    replace(titlecase)
  end

  def smart_capitalize
    # ignore any leading crazy characters and capitalize the first real character
    if self =~ /^['"\(\[']*([a-z])/
      i = index($1)
      x = self[i, length]
      # word with capitals and periods mid-word are left alone
      self[i, 1] = self[i, 1].upcase unless x =~ /[A-Z]/ || x =~ /\.\w+/
    end
    self
  end

  def smart_capitalize!
    replace(smart_capitalize)
  end
end

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
  # - Uses typographically correct ellipsis instead of '...'
  def truncate(input, length)
    if input.length > length && input[0..(length - 1)] =~ /(.+)\b.+$/im
      $1.strip + '&hellip;'
    else
      input
    end
  end

  # Returns a cleaned array of keywords, free of duplicates and extraneous comma
  def clean_keywords(input)
    keywords = input.split(',').map! { |i| i.chomp.strip.downcase }.compact.uniq.keep_if { |i| i != '' }
    if keywords.empty?
      nil
    else
      keywords.join(', ')
    end
  end

  def titlecase(input)
    input.titlecase
  end

end

Liquid::Template.register_filter CustomLiquidFilters
