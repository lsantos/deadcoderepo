require 'rubygems'
require "superfeedr"

superfeedr = {
  :login => "Leandro_santos@superfeedr.com",
  :password => "123560"
}

feeds = ["http://blogs.thescore.com/mlb/feed/",
"http://feeds.feedburner.com/TimAndSidUncut"]

Superfeedr.connect(superfeedr[:login], superfeedr[:password]) do
  
  ##
  # This block will be called for each notification received from the Superfeedr
  Superfeedr.on_notification do |notification|
    # Logging
    puts "The feed #{notification.feed_url} has been fetched (#{notification.http_status}: #{notification.message_status}) and will be fetched again in #{(notification.next_fetch - Time.now)/60} minutes at most."

    notification.entries.each do |e|
      # We post the updates to Twitter
      puts "#{e.title} #{e.link}"
    end
  end
  
  ##
  # Subscribe to all the feeds
  Superfeedr.subscribe(feeds) do |feed|
    puts "Subscribed to : #{feed}"
  end
end