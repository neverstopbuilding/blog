require 'buff'

class Buffer < Jekyll::Generator
  def generate(site)
    if site.config['send_to_buffer']
      message = generate_message(site)
      log "Buffer message: \"#{message}\""
      buffer(message, site)
    else
      log 'Not sending latest post promotion to Buffer...'
    end
  end

  private

  def log(message)
    puts "\n\n#{message}\n\n"
  end

  def generate_message(site)
    most_recent_post = site.posts.reduce do |memo, post|
      memo.date > post.date ? memo : post
    end
    promotion_message = most_recent_post.data['promotion'] || ''
    "#{promotion_message} #{most_recent_post.location_on_server}"
  end

  def buffer(message, site)
    access_token = ENV['BUFFER_ACCESS_TOKEN'] || site.config['buffer_access_token']
    fail ArgumentError, 'No Buffer access token!' unless access_token
    client = Buff::Client.new(access_token)
    content = { body: { text: message, top: true, shorten: true,
                        profile_ids: site.config['buffer_profiles'] } }
    response = client.create_update(content)
    log("Buffer API Response: #{response.inspect}")
  end
end
